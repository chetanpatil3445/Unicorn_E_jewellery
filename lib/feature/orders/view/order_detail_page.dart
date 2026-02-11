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

  static const Color gold = Color(0xFFB8860B);
  static const Color royalNavy = Color(0xFF1A237E);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color softBeige = Color(0xFFFDFBF7);
  static const Color borderGold = Color(0xFFE8E0D5);
  static const Color successGreen = Color(0xFF2E7D32);

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

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildOrderHero(data.order!),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Shipping Address (Naya Content)
                    _buildSectionHeader("DELIVERY ADDRESS"),
                    _buildAddressCard(),
                    const SizedBox(height: 25),

                    // 2. Timeline
                    _buildSectionHeader("TRACK STATUS"),
                    _buildEnhancedTimeline(data.statusHistory!),
                    const SizedBox(height: 25),

                    // 3. Items
                    _buildSectionHeader("SHIPMENT DETAILS"),
                    ...data.items!.map((item) => _buildPremiumItemCard(item)).toList(),
                    const SizedBox(height: 25),

                    // 4. Invoice Download (Naya Content)
                    _buildInvoiceTile(),
                    const SizedBox(height: 25),

                    // 5. Payment Bill
                    _buildSectionHeader("PAYMENT SUMMARY"),
                    _buildLuxuryBill(data.order!),
                    const SizedBox(height: 25),

                    // 6. Support Section
                    _buildSupportSection(),
                    const SizedBox(height: 30),

                    // 7. Expandable Cancel Order Section (Professional)
                    if (data.order!.orderStatus == "Placed")
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

  // --- Naya Card: Address Section ---
  Widget _buildAddressCard() {
    final addr = controller.shippingAddress.value;

    // Agar address abhi load nahi hua
    if (addr == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceWhite,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderGold.withOpacity(0.5)),
        ),
        child: const Center(child: Text("Loading address...", style: TextStyle(fontSize: 12))),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderGold.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: royalNavy.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: gold, size: 18),
                  const SizedBox(width: 8),
                  Text(
                      addr['address_type'].toString().toUpperCase(),
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11, color: gold, letterSpacing: 1)
                  ),
                ],
              ),
              if (addr['is_default'] == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: successGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                  child: Text("DEFAULT", style: GoogleFonts.poppins(fontSize: 9, color: successGreen, fontWeight: FontWeight.bold)),
                )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, thickness: 0.5),
          ),
          Text(
            addr['receiver_name'].toString().toUpperCase(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: royalNavy),
          ),
          const SizedBox(height: 4),
          Text(
            "${addr['house_no_building']}, ${addr['street_area']},\n${addr['landmark']}, ${addr['city']}, ${addr['state']} - ${addr['pincode']}",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.6),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.phone_iphone, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                addr['phone_number'],
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: royalNavy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Naya Card: Invoice Download ---
  Widget _buildInvoiceTile() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gold.withOpacity(0.2)),
      ),
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

  // --- Expandable Cancel Section ---
  Widget _buildExpandableCancelSection() {
    final List<String> reasons = [
      "Changed my mind",
      "Address is incorrect",
      "Ordered by mistake",
      "Delayed delivery",
      "Other"
    ];

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => isCancelExpanded = !isCancelExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Colors.red.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined, color: Colors.red.shade300, size: 18),
                const SizedBox(width: 8),
                Text("CANCEL ORDER",
                    style: GoogleFonts.poppins(color: Colors.red.shade300, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                Icon(isCancelExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.red.shade300),
              ],
            ),
          ),
        ),
        if (isCancelExpanded)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select reason for cancellation",
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: royalNavy)),
                const SizedBox(height: 10),
                ...reasons.map((r) => RadioListTile(
                  value: r,
                  groupValue: selectedReason,
                  dense: true,
                  activeColor: Colors.redAccent,
                  title: Text(r, style: GoogleFonts.poppins(fontSize: 12)),
                  onChanged: (val) => setState(() => selectedReason = val as String),
                )),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: selectedReason == null ? null : () => _confirmCancel(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("CONFIRM CANCELLATION", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }

  void _confirmCancel() {
    Get.defaultDialog(
        title: "Cancel Order?",
        middleText: "Are you sure you want to cancel this order?",
        textConfirm: "YES",
        textCancel: "NO",
        confirmTextColor: Colors.white,
        buttonColor: Colors.redAccent,
        onConfirm: () {
          Get.back();
          Get.snackbar("Success", "Order Cancelled Successfully", snackPosition: SnackPosition.BOTTOM);
        }
    );
  }


  Widget _buildOrderHero(order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
              color: royalNavy.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          // Order No with Copy Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ORD - ${order.orderNo}",
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: royalNavy),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: order.orderNo)).then((_) {
                    Get.rawSnackbar(
                      message: "Order ID copied to clipboard",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: royalNavy,
                      borderRadius: 10,
                      margin: const EdgeInsets.all(15),
                      duration: const Duration(seconds: 1),
                      icon: const Icon(Icons.copy_all, color: gold, size: 20),
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 14,
                    color: gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat('dd MMM yyyy').format(DateTime.parse(order.createdAt)),
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryBill(order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderGold),
      ),
      child: Column(
        children: [
          _billRow("Subtotal", order.subtotal, royalNavy),
          _billRow("Tax (GST)", order.taxAmount, royalNavy),
          _billRow("Discount", "- ${order.discountAmount}", Colors.redAccent),
          const Divider(height: 30, color: borderGold),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Payable", style: GoogleFonts.poppins(color: royalNavy, fontWeight: FontWeight.w700)),
              Text(inr.format(_safeParse(order.totalAmount)), style: GoogleFonts.outfit(color: gold, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
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

  Widget _buildPremiumItemCard(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: surfaceWhite, borderRadius: BorderRadius.circular(15), border: Border.all(color: borderGold.withOpacity(0.3))),
      child: Row(
        children: [
          const Icon(Icons.diamond, color: gold, size: 30),
          const SizedBox(width: 15),
          Expanded(child: Text(item.productName, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: royalNavy))),
          Text(inr.format(_safeParse(item.itemPrice)), style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: royalNavy)),
        ],
      ),
    );
  }

  Widget _buildEnhancedTimeline(List history) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: surfaceWhite, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderGold.withOpacity(0.3))),
      child: Column(
        children: history.map((h) => Row(
          children: [
            const Icon(Icons.check_circle, color: successGreen, size: 16),
            const SizedBox(width: 15),
            Text(h.status, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: royalNavy)),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800, color: gold, letterSpacing: 1.2)),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: royalNavy, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.support_agent, color: Colors.white),
          const SizedBox(width: 12),
          Text("24/7 Customer Support", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
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