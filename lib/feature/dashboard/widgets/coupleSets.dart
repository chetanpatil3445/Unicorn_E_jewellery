import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/appcolors.dart';
import '../model/banner_model.dart';
import '../widgets/browseByCategory.dart';


Widget buildCoupleCollections(BannerModel? banner) {
  if (banner == null) return const SizedBox.shrink();
  return InkWell(
    onTap: () => handleBannerClick(banner),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 157,
      decoration: BoxDecoration(color: const Color(0xFFFBE9E7), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(banner.title, style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 5),
                  Text(banner.subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700])),
                  const SizedBox(height: 10),
                  Text("SHOP NOW →", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: goldAccent)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
              child: Image.network(banner.imageUrl, fit: BoxFit.cover, height: double.infinity),
            ),
          ),
        ],
      ),
    ),
  );
}
