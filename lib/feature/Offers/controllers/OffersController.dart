import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';

class OffersController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  var coupons = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    try {
      isLoading(true);
      var response = await _apiClient.get(Uri.parse(ApiUrls.promoCodes));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          coupons.assignAll(result['coupons']);
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      "Copied!",
      "Code $code copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 1),
    );
  }
}