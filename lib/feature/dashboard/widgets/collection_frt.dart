import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/constants/appcolors.dart';
import '../../products/model/product_model.dart';
import '../controller/DashboardController.dart';



final inrFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);


Widget buildSliverGridWithTitle(String title, String sectionKey) {
  return SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(title),
        buildHorizontalProductList(sectionKey),
      ],
    ),
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 25, 16, 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: deepBlack)),
        if(title != "Gifts for Loved Ones" &&  title != "Shop by Gender" && title != "Main Showcase" && title != "Festive Specials" && title != "Modern Couple Sets" && title != "Exclusive Offers")
          Text("See All", style: GoogleFonts.poppins(fontSize: 10, color: goldAccent, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget buildHorizontalProductList(String sectionKey) {
  DashboardController controller = Get.find<DashboardController>();

  return Obx(() {
    if (controller.sectionLoading[sectionKey] == true) {
      return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator(color: goldAccent))
      );
    }

    final items = controller.sectionProducts[sectionKey] ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 280, // Card ki height ke hisab se adjust karein
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 180, // Card ki width
            margin: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.stockDetail, arguments: item.productDetails.id),
              child: buildLuxuryCard(item), // Aapka existing design
            ),
          );
        },
      ),
    );
  });
}

Widget buildLuxuryCard(Product item, {bool isList = false}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
      ],
    ),
    child: isList
        ? Row(children: [premiumImage(item, 140), Expanded(child: premiumDetails(item))])
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: premiumImage(item, double.infinity)), premiumDetails(item)]),
  );
}

Widget premiumImage(Product item, double width) {
  DashboardController controller = Get.find<DashboardController>();

  String? imageUrl = item.imageUrls.isNotEmpty ? item.imageUrls[0].imageUrl : null;
  return Stack(
    children: [
      Container(
        width: width,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF9F9F9),
        ),
        clipBehavior: Clip.antiAlias,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder())
            : _buildPlaceholder(),
      ),
      Positioned(
        top: 8,
        right: 8,
        child: GestureDetector(
          onTap: () => controller.toggleWishlist(item),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
              ],
            ),
            child: Icon(
              item.isWishlisted ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: item.isWishlisted ? Colors.red : deepBlack,
            ),
          ),
        ),
      ),
    ],
  );
}


Widget premiumDetails(Product item) {
  DashboardController controller = Get.find<DashboardController>();

  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.productDetails.productName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "#${item.productDetails.productCode}" ?? "",
              style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: goldAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text("${item.weights.grossWeight}g",
                  style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: goldAccent)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(item.productDetails.category,
                  maxLines: 1,
                  style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey.shade500)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // --- Updated Price & Cart Row ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(inrFormatter.format(item.calculatedPrice.totalValuation),
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: deepBlack, fontSize: 14)),

            GestureDetector(
              onTap: () => controller.addToCart(item),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.isInCart ? goldAccent : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: item.isInCart ? goldAccent : Colors.grey.shade200),
                ),
                child: Icon(
                  item.isInCart ? Icons.shopping_bag : Icons.shopping_bag_outlined,
                  size: 14,
                  color: item.isInCart ? Colors.white : deepBlack,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildPlaceholder() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFF1F6), // baby pink (very soft)
          Color(0xFFEFF7FF), // baby sky blue (faint)
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 14,
          offset: Offset(0, 6),
        ),
      ],
      border: Border.all(
        color: Colors.white.withOpacity(0.6),
        width: 1,
      ),
    ),
    child: Center(
      child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFC1D9), // soft pink glow
                Color(0xFFBEE6FF), // soft sky blue glow
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFC1D9).withOpacity(0.4),
                blurRadius: 12,
              )
            ],
          ),
          child:Icon(
            Icons.local_florist_rounded,
            color: Colors.white.withOpacity(0.92),
            size: 30,
          )
      ),
    ),
  );
}
