import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unicorn_e_jewellers/core/controller/AppDataController.dart';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';



class MyReviewsController extends GetxController {

  final ApiClient _apiClient = ApiClient();

  var isLoading = false.obs;
  var reviews = [].obs;

  Future<void> fetchMyReviews() async {
    try {
      isLoading(true);

      final int userId = AppDataController.to.staffId.value ?? 0;

      final response = await http.post(
        Uri.parse(ApiUrls.productReviewsList),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await const FlutterSecureStorage().read(key: 'access_token')}',
        },
        body: jsonEncode({
          "user_id": userId
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        reviews.value = data['data'] ?? [];
      } else {
        Get.snackbar("Error", "Failed to load reviews");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}
