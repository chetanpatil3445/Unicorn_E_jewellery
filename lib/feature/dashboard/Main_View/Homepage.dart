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

  late final PageController pageController;
  int currentPage = 0;

  late final PageController festivePageController; // Naya Controller
  int currentFestivePage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    festivePageController = PageController();

    _startAutoScroll();
    _startFestiveAutoScroll(); // Naya auto-scroll function
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final heroBanners = controller.getBannersByType('hero_slider');

      if (heroBanners.isEmpty) return;

      currentPage++;

      if (currentPage >= heroBanners.length) {
        currentPage = 0;
      }

      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      _startAutoScroll();
    });
  }
  void _startFestiveAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      // Check if the controller is attached and widget is still there
      if (!mounted || !festivePageController.hasClients) return;

      final festiveBanners = controller.getBannersByType('festive_banner');
      if (festiveBanners.length <= 1) return;

      currentFestivePage++;
      if (currentFestivePage >= festiveBanners.length) currentFestivePage = 0;

      festivePageController.animateToPage(
        currentFestivePage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _startFestiveAutoScroll();
    });
  }


  @override
  void dispose() {
    pageController.dispose();
    festivePageController.dispose();
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
        return buildSliverGridWithTitle(section.displayName, 'trending_products');
      case 'recommended_products':
        return buildSliverGridWithTitle(section.displayName, 'recommended_products');
      case 'featured_collections':
        return buildSliverGridWithTitle(section.displayName, 'featured_collections');
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
                buildSectionTitle(section.displayName),
                _getContentForSection(section),
            ],
          ),
        );
      default:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  Widget _getContentForSection(HomeSection section) {
    List<BannerModel> banners = controller.getBannersByType(section.sectionName);

    if (banners.isEmpty && !controller.isLoadingBanners.value) {
      return getStaticContent(section.sectionName);
    }

    switch (section.sectionName) {
      case 'hero_slider':
        return section.uiStyle == "CAROUSEL" ? buildCarouselSlider(banners, pageController) : buildHeroBanner(banners.first);
      case 'categories':
        return buildCategorySection(banners);
      case 'modern_couple_sets':
        return buildCoupleCollections(banners.isNotEmpty ? banners.first : null);
      case 'festive_banner':
        return buildFestiveCarousel(banners, festivePageController);
      case 'offer_strip':
        return buildOfferBanner(banners.isNotEmpty ? banners.first : null);
      case 'shop_by_gender':
        return buildGenderSection(banners);
      default:
        return getStaticContent(section.sectionName);
    }
  }
}