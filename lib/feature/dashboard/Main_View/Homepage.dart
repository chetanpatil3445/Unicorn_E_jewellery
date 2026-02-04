// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/appcolors.dart';
// import '../controller/DashboardController.dart';
// import '../model/HomeSection.dart';
// import '../model/banner_model.dart';
// import '../widgets/ExclusiveOffers.dart';
// import '../widgets/appbar.dart';
// import '../widgets/browseByCategory.dart';
// import '../widgets/collection_frt.dart';
// import '../widgets/coupleSets.dart';
// import '../widgets/custom_drawer.dart';
// import '../widgets/festiveBanners.dart';
// import '../widgets/genderSets.dart';
// import '../widgets/giftSection.dart';
// import '../widgets/mainShowcase.dart';
// import '../widgets/rates.dart';
// import '../widgets/stories.dart';
//
// class Dashboard extends StatefulWidget {
//   Dashboard({super.key});
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   final DashboardController controller = Get.put(DashboardController());
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   late final PageController pageController;
//   int currentPage = 0;
//
//   late final PageController festivePageController; // Naya Controller
//   int currentFestivePage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//     festivePageController = PageController();
//
//     _startAutoScroll();
//     _startFestiveAutoScroll(); // Naya auto-scroll function
//   }
//
//   void _startAutoScroll() {
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted) return;
//
//       final heroBanners = controller.getBannersByType('hero_slider');
//
//       if (heroBanners.isEmpty) return;
//
//       currentPage++;
//
//       if (currentPage >= heroBanners.length) {
//         currentPage = 0;
//       }
//
//       pageController.animateToPage(
//         currentPage,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//
//       _startAutoScroll();
//     });
//   }
//   void _startFestiveAutoScroll() {
//     Future.delayed(const Duration(seconds: 4), () {
//       // Check if the controller is attached and widget is still there
//       if (!mounted || !festivePageController.hasClients) return;
//
//       final festiveBanners = controller.getBannersByType('festive_banner');
//       if (festiveBanners.length <= 1) return;
//
//       currentFestivePage++;
//       if (currentFestivePage >= festiveBanners.length) currentFestivePage = 0;
//
//       festivePageController.animateToPage(
//         currentFestivePage,
//         duration: const Duration(milliseconds: 600),
//         curve: Curves.easeInOut,
//       );
//       _startFestiveAutoScroll();
//     });
//   }
//
//
//   @override
//   void dispose() {
//     pageController.dispose();
//     festivePageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         await controller.refreshData();
//       },
//       child: Scaffold(
//         key: scaffoldKey,
//         drawer: const CustomDrawer(),
//         backgroundColor: ivoryWhite,
//         body: Obx(() {
//           if (controller.homeSections.isEmpty || controller.isLoadingBanners.value) {
//             return const Center(child: CircularProgressIndicator(color: goldAccent));
//           }
//           return CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               buildAppBar(context, scaffoldKey),
//               ...controller.homeSections.map((section) => _buildDynamicSection(section)).toList(),
//               const SliverToBoxAdapter(child: SizedBox(height: 50)),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//
//   Widget _buildDynamicSection(HomeSection section) {
//     if (!section.isVisible) return const SliverToBoxAdapter(child: SizedBox.shrink());
//     switch (section.sectionName) {
//       case 'live_rates':
//         return SliverToBoxAdapter(child: buildLiveRates());
//       case 'stories':
//         return SliverToBoxAdapter(child: buildStories());
//       case 'trending_products':
//         return buildSliverGridWithTitle(section.displayName, 'trending_products');
//       case 'recommended_products':
//         return buildSliverGridWithTitle(section.displayName, 'recommended_products');
//       case 'featured_collections':
//         return buildSliverGridWithTitle(section.displayName, 'featured_collections');
//       case 'hero_slider':
//       case 'categories':
//       case 'modern_couple_sets':
//       case 'festive_banner':
//       case 'offer_strip':
//       case 'shop_by_gender':
//       case 'tag_filters':
//       case 'gift_for_loved_ones':
//       case 'testimonials':
//         return SliverToBoxAdapter(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (section.displayName.isNotEmpty)
//                 buildSectionTitle(section.displayName),
//                 _getContentForSection(section),
//             ],
//           ),
//         );
//       default:
//         return const SliverToBoxAdapter(child: SizedBox.shrink());
//     }
//   }
//
//   Widget _getContentForSection(HomeSection section) {
//     List<BannerModel> banners = controller.getBannersByType(section.sectionName);
//
//     if (banners.isEmpty && !controller.isLoadingBanners.value) {
//       return getStaticContent(section.sectionName);
//     }
//
//     switch (section.sectionName) {
//       case 'hero_slider':
//         return section.uiStyle == "CAROUSEL" ? buildCarouselSlider(banners, pageController) : buildHeroBanner(banners.first);
//       case 'categories':
//         return buildCategorySection(banners);
//       case 'modern_couple_sets':
//         return buildCoupleCollections(banners.isNotEmpty ? banners.first : null);
//       case 'festive_banner':
//         return buildFestiveCarousel(banners, festivePageController);
//       case 'offer_strip':
//         return buildOfferBanner(banners.isNotEmpty ? banners.first : null);
//       case 'shop_by_gender':
//         return buildGenderSection(banners);
//       default:
//         return getStaticContent(section.sectionName);
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/DashboardController.dart';
import '../model/HomeSection.dart';
import '../model/banner_model.dart';
import '../widgets/ExclusiveOffers.dart';
import '../widgets/appbar.dart';
import '../widgets/browseByCategory.dart';
import '../widgets/collection_frt.dart';
import '../widgets/coupleSets.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/festiveBanners.dart';
import '../widgets/genderSets.dart';
import '../widgets/giftSection.dart';
import '../widgets/mainShowcase.dart';
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

  // Puraane controllers fixed sections ke liye
  late final PageController heroController;
  int currentHeroPage = 0;

  late final PageController festiveController;
  int currentFestivePage = 0;

  @override
  void initState() {
    super.initState();
    heroController = PageController();
    festiveController = PageController();

    _startHeroAutoScroll();
    _startFestiveAutoScroll();
  }

  void _startHeroAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final banners = controller.getBannersByType('hero_slider');
      if (banners.isEmpty) return;
      currentHeroPage = (currentHeroPage + 1) % banners.length;
      if (heroController.hasClients) {
        heroController.animateToPage(currentHeroPage,
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
      _startHeroAutoScroll();
    });
  }

  void _startFestiveAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted || !festiveController.hasClients) return;
      final banners = controller.getBannersByType('festive_banner');
      if (banners.length <= 1) return;
      currentFestivePage = (currentFestivePage + 1) % banners.length;
      festiveController.animateToPage(currentFestivePage,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      _startFestiveAutoScroll();
    });
  }

  @override
  void dispose() {
    heroController.dispose();
    festiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await controller.refreshData(),
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
              ...controller.homeSections
                  .map((section) => _buildDynamicSection(section))
                  .toList(),
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
      case 'live_rates': return SliverToBoxAdapter(child: buildLiveRates());
      case 'stories': return SliverToBoxAdapter(child: buildStories());
      case 'trending_products': return buildSliverGridWithTitle(section.displayName, 'trending_products');
      case 'recommended_products': return buildSliverGridWithTitle(section.displayName, 'recommended_products');
      case 'featured_collections': return buildSliverGridWithTitle(section.displayName, 'featured_collections');
      default:
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (section.displayName.isNotEmpty) buildSectionTitle(section.displayName),
              _getContentForSection(section),
            ],
          ),
        );
    }
  }

  Widget _getContentForSection(HomeSection section) {
    List<BannerModel> banners = controller.getBannersByType(section.sectionName);
    if (banners.isEmpty && !controller.isLoadingBanners.value) return getStaticContent(section.sectionName);

    // Hardcoded Sections Logic
    switch (section.sectionName) {
      case 'hero_slider': return buildCarouselSlider(banners, heroController);
      case 'festive_banner': return buildFestiveCarousel(banners, festiveController);
      case 'categories': return buildCategorySection(banners);
      case 'modern_couple_sets': return buildCoupleCollections(banners.isNotEmpty ? banners.first : null);
      case 'offer_strip': return buildOfferBanner(banners.isNotEmpty ? banners.first : null);
      case 'shop_by_gender': return buildGenderSection(banners);
    }

    // Naya Dynamic Handler
    return _renderByUiStyle(section, banners);
  }

  Widget _renderByUiStyle(HomeSection section, List<BannerModel> banners) {
    switch (section.uiStyle) {
      case 'CAROUSEL':
        return AutoScrollCarousel(banners: banners); // Smart Auto-scrolling Widget
      case 'GRID_2X2':
        return _buildDynamicGrid(banners);
      case 'HORIZONTAL_LIST':
        return _buildDynamicHorizontalList(banners);
      case 'CHIP_LIST':
        return _buildChipList(banners);
      default:
        return banners.isNotEmpty ? _buildHeroBanner(banners.first) : const SizedBox.shrink();
    }
  }

  // --- Helper Widgets ---


  Widget _buildChipList(List<BannerModel> banners) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: banners.map((b) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ActionChip(label: Text(b.title), onPressed: () => handleBannerClick(b)),
        )).toList(),
      ),
    );
  }

  Widget _buildHeroBanner(BannerModel banner) {
    return SizedBox(
      height: 220,
      child: bannerWithTitle(banner, radius: 14),
    );
  }


  Widget _buildDynamicGrid(List<BannerModel> banners) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.3),
      itemCount: banners.length > 4 ? 4 : banners.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => handleBannerClick(banners[index]),
        child: bannerWithTitle(banners[index], radius: 10),
      ),

    );
  }

  Widget _buildDynamicHorizontalList(List<BannerModel> banners) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: banners.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => handleBannerClick(banners[index]),
          child: Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            child: bannerWithTitle(banners[index]),
          ),

        ),
      ),
    );
  }

  Widget bannerWithTitle(BannerModel banner, {double radius = 12}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            banner.imageUrl,
            fit: BoxFit.cover,
          ),

          // dark gradient for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  banner.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  banner.subtitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

}


class AutoScrollCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  const AutoScrollCarousel({super.key, required this.banners});

  @override
  State<AutoScrollCarousel> createState() => _AutoScrollCarouselState();
}

class _AutoScrollCarouselState extends State<AutoScrollCarousel> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      if (widget.banners.length > 1 && _controller.hasClients) {
        _currentPage = (_currentPage + 1) % widget.banners.length;
        _controller.animateToPage(_currentPage, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
      _startTimer();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildCarouselSlider(widget.banners, _controller);
  }
}