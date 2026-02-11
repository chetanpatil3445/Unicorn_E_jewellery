  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:intl/intl.dart';
  import '../../Adresses/view/AddAddressScreen.dart';
  import '../controller/PaymentController.dart';
  import '../../Adresses/view/EditAddressScreen.dart';
  import 'CouponListScreen.dart'; // Naya Screen Import karein

  class PaymentPage extends StatefulWidget {
    @override
    _PaymentPageState createState() => _PaymentPageState();
  }

  class _PaymentPageState extends State<PaymentPage> {
    final controller = Get.put(PaymentController());

    String selectedMethod = "upi";
    final inrFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    late double subtotal;
    double delivery = 0.0;

    static const Color goldAccent = Color(0xFFD4AF37);
    static const Color deepBlack = Color(0xFF1A1A1A);
    static const Color successGreen = Color(0xFF2E7D32);

    @override
    void initState() {
      super.initState();
      subtotal = Get.arguments ?? 0.0;
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
                    _buildAddressPreview(),
                    const SizedBox(height: 15),
                    _buildDeliveryEstimation(),
                    const SizedBox(height: 20),
                    // Reactive Order Summary
                    Obx(() => _buildDetailedOrderBrief()),
                    const SizedBox(height: 25),
                    // Reactive Promo Section
                    _buildPromoCodeSection(),
                    const SizedBox(height: 25),
                    Text("SELECT PAYMENT METHOD",
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                    const SizedBox(height: 15),
                    _paymentOptionCard("upi", "UPI (GPay, PhonePe, Paytm)", Icons.account_balance_wallet_outlined),
                    _paymentOptionCard("card", "Credit / Debit Cards", Icons.credit_card_outlined),
                    _paymentOptionCard("netbanking", "Net Banking", Icons.language_outlined),

                    // Reactive COD check based on final total
                    Obx(() {
                      double finalPayable = (subtotal - controller.discountAmount.value) * 1.03 + delivery;
                      return _paymentOptionCard("cod", "Cash On Delivery", Icons.payments_outlined,
                          subtitle: finalPayable > 50000 ? "Not available for orders above ₹50 Lacks" : "Available");
                    }),
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

    Widget _buildAddressPreview() {
      return Obx(() {
        if (controller.isLoading.value) {
          return Container(
            height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: const Center(child: CircularProgressIndicator(color: goldAccent, strokeWidth: 2)),
          );
        }

        var addr = controller.selectedAddress;
        bool hasAddress = addr.isNotEmpty;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: hasAddress ? Colors.black.withOpacity(0.05) : goldAccent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(hasAddress ? Icons.location_on_outlined : Icons.add_location_alt_outlined,
                  color: goldAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DELIVERING TO", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text(
                        hasAddress
                            ? "${addr['receiver_name']} - ${addr['city']}, ${addr['pincode']}"
                            : "Please add a delivery address to proceed",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: hasAddress ? FontWeight.w600 : FontWeight.w400,
                            color: hasAddress ? deepBlack : Colors.grey.shade600
                        )),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () => _showAddressSelectionSheet(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: hasAddress ? Colors.transparent : goldAccent,
                      foregroundColor: hasAddress ? goldAccent : Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      side: BorderSide(color: hasAddress ? Colors.transparent : goldAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
                  child: Text(hasAddress ? "CHANGE" : "ADD",
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold)))
            ],
          ),
        );
      });
    }

    void _showAddressSelectionSheet() {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("YOUR ADDRESSES", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close, size: 20))
                ],
              ),
              const Divider(),
              ListTile(
                onTap: () async {
                  Get.back();
                  await Get.to(() => AddAddressScreen());
                  controller.fetchCheckoutAddress();
                },
                leading: const Icon(Icons.add_circle_outline, color: goldAccent),
                title: Text("Add New Address", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: goldAccent)),
              ),
              Obx(() => controller.addresses.isEmpty
                  ? const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Text("No saved addresses found.")))
                  : Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.addresses.length,
                  itemBuilder: (context, index) {
                    var addr = controller.addresses[index];
                    bool isSelected = controller.selectedAddress['id'] == addr['id'];
                    return ListTile(
                      onTap: () => controller.updateSelectedAddress(addr),
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: goldAccent),
                      title: Text("${addr['receiver_name']} (${addr['address_type']})",
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text("${addr['house_no_building']}, ${addr['city']}",
                          style: GoogleFonts.poppins(fontSize: 11)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined, color: goldAccent, size: 20),
                        onPressed: () async {
                          Get.back();
                          await Get.to(() => EditAddressScreen(addressData: addr));
                          controller.fetchCheckoutAddress();
                        },
                      ),
                    );
                  },
                ),
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }

    Widget _buildDeliveryEstimation() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: successGreen.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: successGreen.withOpacity(0.1))),
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

  // ... PaymentPage ke andar Summary Widget ka updated logic ...

    Widget _buildDetailedOrderBrief() {
      // Ab calculation simple hai: Subtotal minus applied discount
      double discount = controller.discountAmount.value;
      double finalTotal = subtotal - discount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ORDER SUMMARY", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black.withOpacity(0.05))),
            child: Column(
              children: [
                _priceRow("Bag Subtotal", inrFormatter.format(subtotal)),

                if (discount > 0) ...[
                  const SizedBox(height: 12),
                  _priceRow("Promo Discount", "- ${inrFormatter.format(discount)}", isDiscount: true),
                ],

                const SizedBox(height: 12),
                _priceRow("Shipping & Handling", "FREE", isFree: true),

                const Divider(height: 30, thickness: 0.5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("TOTAL PAYABLE", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: deepBlack)),
                    Text(inrFormatter.format(finalTotal), style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: deepBlack)),
                  ],
                ),

                const SizedBox(height: 8),
                Text("(Prices are inclusive of all taxes)",
                    style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      );
    }

    Widget _priceRow(String label, String value, {bool isFree = false, bool isDiscount = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
          Text(value,
              style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDiscount ? successGreen : (isFree ? successGreen : deepBlack)
              )),
        ],
      );
    }
    Widget _paymentOptionCard(String id, String title, IconData icon, {String? subtitle}) {
      bool isSelected = selectedMethod == id;

      // Check if COD is disabled based on current total
      double finalTotal = (subtotal - controller.discountAmount.value) * 1.03;
      bool isDisabled = id == "cod" && finalTotal > 5000000;

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
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isSelected ? goldAccent.withOpacity(0.1) : Colors.grey.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: isSelected ? goldAccent : Colors.grey, size: 20)),
                const SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? deepBlack : Colors.grey.shade700)), if (subtitle != null) Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: isDisabled ? Colors.red : Colors.grey))])),
                Radio(value: id, groupValue: selectedMethod, activeColor: goldAccent, onChanged: isDisabled ? null : (val) => setState(() => selectedMethod = val as String))
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildProgressStepper() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15), color: Colors.white,
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
      return Column(children: [Icon(icon, size: 18, color: isActive ? goldAccent : Colors.grey.shade300), const SizedBox(height: 4), Text(label, style: GoogleFonts.poppins(fontSize: 9, color: isActive ? deepBlack : Colors.grey, fontWeight: FontWeight.w600))]);
    }

    Widget _stepperLine(bool isActive) {
      return Container(width: 35, height: 1, color: isActive ? goldAccent : Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 5));
    }

    Widget _buildPromoCodeSection() {
      final TextEditingController _couponTextController = TextEditingController();

      return Obx(() {
        bool hasCoupon = controller.selectedCoupon.isNotEmpty;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: hasCoupon ? successGreen : goldAccent.withOpacity(0.3),
                width: hasCoupon ? 1.5 : 1
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4)
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("PROMO CODE",
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                  if (!hasCoupon)
                    GestureDetector(
                      onTap: () => Get.to(() => CouponListScreen(subtotal: subtotal)),
                      child: Text("VIEW OFFERS",
                          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: goldAccent)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (hasCoupon)
              // Applied State
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: successGreen.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.verified, color: successGreen, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.selectedCoupon['code'],
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: deepBlack)),
                          Text("Savings of ${inrFormatter.format(controller.discountAmount.value)} applied",
                              style: GoogleFonts.poppins(fontSize: 11, color: successGreen, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () => controller.removeCoupon(),
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 22)
                    )
                  ],
                )
              else
              // Input State (Paste option)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _couponTextController,
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: "Enter or paste code",
                            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.content_paste, size: 18, color: goldAccent),
                              onPressed: () async {
                                // Automatically paste from clipboard
                                var data = await Get.rootDelegate.history.last.toString(); // Placeholder logic
                                // Standard way using Clipboard package:
                                // ClipboardData? data = await Clipboard.getData('text/plain');
                                // if(data != null) _couponTextController.text = data.text!;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_couponTextController.text.isNotEmpty) {
                            controller.applyCoupon(_couponTextController.text.trim(), subtotal);
                          } else {
                            Get.snackbar("Error", "Please enter a code",
                                snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deepBlack,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("APPLY", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
            ],
          ),
        );
      });
    }

    Widget _buildSecurityInfo() {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.verified_user_outlined, size: 14, color: successGreen), const SizedBox(width: 6), Text("SECURE 256-BIT SSL ENCRYPTION", style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5))]),
        const SizedBox(height: 10),
        const Icon(Icons.security, size: 20, color: Colors.grey),
      ]);
    }

    Widget _buildPayButton() {
      return Obx(() {
        final double finalTotal =
            (subtotal - controller.discountAmount.value) * 1.03;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 48, // compact height
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: deepBlack,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (controller.selectedAddress.isEmpty) {
                  Get.snackbar(
                    "Address Missing",
                    "Please add a delivery address to place your order.",
                    backgroundColor: Colors.red.shade700,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }
                if (selectedMethod == "cod") {
                  controller.confirmOrder("COD", subtotal);
                } else {
                  _showPaymentMaintenanceDialog();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedMethod == "cod"
                        ? "PLACE ORDER (COD)"
                        : "COMPLETE PAYMENT",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    void _showPaymentMaintenanceDialog() {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: goldAccent.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.handshake_outlined, color: goldAccent, size: 40)),
                const SizedBox(height: 20),
                Text("MAINTENANCE", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 16, color: deepBlack)),
                const SizedBox(height: 15),
                Text("Online payment is currently down. Please use Cash on Delivery.", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 25),
                SizedBox(width: double.infinity, height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: deepBlack, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () { setState(() => selectedMethod = "cod"); Get.back(); }, child: Text("SWITCH TO COD", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
        ),
      );
    }
  }