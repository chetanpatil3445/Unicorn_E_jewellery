import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/controller/AppDataController.dart';
import '../../../core/utils/token_helper.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../model/product_model.dart';

class ProductCatalogueController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var stockItems = <Product>[].obs;
  var isLoading = true.obs;
  var isLoadMoreFetching = false.obs;
  var isGridView = true.obs;

  int _limit = 10;
  int _offset = 0;
  var hasMore = true.obs;

  var categoryFilter = ''.obs;
  var metalFilter = ''.obs;
  var minPriceFilter = ''.obs;
  var maxPriceFilter = ''.obs;

  late TextEditingController categoryController;
  late TextEditingController metalController;
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;


  var selectedMetal = "Gold".obs; // Default value
  final List<String> metalOptions = ["Gold", "Silver", "Platinum", "Rose Gold"];

  void initFilterControllers() {
    categoryController = TextEditingController(text: categoryFilter.value);
    metalController = TextEditingController(text: metalFilter.value);
    minPriceController = TextEditingController(text: minPriceFilter.value);
    maxPriceController = TextEditingController(text: maxPriceFilter.value);
  }

  var searchText = ''.obs; // Search ke liye naya Rx variable
  late TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  Future<void> fetchStockItems({bool isLoadMore = false}) async {
    if (isLoadMore && isLoadMoreFetching.value) return;

    if (!isLoadMore) {
      _offset = 0;
      stockItems.clear();
      isLoading.value = true;
      hasMore.value = true;
    } else {
      isLoadMoreFetching.value = true;
    }

    try {
      final Map<String, dynamic> bodyData = {
        "limit": _limit,
        "offset": _offset,
      };

      // Search Text implementation
      if (searchText.value.isNotEmpty) {
        bodyData["search_text"] = searchText.value;
      }

      if (categoryFilter.value.isNotEmpty) bodyData["categories"] = [categoryFilter.value];
      if (metalFilter.value.isNotEmpty) bodyData["metal_type"] = metalFilter.value;

      double? minP = double.tryParse(minPriceFilter.value);
      if (minP != null) bodyData["min_price"] = minP;

      double? maxP = double.tryParse(maxPriceFilter.value);
      if (maxP != null) bodyData["max_price"] = maxP;

      final response = await _apiClient.post(
        Uri.parse(ApiUrls.productListApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final productRes = productResponseFromJson(response.body);
        stockItems.addAll(productRes.data.products);
        hasMore.value = productRes.data.pagination.hasMore;
        _offset += _limit;
      }
    } catch (e) {
      print("Error fetching: $e");
    } finally {
      isLoading.value = false;
      isLoadMoreFetching.value = false;
    }
  }

  // Search trigger function
  void onSearchChanged(String value) {
    searchText.value = value;
    fetchStockItems(); // Ye automatically offset 0 kar dega isLoadMore false hone par
  }

  void toggleView() => isGridView.value = !isGridView.value;

  void applyFilters() {
    categoryFilter.value = categoryController.text;
    metalFilter.value = metalController.text;
    minPriceFilter.value = minPriceController.text;
    maxPriceFilter.value = maxPriceController.text;
    fetchStockItems();
  }

  void clearFilters() {
    categoryFilter.value = ''; metalFilter.value = '';
    minPriceFilter.value = ''; maxPriceFilter.value = '';
    fetchStockItems();
  }



  Future<void> toggleWishlist(Product item) async {
    final int ownerId = AppDataController.to.ownerId.value ?? 0;

    final String productId = item.productDetails.id;
    final bool wasWishlisted = item.isWishlisted;

    try {
      // 1. Current Controller UI update (Optimistic)
      item.isWishlisted = !wasWishlisted;
      stockItems.refresh();

      // 2. DUSRE CONTROLLER KO SYNC KAREIN (Catalogue Controller)
      _syncWithCatalogue(productId, item.isWishlisted);

      dynamic response;
      if (!wasWishlisted) {
        response = await _apiClient.post(
          Uri.parse(ApiUrls.wishlistAddApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "product_id": int.parse(productId),
            "jeweller_id": ownerId
          }),
        );
      } else {
        response = await _apiClient.delete(
          Uri.parse("${ApiUrls.wishlistDeleteApi}/$productId"),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {
        // 3. Wishlist Controller Sync
        if (Get.isRegistered<WishlistController>()) {
          final wishlistCtrl = Get.find<WishlistController>();
          if (!wasWishlisted) {
            wishlistCtrl.fetchWishlist();
          } else {
            wishlistCtrl.wishlistItems.removeWhere((w) => w.productDetails.id == productId);
          }
        }

        Get.rawSnackbar(
          message: responseData['message'] ?? "Wishlist updated",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.black87,
        );
      } else {
        throw responseData['message'] ?? "Something went wrong";
      }

    } catch (e) {
      // 4. Rollback: Fail hone par dono controllers ko purani state pe laayein
      item.isWishlisted = wasWishlisted;
      stockItems.refresh();
      _syncWithCatalogue(productId, wasWishlisted);

      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

// Helper Function: Catalogue Controller ki list update karne ke liye
  void _syncWithCatalogue(String productId, bool status) {
    if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      // List mein product find karein
      int index = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (index != -1) {
        catCtrl.stockItems[index].isWishlisted = status;
        catCtrl.stockItems.refresh(); // UI update trigger karein
      }
    }
  }
}