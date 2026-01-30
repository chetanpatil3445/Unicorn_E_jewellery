import 'dart:convert';
import 'package:unicorn_e_jewellers/core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';

Future<int?> logProductInteraction({
  required int jewellerId,
  required int productId,
  required int userId,
  required String interactionType,
  required String deviceType,
  required String ipAddress,
}) async {
  final url = Uri.parse(ApiUrls.interactionsLog);
  final ApiClient apiClient = ApiClient();

  final body = jsonEncode({
    "jeweller_id": jewellerId,
    "product_id": productId,
    "user_id": userId,
    "interaction_type": interactionType,
    "device_type": deviceType,
  });

  try {
    final response = await apiClient.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("Interaction logged successfully, ID: ${data['id']}");
      return int.tryParse(data['id'].toString()); // return ID as int
    } else {
      print("Failed to log interaction. Status: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error logging interaction: $e");
    return null;
  }
}
