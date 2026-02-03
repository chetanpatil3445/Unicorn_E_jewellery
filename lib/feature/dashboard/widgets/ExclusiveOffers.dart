import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/appcolors.dart';
import '../model/banner_model.dart';
import '../widgets/browseByCategory.dart';


Widget buildOfferBanner(BannerModel? banner) {
  if (banner == null) return const SizedBox.shrink();
  return InkWell(
    onTap: () => handleBannerClick(banner),
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: deepBlack,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(banner.imageUrl), fit: BoxFit.cover, opacity: 0.4)
      ),
      child: Column(
        children: [
          Text(banner.title, style: GoogleFonts.cinzel(color: goldAccent, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(banner.subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: () {handleBannerClick(banner);}, style: ElevatedButton.styleFrom(backgroundColor: goldAccent, foregroundColor: Colors.black), child: const Text("CLAIM NOW")),
        ],
      ),
    ),
  );
}
