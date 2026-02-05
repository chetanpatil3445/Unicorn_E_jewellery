import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/controller/AppDataController.dart';
import '../../../core/utils/token_helper.dart';
import 'dart:convert';
import '../../homeProducts/controllers/homeProductsListController.dart';
import '../../products/controller/stock_catalogue_controller.dart';
import '../../products/model/product_model.dart';
import '../../wishlist/controller/wishlist_controller.dart';
import '../model/HomeSection.dart';
import '../model/banner_model.dart';
import '../service/metal_rate_service.dart';
import '../model/story_model.dart';


class DashboardController extends GetxController {
  final _apiClient = ApiClient();
  var userName = ''.obs;
  var userLocation = ''.obs;
  var userImageUrl = ''.obs;

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchHomeSections();
    fetchBanners();
    loadUserData();
    fetchGoldRates();
    fetchSilverRates();
    AppDataController.to.expiryCheck.value = storage.read('subscriptionStatus');
    AppDataController.to.expiryDate.value = storage.read('expiryDate');
    fetchStories(); // Add this
    loadAllProductSections(); // Add this
  }

   Future<void> refreshData() async {
    loadUserData();
    fetchGoldRates();
    fetchSilverRates();
    fetchStories();
    fetchBanners();
    fetchHomeSections();
    loadAllProductSections();

  }

  void loadUserData() {
    var userInfo = storage.read('userInfo') ?? {};

    userName.value = userInfo['userName'] ?? '';
    userLocation.value = userInfo['location'] ?? '';
    userImageUrl.value = userInfo['userImageUrl'] ?? '';
  }

  String getInitials(String fullName) {
    fullName = fullName.trim();
    if (fullName.isEmpty) return '';

    List<String> names = fullName.split(' ').where((s) => s.isNotEmpty).toList();
    if (names.isEmpty) return '';

    if (names.length > 1) {
      return (names[0][0] + names.last[0]).toUpperCase();
    } else {
      return names[0][0].toUpperCase();
    }
  }


  final MetalRateService _service = MetalRateService();

  RxInt rate = 0.obs;
  RxInt ratePerWt = 0.obs;
  RxString ratePerWtUnit = ''.obs;

  Future<void> fetchGoldRates({bool showLoading = true}) async {
    try {
      final response = await _service.getMetalRates({
        "metal": "Gold",
        "purity": "100",
        "sortBy": "created_at:desc",
        "limit": 1,
        "offset": 0
      });

      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        if (data.isNotEmpty) {
          final item = data.first;

          rate.value = int.tryParse(double.parse(item['rate']).toStringAsFixed(0)) ?? 0;
          ratePerWt.value = int.tryParse(double.parse(item['rate_per_wt']).toStringAsFixed(0)) ?? 0;
          ratePerWtUnit.value = item['rate_per_wt_unit'] ?? '';
        }
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Check internet connection');
    }
  }

  RxInt rateSl = 0.obs;
  RxInt ratePerWtSl = 0.obs;
  RxString ratePerWtUnitSL = ''.obs;

  Future<void> fetchSilverRates({bool showLoading = true}) async {
    try {
      final response = await _service.getMetalRates({
        "metal": "Silver",
        "purity": "100",
        "sortBy": "created_at:desc",
        "limit": 1,
        "offset": 0
      });

      if (response['success'] == true) {
        final List data = response['data'] ?? [];
        if (data.isNotEmpty) {
          final item = data.first;

          rateSl.value =
              int.tryParse(double.parse(item['rate']).toStringAsFixed(0)) ?? 0;

          ratePerWtSl.value =
              int.tryParse(double.parse(item['rate_per_wt']).toStringAsFixed(0)) ?? 0;

          ratePerWtUnitSL.value = item['rate_per_wt_unit'] ?? '';
        }
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Check internet connection');
    }
  }

  RxList<StoryModel> stories = <StoryModel>[].obs;
  RxBool isLoadingStories = false.obs;

  Future<void> fetchStories() async {
    try {
      isLoadingStories.value = true;

      final response = await _apiClient.get(
        Uri.parse(ApiUrls.stories),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          List data = decoded['data'];

          stories.value =
              data.map((e) => StoryModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("Story Error: $e");
    } finally {
      isLoadingStories.value = false;
    }
  }

  RxList<HomeSection> homeSections = <HomeSection>[].obs;

  Future<void> fetchHomeSections() async {
    try {
      final response = await _apiClient.get(Uri.parse(ApiUrls.homeSections));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          List data = decoded['data'];
          var list = data.map((e) => HomeSection.fromJson(e)).toList();
          list.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
          homeSections.assignAll(list.where((s) => s.isVisible).toList());
        }
      }
     } catch (e) {
      print("Home Section Error: $e");
    }
  }

  RxList<BannerModel> allBanners = <BannerModel>[].obs;
  RxBool isLoadingBanners = false.obs;

  Future<void> fetchBanners() async {
    try {
      isLoadingBanners.value = true;

      final response = await _apiClient.get(
        Uri.parse(ApiUrls.appBanners),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          allBanners.value = (decoded['data'] as List)
              .map((e) => BannerModel.fromJson(e))
              .toList();
        }
      }
    } finally {
      isLoadingBanners.value = false;
    }
  }

  List<BannerModel> getBannersByType(String type) {
    final list = allBanners.where((b) => b.bannerType == type).toList();
    list.sort((a, b) => a.priority.compareTo(b.priority));
    return list;
  }



  /// featured collection api

// Controller ke andar variables
  RxMap<String, List<Product>> sectionProducts = <String, List<Product>>{}.obs;
  RxMap<String, bool> sectionLoading = <String, bool>{}.obs;

// API Method
  Future<void> fetchSectionProducts(String sectionKey, int tagId) async {
    try {
      sectionLoading[sectionKey] = true;
      final Map<String, dynamic> bodyData = {
        "limit": "10",
        "offset": "0",
        "tags": [tagId],
      };
      final response = await _apiClient.post(
        Uri.parse(ApiUrls.homeProductListApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        final productRes = productResponseFromJson(response.body);
        sectionProducts[sectionKey] = productRes.data.products;
      }
    } catch (e) {
      print("Error fetching $sectionKey: $e");
    } finally {
      sectionLoading[sectionKey] = false;
    }
  }

// onInit ya refreshData mein call karein
  void loadAllProductSections() {
    fetchSectionProducts('trending_products', 1);
    fetchSectionProducts('recommended_products', 3);
    fetchSectionProducts('featured_collections', 70);
  }

  Future<void> toggleWishlist(Product item) async {
    final int ownerId = AppDataController.to.ownerId.value ?? 0;
    final String productId = item.productDetails.id;
    final bool wasWishlisted = item.isWishlisted;

    try {
      // 1. Current Controller UI Update (Optimistic)
      item.isWishlisted = !wasWishlisted;
      sectionProducts.refresh();

      // 2. Dusre Controllers mein bhi turant UI update karein (Sync)
      _syncOtherControllers(productId, item.isWishlisted);

      dynamic response;
      if (!wasWishlisted) {
        response = await _apiClient.post(
          Uri.parse(ApiUrls.wishlistAddApi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"product_id": int.parse(productId), "jeweller_id": ownerId}),
        );
      } else {
        response = await _apiClient.delete(
          Uri.parse("${ApiUrls.wishlistDeleteApi}/$productId"),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && responseData['success'] == true) {

        // 3. Wishlist Page ki list update karein
        if (Get.isRegistered<WishlistController>()) {
          final wishCtrl = Get.find<WishlistController>();
          if (!wasWishlisted) {
            wishCtrl.fetchWishlist(); // Naya item add hua toh list refresh karein
          } else {
            wishCtrl.wishlistItems.removeWhere((w) => w.productDetails.id == productId);
          }
        }

        Get.rawSnackbar(
          message: responseData['message'] ?? "Wishlist updated",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 900),
          backgroundColor: Colors.black87,
        );
      } else {
        throw responseData['message'] ?? "Server error";
      }
    } catch (e) {
      // 4. Rollback: Agar fail hua toh sab jagah wapas purana state
      item.isWishlisted = wasWishlisted;
      sectionProducts.refresh();
      _syncOtherControllers(productId, wasWishlisted);

      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _syncOtherControllers(String productId, bool status) {
    if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      int index = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (index != -1) {
        catCtrl.stockItems[index].isWishlisted = status;
        catCtrl.stockItems.refresh();
      }
    }

    // Sync Tag Controller (Agar ye function TagController ke bahar hai toh)
    if (Get.isRegistered<homeProductsListController>()) {
      final tagCtrl = Get.find<homeProductsListController>();
      int index = tagCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (index != -1) {
        tagCtrl.stockItems[index].isWishlisted = status;
        tagCtrl.stockItems.refresh();
      }
    }
  }


  // DashboardController ke andar ye add karein

  Future<void> addToCart(Product item) async {
    final String productId = item.productDetails.id;

    if (item.isInCart) {
      Get.toNamed(AppRoutes.cartPage);
      return;
    }

    try {
      // 1. Optimistic Update
      item.isInCart = true;
      sectionProducts.refresh(); // UI refresh karein

      // 2. Pure app mein sync karein
      _syncCartStatusAcrossApp(productId, true);

      final response = await _apiClient.post(
        Uri.parse(ApiUrls.cartAddApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"item_id": int.parse(productId)}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.rawSnackbar(
          message: "Added to Bag",
          backgroundColor: Colors.black87,
          duration: const Duration(milliseconds: 900),
        );
      }
    } catch (e) {
      // Rollback
      item.isInCart = false;
      sectionProducts.refresh();
      _syncCartStatusAcrossApp(productId, false);
      Get.snackbar("Error", "Failed to add to cart");
    }
  }

// Global Sync Helper for Cart
  void _syncCartStatusAcrossApp(String productId, bool status) {
    // Sync Catalogue
    if (Get.isRegistered<ProductCatalogueController>()) {
      final catCtrl = Get.find<ProductCatalogueController>();
      int idx = catCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (idx != -1) {
        catCtrl.stockItems[idx].isInCart = status;
        catCtrl.stockItems.refresh();
      }
    }

    // Sync HomeProductList (Collections page)
    if (Get.isRegistered<homeProductsListController>()) {
      final homeCtrl = Get.find<homeProductsListController>();
      int idx = homeCtrl.stockItems.indexWhere((p) => p.productDetails.id == productId);
      if (idx != -1) {
        homeCtrl.stockItems[idx].isInCart = status;
        homeCtrl.stockItems.refresh();
      }
    }
  }

}
