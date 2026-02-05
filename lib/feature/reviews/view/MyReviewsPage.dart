import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/MyReviewsController.dart';

class MyReviewsPage extends StatelessWidget {
  final controller = Get.put(MyReviewsController());
  final dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    controller.fetchMyReviews();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Premium light grey background
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        surfaceTintColor: Colors.white,
        title: const Text(
          "My Reviews",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (controller.reviews.isEmpty) {
          return const Center(child: Text("No reviews yet", style: TextStyle(color: Colors.grey)));
        }

        double avgRating = controller.reviews
            .map((r) => (r['rating'] as num).toDouble())
            .reduce((a, b) => a + b) /
            controller.reviews.length;

        return Column(
          children: [
            // ===== Premium Summary Card =====
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat(Icons.rate_review_outlined, controller.reviews.length, "Total"),
                  _stat(Icons.star_rounded, avgRating.toStringAsFixed(1), "Rating", color: Colors.amber),
                  _stat(Icons.verified_user_outlined, "100%", "Reliability", color: Colors.blueAccent),
                ],
              ),
            ),

            // ===== Section Divider =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    "HISTORY",
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Divider(color: Colors.grey.shade300, thickness: 0.8)),
                ],
              ),
            ),

            // ===== Reviews List =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: controller.reviews.length,
                itemBuilder: (_, index) {
                  final r = controller.reviews[index];
                  DateTime parsedDate = DateTime.parse(r['created_at']);
                  String readableDate = dateFormat.format(parsedDate);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                r['product_name'] ?? "Product",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF2D3436),
                                ),
                              ),
                            ),
                            Text(
                              readableDate,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Stars
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: i < r['rating'] ? Colors.amber : Colors.grey.shade200,
                            )),
                            if (r['is_verified'] == true) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.verified, color: Colors.green, size: 14),
                              const SizedBox(width: 2),
                              const Text("Verified Purchase", style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
                            ]
                          ],
                        ),

                        const SizedBox(height: 12),
                        Text(
                          r['comment'] ?? "",
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.5),
                        ),

                        // ===== Optimized Images Layout =====
                        if (r['images_main'] != null || r['images_sub'] != null) ...[
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                if (r['images_main'] != null)
                                  _reviewImage(r['images_main']),
                                if (r['images_sub'] != null) ...[
                                  const SizedBox(width: 10),
                                  _reviewImage(r['images_sub']),
                                ]
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // Optimized Image Widget: Ab ye stretch nahi hogi
  Widget _reviewImage(String url) {
    return GestureDetector(
      onTap: () => _openImageViewer(url),
      child: Container(
        width: 100, // Fixed width for consistent look
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }

  void _openImageViewer(String url) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Widget _stat(IconData icon, dynamic value, String label, {Color color = Colors.black}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}