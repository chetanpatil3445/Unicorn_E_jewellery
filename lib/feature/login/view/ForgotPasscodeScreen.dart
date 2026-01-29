// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/PasscodeController.dart';
//
// class ForgotPasscodeScreen extends GetView<PasscodeController> {
//   const ForgotPasscodeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Controller is already initialized
//     // Get.put(PasscodeController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Forgot Passcode'),
//         backgroundColor: Colors.red.shade900,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Icon(
//                 Icons.warning_amber_rounded,
//                 size: 80,
//                 color: Colors.red,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Are you sure you want to reset your local Passcode?',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'This will clear your local login session and require you to log in with your username and password again to set a new Passcode.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton.icon(
//                 onPressed: controller.forgotPasscode,
//                 icon: const Icon(Icons.logout),
//                 label: const Text('Reset Passcode & Logout'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.red.shade700,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () => Get.back(),
//                 child: const Text('Cancel'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controller/PasscodeController.dart';

class ForgotPasscodeScreen extends GetView<PasscodeController> {
  const ForgotPasscodeScreen({super.key});

  // Wahi Brand Colors jo Passcode Screen mein hain
  static const Color brandRed = Color(0xFFFF4D2D);
  static const Color brandBlue = Color(0xFF003366);
  static const Color brandCyan = Color(0xFF00CED1);
  static const Color brandYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- UPPER SECTION (Logo & Image) ---
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
                    width: 180,
                    fit: BoxFit.contain,
                  ).animate().fadeIn(duration: 800.ms).scale(curve: Curves.easeOutBack),

                  const SizedBox(height: 30),

                  const Text(
                    "RESET PASSCODE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: brandBlue,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- LOWER SECTION (Grey Alert Area) ---
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA), // Passcode screen jaisa grey
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Warning Icon with Animation
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 70,
                    color: brandRed,
                  ).animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: Duration(seconds: 2), color: brandYellow.withOpacity(0.3)),

                  const SizedBox(height: 25),

                  const Text(
                    'Are you sure you want to reset?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'This will clear your local login session and require you to log in again to set a new Passcode.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // Action Button (Premium Style)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: controller.forgotPasscode,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'RESET & LOGOUT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandRed,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: brandRed.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ).animate().slideY(begin: 0.5, end: 0),

                  const SizedBox(height: 15),

                  // Cancel Button
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}