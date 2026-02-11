import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:unicorn_e_jewellers/core/apiUrls/api_urls.dart';
import 'dart:convert';

import '../../../core/utils/token_helper.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var isLoading = true.obs;
  var ordersList = <Order>[].obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await _apiClient.get(
        Uri.parse(ApiUrls.orderList),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = OrderResponse.fromJson(json.decode(response.body));
        ordersList.assignAll(data.orders ?? []);
      }
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }
}