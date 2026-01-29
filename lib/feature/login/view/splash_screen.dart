import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/security_alert_page.dart';
import '../../../services/security_service.dart';
import '../controller/PasscodeController.dart';
import '../controller/login_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final PasscodeController passcodeController = Get.put(PasscodeController());
  final LoginController loginController = Get.put(LoginController());

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 🌈 Main fade/scale animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _navigateAfterDelay();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🕒 Splash delay before token check
  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    // Request location permission before running security checks
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final breaches = await SecurityService.runSecurityChecks();
    if (breaches.isNotEmpty) {
      Get.offAll(() => SecurityAlertPage(breaches: breaches));
    } else {
      await checkLoginStatus();
    }
  }



  /// ✅ Token check logic
  Future<void> checkLoginStatus() async {
    final accessToken = await secureStorage.read(key: 'access_token');
    final refreshToken = await secureStorage.read(key: 'refresh_token');

    if (accessToken != null && accessToken.isNotEmpty) {
      passcodeController.checkPasscodeStatusAndBiometrics();

      if (passcodeController.isPasscodeSet.value) {
        Get.offAllNamed(AppRoutes.PasscodeLoginView);
        passcodeController.authenticateWithBiometrics();
      } else {
        Get.offAllNamed(AppRoutes.CreatePasscodeView);
      }
    } else if (refreshToken != null && refreshToken.isNotEmpty) {
      print('🔄 Trying to refresh token...');
      final success = await loginController.refreshAccessToken(refreshToken);

      if (success) {
        print('✅ Token refreshed successfully');
        passcodeController.checkPasscodeStatusAndBiometrics();

        if (passcodeController.isPasscodeSet.value) {
          Get.offAllNamed(AppRoutes.PasscodeLoginView);
          passcodeController.authenticateWithBiometrics();
        } else {
          Get.offAllNamed(AppRoutes.CreatePasscodeView);
        }
      } else {
        print('⚠️ Refresh token expired, redirecting to Login...');
        await loginController.logout();
      }
    } else {
      print('🔒 No token found, going to Login screen...');
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/images/img_1.png',
              width: 160,   // 👈 size kam/jyada yahan se control karo
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}