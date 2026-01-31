import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicorn_e_jewellers/Routes/app_routes.dart';
import '../controller/wishlist_controller.dart';
import '../model/wishlist_model.dart';

class WishlistPage extends StatelessWidget {
  final WishlistController controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("MY WISHLIST", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) return Center(child: CircularProgressIndicator());
        if (controller.wishlistItems.isEmpty) return _buildEmptyWishlist();

        return ListView.builder(
          itemCount: controller.wishlistItems.length,
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final item = controller.wishlistItems[index];
            return _buildWishlistCard(item, index);
          },
        );
      }),
    );
  }

  Widget _buildWishlistCard(WishlistItem item, int index) {
    return GestureDetector(
      // 1. Click karne par Detail Page par le jaye
      onTap: () async {
        // Arguments me Product ID bhej rahe hain
        await Get.toNamed(AppRoutes.stockDetail, arguments: item.productDetails.id);

        // Jab user detail page se wapas aaye, toh list refresh karein
        // Taaki heart icon ka status sync rahe
        controller.fetchWishlist();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white, // Tap effect ke liye background color zaroori hai
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Hero( // 2. Optional: Hero animation for smooth transition
              tag: 'product-image-${item.productDetails.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrls.isNotEmpty ? item.imageUrls[0].imageUrl : '',
                  width: 80, height: 80, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productDetails.productName,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text("${item.weights.grossWeight} GM | ${item.productDetails.metalType}",
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                  Text(item.productDetails.productCode,
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text("₹${item.calculatedPrice.totalValuation}",
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37), fontSize: 15)),
                ],
              ),
            ),
            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
              onPressed: () => controller.removeFromWishlist(item.productDetails.id, index),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text("Your wishlist is empty", style: GoogleFonts.poppins(color: Colors.grey)),
        ],
      ),
    );
  }
}