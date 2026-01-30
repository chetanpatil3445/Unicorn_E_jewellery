import 'dart:convert';
import 'package:unicorn_e_jewellers/core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';

Future<bool> updateStayDuration({
  required int interactionId,
  required int stayDuration, // in seconds
}) async {
  final url = Uri.parse(ApiUrls.interactionsDuration);
  final ApiClient apiClient = ApiClient();

  final body = jsonEncode({
    "id": interactionId,
    "stay_duration": stayDuration,
  });

  try {
    final response = await apiClient.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("Stay duration updated successfully: ${data['message']}");
      return data['success'] ?? false;
    } else {
      print("Failed to update stay duration. Status: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error updating stay duration: $e");
    return false;
  }
}
