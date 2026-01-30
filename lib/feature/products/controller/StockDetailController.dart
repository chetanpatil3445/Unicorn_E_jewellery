import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:unicorn_e_jewellers/core/controller/AppDataController.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../../logs/service/logProductInteraction.dart';
import '../../logs/service/updateStayDuration.dart';
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

}