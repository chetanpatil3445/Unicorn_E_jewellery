import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

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
          // 1. Royal Black Header
          _buildSliverAppBar(context),

          // 2. Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle('Luxury Guides'),
                const SizedBox(height: 15),
                _buildQuickActionTile(Icons.auto_awesome_mosaic_outlined, 'Jewellery Care Guide', 'Tips to keep your jewels sparkling'),
                _buildQuickActionTile(Icons.straighten_outlined, 'Size Guide', 'Find your perfect ring & bangle fit'),
                _buildQuickActionTile(Icons.verified_user_outlined, 'Authentication', 'Verify your hallmark & certificates'),

                const SizedBox(height: 35),

                _buildSectionTitle('Common Enquiries'),
                const SizedBox(height: 15),
                _buildFAQCard(
                  'How do I track my delivery?',
                  'Once your order is dispatched, a dedicated concierge will share your private tracking link.',
                ),
                _buildFAQCard(
                  'What is your exchange policy?',
                  'We offer a lifetime exchange policy on all hallmarked gold and certified diamonds.',
                ),
                _buildFAQCard(
                  'Can I customize a design?',
                  'Yes, our master artisans can bring your vision to life through our bespoke service.',
                ),

                const SizedBox(height: 35),

                // 3. Premium Support Card
                _buildSupportCard(),

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
              const Icon(Icons.support_agent_outlined, size: 45, color: goldAccent),
              const SizedBox(height: 12),
              Text(
                'ASSISTANCE',
                style: GoogleFonts.cinzel(
                  color: goldAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'How may we serve you today?',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                  letterSpacing: 1.5,
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

  Widget _buildQuickActionTile(IconData icon, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: goldAccent.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: goldAccent, size: 26),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: deepBlack)),
                Text(sub, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: goldAccent),
        ],
      ),
    );
  }

  Widget _buildFAQCard(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: goldAccent.withOpacity(0.05)),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedIconColor: goldAccent,
        iconColor: goldAccent,
        title: Text(
          question,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: deepBlack),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: deepBlack,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: goldAccent.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome_outlined, size: 40, color: goldAccent),
          const SizedBox(height: 20),
          Text(
            'Bespoke Assistance',
            style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.bold, color: goldAccent),
          ),
          const SizedBox(height: 10),
          Text(
            'Our personal shopping assistants are here to guide you through your luxury journey.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.6), height: 1.5),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: deepBlack,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('LIVE CHAT', style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: goldAccent),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('EMAIL US', style: GoogleFonts.cinzel(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}