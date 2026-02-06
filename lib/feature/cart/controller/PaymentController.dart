import 'dart:convert';

import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';

class PaymentController extends GetxController {
  final ApiClient _apiClient = ApiClient();
  var addresses = [].obs;
  var selectedAddress = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCheckoutAddress();
  }

  // Ise call karne se data refresh ho jayega
  Future<void> fetchCheckoutAddress() async {
    try {
      isLoading(true);
      var response = await _apiClient.get(Uri.parse(ApiUrls.addresses));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        List fetchedAddresses = result['data'];
        addresses.assignAll(fetchedAddresses);

        if (fetchedAddresses.isNotEmpty) {
          // Purane selected address ki ID check karke use hi update karo
          // taaki selection na badle
          if (selectedAddress.isNotEmpty) {
            var updatedSelected = fetchedAddresses.firstWhere(
                  (addr) => addr['id'] == selectedAddress['id'],
              orElse: () => fetchedAddresses.firstWhere((a) => a['is_default'] == true, orElse: () => fetchedAddresses[0]),
            );
            selectedAddress.value = updatedSelected;
          } else {
            var defaultAddr = fetchedAddresses.firstWhere(
                  (addr) => addr['is_default'] == true,
              orElse: () => fetchedAddresses[0],
            );
            selectedAddress.value = defaultAddr;
          }
        }
      }
    } catch (e) {
      print("Checkout Address Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateSelectedAddress(Map<String, dynamic> addr) {
    selectedAddress.value = addr;
    Get.back();
  }
}