import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart'; // Adjust based on your ApiClient path
import '../../dashboard/controller/DashboardController.dart';
import '../../products/controller/stock_catalogue_controller.dart';
import '../model/cart_model.dart';

class CartController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var cartData = Rxn<CartData>();
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(Uri.parse(ApiUrls.cartAddApi));

      if (response.statusCode == 200) {
        final res = cartResponseFromJson(response.body);
        cartData.value = res.data;
      }
    } catch (e) {
      print("Cart Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(int cartId , String productId) async {
    try {
      final response = await _apiClient.delete(
        Uri.parse("${ApiUrls.cartAddApi}/$cartId"),
      );

      if (response.statusCode == 200) {
        // 1. Cart list refresh karein
        fetchCart();

        // 2. Catalogue aur Dashboard ko sync karein
        _syncCartStatusWithCatalogue(productId, false);

        Get.rawSnackbar(
            message: "Item removed from bag",
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.black87
        );
      }
    } catch (e) {
      print("Delete Error: $e");
    }
  }

// Sync Helper Function
  void _syncCartStatusWithCatalogue(String productId, bool status) {
    // Product Catalogue Controller sync
    if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      int index = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (index != -1) {
        catCtrl.stockItems[index].isInCart = status;
        catCtrl.stockItems.refresh();
      }
    }

    // Dashboard Controller sync (Homepage sections)
    if (Get.isRegistered<DashboardController>()) {
      final dashCtrl = Get.find<DashboardController>();
      dashCtrl.sectionProducts.forEach((key, list) {
        for (var p in list) {
          if (p.productDetails.id == productId) {
            p.isInCart = status;
          }
        }
      });
      dashCtrl.sectionProducts.refresh();
    }
  }
}