import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});

  // Luxury Theme Colors
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color ivoryWhite = Color(0xFFFDFCFB);
  static const Color fieldGrey = Color(0xFFF9F9F9);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Royal Black & Gold Header
          _buildSliverAppBar(context),

          // 2. Main Body
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Contact Details Box
                _buildSectionTitle('Concierge Services'),
                const SizedBox(height: 15),
                _buildContactDetailsCard(),

                const SizedBox(height: 35),

                // Contact Form Section
                _buildSectionTitle('Send a Private Inquiry'),
                const SizedBox(height: 15),
                _buildInquiryForm(),

                const SizedBox(height: 40),
                _buildFooterBranding(),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      backgroundColor: deepBlack,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: goldAccent, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            color: deepBlack,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.auto_awesome_outlined, size: 40, color: goldAccent),
              const SizedBox(height: 12),
              Text(
                'CONTACT US',
                style: GoogleFonts.cinzel(
                  color: goldAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              Text(
                'Personalized Assistance for You',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.cinzel(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: deepBlack,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildContactDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          _contactDetailTile(Icons.mail_outline_rounded, 'EMAIL ENQUIRIES', 'support@unicornteam.in'),
          const Divider(indent: 70, endIndent: 20, height: 1, color: Color(0xFFF1F1F1)),
          _contactDetailTile(Icons.phone_outlined, 'PRIVATE LINE', '+91 94208 44725'),
          const Divider(indent: 70, endIndent: 20, height: 1, color: Color(0xFFF1F1F1)),
          _contactDetailTile(Icons.location_on_outlined, 'OUR ATELIER', 'Phoenix City, Diamond District, Surat'),
        ],
      ),
    );
  }

  Widget _buildInquiryForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: goldAccent.withOpacity(0.1)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildLuxuryField(controller: _nameController, label: 'YOUR FULL NAME'),
            const SizedBox(height: 20),
            _buildLuxuryField(controller: _emailController, label: 'EMAIL ADDRESS', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildLuxuryField(controller: _messageController, label: 'YOUR MESSAGE', maxLines: 4),
            const SizedBox(height: 30),

            // Royal Gold Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepBlack,
                  foregroundColor: goldAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  'SEND INQUIRY',
                  style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactDetailTile(IconData icon, String title, String sub) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: ivoryWhite, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: goldAccent, size: 22),
      ),
      title: Text(title, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1)),
      subtitle: Text(sub, style: GoogleFonts.poppins(fontSize: 14, color: deepBlack, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildLuxuryField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: goldAccent, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.poppins(fontSize: 14, color: deepBlack),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldGrey,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: goldAccent, width: 0.5),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterBranding() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.verified_user_outlined, color: goldAccent, size: 30),
          const SizedBox(height: 10),
          Text(
            "Your privacy is our priority. Our concierge team\nresponds within 24 hours.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    Get.snackbar(
      'Inquiry Received',
      'Our concierge will contact you shortly.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: deepBlack,
      colorText: goldAccent,
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}