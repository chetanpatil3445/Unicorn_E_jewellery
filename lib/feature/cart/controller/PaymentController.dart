import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unicorn_e_jewellers/Routes/app_routes.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import 'CartController.dart';

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

  final controller = Get.find<CartController>();



  Timer? _countdownTimer;
  var countdown = 5.obs;
  bool isCancelled = false;

  void confirmOrder(String paymentMethod, double subtotal) {
    if (selectedAddress.isEmpty) {
      _showCustomSnackBar("Address Required", "Please select a delivery address.", Colors.orange);
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("CONFIRM ORDER", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              Text("Are you sure you want to place this order?",
                  textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text("NO", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                      onPressed: () {
                        Get.back(); // Popup band karo
                        startOrderSequence(paymentMethod, subtotal); // Timer shuru karo
                      },
                      child: Text("YES", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void startOrderSequence(String paymentMethod, double subtotal) {
    isCancelled = false;
    countdown.value = 5;

    _showLoadingWithCancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        timer.cancel();
        if (!isCancelled) {
          Get.back(); // Loader band karo
          placeOrder(paymentMethod: paymentMethod, subtotal: subtotal); // API call
        }
      }
    });
  }
  void _showLoadingWithCancel() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 60, width: 60,
                    child: CircularProgressIndicator(
                      value: countdown.value / 5,
                      color: const Color(0xFFD4AF37),
                      strokeWidth: 5,
                    ),
                  ),
                  Text("${countdown.value}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              Text("PLACING YOUR ORDER...", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 20),

              // 5 Second tak Cancel button dikhao
              if (countdown.value > 0)
                TextButton(
                  onPressed: () {
                    isCancelled = true;
                    _countdownTimer?.cancel();
                    Get.back();
                    _showCustomSnackBar("Cancelled", "Order placement was cancelled.", Colors.blueGrey);
                  },
                  child: Text("CANCEL NOW", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
            ],
          )),
        ),
      ),
    );
  }


  Future<void> placeOrder({
    required String paymentMethod,
    required double subtotal,
  }) async {
    try {
      if (selectedAddress.isEmpty) {
        _showCustomSnackBar("Address Required", "Please select a delivery address.", Colors.orange);
        return;
      }
      _showLoadingDialog();

        Map<String, dynamic> bodyData = {
          "address_id": selectedAddress['id'],
          "items": controller.checkoutItems,
          "payment_mode": paymentMethod.toUpperCase(),
          "coupon_code": selectedCoupon['code'] ?? "",
        };

        var response = await _apiClient.post(
        Uri.parse(ApiUrls.orderPlace),
        body: jsonEncode(bodyData),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      var result = jsonDecode(response.body);
      print(result);
      print("#############$result");
      if (Get.isOverlaysOpen) Get.back();

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['success'] == true) {
          // DHAYAN DEIN: Yahan 'order_no' use kiya hai jo aapke response mein hai
          String finalOrderId = result['data']['order_no']?.toString() ?? "N/A";
          _showSuccessDialog(finalOrderId);
        } else {
          _showErrorDialog(result['message'] ?? "Order placement failed.");
        }
      } else {
        _showErrorDialog("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      if (Get.isOverlaysOpen) Get.back();
      _showErrorDialog("An unexpected error occurred.");
      print("Order Placement Error: $e");
    }
  }

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       if (result['success'] == true) {
  //         _showSuccessDialog(result['order_id']?.toString() ?? "N/A");
  //       } else {
  //         _showErrorDialog(result['message'] ?? "Order placement failed.");
  //       }
  //     } else {
  //       _showErrorDialog("Server Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     if (Get.isOverlaysOpen) Get.back();
  //     _showErrorDialog("An unexpected error occurred. Please check your internet.");
  //     print("Order Placement Error: $e");
  //   }
  // }


  void _showLoadingDialog() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFFD4AF37)),
              const SizedBox(height: 20),
              Text("SECURELY PLACING ORDER",
                  style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text("Please do not refresh or go back",
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // void _showSuccessDialog(String orderId) {
  //   Get.dialog(
  //     barrierDismissible: false,
  //     Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(24),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 80),
  //             const SizedBox(height: 20),
  //             Text("ORDER PLACED!", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 20)),
  //             const SizedBox(height: 10),
  //             Text("Your order #$orderId has been received successfully.",
  //                 textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
  //             const SizedBox(height: 25),
  //             SizedBox(
  //               width: double.infinity,
  //               height: 48,
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A1A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  //                 onPressed: () => Get.offAllNamed('/home'), // Home page par bhejein
  //                 child: Text("CONTINUE SHOPPING", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showSuccessDialog(String orderId) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie Animation (Use a success json or Icon if lottie not setup)
              SizedBox(
                height: 150,
                width: 150,
                child: Lottie.network(
                  'https://assets10.lottiefiles.com/packages/lf20_pqnfmone.json', // Animated Checkmark
                  repeat: false,
                ),
              ),
              const SizedBox(height: 10),
              Text("ORDER PLACED!",
                  style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF2E7D32))
              ),
              const SizedBox(height: 15),
              Text("Woohoo! Your order has been placed successfully.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Text("Order ID: $orderId",
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.MainNavigation);
                  },
                  child: Text("CONTINUE SHOPPING",
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String msg) {
    Get.defaultDialog(
      title: "ORDER FAILED",
      titleStyle: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 16),
      middleText: msg,
      middleTextStyle: GoogleFonts.poppins(fontSize: 13),
      backgroundColor: Colors.white,
      radius: 15,
      confirm: TextButton(onPressed: () => Get.back(), child: const Text("RETRY", style: TextStyle(color: Colors.red))),
    );
  }

  void _showCustomSnackBar(String title, String msg, Color color) {
    Get.snackbar(title, msg, backgroundColor: color, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(15));
  }
}