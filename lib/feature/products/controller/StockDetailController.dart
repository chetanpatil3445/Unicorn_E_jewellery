import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:unicorn_e_jewellers/core/controller/AppDataController.dart';
import 'package:unicorn_e_jewellers/feature/products/controller/stock_catalogue_controller.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../../Category/controller/Category_tag_controller.dart';
import '../../dashboard/controller/DashboardController.dart';
import '../../logs/service/logProductInteraction.dart';
import '../../logs/service/updateStayDuration.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../model/ProductDetailResponse.dart';
import '../model/product_model.dart'; // Assuming ApiClient is here
import 'package:image_picker/image_picker.dart';

class ProductDetailController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  late String productId;
  var productData = Rx<StockData?>(null);
  var isLoading = true.obs;
  var selectedImageUrl = ''.obs;


  RxInt stayDuration = 0.obs; // duration in seconds
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    productId = Get.arguments.toString();
    fetchProductDetail();
    fetchReviews();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _stopTrackingAndUpdate(); // stop timer and send stay_duration
  }

  void fetchProductDetail() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(Uri.parse("${ApiUrls.productListDetail}$productId"));

      if (response.statusCode == 200) {
        final res = productDetailResponseFromJson(response.body);
        productData.value = res.data;

        if (res.data.images.isNotEmpty) {
          selectedImageUrl.value = res.data.images.first.imageUrl;
        }

        // log and start timer after data loaded
        await logProductViewInteraction(productId);
        _startTracking();

      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
      fetchSimilarItems();
    }
  }

  RxnInt currentInteractionId = RxnInt();

  Future<void> logProductViewInteraction(String productId) async {
    final loggedUserId = AppDataController.to.staffId.value ?? 0;
    final ownerId = AppDataController.to.ownerId.value ?? 0;
     final interactionId = await logProductInteraction(
      jewellerId: ownerId,
      productId: int.parse(productId),
      userId: loggedUserId,
      interactionType: "view",
      deviceType: "Mobile",
      ipAddress: "-", // or get actual IP if available
    );

    if (interactionId != null) {
      print("Logged interaction ID: $interactionId");
      currentInteractionId.value = interactionId;
    }
  }


  void _startTracking() {
    stayDuration.value = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      stayDuration.value += 1;
    });
  }

  void _stopTrackingAndUpdate() {
    _timer?.cancel();

    final id = currentInteractionId.value;
    if (id != null) {
      updateStayDuration(
        interactionId: id,
        stayDuration: stayDuration.value,
      );
    } else {
      print("No interaction ID found. Stay duration not updated.");
    }
  }




  void updateSelectedImage(String url) {
    selectedImageUrl.value = url;
  }



  var similarProducts = <Product>[].obs; // Product model class use karein
  var isSimilarLoading = false.obs;

  void fetchSimilarItems() async {
    final currentData = productData.value;
    if (currentData == null) return;

    isSimilarLoading.value = true;
    try {
      final Map<String, dynamic> bodyData = {
        "limit": 10,
        "offset": 0,
        "search_text": currentData.productDetails.productName, // Extra filter as requested
        "categories": [currentData.productDetails.category],
      };

      final response = await _apiClient.post(
        Uri.parse(ApiUrls.productListApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final productRes = productResponseFromJson(response.body);

        // Filter: Niche ki list me current product nahi dikhna chahiye
        similarProducts.value = productRes.data.products
            .where((p) => p.productDetails.id != productId)
            .toList();
      }
    } catch (e) {
      print("Error fetching similar items: $e");
    } finally {
      isSimilarLoading.value = false;
    }
  }

// Product switch karne ke liye function
  void loadNewProduct(String newId) {
    // 1️⃣ Stop previous timer & send previous stay duration
    _stopTrackingAndUpdate();

    // 2️⃣ Reset state for new product
    stayDuration.value = 0;
    currentInteractionId.value = null;
    selectedImageUrl.value = '';
    productId = newId;

    // 3️⃣ Fetch new product
    fetchProductDetail(); // inside this, interaction will be logged & timer will start
  }



  // ProductDetailController ke andar add karein
  Future<void> toggleWishlist() async {
    final int ownerId = AppDataController.to.ownerId.value ?? 0;

    final data = productData.value;
    if (data == null) return;

    final String pId = data.productDetails.id;
    final bool wasWishlisted = data.isWishlisted;

    try {
      // 1. Local UI Update (Optimistic)
      data.isWishlisted = !wasWishlisted;
      productData.refresh();

      // 2. Global Sync (Taaki peeche wale pages par bhi heart update ho jaye)
      _syncWithOtherControllers(pId, data.isWishlisted);

      // 3. API Call
      if (!wasWishlisted) {
        await _apiClient.post(
          Uri.parse(ApiUrls.wishlistAddApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"product_id": int.parse(pId), "jeweller_id": ownerId}),
        );
      } else {
        await _apiClient.delete(
          Uri.parse("${ApiUrls.wishlistDeleteApi}/$pId"),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // Wishlist controller refresh agar registered ho toh
      if (Get.isRegistered<WishlistController>()) {
        Get.find<WishlistController>().fetchWishlist();
      }

    } catch (e) {
      // Rollback on error
      data.isWishlisted = wasWishlisted;
      productData.refresh();
      _syncWithOtherControllers(pId, wasWishlisted);
      Get.snackbar("Error", "Could not update wishlist");
    }
  }

  void _syncWithOtherControllers(String id, bool status) {
    // Sync TagController
    if (Get.isRegistered<TagController>()) {
      final tagCtrl = Get.find<TagController>();
      int idx = tagCtrl.stockItems.indexWhere((p) => p.productDetails.id == id);
      if (idx != -1) {
        tagCtrl.stockItems[idx].isWishlisted = status;
        tagCtrl.stockItems.refresh();
      }
    }
    // Sync ProductCatalogueController
    if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      int idx = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == id);
      if (idx != -1) {
        catCtrl.stockItems[idx].isWishlisted = status;
        catCtrl.stockItems.refresh();
      }
    }
  }



  /// cart working

// Controller ke andar ye logic add karein
  Future<void> addToCart() async {
    final data = productData.value;
    if (data == null) return;

    final String productId = data.productDetails.id.toString();

    if (data.isInCart) {
      Get.toNamed(AppRoutes.cartPage);
      return;
    }

    try {
      // 1. Optimistic UI Update (Detail Page)
      data.isInCart = true;
      productData.refresh();

      // 2. Dusre controllers ko sync karein (Catalogue & Dashboard)
      _syncCartStatusWithOthers(productId, true);

      final response = await _apiClient.post(
        Uri.parse(ApiUrls.cartAddApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"item_id": int.parse(productId)}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.rawSnackbar(
          message: "Added to Shopping Bag",
          backgroundColor: Colors.black87,
          mainButton: TextButton(
            onPressed: () => Get.toNamed(AppRoutes.cartPage),
            child: const Text("VIEW", style: TextStyle(color: Color(0xFFB8860B), fontWeight: FontWeight.bold)),
          ),
        );
      }
    } catch (e) {
      // Rollback on error
      data.isInCart = false;
      productData.refresh();
      _syncCartStatusWithOthers(productId, false);
      Get.snackbar("Error", "Failed to add to cart");
    }
  }

  void _syncCartStatusWithOthers(String productId, bool status) {
    // Catalogue Sync
    if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      int idx = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (idx != -1) {
        catCtrl.stockItems[idx].isInCart = status;
        catCtrl.stockItems.refresh();
      }
    }

    // Dashboard Sync
    if (Get.isRegistered<DashboardController>()) {
      final dashCtrl = Get.find<DashboardController>();
      dashCtrl.sectionProducts.forEach((key, list) {
        for (var p in list) {
          if (p.productDetails.id == productId) p.isInCart = status;
        }
      });
      dashCtrl.sectionProducts.refresh();
    }
  }




  /// reviews

  var reviewsList = <dynamic>[].obs; // dynamic ki jagah aap model bhi bana sakte hain
  var isReviewsLoading = false.obs;

  Future<void> fetchReviews() async {
    isReviewsLoading.value = true;
    try {
      final response = await _apiClient.post(
        Uri.parse(ApiUrls.productReviewsList), // check your Url name
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "product_id": int.parse(productId),
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['success'] == true) {
          reviewsList.value = res['data'];
        }
      }
    } catch (e) {
      print("Fetch Reviews Error: $e");
    } finally {
      isReviewsLoading.value = false;
    }
  }


  double get averageRating {
    if (reviewsList.isEmpty) return 0.0;

    double totalRating = reviewsList.fold(0, (sum, item) {
      return sum + (item['rating'] as num).toDouble();
    });

    double avg = totalRating / reviewsList.length;

    return double.parse(avg.toStringAsFixed(1));
  }


   var rating = 0.0.obs;
  final TextEditingController commentController = TextEditingController();
  var mainImage = Rxn<String>();
  var subImage = Rxn<String>();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickReviewImage(bool isMain) async {
    // 1. Camera/Gallery selection popup
    await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Source", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () async {
                Get.back();
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  if (isMain) mainImage.value = image.path; else subImage.value = image.path;
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () async {
                Get.back();
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  if (isMain) mainImage.value = image.path; else subImage.value = image.path;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      Get.snackbar("Required", "Please select a rating star");
      return;
    }

    // Show loading
    Get.dialog(const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))), barrierDismissible: false);

    try {
      final int userId = AppDataController.to.staffId.value ?? 0;
      final String userName = AppDataController.to.staffName.value ?? "Guest User";

      var request = http.MultipartRequest('POST', Uri.parse(ApiUrls.productReviewsAdd));

      request.fields['product_id'] = productId;
      request.fields['user_id'] = userId.toString();
      request.fields['user_name'] = userName;
      request.fields['rating'] = rating.value.toString();
      request.fields['comment'] = commentController.text;

      // --- Compression Logic Start ---
      // --- Compression & File Adding Logic ---
      if (mainImage.value != null) {
        File compressedFile = await _compressImage(File(mainImage.value!));
        request.files.add(
          await http.MultipartFile.fromPath(
            'images_main', // Field name
            compressedFile.path,
            filename: p.basename(compressedFile.path),
            contentType: http.MediaType('image', 'jpeg'), // Backend ko batana ki ye image hai
          ),
        );
      }

      if (subImage.value != null) {
        File compressedFile = await _compressImage(File(subImage.value!));
        request.files.add(
          await http.MultipartFile.fromPath(
            'images_sub', // Field name
            compressedFile.path,
            filename: p.basename(compressedFile.path),
            contentType: http.MediaType('image', 'jpeg'),
          ),
        );
      }

      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'access_token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'multipart/form-data';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      Get.back(); // Remove loading dialog
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close bottom sheet
        Get.snackbar("Success", "Review submitted successfully!",
            backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

        // Clean up
        commentController.clear();
        rating.value = 0.0;
        mainImage.value = null;
        subImage.value = null;
      } else if (response.statusCode == 409 &&
          responseBody['message'] == "You have already reviewed this product") {

        Get.snackbar(
          "Already Reviewed",
          "You have already submitted a review for this product.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

      } else {
        Get.snackbar(
          "Error",
          responseBody['message'] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.back(); // Remove loading
      print("Review Error: $e");
      Get.snackbar("Error", "Failed to submit review");
    } finally{
      fetchReviews();
    }
  }

   Future<File> _compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final String targetPath = p.join(path, "${DateTime.now().millisecondsSinceEpoch}_compressed.jpg");

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80, // 80 quality balance rakhta hai size aur detail mein
      format: CompressFormat.jpeg,
    );

    return File(result!.path);
  }


  Future<void> deleteReview(int reviewId) async {
    Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
        barrierDismissible: false
    );

    try {
      final response = await _apiClient.delete(
        Uri.parse("${ApiUrls.productReviewsAdd}/$reviewId"),
      );
      if (Get.isDialogOpen!) Get.back();
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          "Success",
          data['message'] ?? "Review deleted successfully",
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchReviews();
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Could not delete review",
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      print("Delete Error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong while deleting.",
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    }
  }


}