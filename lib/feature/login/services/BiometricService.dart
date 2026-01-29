import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  /// Check if biometrics are available on the device
  Future<bool> canCheckBiometrics() async {

    try {
      final bool canCheck = await auth.canCheckBiometrics;
      return canCheck;
    } on PlatformException catch (_) {
      // Handle platform-specific errors (e.g., no sensors, permissions)
      return false;
    }
  }

  /// Authenticate the user using biometrics (Fingerprint/Face ID)
  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint (or face or whatever) to authenticate',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
       );


      return didAuthenticate;
    } on PlatformException catch (e) {
      // For general device/OS issues
      print('Biometric error: $e');
      return false;
    }
  }
}

//
// import 'package:flutter/services.dart';
//
// class BiometricService {
//   static const MethodChannel _channel = MethodChannel('custom_biometrics');
//
//   Future<bool> authenticate() async {
//     try {
//       final bool result = await _channel.invokeMethod('authenticate');
//       return result;
//     } on PlatformException catch (e) {
//       print('Biometric error: $e');
//       return false;
//     }
//   }
//
//   /// Optional placeholder so your controller compiles fine:
//   Future<bool> canCheckBiometrics() async {
//     // Always true for devices with hardware
//     return true;
//   }
// }
