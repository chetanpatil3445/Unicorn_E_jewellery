import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controller/PasscodeController.dart';

class PasscodeLoginScreen extends GetView<PasscodeController> {
  const PasscodeLoginScreen({super.key});

  static const Color brandRed = Color(0xFFFF4D2D);
  static const Color brandBlue = Color(0xFF003366);
  static const Color brandCyan = Color(0xFF00CED1);
  static const Color brandYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    Get.put(PasscodeController());

    return Scaffold(
      backgroundColor: Colors.white,
      // ResizeToAvoidBottomInset false taaki keyboard open hone par layout na bigde
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // --- UPPER SECTION (Fixed Height Ratio) ---
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    "assets/images/img_1.png",
                    width: 180, // Size thoda optimize kiya
                    fit: BoxFit.contain,
                  ).animate().fadeIn(duration: 800.ms).scale(curve: Curves.easeOutBack),

                  const SizedBox(height: 20),

                  Obx(() => Text(
                    (controller.isPinError.isTrue ? 'INVALID PASSCODE' : 'ENTER PASSCODE'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: brandBlue,
                      letterSpacing: 2,
                    ),
                  )),
                ],
              ),
            ),
          ),

          // --- LOWER SECTION (Fixed Container) ---
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Auto spacing
                children: [
                  const SizedBox(height: 10),

                  // Multicolor Dots
                  Obx(() => _buildMulticolorDots()),

                  // Keypad
                  _buildPremiumKeypad(context),

                  // Footer
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.ForgotPasscodeView),
                      child: const Text(
                        "FORGOT PASSCODE?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMulticolorDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = index < controller.enteredPin.value.length;
        List<Color> dotColors = [brandRed, brandBlue, brandCyan, brandYellow];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 16, // Size 18 se 16 kiya for safety
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? (controller.isPinError.isTrue ? brandRed : dotColors[index])
                : Colors.transparent,
            border: Border.all(
              color: isFilled
                  ? (controller.isPinError.isTrue ? brandRed : dotColors[index])
                  : Colors.grey.shade300,
              width: 2.5,
            ),
          ),
        ).animate(target: isFilled ? 1 : 0).shimmer();
      }),
    );
  }

  Widget _buildPremiumKeypad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _keypadRow(['1', '2', '3'], [brandRed, brandBlue, brandCyan]),
          _keypadRow(['4', '5', '6'], [brandYellow, brandRed, brandBlue]),
          _keypadRow(['7', '8', '9'], [brandCyan, brandYellow, brandRed]),
          _keypadRow(['fingerprint', '0', 'delete'], [brandCyan, brandBlue, Colors.grey]),
        ],
      ),
    );
  }

  Widget _keypadRow(List<String> keys, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6), // Spacing kam ki taaki fit ho
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(keys.length, (i) {
          if (keys[i] == 'delete') {
            return _keyButton(icon: Icons.backspace_outlined, color: colors[i], onTap: controller.clearLastDigit);
          }
          if (keys[i] == 'fingerprint') {
            return _keyButton(icon: Icons.fingerprint, color: colors[i], onTap: controller.authenticateWithBiometrics);
          }
          return _keyButton(label: keys[i], color: colors[i], onTap: () => controller.handlePinInput(keys[i]));
        }),
      ),
    );
  }

  Widget _keyButton({String? label, IconData? icon, required Color color, required VoidCallback onTap}) {
    // Responsive button size
    double btnSize = Get.height * 0.085;
    if (btnSize > 70) btnSize = 70;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(btnSize / 2),
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: label != null
              ? Text(label, style: TextStyle(fontSize: btnSize * 0.38, fontWeight: FontWeight.bold, color: color))
              : Icon(icon, size: btnSize * 0.38, color: color),
        ),
      ),
    );
  }
}