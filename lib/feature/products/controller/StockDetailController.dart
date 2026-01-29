import 'dart:convert';

import 'package:get/get.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../model/ProductDetailResponse.dart';
import '../model/product_model.dart'; // Assuming ApiClient is here

class ProductDetailController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  late String productId;
  var productData = Rx<StockData?>(null);
  var isLoading = true.obs;
  var selectedImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    productId = Get.arguments.toString();
    fetchProductDetail();
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
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
      fetchSimilarItems();
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
    productId = newId;
    fetchProductDetail(); // Iske andar fetchSimilarItems() call hona chahiye detail milne ke baad
  }
}