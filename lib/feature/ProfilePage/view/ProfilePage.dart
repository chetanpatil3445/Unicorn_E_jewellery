import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicorn_e_jewellers/Routes/app_routes.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController controller = Get.put(ProfileController());

  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color ivoryWhite = Color(0xFFFDFCFB);
  static const Color dividerGrey = Color(0xFFEFEFEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.grid_view_rounded, color: goldAccent),
          onPressed: () {},
        ),
        title: Text(
          "MY ACCOUNT",
          style: GoogleFonts.cinzel(
            color: goldAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.6,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _royalProfileHeader(),

            _buildMenuSection("MY ACTIVITY", [
              _luxuryItem(Icons.shopping_bag_outlined, "My Orders", "Track, cancel or return", onTap: controller.openOrders),
              _luxuryItem(Icons.favorite_outline, "Wishlist", "Saved luxury pieces", onTap: controller.openWishlist),
              _luxuryItem(Icons.shopping_cart, "My Cart", "Saved luxury pieces", onTap: controller.openCartList),
              _luxuryItem(Icons.star_outline, "My Reviews", "Your feedback",onTap: controller.openReview),
            ]),

            _buildMenuSection("ACCOUNT SETTINGS", [
              _luxuryItem(Icons.person_outline, "Edit Profile", "Personal details", onTap: controller.openEditProfile),
              _luxuryItem(Icons.location_on_outlined, "Saved Addresses", "Delivery locations",onTap: controller.openAdress),
              _luxuryItem(Icons.account_balance_wallet_outlined, "Payment Methods", "Cards & UPI"),
            ]),

            _buildMenuSection("HELP & LEGAL", [
              _luxuryItem(Icons.help_outline, "Help Center", "Customer care"),
              _luxuryItem(Icons.policy_outlined, "Privacy Policy", "Data security"),
              _luxuryItem(Icons.info_outline, "About Us", "Crafted with elegance"),
            ]),

            const SizedBox(height: 28),
            _luxuryLogout(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _royalProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar (image + initials fallback)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: goldAccent,
              shape: BoxShape.circle,
            ),
            child: Obx(() => CircleAvatar(
              radius: 36,
              backgroundColor: ivoryWhite,
              backgroundImage: controller.userImageUrl.value.isNotEmpty
                  ? NetworkImage(controller.userImageUrl.value)
                  : null,
              child: controller.userImageUrl.value.isEmpty
                  ? Text(
                controller.initials.value,
                style: GoogleFonts.cinzel(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: goldAccent,
                ),
              )
                  : null,
            )),
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Obx(() => Text(
                controller.userName.value,
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: deepBlack,
                ),
              )),

              const SizedBox(height: 4),

              // Email
              Obx(() => Text(
                controller.email.value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )),

              const SizedBox(height: 8),

              // Role badge (optional but looks premium)
              Obx(() => Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: goldAccent),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  controller.role.value.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: goldAccent,
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 10),
          child: Text(
            title,
            style: GoogleFonts.cinzel(
              fontSize: 12,
              color: goldAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: dividerGrey),
        ),
      ],
    );
  }

  Widget _luxuryItem(
      IconData icon,
      String title,
      String subtitle, {
        VoidCallback? onTap,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: deepBlack),
      title: Text(title,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle:
      Text(subtitle, style: GoogleFonts.poppins(fontSize: 11)),
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _luxuryLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: InkWell(
        onTap: () => _showLuxuryLogoutDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.shade100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded,
                  color: Colors.redAccent),
              const SizedBox(width: 10),
              Text("SIGN OUT",
                  style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLuxuryLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Icon(Icons.logout_rounded, size: 40, color: goldAccent),
        content: const Text(
          "Are you sure you want to logout?",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          ElevatedButton(
            onPressed: controller.logout,
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
