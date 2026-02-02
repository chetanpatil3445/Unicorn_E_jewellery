import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/DashboardController.dart';


Widget buildLiveRates() {
  DashboardController controller = Get.find<DashboardController>();

  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7F3F0), // Soft Silk Cream
            Color(0xFFFDFCFB), // Back to Ivory
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD4AF37).withOpacity(0.08), // Subtle Gold Shadow
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        return ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            _premiumRateItem(
              "GOLD 24K",
              controller.rate.value.toString(),
              "${controller.ratePerWt.value}/${controller.ratePerWtUnit.value}",
              const Color(0xFFB8860B), // Deep Golden Rod (Premium Gold)
              true,
            ),
            _premiumRateItem(
              "SILVER",
              controller.rateSl.value.toString(),
              "${controller.ratePerWtSl.value}/${controller.ratePerWtUnitSL.value}",
              const Color(0xFF707070), // Charcoal Grey for Silver Contrast
              false,
            ),
          ],
        );
      }),
    ),
  );
}

Widget _premiumRateItem(String label, String price, String subPrice, Color metalColor, bool isUp) {
  // Luxury Green & Deep Red (Muted tones)
  final trendColor = isUp ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C);

  return Row(
    children: [
      // Elegant Gold Frame Icon
      Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: metalColor.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(color: metalColor.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Center(
          child: Icon(
            isUp ? Icons.auto_graph_rounded : Icons.trending_down_rounded,
            color: metalColor,
            size: 18,
          ),
        ),
      ),
      const SizedBox(width: 12),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.cinzel( // Classic Serif Font for Royalty
              color: metalColor,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          Row(
            children: [
              Text(
                "₹$price",
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2D2D2D), // Soft Charcoal (not pure black)
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "(${isUp ? '+' : ''}$subPrice)",
                style: GoogleFonts.inter(
                  color: trendColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(width: 15),
    ],
  );
}

