import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicorn_e_jewellers/core/apiUrls/api_urls.dart';
import 'package:unicorn_e_jewellers/core/utils/token_helper.dart';
import '../../Category/controller/Category_tag_controller.dart';
import '../../products/controller/stock_catalogue_controller.dart';
import '../../products/model/product_model.dart';
import '../model/wishlist_model.dart';

class WishlistController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  var wishlistItems = <WishlistItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(Uri.parse(ApiUrls.wishlistAddApi));
      if (response.statusCode == 200) {
        final res = wishlistResponseFromJson(response.body);
        wishlistItems.value = res.data.items;
      }
    } catch (e) {
      print("Wishlist Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> removeFromWishlist(String productId, int index) async {
  //   try {
  //     final response = await _apiClient.delete(
  //       Uri.parse("${ApiUrls.wishlistDeleteApi}/$productId"),
  //     );
  //     if (response.statusCode == 200) {
  //       wishlistItems.removeAt(index);
  //       Get.rawSnackbar(message: "Removed from wishlist", backgroundColor: Colors.black87);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Could not remove item");
  //   }
  // }

  Future<void> removeFromWishlist(String productId, int index) async {
    try {
      final response = await _apiClient.delete(
        Uri.parse("${ApiUrls.wishlistDeleteApi}/$productId"),
      );

      if (response.statusCode == 200) {
        // 1. Wishlist ki apni list se hatao
        wishlistItems.removeAt(index);

        // 2. Catalogue Controller check karo aur wahan ka flag false karo
        if (Get.isRegistered<ProductCatalogueController>()) {
          final catController = Get.find<ProductCatalogueController>();
          _updateProductFlag(catController.stockItems, productId);
        }

        // 3. Tag Controller check karo aur wahan ka flag false karo
        if (Get.isRegistered<TagController>()) {
          final tagController = Get.find<TagController>();
          _updateProductFlag(tagController.stockItems, productId);
        }

        Get.rawSnackbar(
            message: "Removed from wishlist",
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(milliseconds: 800)
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Could not remove item");
    }
  }

// Common helper function jo flag ko false karega aur list refresh karega
  void _updateProductFlag(RxList<Product> list, String productId) {
    int itemIndex = list.indexWhere((p) => p.productDetails.id == productId);
    if (itemIndex != -1) {
      list[itemIndex].isWishlisted = false;
      list.refresh(); // Yeh UI ko update trigger karega
    }
  }
}