import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/DashboardController.dart';
import '../widgets/custom_drawer.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color ivoryWhite = Color(0xFFFDFCFB);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color accentRed = Color(0xFFB22222);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final DashboardController controller = Get.put(DashboardController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      backgroundColor: Dashboard.ivoryWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          _buildLiveRates(),
          _buildStories(), // UPGRADED
          _buildHeroBanner(),

          _buildSectionTitle("Browse by Category"),
          _buildCategorySection(), // UPGRADED

          _buildTagFilterRow(),

          _buildSectionTitle("Featured Collections"),
          _buildFeaturedCollections(),

          _buildSectionTitle("Trending Collections"),
          _buildProductGrid(hasBadges: true),

          _buildSectionTitle("Gifts for Loved Ones"),
          _buildGiftSection(),

          _buildSectionTitle("Modern Couple Sets"),
          _buildCoupleCollections(),

          _buildSectionTitle("Festive Specials 2026"),
          _buildFestiveBanner(),

          _buildSectionTitle("Shop by Gender"),
          _buildGenderSection(),

          _buildSectionTitle("Recommended for You"),
          _buildRecommendedGrid(),

          _buildSectionTitle("Exclusive Offers"),
          _buildOfferBanner(),

          _buildSectionTitle("Customer Whispers"),
          _buildTestimonials(),

          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  // ===================== 1. UPGRADED PREMIUM STORIES =====================
  Widget _buildStories() {
    final storyData = [
      {'t': 'On Sale', 'img': 'https://plus.unsplash.com/premium_photo-1671076131210-5376fccb100b?q=80&w=3400&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
      {'t': 'New In', 'img': 'https://images.unsplash.com/photo-1601121141461-9d6647bca1ed?q=80&w=200'},
      {'t': 'Bridal', 'img': 'https://images.unsplash.com/photo-1600685890506-593fdf55949b?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
      {'t': 'Offers', 'img': 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?q=80&w=200'},
      {'t': 'Antique', 'img': 'https://images.unsplash.com/photo-1762970782860-575f62ba05a8?q=80&w=1337&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
      {'t': 'Hallmark', 'img': 'https://images.unsplash.com/photo-1603561596112-0a132b757442?q=80&w=200'},
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 115,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: storyData.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5), // Space for gradient border
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [Dashboard.goldAccent, Colors.amber.shade200, Dashboard.goldAccent, Colors.orange, Dashboard.goldAccent],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: Dashboard.softGrey,
                      backgroundImage: NetworkImage(storyData[i]['img']!),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  storyData[i]['t']!,
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: i == 0 ? Dashboard.accentRed : Dashboard.deepBlack,
                      letterSpacing: 0.2
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== 2. UPGRADED PREMIUM CATEGORY SECTION =====================
  Widget _buildCategorySection() {
    final cats = [
      {'name': 'Rings', 'img': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?q=80&w=300'},
      {'name': 'Necklace', 'img': 'https://plus.unsplash.com/premium_photo-1674255466849-b23fc5f5d3eb?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
      {'name': 'Earrings', 'img': 'https://plus.unsplash.com/premium_photo-1675107359685-f268487a3a46?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
      {'name': 'Bangles', 'img': 'https://images.unsplash.com/photo-1619119069152-a2b331eb392a?q=80&w=300'},
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cats.length,
          itemBuilder: (context, i) => Container(
            width: 95,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Dashboard.goldAccent.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        cats[i]['img']!,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  cats[i]['name']!.toUpperCase(),
                  style: GoogleFonts.cinzel(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Dashboard.deepBlack,
                      letterSpacing: 1
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== THE REST OF YOUR CODE (STAYS SAME) =====================
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Dashboard.ivoryWhite,
      elevation: 0,
      centerTitle: true,
      title: Text("LUXE JEWELS",
          style: GoogleFonts.cinzel(
              color: Dashboard.deepBlack, fontWeight: FontWeight.bold, letterSpacing: 2)),
      leading: IconButton(
        icon: const Icon(Icons.menu_outlined, color: Dashboard.deepBlack),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, color: Dashboard.deepBlack)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag_outlined, color: Dashboard.deepBlack)),
      ],
    );
  }
  Widget _buildLiveRates() {
    return SliverToBoxAdapter(
      child: Container(
        height: 45, // Thoda compact kiya for sleekness
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A), // Deepest Carbon Black
          border: Border(
            bottom: BorderSide(color: Dashboard.goldAccent.withOpacity(0.3), width: 0.8),
          ),
        ),
        child: Obx(() {
          return ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              // Gold Section
              _premiumRateItem(
                "GOLD 24K",
                controller.rate.value.toString(),
                "${controller.ratePerWt.value}/${controller.ratePerWtUnit.value}",
                const Color(0xFFD4AF37), // Luxury Gold
                true, // Up trend
              ),

              _premiumDivider(),

              // Silver Section
              _premiumRateItem(
                "SILVER",
                controller.rateSl.value.toString(),
                "${controller.ratePerWtSl.value}/${controller.ratePerWtUnitSL.value}",
                const Color(0xFFC0C0C0), // Elegant Silver
                false, // Down trend
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _premiumRateItem(String label, String price, String subPrice, Color metalColor, bool isUp) {
    final trendColor = isUp ? const Color(0xFF00E676) : const Color(0xFFFF5252);

    return Row(
      children: [
        // Metal Indicator Dot with Glow
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            color: metalColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: metalColor.withOpacity(0.6), blurRadius: 6, spreadRadius: 1),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Label with tight letter spacing
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white54,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),

        // Main Price - High Contrast
        Text(
          "₹$price",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),

        // Compact Sub-Price Capsule
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(
            color: trendColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: trendColor.withOpacity(0.2), width: 0.5),
          ),
          child: Row(
            children: [
              Icon(isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: trendColor, size: 14),
              Text(
                "₹$subPrice",
                style: GoogleFonts.jetBrainsMono( // Monospaced for numbers looks premium
                  color: trendColor,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _premiumDivider() {
    return Center(
      child: Container(
        height: 15,
        width: 1.5,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?q=80&w=2070'),
              fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [Colors.black.withOpacity(0.7), Colors.transparent], begin: Alignment.bottomLeft),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("THE ROYAL HERITAGE", style: GoogleFonts.cinzel(color: Dashboard.goldAccent, fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Handcrafted with love since 1990", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagFilterRow() {
    final quickTags = ["Trending", "New Arrival", "Best Seller", "Hot Deal", "Hallmarked Gold", "Pure Silver"];
    return SliverToBoxAdapter(
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: quickTags.length,
          itemBuilder: (context, i) => Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Dashboard.goldAccent.withOpacity(0.3)),
            ),
            alignment: Alignment.center,
            child: Text(
              quickTags[i],
              style: GoogleFonts.poppins(fontSize: 11, color: Dashboard.deepBlack, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, {Color color = Dashboard.deepBlack}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.poppins(color: Dashboard.goldAccent, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildFeaturedCollections() {
    final list = [
      {'t': 'Diamond Forever', 'img': 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?q=80&w=400', 'tag': 'Premium'},
      {'t': 'Antique Gold', 'img': 'https://images.unsplash.com/photo-1611085583191-a3b136335918?q=80&w=400', 'tag': 'Traditional'},
    ];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 2,
          itemBuilder: (context, i) => Container(
            width: 300,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: NetworkImage(list[i]['img']!), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter),
                  ),
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.bottomLeft,
                  child: Text(list[i]['t']!, style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Positioned(top: 0, left: 0, child: _buildBadge(list[i]['tag']!)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGiftSection() {
    final gifts = [
      {'n': 'For Her', 'i': Icons.card_giftcard},
      {'n': 'For Him', 'i': Icons.redeem},
      {'n': 'Anniversary', 'i': Icons.favorite_border},
      {'n': 'Birthday', 'i': Icons.cake_outlined},
    ];
    return SliverToBoxAdapter(
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, i) => Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Dashboard.goldAccent.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(gifts[i]['i'] as IconData, color: Dashboard.goldAccent, size: 24),
                const SizedBox(height: 5),
                Text(gifts[i]['n'].toString(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoupleCollections() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFFBE9E7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("COUPLE RINGS", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 5),
                    Text("Matches made in heaven.", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700])),
                    const SizedBox(height: 10),
                    Text("SHOP NOW →", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Dashboard.goldAccent)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                child: Image.network('https://images.unsplash.com/photo-1630801059808-1a29d15a2f18?q=80&w=2668', fit: BoxFit.cover, height: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFestiveBanner() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF800000), Color(0xFFD4AF37)]),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: ListTile(
          leading: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
          title: Text("DIWALI SPECIAL", style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          subtitle: Text("Exclusive Collection for the Festival of Lights", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildRecommendedGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.8),
        delegate: SliverChildBuilderDelegate((context, i) => _productCardSmall(i), childCount: 4),
      ),
    );
  }

  Widget _productCardSmall(int i) {
    final labels = ["Staff Pick", "Limited", "Top Rated", "New"];
    return Container(
      decoration: BoxDecoration(color: Dashboard.softGrey, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network('https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?q=80&w=400', fit: BoxFit.cover, width: double.infinity))),
                const SizedBox(height: 5),
                Text("Rose Gold Earring", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
                Text("₹12,400", style: GoogleFonts.poppins(color: Dashboard.goldAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          _buildBadge(labels[i]),
        ],
      ),
    );
  }

  Widget _buildProductGrid({bool hasBadges = false}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 0.75),
          delegate: SliverChildBuilderDelegate((context, i) => _productCard(i, hasBadges), childCount: 2)
      ),
    );
  }

  Widget _productCard(int i, bool hasBadges) {
    final tags = ["Best Seller", "Hot Deal"];
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Stack(
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: Image.network('https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?q=80&w=2070', fit: BoxFit.cover, width: double.infinity))),
                Padding(padding: const EdgeInsets.all(8.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Solitaire Diamond", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text("₹1,25,000", style: GoogleFonts.poppins(color: Dashboard.goldAccent, fontWeight: FontWeight.bold, fontSize: 14))
                ]))
              ]
          ),
          if (hasBadges) Positioned(top: 0, left: 0, child: _buildBadge(tags[i], color: i == 1 ? Dashboard.accentRed : Dashboard.deepBlack)),
        ],
      ),
    );
  }

  Widget _buildGenderSection() {
    return SliverToBoxAdapter(
      child: Row(children: [_genderTile("WOMEN", 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=200'), _genderTile("MEN", 'https://images.unsplash.com/photo-1617137968427-85924c800a22?q=80&w=200')]),
    );
  }

  Widget _genderTile(String label, String url) {
    return Expanded(child: Container(height: 120, margin: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))), alignment: Alignment.center, child: Text(label, style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2))));
  }

  Widget _buildTestimonials() {
    return SliverToBoxAdapter(
      child: SizedBox(height: 130, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: 3, itemBuilder: (context, i) => Container(width: 250, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Dashboard.softGrey, borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.star, color: Dashboard.goldAccent, size: 14), Icon(Icons.star, color: Dashboard.goldAccent, size: 14), Icon(Icons.star, color: Dashboard.goldAccent, size: 14)]), const SizedBox(height: 10), Text("\"Beautiful craftsmanship!\"", style: GoogleFonts.poppins(fontSize: 11, fontStyle: FontStyle.italic)), const Spacer(), Text("- Priya Sharma", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold))])))),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: Dashboard.deepBlack)),
            Text("See All", style: GoogleFonts.poppins(fontSize: 10, color: Dashboard.goldAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferBanner() {
    return SliverToBoxAdapter(
      child: Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Dashboard.deepBlack, borderRadius: BorderRadius.circular(20)), child: Column(children: [Text("SPECIAL SUNDAY", style: GoogleFonts.cinzel(color: Dashboard.goldAccent, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text("0% Making Charges", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)), const SizedBox(height: 15), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Dashboard.goldAccent, foregroundColor: Colors.black), child: const Text("CLAIM NOW"))])),
    );
  }
}