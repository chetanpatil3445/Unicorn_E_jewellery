import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controller/PasscodeController.dart';

class CreatePasscodeScreen extends GetView<PasscodeController> {
  const CreatePasscodeScreen({super.key});

  // Logo se liye gaye brand colors
  static const Color brandRed = Color(0xFFFF4D2D);
  static const Color brandBlue = Color(0xFF003366);
  static const Color brandCyan = Color(0xFF00CED1);
  static const Color brandYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background as requested
      body: Column(
        children: [
          // --- UPPER SECTION (Bada Logo) ---
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Bada Image Logo
                  Image.asset(
                    "assets/images/img_1.png",
                    width: 200, // Size bada kiya gaya hai
                    fit: BoxFit.contain,
                  ).animate().fadeIn(duration: 800.ms).scale(curve: Curves.easeOutBack),

                  const SizedBox(height: 20),

                  Obx(() => Text(
                    controller.creationMessage.value.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: brandBlue, // Deep blue for text
                      letterSpacing: 2,
                    ),
                  )),
                ],
              ),
            ),
          ),

          // --- LOWER SECTION (Multicolor Keypad Area) ---
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA), // Bahut halka grey divider feel ke liye
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Brand Color PIN Dots
                  Obx(() => _buildMulticolorDots()),

                  const Spacer(),

                  // Multicolor Keypad
                  _buildPremiumKeypad(context),

                  const SizedBox(height: 20),
                  if (controller.isPasscodeSet.isTrue)
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
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
        final currentPin = controller.isConfirming.isFalse
            ? controller.newPasscode1.value
            : controller.newPasscode2.value;

        bool isFilled = index < currentPin.length;

        // Har dot ka alag color (Logo theme ki tarah)
        List<Color> dotColors = [brandRed, brandBlue, brandCyan, brandYellow];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? dotColors[index] : Colors.transparent,
            border: Border.all(
              color: isFilled ? dotColors[index] : Colors.grey.shade300,
              width: 3,
            ),
          ),
        ).animate(target: isFilled ? 1 : 0).shimmer();
      }),
    );
  }

  Widget _buildPremiumKeypad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        children: [
          _keypadRow(['1', '2', '3'], [brandRed, brandBlue, brandCyan]),
          _keypadRow(['4', '5', '6'], [brandYellow, brandRed, brandBlue]),
          _keypadRow(['7', '8', '9'], [brandCyan, brandYellow, brandRed]),
          _keypadRow(['', '0', 'delete'], [Colors.transparent, brandBlue, Colors.grey]),
        ],
      ),
    );
  }

  Widget _keypadRow(List<String> keys, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(keys.length, (i) {
          if (keys[i] == '') return const SizedBox(width: 70);

          return _keyButton(
            label: keys[i] == 'delete' ? null : keys[i],
            icon: keys[i] == 'delete' ? Icons.backspace_outlined : null,
            color: colors[i],
            onTap: keys[i] == 'delete'
                ? controller.clearCreationLastDigit
                : () => controller.handleCreationPinInput(keys[i]),
          );
        }),
      ),
    );
  }

  Widget _keyButton({String? label, IconData? icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.1), width: 1),
        ),
        child: Center(
          child: label != null
              ? Text(
            label,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color, // Number ka color logo ke colors se match karega
            ),
          )
              : Icon(icon, size: 22, color: color),
        ),
      ),
    );
  }
}