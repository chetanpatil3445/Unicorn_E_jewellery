import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/DrawerController.dart' as drawer_controller;

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final drawerController = Get.find<drawer_controller.CustomDrawerController>();

  // Luxury Theme Colors
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color ivoryWhite = Color(0xFFFDFCFB);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ivoryWhite,
      width: MediaQuery.of(context).size.width * 0.75, // Thoda sleek width
      child: Column(
        children: [
          // 1. Royal Header Section
          _buildRoyalHeader(drawerController),

          // 2. Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                _luxuryTile(Icons.home_outlined, "Home", () => Get.back()),
                _luxuryTile(Icons.person_outline, "My Profile", () {}),
                _luxuryTile(Icons.shopping_bag_outlined, "My Orders", () {}),
                _luxuryTile(Icons.favorite_border, "Wishlist", () {}),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
                ),

                _luxuryTile(Icons.info_outline, "About Luxe Jewels", drawerController.navigateToAboutUs),
                _luxuryTile(Icons.support_agent_outlined, "Customer Support", drawerController.navigateToHelp),
                _luxuryTile(Icons.settings_outlined, "Settings", drawerController.navigateToSettings),

                const SizedBox(height: 30),

                // Logout Button - Different Style
                _logoutButton(),
              ],
            ),
          ),

          // 3. Brand Footer
          _buildFooter(),
        ],
      ),
    );
  }

  // Luxury Header Design
  Widget _buildRoyalHeader(drawer_controller.CustomDrawerController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
      decoration: const BoxDecoration(
        color: deepBlack,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Pic with Gold Border
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: goldAccent,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: ivoryWhite,
              backgroundImage: controller.userImageUrl.value.isNotEmpty
                  ? NetworkImage(controller.userImageUrl.value)
                  : null,
              child: controller.userImageUrl.value.isEmpty
                  ? const Icon(Icons.person, color: goldAccent, size: 30)
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            controller.userName.value.toUpperCase(),
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            controller.userEmail.value,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: goldAccent),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "GOLD MEMBER",
              style: GoogleFonts.poppins(
                color: goldAccent,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      )),
    );
  }

  // Elegant Tile Design
  Widget _luxuryTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: deepBlack, size: 22),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: deepBlack,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
    );
  }

  Widget _logoutButton() {
    return InkWell(
      onTap: drawerController.handleLogout,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade100),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
            const SizedBox(width: 10),
            Text(
              "Sign Out",
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(
            "LUXE JEWELS",
            style: GoogleFonts.cinzel(
              color: goldAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Version 3.0.1 • Crafted for Elegance",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 9),
          ),
        ],
      ),
    );
  }
}