
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/controller/AppDataController.dart';
import '../../../core/utils/token_helper.dart';
import '../model/cr_dr_model.dart';

class CrDrController extends GetxController {
  var crList = <CrDrEntry>[].obs;
  var drList = <CrDrEntry>[].obs;

  var isDrLoading = false.obs;
  var isCrLoading = false.obs;
  var isLoadMore = false.obs; // Pagination loader ke liye

  var isDrFetched = false.obs;
  var isCrFetched = false.obs;

  // Pagination states
  int drPage = 1;
  int crPage = 1;
  bool drHasMore = true;
  bool crHasMore = true;
  final int limit = 20;

  var drFilter = 'unpaid'.obs;
  var crFilter = 'unpaid'.obs;

  final ApiClient _apiClient = ApiClient();

  List<CrDrEntry> getFilteredList(bool isCr) {
    if (isCr) {
      return crFilter.value == 'paid'
          ? crList.where((e) => e.isSettled).toList()
          : crList.where((e) => !e.isSettled).toList();
    } else {
      return drFilter.value == 'paid'
          ? drList.where((e) => e.isPaid).toList()
          : drList.where((e) => !e.isPaid).toList();
    }
  }

  Future<void> fetchData({required bool isCr, bool isRefresh = false}) async {
    if (isCr) {
      if (isCrLoading.value || (isLoadMore.value && !isRefresh)) return;
      if (!crHasMore && !isRefresh) return;
      if (isRefresh) { crPage = 1; crHasMore = true; }
    } else {
      if (isDrLoading.value || (isLoadMore.value && !isRefresh)) return;
      if (!drHasMore && !isRefresh) return;
      if (isRefresh) { drPage = 1; drHasMore = true; }
    }

    if (isRefresh) {
      isCr ? isCrLoading(true) : isDrLoading(true);
    } else {
      isLoadMore(true);
    }

    int? userId = AppDataController.to.staffId.value;
    int? firmId = AppDataController.to.firmID.value;
    int currentPage = isCr ? crPage : drPage;

    try {
      final response = await _apiClient.post(
        Uri.parse(ApiUrls.udharAdvanceList),
        body: jsonEncode({
          "filters": {
            "utin_type": isCr ? ["ADVANCE", "METAL_ADVANCE"] : ["UDHAAR", "METAL_DUE"],
            "utin_status": isCr ? ["ADVANCE", "SETTLED"]: ["DUE", "SETTLED"],
            "utin_firm_id": firmId,
            "utin_user_id": userId,
            "utin_transaction_type": [
              "DIRECT"
            ]
          },
          "sort": {"field": "utin_createdAt", "order": "desc"},
          "page": currentPage,
          "limit": limit
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List data = jsonData['data'] ?? [];
        final List<CrDrEntry> newEntries = data.map((e) => CrDrEntry.fromApi(e)).toList();

        if (isRefresh) {
          isCr ? crList.assignAll(newEntries) : drList.assignAll(newEntries);
        } else {
          isCr ? crList.addAll(newEntries) : drList.addAll(newEntries);
        }

        bool hasMore = newEntries.length == limit;
        if (isCr) { crHasMore = hasMore; crPage++; }
        else { drHasMore = hasMore; drPage++; }
      }
    } finally {
      isCrLoading(false);
      isDrLoading(false);
      isLoadMore(false);
      isCr ? isCrFetched(true) : isDrFetched(true);
    }
  }

  Future<void> fetchDrData() => fetchData(isCr: false, isRefresh: true);
  Future<void> fetchCrData() => fetchData(isCr: true, isRefresh: true);
}