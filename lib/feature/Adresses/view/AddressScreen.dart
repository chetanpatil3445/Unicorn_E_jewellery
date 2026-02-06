import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/AddressController.dart';
import 'AddAddressScreen.dart';
import 'EditAddressScreen.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final controller = Get.put(AddressController());

  static const Color goldColor = Color(0xFFC5A059);
  static const Color darkText = Color(0xFF1A1A1A);
  static const Color lightBg = Color(0xFFF9F9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("MY ADDRESSES",
            style: GoogleFonts.cinzel(
                color: darkText,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.addresses.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: goldColor));
        }

        if (controller.addresses.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: controller.addresses.length,
          itemBuilder: (context, index) {
            var addr = controller.addresses[index];
            return PremiumAddressCard(
              address: addr,
              onDelete: () => _showDeleteDialog(addr['id']),
              onSetDefault: () => _showDefaultDialog(addr['id']),
            );
          },
        );
      }),
      bottomNavigationBar: _buildAddButton(),
    );
  }

  void _showDefaultDialog(String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Set as Default?", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text("Deliveries will be sent to this address by default.", style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("CANCEL", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () { controller.setDefault(id); Get.back(); },
              child: Text("CONFIRM", style: TextStyle(color: goldColor, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  void _showDeleteDialog(String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Remove Address", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text("Are you sure you want to delete this address?", style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("CANCEL", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () { controller.deleteAddress(id); Get.back(); },
              child: Text("DELETE", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on_outlined, size: 60, color: goldColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text("No saved addresses found", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: ElevatedButton(
        onPressed: () => Get.to(() => AddAddressScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: darkText,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text("ADD NEW ADDRESS", style: GoogleFonts.cinzel(color: goldColor, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      ),
    );
  }
}

class PremiumAddressCard extends StatelessWidget {
  final dynamic address;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const PremiumAddressCard({
    super.key,
    required this.address,
    required this.onDelete,
    required this.onSetDefault
  });

  @override
  Widget build(BuildContext context) {
    bool isDefault = address['is_default'] ?? false;
    const Color goldColor = Color(0xFFC5A059);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDefault ? const Color(0xFFFFFDF9) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isDefault ? goldColor : Colors.grey.withOpacity(0.2)
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        address['address_type'].toString().toUpperCase(),
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: goldColor,
                            letterSpacing: 1
                        )
                    ),
                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: goldColor,
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text(
                            "DEFAULT",
                            style: GoogleFonts.poppins(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                    address['receiver_name'],
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)
                ),
                const SizedBox(height: 4),
                Text(
                    "${address['house_no_building']}, ${address['street_area']}",
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)
                ),
                Text(
                    "${address['city']}, ${address['state']} - ${address['pincode']}",
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)
                ),
                const SizedBox(height: 8),
                Text(
                    "Phone: ${address['phone_number']}",
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Actions Row (Isme EDIT button add kiya hai)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // DELETE BUTTON
              TextButton(
                  onPressed: onDelete,
                  child: Text(
                      "REMOVE",
                      style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)
                  )
              ),

              // EDIT BUTTON (Naya add kiya gaya)
              TextButton(
                  onPressed: () => Get.to(() => EditAddressScreen(addressData: address)),
                  child: Text(
                      "EDIT",
                      style: GoogleFonts.poppins(color: goldColor, fontSize: 11, fontWeight: FontWeight.bold)
                  )
              ),

              // DEFAULT BUTTON
              if (!isDefault)
                TextButton(
                    onPressed: onSetDefault,
                    child: Text(
                        "SET AS DEFAULT",
                        style: GoogleFonts.poppins(color: goldColor, fontSize: 11, fontWeight: FontWeight.bold)
                    )
                ),
            ],
          )
        ],
      ),
    );
  }
}