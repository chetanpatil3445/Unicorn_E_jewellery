import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Category/controller/Category_tag_controller.dart';
import '../../Category/view/CollectionStock.dart';
import '../model/banner_model.dart';
import '../widgets/browseByCategory.dart';



Widget buildGenderSection(List<BannerModel> banners) {
  final TagController tcontroller = Get.put(TagController());
  return Row(
    children: banners.map((b) => Expanded(
      child: InkWell(
        onTap: () {
          tcontroller.gender.value = b.subtitle;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.to(() => CollectionStock());
          });
        },
        child: _genderTile(b.subtitle, b.imageUrl),
      ),
    )).toList(),
  );
}

Widget _genderTile(String label, String url) {
  return Container(
      height: 120,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
          )
      ),
      alignment: Alignment.center,
      child: Text(
          label,
          style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)
      )
  );
}