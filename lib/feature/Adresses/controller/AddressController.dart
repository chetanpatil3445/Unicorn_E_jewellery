import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:unicorn_e_jewellers/core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';

class AddressController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  var addresses = [].obs;
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final secondaryPhoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final houseController = TextEditingController();
  final areaController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  var addressType = "Home".obs;

  @override
  void onInit() {
    fetchAddresses();
    super.onInit();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading(true);
      var response = await _apiClient.get(Uri.parse(ApiUrls.addresses));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        addresses.assignAll(result['data']);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addAddress() async {
    try {
      isLoading(true);

      Map<String, dynamic> data = {
        "receiver_name": nameController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "secondary_phone_number": secondaryPhoneController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "house_no_building": houseController.text.trim(),
        "street_area": areaController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "address_type": addressType.value,
        "is_default": false
      };

      var response = await _apiClient.post(
        Uri.parse(ApiUrls.addresses),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      final result = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && result['success'] == true) {
        addresses.insert(0, result['data']);
        clearFields();
        Get.back();

        Get.snackbar(
          "Success",
          result['message'] ?? "Address created successfully",
          backgroundColor: const Color(0xFFC5A059),
          colorText: Colors.white,
        );
      } else {
        String errorMsg = "Something went wrong";
        if (result['errors'] != null && (result['errors'] as List).isNotEmpty) {
          errorMsg = result['errors'][0]['message'];
        }
        Get.snackbar(
          "Failed",
          errorMsg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> setDefault(String id) async {
    try {
      isLoading(true);
      var response = await _apiClient.put(Uri.parse('${ApiUrls.addresses}/$id/set-default'));
      var result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        await fetchAddresses();
        Get.snackbar(
          "Success",
          result['message'] ?? "Default address updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFC5A059),
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
        );
      } else {
        Get.snackbar("Error", result['message'] ?? "Failed to update default address");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      isLoading(true);
      var response = await _apiClient.delete(Uri.parse('${ApiUrls.addresses}/$id'));
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        addresses.removeWhere((element) => element['id'].toString() == id.toString());

        Get.snackbar(
          "Deleted",
          result['message'] ?? "Address removed successfully",
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          result['message'] ?? "Failed to delete address",
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    secondaryPhoneController.clear();
    pincodeController.clear();
    houseController.clear();
    areaController.clear();
    landmarkController.clear();
    cityController.clear();
    stateController.clear();
    addressType.value = "Home";
  }


  // Controller mein ye do naye methods add karein
  void setFieldsForUpdate(Map<String, dynamic> addr) {
    nameController.text = addr['receiver_name'] ?? "";
    phoneController.text = addr['phone_number'] ?? "";
    secondaryPhoneController.text = addr['secondary_phone_number'] ?? "";
    pincodeController.text = addr['pincode'] ?? "";
    houseController.text = addr['house_no_building'] ?? "";
    areaController.text = addr['street_area'] ?? "";
    landmarkController.text = addr['landmark'] ?? "";
    cityController.text = addr['city'] ?? "";
    stateController.text = addr['state'] ?? "";
    addressType.value = addr['address_type'] ?? "Home";
  }

  Future<void> updateAddress(String id) async {
    try {
      isLoading(true);
      Map<String, dynamic> data = {
        "receiver_name": nameController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "secondary_phone_number": secondaryPhoneController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "house_no_building": houseController.text.trim(),
        "street_area": areaController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "address_type": addressType.value,
      };

      var response = await _apiClient.put(
        Uri.parse('${ApiUrls.addresses}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        await fetchAddresses(); // List refresh
        Get.back();
        Get.snackbar("Success", result['message'] ?? "Address updated",
            backgroundColor: const Color(0xFFC5A059), colorText: Colors.white);
      } else {
        Get.snackbar("Failed", result['message'] ?? "Update failed",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Server Error: $e");
    } finally {
      isLoading(false);
    }
  }
}