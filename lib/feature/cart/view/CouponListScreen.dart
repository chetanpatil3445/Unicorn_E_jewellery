import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/PaymentController.dart';

class CouponListScreen extends StatelessWidget {
  final double subtotal;
  CouponListScreen({required this.subtotal});

  final controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      appBar: AppBar(
        title: Text("OFFERS & COUPONS", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isCouponsLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
        }
        if (controller.coupons.isEmpty) {
          return Center(child: Text("No coupons available", style: GoogleFonts.poppins(color: Colors.grey)));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.coupons.length,
          itemBuilder: (context, index) {
            var coupon = controller.coupons[index];
            double minOrder = double.parse(coupon['min_order_value'].toString());
            bool isLocked = subtotal < minOrder;

            String discountLabel = coupon['discount_type'] == 'percentage' ? "${coupon['discount_value']}% OFF" : "₹${coupon['discount_value']} OFF";

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isLocked ? Colors.grey.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isLocked ? Colors.grey.shade300 : const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            height: 45, width: 45,
                            decoration: BoxDecoration(
                              color: isLocked ? Colors.grey.shade200 : const Color(0xFFD4AF37).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(isLocked ? Icons.lock_outline : Icons.local_offer_outlined, color: isLocked ? Colors.grey : const Color(0xFFD4AF37), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        coupon['code'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: isLocked ? Colors.grey : Colors.black),
                                      ),
                                    ),
                                    if (!isLocked) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                        child: Text(discountLabel, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text("Save up to ₹${coupon['max_discount']} on ₹$minOrder+", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          Obx(() => TextButton(
                            onPressed: (isLocked || controller.isLoading.value)
                                ? null
                                : () => controller.applyCoupon(coupon['code'], subtotal, isFromList: true),
                            style: TextButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 12)),
                            child: controller.isLoading.value && !isLocked
                                ? const SizedBox(height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD4AF37)))
                                : Text(isLocked ? "LOCKED" : "APPLY", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: isLocked ? Colors.grey : const Color(0xFFD4AF37))),
                          )),
                        ],
                      ),
                    ),
                    if (isLocked)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: Colors.red.withOpacity(0.05),
                        child: Text("Add ₹${(minOrder - subtotal).toStringAsFixed(0)} more to unlock this offer", style: GoogleFonts.poppins(fontSize: 9, color: Colors.red.shade700, fontWeight: FontWeight.w500)),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}