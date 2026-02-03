import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/appcolors.dart';
import '../model/banner_model.dart';
import 'browseByCategory.dart';


Widget buildHeroBanner(BannerModel banner) {
  return InkWell(
    onTap: () => handleBannerClick(banner),
    child: Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(banner.imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [Colors.black.withOpacity(0.7), Colors.transparent], begin: Alignment.bottomLeft),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(banner.title, style: GoogleFonts.cinzel(color: goldAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(banner.subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

Widget buildCarouselSlider(List<BannerModel> banners, PageController pageController) {
  if (banners.isEmpty) return const SizedBox();

  return SizedBox(
    height: 200,
    child: PageView.builder(
      controller: pageController,
      itemCount: banners.length,
      itemBuilder: (context, index) => buildHeroBanner(banners[index]),
    ),
  );
}