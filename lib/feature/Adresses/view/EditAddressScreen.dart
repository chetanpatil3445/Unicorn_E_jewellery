import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/AddressController.dart';

class EditAddressScreen extends StatelessWidget {
  final Map<String, dynamic> addressData;
  EditAddressScreen({super.key, required this.addressData});

  final controller = Get.put(AddressController());
  static const Color goldColor = Color(0xFFC5A059);
  static const Color darkText = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    // Initial data fill kar rahe hain
    controller.setFieldsForUpdate(addressData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("EDIT ADDRESS",
            style: GoogleFonts.cinzel(
                color: darkText,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText, size: 18),
          onPressed: () {
            controller.clearFields();
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("CONTACT DETAILS"),
            buildPremiumField(controller.nameController, "Receiver Name", Icons.person_outline),
            buildPremiumField(controller.phoneController, "Phone Number", Icons.phone_outlined, isNumber: true),

            const SizedBox(height: 20),
            buildSectionTitle("LOCATION DETAILS"),
            Row(
              children: [
                Expanded(child: buildPremiumField(controller.pincodeController, "Pincode", Icons.pin_drop_outlined, isNumber: true)),
                const SizedBox(width: 12),
                Expanded(child: buildPremiumField(controller.cityController, "City", Icons.location_city_outlined)),
              ],
            ),
            buildPremiumField(controller.stateController, "State", Icons.map_outlined),
            buildPremiumField(controller.houseController, "House No. / Building", Icons.home_work_outlined),
            buildPremiumField(controller.areaController, "Street / Area", Icons.add_road_outlined),
            buildPremiumField(controller.landmarkController, "Landmark (Optional)", Icons.assistant_photo_outlined),

            const SizedBox(height: 20),
            buildSectionTitle("SAVE AS"),
            Obx(() => Row(
              children: ["Home", "Work", "Other"].map((type) => _buildTypeChip(type)).toList(),
            )),

            const SizedBox(height: 40),
            _buildUpdateButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(type.toUpperCase()),
        labelStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: controller.addressType.value == type ? Colors.white : darkText,
        ),
        selected: controller.addressType.value == type,
        onSelected: (val) => controller.addressType.value = type,
        selectedColor: goldColor,
        backgroundColor: Colors.white,
        elevation: 0,
        pressElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: controller.addressType.value == type ? goldColor : Colors.grey.shade300),
        ),
      ),
    );
  }


  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(title,
          style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: goldColor,
              letterSpacing: 1.2)),
    );
  }

  Widget _buildUpdateButton() {
    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value
          ? null
          : () => controller.updateAddress(addressData['id'].toString()),
      style: ElevatedButton.styleFrom(
        backgroundColor: darkText,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: controller.isLoading.value
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: goldColor, strokeWidth: 2))
          : Text("UPDATE ADDRESS", style: GoogleFonts.cinzel(color: goldColor, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
    ));
  }

  Widget buildPremiumField(TextEditingController ctrl, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        cursorColor: goldColor,
        style: GoogleFonts.poppins(fontSize: 14, color: darkText),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500),
          floatingLabelStyle: GoogleFonts.poppins(color: goldColor, fontWeight: FontWeight.w600),
          prefixIcon: Icon(icon, size: 18, color: goldColor.withOpacity(0.7)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: goldColor, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }
}