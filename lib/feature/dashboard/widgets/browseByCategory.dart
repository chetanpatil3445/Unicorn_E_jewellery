import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/constants/appcolors.dart';
import '../model/banner_model.dart';



Widget buildCategorySection(List<BannerModel> banners) {
  return Container(
    height: 130,
    margin: const EdgeInsets.only(top: 10),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: banners.length,
      itemBuilder: (context, i) => InkWell(
        onTap: () => handleBannerClick(banners[i]),
        child: Container(
          width: 95,
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: goldAccent.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))]),
                  child: ClipOval(child: Image.network(banners[i].imageUrl, fit: BoxFit.cover, width: 90, height: 90)),
                ),
              ),
              const SizedBox(height: 10),
              Text(banners[i].subtitle.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: deepBlack)),
            ],
          ),
        ),
      ),
    ),
  );
}

void handleBannerClick(BannerModel banner) {
  if (banner.clickType.isEmpty) return;

  Get.toNamed(
    AppRoutes.homeProductsList, // Aapka destination route
    arguments: {
      'click_type': banner.clickType,
      'target_id': banner.targetId,
    },
  );
}

