import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/banner_model.dart';
import '../widgets/browseByCategory.dart';



Widget buildFestiveCarousel(List<BannerModel> banners, PageController festivePageController ) {
  if (banners.isEmpty) return const SizedBox.shrink();
  return SizedBox(
    height: 110, // Container height + margin
    child: PageView.builder(
      controller: festivePageController,
      itemCount: banners.length,
      itemBuilder: (context, index) {
        return _buildFestiveBannerItem(banners[index]);
      },
    ),
  );
}

Widget _buildFestiveBannerItem(BannerModel banner) {
  // Logic to determine which image to use
  String? finalImageUrl = (banner.imageUrl.isNotEmpty)
      ? banner.imageUrl
      : (banner.defaultImageUrl.isNotEmpty ? banner.defaultImageUrl : null);

  return InkWell(
    onTap: () => handleBannerClick(banner),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: finalImageUrl == null
            ? const LinearGradient(colors: [Color(0xFF800000), Color(0xFFD4AF37)])
            : null,
        image: finalImageUrl != null
            ? DecorationImage(
          image: NetworkImage(finalImageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0xFF800000).withOpacity(0.5), // Image ke upar halka maroon shade
            BlendMode.darken,
          ),
        )
            : null,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: finalImageUrl != null
              ? LinearGradient(
            begin: Alignment.centerLeft,
            colors: [Colors.black.withOpacity(0.0), Colors.transparent],
          )
              : null,
        ),
        child: ListTile(
          leading: const Icon(Icons.auto_awesome, color: Colors.white, size: 35),
          title: Text(
            banner.title,
            style: GoogleFonts.cinzel(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            banner.subtitle,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ),
      ),
    ),
  );
}
