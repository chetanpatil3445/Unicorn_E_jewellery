import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/appcolors.dart';
import '../../Category/controller/Category_tag_controller.dart';
import '../../Category/view/CollectionStock.dart';




Widget getStaticContent(String name) {
  switch (name) {
    case 'gift_for_loved_ones': return _buildGiftSection();
    case 'testimonials': return _buildTestimonials();
    default: return const SizedBox.shrink();
  }
}

Widget _buildGiftSection() {
  final TagController tcontroller = Get.put(TagController());

  final gifts = [{'n': 'For Her', 'i': Icons.card_giftcard}, {'n': 'For Him', 'i': Icons.redeem}, {'n': 'Anniversary', 'i': Icons.favorite_border}, {'n': 'Birthday', 'i': Icons.cake_outlined}];
  return Container(
    height: 90,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, i) => Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: goldAccent.withOpacity(0.2)), borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            final String tagName = gifts[i]['n'].toString();
            tcontroller.selectedTag.value = '';
            tcontroller.gender.value = '';

            if (tagName == 'For Her') {
              tcontroller.gender.value = 'FEMALE';
            }
            else if (tagName == 'For Him') {
              tcontroller.gender.value = 'MALE';
            }
            else if (tagName == 'Anniversary') {
              tcontroller.selectedTag.value = 'Anniversary Gift';
            }
            else if (tagName == 'Birthday') {
              tcontroller.selectedTag.value = 'Birthday Gift';
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(() => CollectionStock());
            });
            },

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(gifts[i]['i'] as IconData, color: goldAccent, size: 24),
              const SizedBox(height: 5),
              Text(gifts[i]['n'].toString(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    ),
  );
}



Widget _buildTestimonials() {
  return SizedBox(height: 130, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: 3, itemBuilder: (context, i) => Container(width: 250, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: softGrey, borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.star, color: goldAccent, size: 14), Icon(Icons.star, color: goldAccent, size: 14), Icon(Icons.star, color: goldAccent, size: 14)]), const SizedBox(height: 10), Text("\"Beautiful craftsmanship!\"", style: GoogleFonts.poppins(fontSize: 11, fontStyle: FontStyle.italic)), const Spacer(), Text("- Priya Sharma", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold))]))));
}