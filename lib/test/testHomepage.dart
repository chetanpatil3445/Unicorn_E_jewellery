// import 'package:flutter/material.dart';
// import 'package:get/Get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../core/constants/appcolors.dart';
// import '../controller/DashboardController.dart';
// import '../model/HomeSection.dart';
// import '../widgets/appbar.dart';
// import '../widgets/custom_drawer.dart';
// import '../widgets/rates.dart';
// import '../widgets/stories.dart';
//
// class Dashboard extends StatefulWidget {
//   Dashboard({super.key});
//
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//
//   final DashboardController controller = Get.put(DashboardController());
//
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: ()async { controller.refreshData();},
//       child: Scaffold(
//         key: scaffoldKey,
//         drawer: const CustomDrawer(),
//         backgroundColor: ivoryWhite,
//
//         body: Obx(() {
//           if (controller.homeSections.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               buildAppBar(context, scaffoldKey),
//               ...controller.homeSections.map((section) => _buildDynamicSection(section)).toList(),
//               const SliverToBoxAdapter(child: SizedBox(height: 50)),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//   Widget _buildDynamicSection(HomeSection section) {
//     if (!section.isVisible) {
//       return const SliverToBoxAdapter(child: SizedBox.shrink());
//     }
//     switch (section.sectionName) {
//
//       case 'live_rates':
//         return _box(buildLiveRates());
//
//       case 'stories':
//         return _box(buildStories());
//
//       case 'trending_products':
//         return _buildSliverGridWithTitle(section.displayName, true);
//
//       case 'recommended_products':
//         return _buildSliverGridWithTitle(section.displayName, false);
//
//       default:
//         return _box(
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (section.displayName.isNotEmpty)
//                 _buildSectionTitle(section.displayName),
//               // _getContentForSection(section.sectionName),
//               // Dashboard.dart me update karein
//               _getContentForSection(section), // Pura section pass karein
//             ],
//           ),
//         );
//     }
//   }
//
//   Widget _box(Widget child) {
//     return SliverToBoxAdapter(child: child);
//   }
//
//   Widget _getContentForSection(HomeSection section) {
//     switch (section.sectionName) {
//       case 'hero_slider': return _buildHeroBanner();
//       case 'categories': return _buildCategorySection();
//       case 'tag_filters': return _buildTagFilterRow();
//       case 'featured_collections': return _buildFeaturedCollections();
//       case 'gift_for_loved_ones': return _buildGiftSection();
//       case 'modern_couple_sets': return _buildCoupleCollections();
//       case 'festive_banner': return _buildFestiveBanner();
//       case 'shop_by_gender': return _buildGenderSection();
//       case 'offer_strip': return _buildOfferBanner();
//       case 'testimonials': return _buildTestimonials();
//       default: return const SizedBox.shrink();
//     }
//   }
//
//   Widget _buildSliverGridWithTitle(String title, bool isTrending) {
//     return SliverMainAxisGroup(
//       slivers: [
//         SliverToBoxAdapter(child: _buildSectionTitle(title)),
//         isTrending
//             ? _buildProductGrid(hasBadges: true)
//             : _buildRecommendedGrid(),
//       ],
//     );
//   }
//
//
//
//   // ===================== 2. UPGRADED PREMIUM CATEGORY SECTION =====================
//   Widget _buildCategorySection() {
//     final cats = [
//       {'name': 'Rings', 'img': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?q=80&w=300'},
//       {'name': 'Necklace', 'img': 'https://plus.unsplash.com/premium_photo-1674255466849-b23fc5f5d3eb?q=80&w=1287&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
//       {'name': 'Earrings', 'img': 'https://plus.unsplash.com/premium_photo-1675107359685-f268487a3a46?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'},
//       {'name': 'Bangles', 'img': 'https://images.unsplash.com/photo-1619119069152-a2b331eb392a?q=80&w=300'},
//     ];
//
//     return Container(
//       height: 130,
//       margin: const EdgeInsets.only(top: 10),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: cats.length,
//         itemBuilder: (context, i) => Container(
//           width: 95,
//           margin: const EdgeInsets.only(right: 12),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: goldAccent.withOpacity(0.15),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       )
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: Image.network(
//                       cats[i]['img']!,
//                       fit: BoxFit.cover,
//                       width: 90,
//                       height: 90,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 cats[i]['name']!.toUpperCase(),
//                 style: GoogleFonts.cinzel(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: deepBlack,
//                     letterSpacing: 1
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
//   Widget _buildHeroBanner() {
//     return Container(
//       width: double.infinity, // force full width
//       height: 200,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         image: const DecorationImage(
//             image: NetworkImage('https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?q=80&w=2070'),
//             fit: BoxFit.cover),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: LinearGradient(colors: [Colors.black.withOpacity(0.7), Colors.transparent], begin: Alignment.bottomLeft),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("THE ROYAL HERITAGE", style: GoogleFonts.cinzel(color: goldAccent, fontSize: 20, fontWeight: FontWeight.bold)),
//             Text("Handcrafted with love since 1990", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTagFilterRow() {
//     final quickTags = ["Trending", "New Arrival", "Best Seller", "Hot Deal", "Hallmarked Gold", "Pure Silver"];
//     return Container(
//       height: 40,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: quickTags.length,
//         itemBuilder: (context, i) => Container(
//           margin: const EdgeInsets.only(right: 8),
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: goldAccent.withOpacity(0.3)),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             quickTags[i],
//             style: GoogleFonts.poppins(fontSize: 11, color: deepBlack, fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBadge(String text, {Color color = deepBlack}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.9),
//         borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
//       ),
//       child: Text(
//         text.toUpperCase(),
//         style: GoogleFonts.poppins(color: goldAccent, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
//       ),
//     );
//   }
//
//   Widget _buildFeaturedCollections() {
//     final list = [
//       {'t': 'Diamond Forever', 'img': 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?q=80&w=400', 'tag': 'Premium'},
//       {'t': 'Antique Gold', 'img': 'https://images.unsplash.com/photo-1611085583191-a3b136335918?q=80&w=400', 'tag': 'Traditional'},
//     ];
//     return SizedBox(
//       height: 180,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: 2,
//         itemBuilder: (context, i) => Container(
//           width: 300,
//           margin: const EdgeInsets.only(right: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             image: DecorationImage(image: NetworkImage(list[i]['img']!), fit: BoxFit.cover),
//           ),
//           child: Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   gradient: const LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter),
//                 ),
//                 padding: const EdgeInsets.all(15),
//                 alignment: Alignment.bottomLeft,
//                 child: Text(list[i]['t']!, style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//               ),
//               Positioned(top: 0, left: 0, child: _buildBadge(list[i]['tag']!)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGiftSection() {
//     final gifts = [
//       {'n': 'For Her', 'i': Icons.card_giftcard},
//       {'n': 'For Him', 'i': Icons.redeem},
//       {'n': 'Anniversary', 'i': Icons.favorite_border},
//       {'n': 'Birthday', 'i': Icons.cake_outlined},
//     ];
//     return Container(
//       height: 90,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 4,
//         itemBuilder: (context, i) => Container(
//           width: 100,
//           margin: const EdgeInsets.symmetric(horizontal: 5),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: goldAccent.withOpacity(0.2)),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(gifts[i]['i'] as IconData, color: goldAccent, size: 24),
//               const SizedBox(height: 5),
//               Text(gifts[i]['n'].toString(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCoupleCollections() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       height: 150,
//       decoration: BoxDecoration(
//         color: const Color(0xFFFBE9E7),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("COUPLE RINGS", style: GoogleFonts.cinzel(fontWeight: FontWeight.bold, fontSize: 18)),
//                   const SizedBox(height: 5),
//                   Text("Matches made in heaven.", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700])),
//                   const SizedBox(height: 10),
//                   Text("SHOP NOW →", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: goldAccent)),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
//               child: Image.network('https://images.unsplash.com/photo-1630801059808-1a29d15a2f18?q=80&w=2668', fit: BoxFit.cover, height: double.infinity),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFestiveBanner() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       height: 100,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(colors: [Color(0xFF800000), Color(0xFFD4AF37)]),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       alignment: Alignment.center,
//       child: ListTile(
//         leading: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
//         title: Text("DIWALI SPECIAL", style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//         subtitle: Text("Exclusive Collection for the Festival of Lights", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10)),
//         trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//       ),
//     );
//   }
//
//   Widget _buildRecommendedGrid() {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       sliver: SliverGrid(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.8),
//         delegate: SliverChildBuilderDelegate((context, i) => _productCardSmall(i), childCount: 4),
//       ),
//     );
//   }
//
//   Widget _productCardSmall(int i) {
//     final labels = ["Staff Pick", "Limited", "Top Rated", "New"];
//     return Container(
//       decoration: BoxDecoration(color: softGrey, borderRadius: BorderRadius.circular(12)),
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network('https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?q=80&w=400', fit: BoxFit.cover, width: double.infinity))),
//                 const SizedBox(height: 5),
//                 Text("Rose Gold Earring", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
//                 Text("₹12,400", style: GoogleFonts.poppins(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 12)),
//               ],
//             ),
//           ),
//           _buildBadge(labels[i]),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductGrid({bool hasBadges = false}) {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       sliver: SliverGrid(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15, childAspectRatio: 0.75),
//           delegate: SliverChildBuilderDelegate((context, i) => _productCard(i, hasBadges), childCount: 2)
//       ),
//     );
//   }
//
//   Widget _productCard(int i, bool hasBadges) {
//     final tags = ["Best Seller", "Hot Deal"];
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
//       child: Stack(
//         children: [
//           Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: Image.network('https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?q=80&w=2070', fit: BoxFit.cover, width: double.infinity))),
//                 Padding(padding: const EdgeInsets.all(8.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text("Solitaire Diamond", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
//                   Text("₹1,25,000", style: GoogleFonts.poppins(color: goldAccent, fontWeight: FontWeight.bold, fontSize: 14))
//                 ]))
//               ]
//           ),
//           if (hasBadges) Positioned(top: 0, left: 0, child: _buildBadge(tags[i], color: i == 1 ? accentRed : deepBlack)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGenderSection() {
//     return Row(children: [_genderTile("WOMEN", 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=200'), _genderTile("MEN", 'https://images.unsplash.com/photo-1617137968427-85924c800a22?q=80&w=200')]);
//   }
//
//   Widget _genderTile(String label, String url) {
//     return Expanded(child: Container(height: 120, margin: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken))), alignment: Alignment.center, child: Text(label, style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2))));
//   }
//
//   Widget _buildTestimonials() {
//     return SizedBox(height: 130, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: 3, itemBuilder: (context, i) => Container(width: 250, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: softGrey, borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Icons.star, color: goldAccent, size: 14), Icon(Icons.star, color: goldAccent, size: 14), Icon(Icons.star, color: goldAccent, size: 14)]), const SizedBox(height: 10), Text("\"Beautiful craftsmanship!\"", style: GoogleFonts.poppins(fontSize: 11, fontStyle: FontStyle.italic)), const Spacer(), Text("- Priya Sharma", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold))]))));
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.bold, color: deepBlack)),
//           Text("See All", style: GoogleFonts.poppins(fontSize: 10, color: goldAccent, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOfferBanner() {
//     return Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: deepBlack, borderRadius: BorderRadius.circular(20)), child: Column(children: [Text("SPECIAL SUNDAY", style: GoogleFonts.cinzel(color: goldAccent, fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text("0% Making Charges", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)), const SizedBox(height: 15), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: goldAccent, foregroundColor: Colors.black), child: const Text("CLAIM NOW"))]));
//   }
// }
//
//
//
//



