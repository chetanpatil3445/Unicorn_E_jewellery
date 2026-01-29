
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:geolocator/geolocator.dart';

class SecurityService {
  static const platform = MethodChannel('com.swiftHRM.app/security');

  static Future<List<String>> runSecurityChecks() async {
    final List<String> breaches = [];

    // 1. Root / Jailbreak Detection
    try {
      bool isJailbroken = await FlutterJailbreakDetection.jailbroken;
      if (isJailbroken) {
        breaches.add("Device is Rooted / Jailbroken");
      }

    } catch (e) {
      print('Error during jailbreak detection: $e');
    }

    // 2. Developer Options Status (Android)
    // try {
    //   final bool isDeveloperMode = await platform.invokeMethod('isDeveloperMode');
    //   if (isDeveloperMode) {
    //     breaches.add("Developer Options Enabled");
    //   }
    // } on PlatformException catch (e) {
    //   print("Failed to check developer mode: '${e.message}'.");
    // }
//
    // 3. Mock Location Detection & 4. GPS Accuracy Validation
    // try {
    //   final position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.best,
    //   );
    //   if (position.isMocked) {
    //     breaches.add("Mock Location Detected");
    //   }
    //   if (position.accuracy > 20) {
    //     breaches.add("GPS Accuracy Too Low (${position.accuracy.toStringAsFixed(2)}m)");
    //   }
    // } catch (e) {
    //   breaches.add("Could not verify location: ${e.toString()}");
    //   print('Error during location validation: $e');
    // }

    return breaches;
  }
}
