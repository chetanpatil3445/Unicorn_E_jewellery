import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controller/StockDetailController.dart';
import '../model/ProductDetailResponse.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductDetailController controller = Get.put(ProductDetailController());
  final inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  static const Color goldAccent = Color(0xFFB8860B);
  static const Color premiumBlack = Color(0xFF1A1A1A);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGold = Color(0xFFFFF9E6);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color starColor = Color(0xFFFFB400);

  ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomActionBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: goldAccent, strokeWidth: 2));
        }

        final data = controller.productData.value;
        if (data == null) return const Center(child: Text("Product Not Found"));

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumGallery(data), // Updated Gallery
              _buildMainInfoSection(data),
              _buildOffersSection(),
              const Divider(thickness: 6, color: softGrey),
              _buildTrustBadges(),
              const Divider(thickness: 6, color: softGrey),
              _buildDeliveryChecker(),
              const Divider(thickness: 6, color: softGrey),
              _buildPriceBreakdown(data),
              _buildSpecifications(data),
              if (data.stones.isNotEmpty) _buildStoneDetails(data.stones),
              const Divider(thickness: 6, color: softGrey),
              _buildReviewSection(),
              _buildLuxuryPromise(),
              const Divider(thickness: 6, color: softGrey),

              _buildSimilarProducts(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: premiumBlack),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Text("DESIGN DETAILS",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 1.2, color: premiumBlack)),
      actions: [
        IconButton(icon: const Icon(Icons.share_outlined, size: 20, color: premiumBlack), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  // --- 1. PREMIUM GALLERY (UPDATED: Full Width & Scrollable Thumbnails on Top) ---
  // --- 1. PREMIUM GALLERY (Updated for Placeholder & Full Width) ---
  Widget _buildPremiumGallery(StockData data) {
    // Ye widget tab dikhega jab image empty ho ya load na ho
    Widget placeholderWidget = Container(
      height: 420,
      width: double.infinity,
      color: softGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, color: Colors.grey.shade400, size: 50),
          const SizedBox(height: 8),
          Text("No Image Available", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );

    return Stack(
      children: [
        // Main Image - Full Width logic
        Obx(() {
          final imageUrl = controller.selectedImageUrl.value;
          return GestureDetector(
            onTap: imageUrl.isEmpty ? null : () => _zoomImage(Get.context!, imageUrl),
            child: Container(
              height: 420,
              width: double.infinity,
              color: softGrey,
              child: imageUrl.isEmpty
                  ? placeholderWidget
                  : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 1)),
                errorWidget: (context, url, error) => placeholderWidget, // Link error pe placeholder
              ),
            ),
          );
        }),

        Positioned(
          top: 20,
          right: 20,
          child: Obx(() {
            final isFav = controller.productData.value?.isWishlisted ?? false;
            return GestureDetector(
              onTap: () => controller.toggleWishlist(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border_rounded,
                  color: isFav ? Colors.red : premiumBlack,
                  size: 24,
                ),
              ),
            );
          }),
        ),

        // Thumbnails (Sirf tabhi dikhengi jab list empty na ho)
        if (data.images.isNotEmpty)
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 65,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: data.images.length,
                itemBuilder: (context, i) {
                  return Obx(() {
                    final isSelected = controller.selectedImageUrl.value == data.images[i].imageUrl;
                    return GestureDetector(
                      onTap: () => controller.updateSelectedImage(data.images[i].imageUrl),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 60,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected ? goldAccent : Colors.transparent,
                              width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: data.images[i].imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
  // --- 2. MAIN INFO ---
  Widget _buildMainInfoSection(StockData data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.productDetails.category?.toUpperCase() ?? "JEWELLERY",
              style: GoogleFonts.poppins(fontSize: 11, letterSpacing: 1.5, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(data.productDetails.productName ?? "Luxurious Masterpiece",
              style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(inr.format(data.calculatedPrice.totalValuation),
                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, color: premiumBlack)),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(inr.format(data.calculatedPrice.totalValuation * 1.15), // Mock MRP
                    style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text("VAT & Taxes included. Free Insured Delivery.",
              style: GoogleFonts.poppins(fontSize: 12, color: successGreen, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: lightGold, borderRadius: BorderRadius.circular(12), border: Border.all(color: goldAccent.withOpacity(0.2))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, color: goldAccent, size: 18),
              const SizedBox(width: 8),
              Text("Available Offers", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: goldAccent)),
            ],
          ),
          const SizedBox(height: 10),
          _offerItem("Flat 10% Off on SBI Credit Cards. T&C Apply."),
          _offerItem("Extra ₹2000 Off on your first luxury purchase."),
        ],
      ),
    );
  }

  Widget _offerItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: goldAccent),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 11, color: premiumBlack))),
        ],
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _trustItem(Icons.verified_outlined, "100% Certified"),
          _trustItem(Icons.history_outlined, "Lifetime Exchange"),
          _trustItem(Icons.security_outlined, "Secure Logistics"),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(color: softGrey, shape: BoxShape.circle),
          child: Icon(icon, color: premiumBlack, size: 22),
        ),
        const SizedBox(height: 8),
        Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPriceBreakdown(StockData data) {
    final cp = data.calculatedPrice;
    final subTotal = cp.metalValue;
    final taxPercent = double.tryParse(data.productDetails.taxPercent?.toString() ?? "0") ?? 0;
    final totalTax = subTotal * (taxPercent / 100);

    return ExpansionTile(
      title: Text("PRICE BREAKUP", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      children: [
        _priceRow("Gold Value (${data.productDetails.purity}K)", cp.metalValue),
        if (cp.stoneValuation > 0) _priceRow("Diamond & Stones", cp.stoneValuation),
        _priceRow("Making Charges", cp.totalMakingAmt),
        _priceRow("Tax (${data.productDetails.taxPercent}%)", totalTax),
        const Divider(),
        _priceRow("Final Price", cp.totalValuation, isBold: true),
      ],
    );
  }

  Widget _buildSpecifications(StockData data) {
    final rawPurity = data.productDetails.purity?.toString() ?? "0";
    final cleanedPurity = rawPurity.replaceAll(RegExp(r'[^0-9.]'), '');
    final purity = double.tryParse(cleanedPurity) ?? 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PRODUCT SPECIFICATIONS", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 15),
          _specRow("SKU", data.productDetails.productCode ?? "-"),
          _specRow("Metal", data.productDetails.metalType ?? "-"),
          _specRow("Gold Weight", "${(double.tryParse(data.weights.grossWeight?.toString() ?? '0') ?? 0).toStringAsFixed(2)} g"),
          _specRow("Gold Purity", "${purity.toStringAsFixed(0)} KT"),
          if (data.productDetails.huid != null) _specRow("HUID Unique ID", data.productDetails.huid!),
        ],
      ),
    );
  }
  Widget _buildLuxuryPromise() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      color: softGrey,
      child: Column(
        children: [
          // Section Heading
          Text("THE LUXURY PROMISE",
              style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: premiumBlack
              )
          ),
          const SizedBox(height: 30),

          // Row 1: Craftsmanship & Purity
          Row(
            children: [
              _promiseIcon(Icons.auto_awesome_outlined, "FINEST\nCRAFTSMANSHIP"),
              _promiseIcon(Icons.gpp_good_outlined, "100% PURITY\nGUARANTEED"),
            ],
          ),
          const SizedBox(height: 30),

          // Row 2: Delivery & Hallmarking
          Row(
            children: [
              _promiseIcon(Icons.local_shipping_outlined, "FREE INSURED\nDELIVERY"),
              _promiseIcon(Icons.verified_user_outlined, "BIS HALLMARKED\nJEWELLERY"),
            ],
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.black12, thickness: 1),
          const SizedBox(height: 20),

          // Bottom Tagline
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Each piece is handcrafted by master artisans and undergoes 25 quality checks to ensure perfection for your special moments.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 10.5,
                  color: Colors.grey.shade600,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.3
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Helper Widget for individual promise items
  Widget _promiseIcon(IconData icon, String label) {
    return Expanded( // Expanded use kiya hai taaki screen width ke hisaab se space barabar divide ho
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4)
                  )
                ]
            ),
            child: Icon(icon, color: goldAccent, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: premiumBlack,
                letterSpacing: 0.5,
                height: 1.3
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: isBold ? premiumBlack : Colors.grey.shade700, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(inr.format(val), style: GoogleFonts.outfit(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _specRow(String l, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(l, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600))),
          Expanded(child: Text(v, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: premiumBlack))),
        ],
      ),
    );
  }

  Widget _buildDeliveryChecker() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Check Delivery Availability", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter Pincode",
              hintStyle: GoogleFonts.poppins(fontSize: 12),
              suffix: Text("CHECK", style: GoogleFonts.poppins(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              filled: true,
              fillColor: softGrey,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoneDetails(List<Stone> stones) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("DIAMOND & STONE DETAILS", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 10),
          ...stones.map((s) => Text("• ${s.stoneItemName}: ${s.stoneQuantity} pcs (${s.stoneGsWeight} ${s.stoneGsWeightType})",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700, height: 1.8))),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, -6))],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 42,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined, size: 18, color: goldAccent),
                label: Text("CART", style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: goldAccent)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: goldAccent, width: 1.3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.flash_on_rounded, size: 18, color: Colors.white),
                label: Text("BUY NOW", style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: goldAccent, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CUSTOMER REVIEWS", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: starColor, size: 20),
                      const SizedBox(width: 4),
                      Text("4.8", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("  (124 Reviews)", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              TextButton(onPressed: () {}, child: Text("Write a review", style: GoogleFonts.poppins(color: goldAccent, fontSize: 12, fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 20),
          _buildReviewItem(name: "Ananya Sharma", rating: 5, comment: "Absolutely stunning!", date: "2 days ago", isVerified: true),
          const Divider(height: 30),
          _buildReviewItem(name: "Rohan Mehra", rating: 4, comment: "Very elegant design.", date: "1 week ago", isVerified: true),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text("VIEW ALL REVIEWS", style: GoogleFonts.poppins(color: premiumBlack, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReviewItem({required String name, required int rating, required String comment, required String date, bool isVerified = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(children: List.generate(5, (index) => Icon(Icons.star_rounded, size: 14, color: index < rating ? starColor : Colors.grey.shade300))),
            const SizedBox(width: 8),
            if (isVerified)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: successGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Row(children: [const Icon(Icons.verified, size: 10, color: successGreen), const SizedBox(width: 4), Text("Verified Buyer", style: GoogleFonts.poppins(fontSize: 9, color: successGreen, fontWeight: FontWeight.w600))]),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(comment, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade800, height: 1.5)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(name, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)), Text(date, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey))]),
      ],
    );
  }

  void _zoomImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(child: InteractiveViewer(child: CachedNetworkImage(imageUrl: url))),
            Positioned(top: 40, right: 20, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Get.back())),
          ],
        ),
      ),
    );
  }


  Widget _buildSimilarProducts() {
    return Obx(() {
      if (controller.isSimilarLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator(color: goldAccent, strokeWidth: 1.5)),
        );
      }

      if (controller.similarProducts.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 8, color: softGrey), // Thicker section separator
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SIMILAR DESIGNS",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: premiumBlack)),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: 40,
                      color: goldAccent, // Subtle underline accent
                    )
                  ],
                ),
                Text("VIEW ALL",
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: goldAccent, letterSpacing: 0.5)),
              ],
            ),
          ),
          SizedBox(
            height: 310, // Adjusted height for shadows
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.similarProducts.length,
              itemBuilder: (context, index) {
                final item = controller.similarProducts[index];
                final detail = item.productDetails;
                final price = item.calculatedPrice;

                return GestureDetector(
                  onTap: () => controller.loadNewProduct(detail.id),
                  child: Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Image Section ---
                        Stack(
                          children: [
                            Container(
                              height: 190,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9), // Lighter than softGrey
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                child: CachedNetworkImage(
                                  imageUrl: item.imageUrls.isNotEmpty ? item.imageUrls.first.imageUrl : "",
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Center(child: Icon(Icons.photo, color: Colors.grey.shade300)),
                                  errorWidget: (c, u, e) => const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                                ),
                              ),
                            ),
                            // Premium "NEW" Tag
                            Positioned(
                              top: 10,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(
                                    color: goldAccent,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4))
                                ),
                                child: Text("NEW", style: GoogleFonts.poppins(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),

                        // --- Content Section ---
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.productName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade600, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    inr.format(price.totalValuation),
                                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: premiumBlack),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.scale_outlined, size: 10, color: Colors.grey.shade400),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${item.weights.grossWeight} g",
                                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      );
    });
  }
}