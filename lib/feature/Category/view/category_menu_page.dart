import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../products/view/stock_catalogue_page.dart';
import '../controller/Category_tag_controller.dart';
import 'CollectionStock.dart';

class CategoryMenuPage extends StatelessWidget {
  CategoryMenuPage({super.key});

  final TagController controller = Get.put(TagController());

  static const Color goldColor = Color(0xFFC5A059);
  static const Color background = Color(0xFFF9F9F9);
  static const Color darkText = Color(0xFF1A1A1A);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("COLLECTIONS",
            style: GoogleFonts.cinzel(
                color: darkText,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
                fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: darkText, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: Row(
        children: [
          // --- COMPACT SIDEBAR ---
          Container(
            width: 90,
            decoration: BoxDecoration(
              color: background,
              border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)),
            ),
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.categorizedTags.keys.length,
              itemBuilder: (context, index) {
                String catName = controller.categorizedTags.keys.elementAt(index);
                return SidebarItem(
                  title: catName,
                  isSelected: controller.selectedCategory.value == catName,
                  onTap: () => controller.selectCategory(catName),
                );
              },
            )),
          ),

          // --- REFINED CONTENT ---
          Expanded(
            child: Obx(() => _buildMainContent(
                controller.selectedCategory.value,
                controller.categorizedTags[controller.selectedCategory.value] ?? []
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(String selected, List<String> tags) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 130,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?q=80&w=800'),
                    fit: BoxFit.cover
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [darkText.withOpacity(0.7), Colors.transparent],
                      begin: Alignment.bottomLeft
                  ),
                ),
                padding: const EdgeInsets.all(15),
                alignment: Alignment.bottomLeft,
                child: Text(selected.toUpperCase(),
                    style: GoogleFonts.cinzel(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1)),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.8
              ),
              delegate: SliverChildBuilderDelegate(
                // Yahan 'selected' pass kiya hai taaki pata chale kaunsi category ka tag hai
                    (context, index) => _buildCompactTagCard(tags[index], selected),
                childCount: tags.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildCompactTagCard(String tagName, String categoryName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: goldColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await Future.microtask(() {
              controller.selectedTag.value = tagName;
            });
              Get.to(() => CollectionStock(), arguments: {
                "category": categoryName,
                "tag": tagName,
               });
          },
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(tagName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: darkText)),
            ),
          ),
        ),
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarItem({super.key, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: isSelected
              ? const Border(right: BorderSide(color: CategoryMenuPage.goldColor, width: 3))
              : null,
        ),
        child: Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? CategoryMenuPage.goldColor : Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}