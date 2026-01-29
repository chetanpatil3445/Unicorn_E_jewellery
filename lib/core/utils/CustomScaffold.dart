import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'CustomAppBar.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? mobileAppBar;
  final String? HeaderText;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const CustomScaffold({
    super.key,
    required this.body,
    this.mobileAppBar,
    this.HeaderText,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 🔥 Web + Desktop + Mobile → same AppBar everywhere
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: mobileAppBar ??
              CustomAppBar(
                title: HeaderText ?? "Unicorn Software",
              ),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          body: body,
        );
      },
    );
  }
}
