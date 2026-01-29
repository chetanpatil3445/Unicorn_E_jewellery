import 'package:flutter/services.dart';

class CustomBiometricService {
  static const platform = MethodChannel('custom_biometrics');

  Future<bool> authenticate() async {
    try {
      final bool result = await platform.invokeMethod('authenticate');
      return result;
    } on PlatformException catch (e) {
      print('Biometric error: $e');
      return false;
    }
  }
}
