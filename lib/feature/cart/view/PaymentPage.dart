import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = "upi";
  final inrFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  late double subtotal;
  double tax = 0.0;
  double delivery = 0.0;
  double totalPayable = 0.0;

  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color successGreen = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    subtotal = Get.arguments ?? 0.0;
    tax = subtotal * 0.03;
    totalPayable = subtotal + tax + delivery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text("SECURE CHECKOUT",
            style: GoogleFonts.cinzel(color: deepBlack, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 2)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: deepBlack), onPressed: () => Get.back()),
      ),
      body: Column(
        children: [
          _buildProgressStepper(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  _buildAddressPreview(), // New: Address Summary
                  const SizedBox(height: 15),
                  _buildDeliveryEstimation(), // New: Delivery Date
                  const SizedBox(height: 20),
                  _buildDetailedOrderBrief(),
                  const SizedBox(height: 25),

                  // Promo Code Section
                  _buildPromoCodeSection(),
                  const SizedBox(height: 25),

                  Text("SELECT PAYMENT METHOD",
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                  const SizedBox(height: 15),

                  _paymentOptionCard("upi", "UPI (GPay, PhonePe, Paytm)", Icons.account_balance_wallet_outlined),
                  _paymentOptionCard("card", "Credit / Debit Cards", Icons.credit_card_outlined),
                  _paymentOptionCard("netbanking", "Net Banking", Icons.language_outlined),

                  // COD with condition
                  _paymentOptionCard("cod", "Cash On Delivery", Icons.payments_outlined,
                      subtitle: totalPayable > 50000 ? "Not available for orders above ₹50k" : "Available"),

                  const SizedBox(height: 30),
                  _buildSecurityInfo(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildPayButton(),
        ],
      ),
    );
  }

  // --- 1. Address Preview Section ---
  Widget _buildAddressPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: goldAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("DELIVERING TO", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text("Home - Pune, Maharashtra 411001",
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: deepBlack)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: Text("CHANGE", style: GoogleFonts.poppins(fontSize: 11, color: goldAccent, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  // --- 2. Delivery Estimation ---
  Widget _buildDeliveryEstimation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: successGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: successGreen.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined, color: successGreen, size: 18),
          const SizedBox(width: 12),
          Text("Expected Delivery by:", style: GoogleFonts.poppins(fontSize: 12, color: deepBlack)),
          const Spacer(),
          Text("12th Feb, 2026", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: successGreen)),
        ],
      ),
    );
  }

  // --- 3. Promo Code Section ---
  Widget _buildPromoCodeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: goldAccent.withOpacity(0.3), style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, color: goldAccent, size: 18),
          const SizedBox(width: 12),
          Text("APPLY PROMO CODE", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: deepBlack)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // --- Price Breakdown ---
  Widget _buildDetailedOrderBrief() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ORDER SUMMARY",
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _priceRow("Bag Subtotal", inrFormatter.format(subtotal)),
              const SizedBox(height: 12),
              _priceRow("Estimated GST (3%)", inrFormatter.format(tax)),
              const SizedBox(height: 12),
              _priceRow("Shipping & Handling", "FREE", isFree: true),
              const Divider(height: 30, thickness: 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("AMOUNT PAYABLE",
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: deepBlack)),
                  Text(inrFormatter.format(totalPayable),
                      style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: deepBlack)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
        Text(value, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: isFree ? successGreen : deepBlack)),
      ],
    );
  }

  // --- Payment Card (Fixed Overflow) ---
  Widget _paymentOptionCard(String id, String title, IconData icon, {String? subtitle}) {
    bool isSelected = selectedMethod == id;
    bool isDisabled = id == "cod" && totalPayable > 50000;

    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => selectedMethod = id),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isSelected ? goldAccent : Colors.transparent, width: 1.5),
            boxShadow: isSelected ? [BoxShadow(color: goldAccent.withOpacity(0.1), blurRadius: 10)] : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: isSelected ? goldAccent.withOpacity(0.1) : Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: isSelected ? goldAccent : Colors.grey, size: 20),
              ),
              const SizedBox(width: 15),
              Expanded( // <-- FIXED OVERFLOW HERE
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? deepBlack : Colors.grey.shade700)),
                    if (subtitle != null)
                      Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: isDisabled ? Colors.red : Colors.grey)),
                  ],
                ),
              ),
              Radio(
                value: id,
                groupValue: selectedMethod,
                activeColor: goldAccent,
                onChanged: isDisabled ? null : (val) => setState(() => selectedMethod = val as String),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Standard Components
  Widget _buildProgressStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepperIcon(Icons.check_circle, "Bag", true),
          _stepperLine(true),
          _stepperIcon(Icons.check_circle, "Address", true),
          _stepperLine(true),
          _stepperIcon(Icons.radio_button_checked, "Payment", true),
        ],
      ),
    );
  }

  Widget _stepperIcon(IconData icon, String label, bool isActive) {
    return Column(children: [
      Icon(icon, size: 18, color: isActive ? goldAccent : Colors.grey.shade300),
      const SizedBox(height: 4),
      Text(label, style: GoogleFonts.poppins(fontSize: 9, color: isActive ? deepBlack : Colors.grey, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _stepperLine(bool isActive) {
    return Container(width: 35, height: 1, color: isActive ? goldAccent : Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 5,));
  }

  Widget _buildSecurityInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user_outlined, size: 14, color: successGreen),
            const SizedBox(width: 6),
            Text("PCI-DSS COMPLIANT | 256-BIT ENCRYPTION", style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 10),
        Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/PayPal.svg/1200px-PayPal.svg.png", height: 20, color: Colors.grey.withOpacity(0.5), errorBuilder: (c,e,s)=>SizedBox()),
      ],
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: deepBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0
          ),
          onPressed: () {
            if (selectedMethod == "cod") {
              // Agar COD select hai toh direct Order Success par le jayein
              // Get.to(() => OrderSuccessPage());
              print("Order Placed via COD");
            } else {
              // Agar Online payment select hai toh popup dikhayein
              _showPaymentMaintenanceDialog();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  selectedMethod == "cod" ? "PLACE ORDER (COD)" : "COMPLETE PAYMENT",
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2)
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentMaintenanceDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with soft background
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: goldAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.handshake_outlined, color: goldAccent, size: 40), // Construction / Maintenance Feel
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "ONLINE PAYMENT UNAVAILABLE",
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                    color: deepBlack
                ),
              ),
              const SizedBox(height: 15),

              // Professional Message
              Text(
                "Our online payment gateway is currently under maintenance as we upgrade our systems to serve you better. We sincerely apologize for any inconvenience caused.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.6
                ),
              ),
              const SizedBox(height: 12),

              // Call to Action
              Text(
                "Please select 'Cash on Delivery' to proceed with your order.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: successGreen
                ),
              ),
              const SizedBox(height: 25),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepBlack,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() => selectedMethod = "cod"); // Auto-select COD
                    Get.back(); // Close dialog
                  },
                  child: Text(
                    "CHOOSE COD & CONTINUE",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      transitionCurve: Curves.easeInOutBack,
    );
  }

}