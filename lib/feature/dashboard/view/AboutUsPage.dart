import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // Luxury Theme Colors
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color ivoryWhite = Color(0xFFFDFCFB);
  static const Color softGrey = Color(0xFFF4F4F4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- ROYAL HEADER ---
          SliverAppBar(
            expandedHeight: 220.0,
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
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: goldAccent, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_outlined, size: 45, color: goldAccent),
                    ).animate().shimmer(duration: 2.seconds),
                    const SizedBox(height: 15),
                    Text(
                      'Unicorn JEWELS',
                      style: GoogleFonts.cinzel(
                        color: goldAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    Text(
                      'CRAFTING ELEGANCE SINCE 1990',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- CONTENT ---
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('Our Legacy'),
                const SizedBox(height: 15),
                _buildLuxuryStoryCard(
                  'Founded on the principles of purity and trust, Unicorn Jewels has been a pioneer in handcrafted luxury jewellery for over three decades.',
                  Icons.history_edu_outlined,
                ),

                const SizedBox(height: 30),
                _buildSectionTitle('The Craftsmanship'),
                const SizedBox(height: 15),
                _buildFeatureTile(Icons.diamond_outlined, 'Certified Diamonds', 'Every diamond is IGI/GIA certified for maximum brilliance.'),
                _buildFeatureTile(Icons.verified_outlined, '22K BIS Hallmarked', 'Pure gold jewellery with government-approved hallmarks.'),
                _buildFeatureTile(Icons.brush_outlined, 'Handcrafted Designs', 'Unique pieces designed by award-winning artisans.'),
                _buildFeatureTile(Icons.security_outlined, 'Lifetime Exchange', 'Transparancy in every transaction with easy upgrades.'),

                const SizedBox(height: 30),
                _buildSectionTitle('Why Choose Unicorn'),
                const SizedBox(height: 15),
                _buildLuxuryStoryCard(
                  'We combine traditional artistry with modern technology to give you a seamless shopping experience, whether in-store or on-app.',
                  Icons.star_border_rounded,
                ),

                const SizedBox(height: 30),
                _buildSectionTitle('Visit Our Atelier'),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    children: [
                      _contactRow(Icons.location_on_outlined, 'The Phoenix Mall, Surat, Gujarat'),
                      const Divider(height: 1, indent: 60),
                      _contactRow(Icons.phone_outlined, '+91 94208 44725'),
                      const Divider(height: 1, indent: 60),
                      _contactRow(Icons.mail_outline_rounded, 'support@unicornteam.in'),
                    ],
                  ),
                ),

                const SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Unicorn JEWELS",
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          color: goldAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Crafted for the Extraordinary",
                        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.cinzel(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: deepBlack,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildLuxuryStoryCard(String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: softGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: goldAccent.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: goldAccent, size: 28),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.8,
                color: deepBlack.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: goldAccent.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: goldAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: goldAccent, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: deepBlack)),
                const SizedBox(height: 2),
                Text(sub,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: goldAccent, size: 20),
      title: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 13, color: deepBlack, fontWeight: FontWeight.w500),
      ),
      onTap: () {},
    );
  }
}