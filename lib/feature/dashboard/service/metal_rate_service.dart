import 'dart:convert';

import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';

class MetalRateService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> addMetalRate(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      Uri.parse(ApiUrls.metalRates),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getMetalRates(Map<String, dynamic> params) async {
    final response = await _apiClient.post(
      Uri.parse(ApiUrls.metalRatesList),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(params),
    );
    return jsonDecode(response.body);
  }
}
