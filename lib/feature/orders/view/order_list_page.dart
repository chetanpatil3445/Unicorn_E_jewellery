import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_e_jewellers/Routes/app_routes.dart';
import '../controller/order_controller.dart';

class OrderListPage extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());
  final inrFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  // Colors for Premium Look
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text("MY ORDERS",
            style: GoogleFonts.cinzel(color: deepBlack, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: deepBlack, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: goldAccent));
        }

        if (controller.ordersList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchOrders(),
          color: goldAccent,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: controller.ordersList.length,
            itemBuilder: (context, index) {
              final order = controller.ordersList[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(order) {
    // Formatting date
    DateTime date = DateTime.parse(order.createdAt);
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          // Upper Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderNo, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: deepBlack)),
                    const SizedBox(height: 4),
                    Text(formattedDate, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                _buildStatusBadge(order.orderStatus),
              ],
            ),
          ),
          const Divider(height: 1),
          // Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildItemCountBox(order.itemsCount),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Amount", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                      Text(inrFormat.format(double.parse(order.totalAmount)),
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: deepBlack)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Payment", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    Text(order.paymentMode.toUpperCase(),
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: goldAccent)),
                  ],
                ),
              ],
            ),
          ),
          // Action Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFB),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.orangeAccent),
                    const SizedBox(width: 6),
                    Text("Payment: ${order.paymentStatus}", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.orderDetailPage, arguments: order.id);
                    },
                  child: Row(
                    children: [
                      Text("VIEW DETAILS", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: deepBlack)),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: deepBlack),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status.toUpperCase(),
          style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue.shade800, letterSpacing: 0.5)),
    );
  }

  Widget _buildItemCountBox(String count) {
    return Container(
      height: 45, width: 45,
      decoration: BoxDecoration(
        color: goldAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(count, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: goldAccent)),
            Text("ITEM", style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.bold, color: goldAccent)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text("NO ORDERS YET", style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          Text("Looks like you haven't placed any orders.", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}