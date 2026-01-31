import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:unicorn_e_jewellers/core/controller/AppDataController.dart';
import 'package:unicorn_e_jewellers/feature/products/controller/stock_catalogue_controller.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../../Category/controller/Category_tag_controller.dart';
import '../../logs/service/logProductInteraction.dart';
import '../../logs/service/updateStayDuration.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../model/ProductDetailResponse.dart';
import '../model/product_model.dart'; // Assuming ApiClient is here

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

}