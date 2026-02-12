import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/order_detail_controller.dart';
import 'package:flutter/services.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final OrderDetailController controller = Get.put(OrderDetailController());
  final inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  bool isCancelExpanded = false;
  String? selectedReason;

  // Colors
  static const Color gold = Color(0xFFB8860B);
  static const Color royalNavy = Color(0xFF1A237E);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color softBeige = Color(0xFFFDFBF7);
  static const Color borderGold = Color(0xFFE8E0D5);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color cancelledGrey = Color(0xFF9E9E9E); // Naya Color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBeige,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: gold, strokeWidth: 2));
        }
        final data = controller.orderDetail.value;
        if (data == null) return const Center(child: Text("Order details not found."));

        // Status Check
        bool isCancelled = data.order!.orderStatus.toString().toLowerCase() == 'cancelled';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildOrderHero(data.order!, isCancelled),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Shipping Address
                    _buildSectionHeader("DELIVERY ADDRESS", isCancelled),
                    _buildAddressCard(isCancelled),
                    const SizedBox(height: 25),

                    // 2. Timeline
                    _buildSectionHeader("TRACK STATUS", isCancelled),
                    _buildEnhancedTimeline(data.statusHistory!, isCancelled),
                    const SizedBox(height: 25),

                    // 3. Items
                    _buildSectionHeader("SHIPMENT DETAILS", isCancelled),
                    ...data.items!.map((item) => _buildPremiumItemCard(item, isCancelled)).toList(),
                    const SizedBox(height: 25),

                    // 4. Invoice Download (Hide if cancelled)
                    if (!isCancelled) ...[
                      _buildInvoiceTile(),
                      const SizedBox(height: 25),
                    ],

                    // 5. Payment Bill
                    _buildSectionHeader("PAYMENT SUMMARY", isCancelled),
                    _buildLuxuryBill(data.order!, isCancelled),
                    const SizedBox(height: 25),

                    // 6. Support Section
                    _buildSupportSection(isCancelled),
                    const SizedBox(height: 30),

                    // 7. Cancel Button (Only if "Placed")
                    if (data.order!.orderStatus == "Placed" && !isCancelled)
                      _buildExpandableCancelSection(),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: surfaceWhite,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: royalNavy, size: 20),
        onPressed: () => Get.back(),
      ),
      title: Text("ORDER SUMMARY",
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: royalNavy)),
    );
  }

  Widget _buildAddressCard(bool isCancelled) {
    final addr = controller.shippingAddress.value;
    if (addr == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isCancelled ? Colors.grey.shade200 : borderGold.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: isCancelled ? cancelledGrey : gold, size: 18),
              const SizedBox(width: 8),
              Text(addr['address_type'].toString().toUpperCase(),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: isCancelled ? cancelledGrey : gold)),
            ],
          ),
          const Divider(height: 20),
          Text(addr['receiver_name'].toString().toUpperCase(),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: isCancelled ? cancelledGrey : royalNavy)),
          const SizedBox(height: 4),
          Text(
            "${addr['house_no_building']}, ${addr['street_area']}, ${addr['city']} - ${addr['pincode']}",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHero(order, bool isCancelled) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ORD - ${order.orderNo}",
                  style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isCancelled ? Colors.red.shade300 : royalNavy,
                      decoration: isCancelled ? TextDecoration.lineThrough : null // Strike through for cancelled
                  )),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isCancelled ? Colors.red.shade50 : successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.orderStatus.toUpperCase(),
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isCancelled ? Colors.red : successGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTimeline(List history, bool isCancelled) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isCancelled ? Colors.grey.shade100 : borderGold.withOpacity(0.3))
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final h = history[index];
          bool isLast = index == history.length - 1;
          bool isCancelStep = h.status.toString().toLowerCase() == 'cancelled';

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon aur Connecting Line Logic
                Column(
                  children: [
                    Icon(
                      isCancelStep ? Icons.cancel : Icons.check_circle,
                      color: isCancelStep ? Colors.red : successGreen,
                      size: 18,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: isCancelled ? Colors.grey.shade200 : successGreen.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 15),
                // Status Text aur Remarks
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.status.toString().toUpperCase(),
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isCancelStep ? Colors.red : royalNavy,
                              letterSpacing: 0.5
                          ),
                        ),
                        // Remarks Section
                        if (h.remarks != null && h.remarks.toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              h.remarks.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  height: 1.4
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLuxuryBill(order, bool isCancelled) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCancelled ? Colors.grey.shade50 : surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isCancelled ? Colors.grey.shade200 : borderGold),
      ),
      child: Column(
        children: [
          _billRow("Subtotal", order.subtotal, isCancelled ? cancelledGrey : royalNavy),
          _billRow("Tax (GST)", order.taxAmount, isCancelled ? cancelledGrey : royalNavy),
          _billRow("Discount", "- ${order.discountAmount}", Colors.redAccent),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount", style: GoogleFonts.poppins(color: isCancelled ? cancelledGrey : royalNavy, fontWeight: FontWeight.w700)),
              Text(inr.format(_safeParse(order.totalAmount)),
                  style: GoogleFonts.outfit(color: isCancelled ? cancelledGrey : gold, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumItemCard(item, bool isCancelled) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: surfaceWhite,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isCancelled ? Colors.grey.shade100 : borderGold.withOpacity(0.3))
      ),
      child: Row(
        children: [
          Icon(Icons.diamond, color: isCancelled ? cancelledGrey : gold, size: 30),
          const SizedBox(width: 15),
          Expanded(child: Text(item.productName,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isCancelled ? cancelledGrey : royalNavy))),
          Text(inr.format(_safeParse(item.itemPrice)),
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: isCancelled ? cancelledGrey : royalNavy)),
        ],
      ),
    );
  }

  Widget _buildSupportSection(bool isCancelled) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: isCancelled ? cancelledGrey : royalNavy, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.support_agent, color: Colors.white),
          const SizedBox(width: 12),
          Text("Need help with this order?", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isCancelled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800, color: isCancelled ? cancelledGrey : gold, letterSpacing: 1.2)),
    );
  }

  // --- Invoice & Cancel methods (vahi rahega jo pehle tha) ---
  Widget _buildInvoiceTile() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: gold.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: gold.withOpacity(0.2))),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: gold),
          const SizedBox(width: 12),
          Text("Download Digital Invoice", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: gold)),
          const Spacer(),
          const Icon(Icons.download_for_offline, color: gold, size: 20),
        ],
      ),
    );
  }

  Widget _buildExpandableCancelSection() {
    final List<String> reasons = ["Changed my mind", "Address is incorrect", "Ordered by mistake", "Delayed delivery", "Other"];
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => isCancelExpanded = !isCancelExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined, color: Colors.red.shade300, size: 18),
                const SizedBox(width: 8),
                Text("CANCEL ORDER", style: GoogleFonts.poppins(color: Colors.red.shade300, fontWeight: FontWeight.bold, fontSize: 13)),
                Icon(isCancelExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.red.shade300),
              ],
            ),
          ),
        ),
        if (isCancelExpanded)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: surfaceWhite, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.red.withOpacity(0.1))),
            child: Column(
              children: [
                ...reasons.map((r) => RadioListTile(
                  value: r, groupValue: selectedReason, dense: true, activeColor: Colors.redAccent,
                  title: Text(r, style: GoogleFonts.poppins(fontSize: 12)),
                  onChanged: (val) => setState(() => selectedReason = val as String),
                )),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: (selectedReason == null || controller.isCancelling.value)
                      ? null
                      : () => _confirmCancel(),                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 45)),
                  child: Text("CONFIRM CANCELLATION", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ],
            ),
          ),
      ],
    );
  }

  void _confirmCancel() {
    final orderId = controller.orderDetail.value?.order?.id;
    if (orderId == null || selectedReason == null) return;

    Get.defaultDialog(
        title: "CANCEL ORDER?",
        titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: royalNavy),
        middleText: "Are you sure you want to cancel this order with reason: '$selectedReason'?",
        textConfirm: "YES, CANCEL",
        textCancel: "NO, KEEP IT",
        confirmTextColor: Colors.white,
        buttonColor: Colors.redAccent,
        onConfirm: () {
          Get.back(); // Dialog band karein
          controller.cancelOrder(orderId, selectedReason!);
        }
    );
  }

  Widget _billRow(String l, String v, Color c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12)),
          Text(inr.format(_safeParse(v)), style: GoogleFonts.outfit(color: c, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  double _safeParse(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }
}