// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Opacity(
//                         opacity: 0.05,
//                         child: Image.asset("assets/images/bargraph2.png",width: 130,),
//                       ),
//                     ],
//                   ),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Opacity(
//                         opacity: 0.09,
//                         child: SvgPicture.asset(
//                           "assets/images/onbard6.svg",
//                           width: 130,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 380),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Opacity(
//                         opacity: 0.07,
//                         child: SvgPicture.asset(
//                           "assets/images/graph3.svg",
//                           width: 100,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment(-0.6, -0.5),
//               child:  Opacity(
//                 opacity: 0.06,
//                 child: SvgPicture.asset("assets/images/svg1.svg",width: 120,),),
//             ),
//             Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Color(0xff202a44),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 height: 270,
//                 width: 400,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 30),
//                       TextFormField(
//                         controller: _usernameController,
//                         decoration: InputDecoration(
//                           fillColor: Colors.white,
//                           filled: true,
//                           hintText: "UserName",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           hintStyle: TextStyle(
//                             color: Color(0xff202a44),
//                             fontFamily: "Poppins",
//                           ),
//                           prefixIcon: Icon(Icons.person, color: Color(0xff202a44)),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           hintText: "Email",
//                           fillColor: Colors.white,filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           hintStyle: TextStyle(
//                             color: Color(0xff202a44),
//                             fontFamily: "Poppins",
//                           ),
//                           prefixIcon: Icon(Icons.email, color: Color(0xff202a44)),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       SizedBox(
//                         height: 50,
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             side: BorderSide(color: Colors.white),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             backgroundColor: Color(0xff202a44),
//                           ),
//                           onPressed: () {
//                             // Functionality from forgot_screen.dart
//                             final username = _usernameController.text;
//                             final email = _emailController.text;
//
//                             if (username.isNotEmpty && email.isNotEmpty) {
//                               // Call API or handle forgot password logic here
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('Password reset request sent')),
//                               );
//                               // Optionally, navigate to another screen if needed
//                               // Navigator.pop(context); // Example: go back after sending request
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text('Please fill in all fields')),
//                               );
//                             }
//                           },
//                           child: Text("Send Request",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.w500),),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment(0.9,0.7),
//               child:  Opacity(
//                 opacity: 0.05,
//                 child: SvgPicture.asset(
//                   "assets/images/graph6.svg",
//                   width: 150,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment(0,0.9),
//               child: Opacity(
//                 opacity: 0.05,
//                 child: Image.asset(
//                   "assets/images/barchart.png",
//                   width: 80,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 50),
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(onPressed: (){
//                   Navigator.pop(context);
//                 }, icon: Icon(Icons.arrow_back_ios)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Passcode screen wale same colors
  static const Color brandRed = Color(0xFFFF4D2D);
  static const Color brandBlue = Color(0xFF003366);
  static const Color brandCyan = Color(0xFF00CED1);
  static const Color brandYellow = Color(0xFFFFC107);

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- UPPER SECTION (Logo & Title) ---
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                    Padding(
                    padding: const EdgeInsets.only(top: 50, left: 10),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: brandBlue),
                    ),
                  ),

                  // Center Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          "assets/images/img_1.png",
                          width: 180,
                          fit: BoxFit.contain,
                        ).animate().fadeIn(duration: 800.ms).scale(curve: Curves.easeOutBack),

                        const SizedBox(height: 20),

                        const Text(
                          "FORGOT PASSCODE",
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
                ],
              ),
            ),
          ),

          // --- LOWER SECTION (Grey Background with Inputs) ---
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA), // Same as Passcode Screen
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView( // Form fields ke liye scroll safety
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // Username Field
                    _buildPremiumTextField(
                      controller: _usernameController,
                      hint: "UserName",
                      icon: Icons.person_outline,
                      accentColor: brandRed,
                    ),

                    const SizedBox(height: 20),

                    // Email Field
                    _buildPremiumTextField(
                      controller: _emailController,
                      hint: "Email Address",
                      icon: Icons.email_outlined,
                      accentColor: brandCyan,
                    ),

                    const SizedBox(height: 40),

                    // Send Request Button (Multicolor touch)
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                          shadowColor: brandBlue.withOpacity(0.3),
                        ),
                        onPressed: _submitRequest,
                        child: const Text(
                          "SEND REQUEST",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: brandBlue, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: accentColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 1),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1, end: 0);
  }

  void _submitRequest() {
    if (_usernameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset request sent'), backgroundColor: brandBlue),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields'), backgroundColor: brandRed),
      );
    }
  }
}