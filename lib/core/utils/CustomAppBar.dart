import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/appcolors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBack = true,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {

    // 🔥 WebHeaderGlobal हटाया — अब web और mobile दोनों पर same AppBar दिखेगा
    return AppBar(
      automaticallyImplyLeading: showBack,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: AllTextColor,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: actions,
      leading: showBack
          ? IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios, color: AllTextColor),
      )
          : null,
    );
  }
}
