import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';

class PaymentController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var addresses = [].obs;
  var selectedAddress = {}.obs;
  var isLoading = false.obs;

  var coupons = [].obs;
  var isCouponsLoading = false.obs;
  var selectedCoupon = {}.obs;
  var discountAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCheckoutAddress();
    fetchAvailableCoupons();
  }

  Future<void> fetchCheckoutAddress() async {
    try {
      isLoading(true);
      var response = await _apiClient.get(Uri.parse(ApiUrls.addresses));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        List fetchedAddresses = result['data'];
        addresses.assignAll(fetchedAddresses);
        if (fetchedAddresses.isNotEmpty) {
          selectedAddress.value = fetchedAddresses.firstWhere(
                (addr) => addr['is_default'] == true,
            orElse: () => fetchedAddresses[0],
          );
        }
      }
    } catch (e) {
      print("Address Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAvailableCoupons() async {
    try {
      isCouponsLoading(true);
      var response = await _apiClient.get(Uri.parse(ApiUrls.promoCodes));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['success'] == true) {
          coupons.assignAll(result['coupons']);
        }
      }
    } catch (e) {
      print("Coupons Error: $e");
    } finally {
      isCouponsLoading(false);
    }
  }

  Future<void> applyCoupon(String promoCode, double subtotal, {bool isFromList = false}) async {
    try {
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFFD4AF37)),
                const SizedBox(height: 20),
                Text("Checking Validity...", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Text("Verifying the best offer for you", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      );

      isLoading(true);
      Map<String, dynamic> bodyData = {"promo_code": promoCode, "order_amount": subtotal};

      var response = await _apiClient.post(
        Uri.parse(ApiUrls.validatePromoCode),
        body: jsonEncode(bodyData),
        headers: {"Content-Type": "application/json"},
      );

      var result = jsonDecode(response.body);

      if (Get.isOverlaysOpen) {
        Get.back();
      }

      if (response.statusCode == 200 && result['success'] == true && result['is_valid'] == true) {
        selectedCoupon.value = {"coupon_id": result['coupon_id'].toString(), "code": promoCode};
        discountAmount.value = double.parse(result['discount_amount'].toString());

        Get.snackbar(
          "Applied!",
          "Promo code applied successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        if (isFromList) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (Get.context != null) {
              Navigator.of(Get.context!).pop();
            }
          });
        }
      } else {
        String errorMsg = result['error'] ?? "Coupon not applicable";
        Get.snackbar("Invalid", errorMsg, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      if (Get.isOverlaysOpen) Get.back();
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }


  void removeCoupon() {
    selectedCoupon.value = {};
    discountAmount.value = 0.0;
  }

  void updateSelectedAddress(Map<String, dynamic> addr) {
    selectedAddress.value = addr;
    Get.back();
  }
}