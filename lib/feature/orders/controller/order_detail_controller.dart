import 'package:get/get.dart';
import 'package:unicorn_e_jewellers/core/apiUrls/api_urls.dart';
import 'dart:convert';
import '../../../core/utils/token_helper.dart';
import '../models/order_detail_model.dart';

class OrderDetailController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var isLoading = true.obs;
  var orderDetail = Rxn<OrderDetailResponse>();
  var shippingAddress = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    if (Get.arguments != null) {
      final orderId = Get.arguments;
      fetchOrderDetails(orderId);
    }
    super.onInit();
  }

  Future<void> fetchOrderDetails(int id) async {
    try {
      isLoading(true);
      final response = await _apiClient.get(Uri.parse("${ApiUrls.orderDetail}$id"));
      if (response.statusCode == 200) {
        orderDetail.value = OrderDetailResponse.fromJson(json.decode(response.body));
        final idToFetch = orderDetail.value?.order?.addressId;

        if (idToFetch != null) {
          fetchAddress(idToFetch);
        } else {
          print("Address ID is missing in order details");
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAddress(int addressId) async {
    try {
      final response = await _apiClient.get(Uri.parse("${ApiUrls.addresses}/$addressId"));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success']) {
          shippingAddress.value = body['data'];
        }
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }
}