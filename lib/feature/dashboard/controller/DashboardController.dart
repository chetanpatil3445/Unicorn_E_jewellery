import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/controller/AppDataController.dart';
import '../../../core/utils/token_helper.dart';
import 'dart:convert';

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
  }

   Future<void> refreshData() async {
    loadUserData();
    fetchGoldRates();
    fetchSilverRates();
    fetchStories();
    fetchBanners();
    fetchHomeSections();

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


}
