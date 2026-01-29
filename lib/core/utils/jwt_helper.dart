import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../../feature/login/view/login_page.dart';
import '../../routes/app_routes.dart';


class JwtHelper {
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      final exp = payload['exp'];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  static void checkAndLogoutIfExpired() {
    final storage = GetStorage();
    final token = storage.read('token');
    if (token != null && isTokenExpired(token)) {
      storage.erase();
      Get.offAllNamed(AppRoutes.LOGIN);
      Get.offAll(() => LoginScreen());
      Get.snackbar('Session Expired', 'Please login again.');
    }
  }
    static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

 // 
  static void Logout() async{
    final storage = GetStorage();
      await storage.erase();
      await clearSecureStorage();
      Get.offAllNamed(AppRoutes.LOGIN);
    }

      /// 🧹 Helper to clear both secure and GetStorage (if used anywhere)
  static Future<void> clearSecureStorage() async {
    final secureStorage = const FlutterSecureStorage();
    await secureStorage.deleteAll();
  }
}

