import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/cart_model.dart';
import '../controller/CartController.dart';
import 'PaymentPage.dart';

class CartPage extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  final inrFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color premiumGrey = Color(0xFFF8F8F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      appBar: AppBar(
        title: Text("MY SHOPPING BAG",
            style: GoogleFonts.cinzel(color: deepBlack, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.8)),
        backgroundColor: Colors.white,
        elevation: 0, // Flattened for premium look
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: deepBlack), onPressed: () => Get.back()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: goldAccent, strokeWidth: 2));

        if (controller.cartData.value == null || controller.cartData.value!.items.isEmpty) {
          return _buildEmptyState();
        }

        final data = controller.cartData.value!;

        return Column(
          children: [
            // --- TOP SUMMARY BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text("${data.count} ITEMS IN YOUR BAG",
                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.8)),
                  const Spacer(),
                  Text("SUBTOTAL: ", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                  Text(inrFormatter.format(data.cartTotal),
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: deepBlack)),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: data.items.length,
                itemBuilder: (context, index) => _buildCartCard(data.items[index]),
              ),
            ),

            _buildCompactCheckout(data.cartTotal),
          ],
        );
      }),
    );
  }

  Widget _buildCartCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 8))
        ],
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Image Shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(item.imageUrls[0].imageUrl, width: 100, height: 110, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(width:100, height:110, color: premiumGrey, child: const Icon(Icons.image_outlined, color: Colors.grey))),
            ),
          ),
          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.itemDetails.productName.toUpperCase(),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
                          Text("#${item.itemDetails.productCode}",
                              style: GoogleFonts.poppins(fontSize: 9, color: goldAccent, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showDeleteConfirmation(item),
                      icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 18),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Text("${item.itemDetails.metalType} • ${item.itemDetails.category}",
                    style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w500)),

                const SizedBox(height: 12),

                // PRICE SECTION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(inrFormatter.format(item.itemTotal),
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17, color: deepBlack)),
                    const SizedBox(width: 8),
                    if (item.priceDiff != 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (item.priceDiff > 0 ? Colors.red : Colors.green).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(item.priceDiff > 0 ? Icons.trending_up : Icons.trending_down,
                            color: item.priceDiff > 0 ? Colors.red : Colors.green, size: 12),
                      ),
                  ],
                ),

                // PRICE CHANGE INDICATOR
                if (item.priceDiff != 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    "Price when added: ${inrFormatter.format(item.priceAtAdded)}",
                    style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey, decoration: TextDecoration.lineThrough),
                  ),
                  Text(
                    "${item.priceDiff > 0 ? "Increased by " : "Dropped by "} ${inrFormatter.format(item.priceDiff.abs())}",
                    style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: item.priceDiff > 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // COMPACT & PREMIUM CHECKOUT
  Widget _buildCompactCheckout(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TOTAL PAYABLE",
                    style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 9, letterSpacing: 0.5)),
                Text(inrFormatter.format(total),
                    style: GoogleFonts.outfit(color: deepBlack, fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepBlack,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Get.to(() => PaymentPage(),
                        transition: Transition.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 400),
                        arguments: total // Yaha se amount pass ho rahi hai
                    );
                  },
                  child: Text("PLACE ORDER",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 1
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showDeleteConfirmation(CartItem item) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("REMOVE ITEM",
                  style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
              const SizedBox(height: 16),
              Text("Do you want to remove this piece from your luxury bag?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFEEEEEE)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Get.back(),
                      child: Text("KEEP", style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.back();
                        controller.removeFromCart(item.cartId, item.itemDetails.id);
                      },
                      child: Text("REMOVE", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 20),
          Text("YOUR BAG IS EMPTY",
              style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          TextButton(
              onPressed: () => Get.back(),
              child: Text("EXPLORE COLLECTIONS", style: GoogleFonts.poppins(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 11))),
        ],
      ),
    );
  }
}