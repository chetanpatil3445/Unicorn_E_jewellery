import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/OffersController.dart';

class MyOffersScreen extends StatelessWidget {
  MyOffersScreen({super.key});

  final controller = Get.put(OffersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      appBar: AppBar(
        title: Text("MY OFFERS & REWARDS",
            style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
        }
        if (controller.coupons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 60, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text("No active offers found", style: GoogleFonts.poppins(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.coupons.length,
          itemBuilder: (context, index) {
            var coupon = controller.coupons[index];
            String discountLabel = coupon['discount_type'] == 'percentage'
                ? "${coupon['discount_value']}% OFF"
                : "₹${coupon['discount_value']} OFF";

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.confirmation_num_outlined, color: Color(0xFFD4AF37)),
                    ),
                    title: Text(discountLabel,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                    subtitle: Text(
                      "On minimum order of ₹${coupon['min_order_value']}",
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => controller.copyToClipboard(coupon['code']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text("COPY", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CODE: ${coupon['code']}",
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                        Text("Valid till: ${coupon['expiry_date'].toString().split('T')[0]}",
                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}