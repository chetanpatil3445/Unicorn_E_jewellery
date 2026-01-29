import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/controller/AppDataController.dart';
import '../../../core/utils/token_helper.dart';
import 'dart:convert';

import '../metal_rate_service.dart';


class DashboardController extends GetxController {
  final _apiClient = ApiClient();
  var userName = ''.obs;
  var userLocation = ''.obs;
  var userImageUrl = ''.obs;

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchGoldRates();
    fetchSilverRates();
    AppDataController.to.expiryCheck.value = storage.read('subscriptionStatus');
    AppDataController.to.expiryDate.value = storage.read('expiryDate');
  }

   Future<void> refreshData() async {
    loadUserData();
    fetchGoldRates();
    fetchSilverRates();
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


}
