import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicorn_e_jewellers/Routes/app_routes.dart';
import 'package:video_player/video_player.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/DashboardController.dart';

Widget buildAppBar(BuildContext context , scaffoldKey) {
  return SliverAppBar(
    pinned: true,
    surfaceTintColor: ivoryWhite,
    backgroundColor: ivoryWhite,
    elevation: 0,
    title: Text("Unicorn",
        style: GoogleFonts.cinzel(
            color: deepBlack, fontWeight: FontWeight.bold, letterSpacing: 2)),
    leading: IconButton(
      icon: const Icon(Icons.menu_outlined, color: deepBlack),
      onPressed: () => scaffoldKey.currentState?.openDrawer(),
    ),
    actions: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag_outlined, color: deepBlack)),
    ],
  );
}