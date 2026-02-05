import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/controller/AppDataController.dart';
import '../controller/StockDetailController.dart';

class ProductReviewsPage extends StatelessWidget {
  const ProductReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "All Reviews",
          style: GoogleFonts.cinzel(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isReviewsLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Rating Summary Header
              _buildRatingSummary(controller),

              const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

              // 2. Reviews List
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.reviewsList.length,
                  separatorBuilder: (context, index) => const Divider(height: 40),
                  itemBuilder: (context, index) {
                    final review = controller.reviewsList[index];
                    return _buildReviewItem(
                      id: review['id'], // ID add kiya
                      userId: review['user_id'], // UserID add kiya
                      name: review['user_name'] ?? "Guest User",
                      rating: (review['rating'] as num).toDouble(),
                      comment: review['comment'] ?? "",
                      date: review['created_at'] ?? "",
                      isVerified: review['is_verified'] ?? false,
                      imageMain: review['images_main'],
                      imageSub: review['images_sub'],
                      context: context,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRatingSummary(ProductDetailController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Left Side: Big Rating
          Column(
            children: [
              Text(
                controller.averageRating.toString(),
                style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                    Icons.star_rounded,
                    color: i < controller.averageRating.floor() ? Colors.amber : Colors.grey[300],
                    size: 18
                )),
              ),
              const SizedBox(height: 4),
              Text(
                "${controller.reviewsList.length} Reviews",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 40),

          // Right Side: Progress Bars
          Expanded(
            child: Column(
              children: [
                _buildStatBar(5, 0.8), // Static for now, can be dynamic
                _buildStatBar(4, 0.6),
                _buildStatBar(3, 0.1),
                _buildStatBar(2, 0.05),
                _buildStatBar(1, 0.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatBar(int star, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$star", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[100],
              color: Colors.amber,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildReviewItem({
    required int id, // Add this
    required int userId, // Add this
    required String name,
    required double rating,
    required String comment,
    required String date,
    required bool isVerified,
    String? imageMain,
    String? imageSub,
    required BuildContext context, // <--- Yeh line add karein
  }) {
    final controller = Get.find<ProductDetailController>();
    // Login user ki ID nikalne ke liye (Aapka AppDataController use karein)
    final int currentUserId = AppDataController.to.staffId.value ?? 0;

    // --- Date Logic ---
    DateTime reviewDate = DateTime.parse(date).toUtc();
    DateTime currentDate = DateTime.now().toUtc();
    int daysDifference = currentDate.difference(reviewDate).inDays;
    bool isExpired = daysDifference >= 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
        //     Text(date.split('T')[0], style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
        //   ],
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(date.split('T')[0], style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
              ],
            ),

            // --- Delete Button Logic ---
            if (userId == currentUserId)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: isExpired ? Colors.grey[300] : Colors.red[400],
                ),
                onPressed: () {
                  if (isExpired) {
                    Get.snackbar(
                      "Action Denied",
                      "Reviews older than 3 days cannot be deleted.",
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.defaultDialog(
                      title: "Delete Review",
                      middleText: "Are you sure you want to remove this review?",
                      textConfirm: "Delete",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      onConfirm: () {
                        Get.back();
                        controller.deleteReview(id); // Controller function call
                      },
                    );
                  }
                },
              ),
          ],
        ),

        Row(
          children: [
            Row(children: List.generate(5, (i) => Icon(Icons.star_rounded, color: i < rating ? Colors.amber : Colors.grey.shade300, size: 14))),
            if (isVerified) ...[
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: Colors.green, size: 12),
              const SizedBox(width: 2),
              Text("Verified Buyer", style: GoogleFonts.poppins(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w500)),
            ]
          ],
        ),
        const SizedBox(height: 8),
        Text(comment, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade800, height: 1.4)),

        // Images Section
        if (imageMain != null || imageSub != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              // Ab yahan Get.context! ki jagah direct 'context' use karein jo parameter se aa raha hai
              if (imageMain != null) _reviewThumbnail(imageMain, context),
              if (imageSub != null) ...[const SizedBox(width: 10), _reviewThumbnail(imageSub, context)],
            ],
          ),
        ],
      ],
    );
  }
  Widget _reviewThumbnail(String url, BuildContext context) { // context add kiya
    String finalUrl = cleanImageUrl(url);

    return GestureDetector(
      onTap: () => _showFullScreenImage(context, url), // Yahan zoom trigger hoga
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            finalUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            },
          ),
        ),
      ),
    );
  }

  String cleanImageUrl(String? url) {
    if (url == null || url.isEmpty) return "";
    if (url.contains("https", 10)) {
      int secondHttpsIndex = url.lastIndexOf("https");
      String cleaned = url.substring(secondHttpsIndex);
      return Uri.decodeFull(cleaned);
    }
    return url;
  }

  void _showFullScreenImage(BuildContext context, String url) {
    String finalUrl = cleanImageUrl(url);

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background dismiss layer
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black.withOpacity(0.9),
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            // Zoomable Image
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                finalUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white, size: 50),
              ),
            ),

            // Close Button
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}