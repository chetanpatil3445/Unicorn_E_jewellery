import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/DashboardController.dart';
import '../model/HomeSection.dart';
import '../model/banner_model.dart';
import '../widgets/appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/rates.dart';
import '../widgets/stories.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final heroBanners = controller.getBannersByType('hero_slider');

      if (heroBanners.isEmpty) return;

      _currentPage++;

      if (_currentPage >= heroBanners.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      _startAutoScroll();
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshData();
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: const CustomDrawer(),
        backgroundColor: ivoryWhite,
        body: Obx(() {
          if (controller.homeSections.isEmpty || controller.isLoadingBanners.value) {
            return const Center(child: CircularProgressIndicator(color: goldAccent));
          }
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              buildAppBar(context, scaffoldKey),
              ...controller.homeSections.map((section) => _buildDynamicSection(section)).toList(),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          );
        }),
      ),
    );
  }


  Widget _buildDynamicSection(HomeSection section) {
    if (!section.isVisible) return const SliverToBoxAdapter(child: SizedBox.shrink());

    switch (section.sectionName) {
      case 'live_rates':
        return SliverToBoxAdapter(child: buildLiveRates());

      case 'stories':
        return SliverToBoxAdapter(child: buildStories());

      case 'trending_products':
        return _buildSliverGridWithTitle(section.displayName, true);

      case 'recommended_products':
        return _buildSliverGridWithTitle(section.displayName, false);

      case 'featured_collections':
        return _buildSliverGridWithTitle(section.displayName, true);

    // 🌟 INKO EXPLICITLY HANDLE KAREIN TAKI DEFAULT MEIN NA JAYEIN
      case 'hero_slider':
      case 'categories':
      case 'modern_couple_sets':
      case 'festive_banner':
      case 'offer_strip':
      case 'shop_by_gender':
      case 'tag_filters':
      case 'gift_for_loved_ones':
      case 'testimonials':
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (section.displayName.isNotEmpty)
                _buildSectionTitle(section.displayName),
              _getContentForSection(section),
            ],
          ),
        );

      default:
      // Agar upar koi case match nahi hua, tabhi blank return karein (Zero Space)
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }


  // ===================== CONTENT SELECTOR =====================
  Widget _getContentForSection(HomeSection section) {
    List<BannerModel> banners = controller.getBannersByType(section.sectionName);

    // Agar loading hai ya banners nahi mile
    if (banners.isEmpty && !controller.isLoadingBanners.value) {
      return _getStaticContent(section.sectionName);
    }

    switch (section.sectionName) {
      case 'hero_slider':
        return section.uiStyle == "CAROUSEL" ? _buildCarouselSlider(banners) : _buildHeroBanner(banners.first);
      case 'categories':
        return _buildCategorySection(banners);
      case 'modern_couple_sets':
        return _buildCoupleCollections(banners.isNotEmpty ? banners.first : null);
      case 'festive_banner':
        return _buildFestiveBanner(banners.isNotEmpty ? banners.first : null);
      case 'offer_strip':
        return _buildOfferBanner(banners.isNotEmpty ? banners.first : null);
      case 'shop_by_gender':
        return _buildGenderSection(banners);
      default:
        return _getStaticContent(section.sectionName);
    }
  }
  Widget _getStaticContent(String name) {
    switch (name) {
      case 'tag_filters': return _buildTagFilterRow();
      case 'gift_for_loved_ones': return _buildGiftSection();
      case 'testimonials': return _buildTestimonials();
      default: return const SizedBox.shrink();
    }
  }


  void _handleBannerClick(BannerModel banner) {
    if (banner.clickType.isEmpty) return;

    Get.toNamed(
      AppRoutes.stockDetail, // Aapka destination route
      arguments: {
        'click_type': banner.clickType,
        'target_id': banner.targetId,
      },
    );
  }

  // ===================== DYNAMIC UI COMPONENTS =====================

  Widget _buildHeroBanner(BannerModel banner) {
    return InkWell(
      onTap: () => _handleBannerClick(banner),
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(banner.imageUrl), fit: BoxFit.cover),
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
              Text(banner.title, style: GoogleFonts.cinzel(color: goldAccent, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(banner.subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider(List<BannerModel> banners) {
    if (banners.isEmpty) return const SizedBox();

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) => _buildHeroBanner(banners[index]),
      ),
    );
  }



  Widget _buildCategorySection(List<BannerModel> banners) {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: banners.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () => _handleBannerClick(banners[i]),
          child: Container(
            width: 95,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: goldAccent.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))]),
                    child: ClipOval(child: Image.network(banners[i].imageUrl, fit: BoxFit.cover, width: 90, height: 90)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(banners[i].subtitle.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: deepBlack)),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildCoupleCollections(BannerModel? banner) {
    if (banner == null) return const SizedBox.shrink();
    return InkWell(
      onTap: () => _handleBannerClick(banner),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 157,
        decoration: BoxDecoration(color: const Color(0xFFFBE9E7), borderRadius: BorderRadius.circular(15)),
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
                    Text(banner.title, style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 5),
                    Text(banner.subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700])),
                    const SizedBox(height: 10),
                    Text("SHOP NOW →", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: goldAccent)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                child: Image.network(banner.imageUrl, fit: BoxFit.cover, height: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFestiveBanner(BannerModel? banner) {
    if (banner == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF800000), Color(0xFFD4AF37)]),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: ListTile(
        leading: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
        title: Text(banner.title, style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(banner.subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildOfferBanner(BannerModel? banner) {
    if (banner == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: deepBlack,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(banner.imageUrl), fit: BoxFit.cover, opacity: 0.4)
      ),
      child: Column(
        children: [
          Text(banner.title, style: GoogleFonts.cinzel(color: goldAccent, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(banner.subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: goldAccent, foregroundColor: Colors.black), child: const Text("CLAIM NOW")),
        ],
      ),
    );
  }

  Widget _buildGenderSection(List<BannerModel> banners) {
    return Row(
      // Row ke direct bache Expanded hone chahiye, uske andar InkWell
      children: banners.map((b) => Expanded(
        child: InkWell(
          onTap: () => _handleBannerClick(b),
          child: _genderTile(b.subtitle, b.imageUrl),
        ),
      )).toList(),
    );
  }

  Widget _genderTile(String label, String url) {
    return Container(
        height: 120,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
            )
        ),
        alignment: Alignment.center,
        child: Text(
            label,
            style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)
        )
    );
  }

  // ===================== HELPER WIDGETS =====================

  Widget _buildSliverGridWithTitle(String title, bool isTrending) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: _buildSectionTitle(title)),
        isTrending ? _buildProductGrid(hasBadges: true) : _buildRecommendedGrid(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: deepBlack)),
          if(title != "Gifts for Loved Ones" &&  title != "Shop by Gender" && title != "Main Showcase")
            Text("See All", style: GoogleFonts.poppins(fontSize: 10, color: goldAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }




  Widget _buildTagFilterRow() {
    final quickTags = ["Trending", "New Arrival", "Best Seller", "Hot Deal", "Hallmarked"];
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: quickTags.length,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: goldAccent.withOpacity(0.3))),
          alignment: Alignment.center,
          child: Text(quickTags[i], style: GoogleFonts.poppins(fontSize: 11, color: deepBlack, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildGiftSection() {
    final gifts = [{'n': 'For Her', 'i': Icons.card_giftcard}, {'n': 'For Him', 'i': Icons.redeem}, {'n': 'Anniversary', 'i': Icons.favorite_border}, {'n': 'Birthday', 'i': Icons.cake_outlined}];
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, i) => Container(
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: goldAccent.withOpacity(0.2)), borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(gifts[i]['i'] as IconData, color: goldAccent, size: 24),
              const SizedBox(height: 5),
              Text(gifts[i]['n'].toString(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
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

  Widget _buildRecommendedGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.8),
        delegate: SliverChildBuilderDelegate((context, i) => _productCardSmall(i), childCount: 2),
      ),
    );
  }

  Widget _productCardSmall(int i) {
    return Container(
      decoration: BoxDecoration(color: softGrey, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network('https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?q=80&w=400', fit: BoxFit.cover, width: double.infinity))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Rose Gold Earring", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
              Text("₹12,400", style: GoogleFonts.poppins(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 12)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _productCard(int i, bool hasBadges) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: Image.network('https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?q=80&w=2070', fit: BoxFit.cover, width: double.infinity))),
            Padding(padding: const EdgeInsets.all(8.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Solitaire Diamond", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
              Text("₹1,25,000", style: GoogleFonts.poppins(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 14))
            ]))
          ]
      ),
    );
  }

  Widget _buildTestimonials() {
    return SizedBox(height: 130, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: 3, itemBuilder: (context, i) => Container(width: 250, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: softGrey, borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.star, color: goldAccent, size: 14), Icon(Icons.star, color: goldAccent, size: 14), Icon(Icons.star, color: goldAccent, size: 14)]), const SizedBox(height: 10), Text("\"Beautiful craftsmanship!\"", style: GoogleFonts.poppins(fontSize: 11, fontStyle: FontStyle.italic)), const Spacer(), Text("- Priya Sharma", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold))]))));
  }
}