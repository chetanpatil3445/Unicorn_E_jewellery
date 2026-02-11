import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../Routes/app_routes.dart';
import '../controller/stock_catalogue_controller.dart';
import '../model/product_model.dart';

class ProductCataloguePage extends StatefulWidget {
  @override
  State<ProductCataloguePage> createState() => _ProductCataloguePageState();
}

class _ProductCataloguePageState extends State<ProductCataloguePage> {
  final ProductCatalogueController controller = Get.put(ProductCatalogueController());
  final inrFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  // Theme Colors from Dashboard
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color ivoryWhite = Color(0xFFFDFCFB);

  @override
  void initState() {
    super.initState();
    controller.fetchStockItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivoryWhite,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text("CATALOGUE",
            style: GoogleFonts.cinzel(color: deepBlack, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: deepBlack, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => IconButton(
            icon: Icon(controller.isGridView.value ? Icons.format_list_bulleted_rounded : Icons.grid_view_rounded, color: deepBlack),
            onPressed: controller.toggleView,
          )),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(), // Premium Search Bar
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.stockItems.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: goldAccent));
              }

              if (controller.stockItems.isEmpty) {
                return _buildEmptyState();
              }
            
              return Column(
                children: [
                  _buildResultCountRow(),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200 && controller.hasMore.value) {
                          controller.fetchStockItems(isLoadMore: true);
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        color: goldAccent,
                        onRefresh: () => controller.fetchStockItems(),
                        child: controller.isGridView.value
                            ? _buildPremiumGrid(controller.stockItems)
                            : _buildPremiumList(controller.stockItems),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: (val) => controller.onSearchChanged(val),
                decoration: InputDecoration(
                  hintText: "Search Necklace, Rings...",
                  hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: deepBlack, size: 20),
                  suffixIcon: Obx(() => controller.searchText.value.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.grey, size: 18),
                    onPressed: () => controller.clearFilters(),
                  )
                      : const SizedBox()),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _showFilterSheet(context),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: deepBlack,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCountRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${controller.stockItems.length} DESIGNS FOUND",
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 1)),
          Text("SORT BY: RELEVANCE",
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: deepBlack, letterSpacing: 0.5)),
        ],
      ),
    );
  }



  Widget _buildPremiumGrid(List<Product> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.62, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: controller.hasMore.value ? items.length + 2 : items.length,
      itemBuilder: (context, index) {
        if (index < items.length) {
          final item = items[index];
          return GestureDetector(
            // Navigation logic here
            onTap: () => Get.toNamed(AppRoutes.stockDetail, arguments: item.productDetails.id),
            child: _buildLuxuryCard(item),
          );
        }
        return index == items.length
            ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: goldAccent, strokeWidth: 2)))
            : const SizedBox();
      },
    );
  }

  Widget _buildPremiumList(List<Product> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.hasMore.value ? items.length + 1 : items.length,
      itemBuilder: (context, index) {
        if (index < items.length) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.stockDetail, arguments: item.productDetails.id),
              child: SizedBox(height: 150, child: _buildLuxuryCard(item, isList: true)),
            ),
          );
        }
        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: goldAccent, strokeWidth: 2)));
      },
    );
  }



  Widget _buildLuxuryCard(Product item, {bool isList = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: isList
          ? Row(children: [_premiumImage(item, 140), Expanded(child: _premiumDetails(item))])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _premiumImage(item, double.infinity)), _premiumDetails(item)]),
    );
  }


  // Widget _premiumImage(Product item, double width) {
  //   String? imageUrl = item.imageUrls.isNotEmpty ? item.imageUrls[0].imageUrl : null;
  //   return Stack(
  //     children: [
  //       Container(
  //         width: width,
  //         height: double.infinity,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(15),
  //           color: const Color(0xFFF9F9F9),
  //         ),
  //         clipBehavior: Clip.antiAlias,
  //         child: imageUrl != null && imageUrl.isNotEmpty
  //             ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder())
  //             : _buildPlaceholder(),
  //       ),
  //
  //       Positioned(
  //         top: 8, right: 8,
  //         child: GestureDetector(
  //           onTap: () => controller.toggleWishlist(item), // Function call
  //           child: Container(
  //             padding: const EdgeInsets.all(6),
  //             decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.9),
  //                 shape: BoxShape.circle,
  //                 boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
  //             ),
  //             child: Icon(
  //               // Status check karke icon aur color badlein
  //               item.isWishlisted ? Icons.favorite : Icons.favorite_border,
  //               size: 18,
  //               color: item.isWishlisted ? Colors.red : deepBlack,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _premiumImage(Product item, double width) {
    String? imageUrl = item.imageUrls.isNotEmpty ? item.imageUrls[0].imageUrl : null;
    // Status check
    bool isSoldOut = item.productDetails.status == "SOLD_OUT";

    return Stack(
      children: [
        Container(
          width: width,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFF9F9F9),
          ),
          clipBehavior: Clip.antiAlias,
          child: ColorFiltered(
            // Agar sold out hai to image ko thoda grayscale/fade kar dega
            colorFilter: isSoldOut
                ? ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstATop)
                : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildPlaceholder())
                : _buildPlaceholder(),
          ),
        ),

        // --- SOLD OUT RIBBON/BADGE ---
        if (isSoldOut)
          Positioned(
            top: 15,
            left: -20,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees diagonal look ke liye
              child: Container(
                width: 120,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                child: Center(
                  child: Text(
                    "SOLD OUT",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Wishlist Icon (Already existing)
        Positioned(
          top: 8, right: 8,
          child: GestureDetector(
            onTap: () => controller.toggleWishlist(item),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
              ),
              child: Icon(
                item.isWishlisted ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: item.isWishlisted ? Colors.red : deepBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.grey.shade100, Colors.grey.shade50], begin: Alignment.topLeft),
      ),
      child: Center(child: Icon(Icons.diamond_outlined, color: goldAccent.withOpacity(0.3), size: 40)),
    );
  }

  Widget _premiumDetails(Product item) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.productDetails.productName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "#${item.productDetails.productCode}" ?? "",
                style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: goldAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text("${item.weights.grossWeight}g",
                    style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: goldAccent)),
              ),
              const SizedBox(width: 6),
              Text(item.productDetails.category, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(inrFormatter.format(item.calculatedPrice.totalValuation),
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: deepBlack, fontSize: 15)),
              // --- BAG BUTTON (DISABLED IF SOLD OUT) ---
              Obx(() {
                final currentItem = controller.stockItems.firstWhere(
                        (p) => p.productDetails.id == item.productDetails.id,
                    orElse: () => item
                );
                bool inBag = currentItem.isInCart;
                bool isSoldOut = item.productDetails.status == "SOLD_OUT";

                return GestureDetector(
                  // Agar Sold Out hai to tap disable kar do (null bhej kar)
                  onTap: isSoldOut ? null : () => controller.addToCart(currentItem),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // Sold out hone par light grey color, varna normal logic
                      color: isSoldOut
                          ? Colors.grey.shade200
                          : (inBag ? goldAccent : Colors.white),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSoldOut
                              ? Colors.grey.shade300
                              : (inBag ? goldAccent : Colors.grey.shade200)
                      ),
                      boxShadow: (inBag && !isSoldOut)
                          ? [BoxShadow(color: goldAccent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Icon(
                      isSoldOut ? Icons.shopping_bag : (inBag ? Icons.shopping_bag : Icons.shopping_bag_outlined),
                      size: 16,
                      // Icon color bhi grey kar di hai sold out ke liye
                      color: isSoldOut
                          ? Colors.grey.shade500
                          : (inBag ? Colors.white : deepBlack),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    controller.initFilterControllers();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Text("FILTER BY", style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 25),
              _premiumFilterField(controller.categoryController, "Category", Icons.category_outlined),
              const SizedBox(height: 16),
              // _premiumFilterField(controller.metalController, "Metal Type", Icons.diamond_outlined),
              _premiumMetalDropdown(controller),
              const SizedBox(height: 16),
              Text("PRICE RANGE", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _premiumFilterField(controller.minPriceController, "Min ₹", null, type: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _premiumFilterField(controller.maxPriceController, "Max ₹", null, type: TextInputType.number)),
              ]),
              const SizedBox(height: 35),
              Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () { controller.clearFilters(); Get.back(); },
                        child: Text("CLEAR ALL", style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13))
                    )
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepBlack,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () { controller.applyFilters(); Get.back(); },
                      child: Text("APPLY FILTERS", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))
                  ),
                ),
              ]),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _premiumMetalDropdown(ProductCatalogueController controller) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(canvasColor: Colors.white),
      child: Obx(() {
        // GetX ko batane ke liye ki 'metalFilter' ko listen karna hai
        String currentSelected = controller.metalFilter.value;

        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Metal Type",
            labelStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            prefixIcon: const Icon(Icons.diamond_outlined, size: 20, color: Color(0xFFC5A059)),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              // .obs variable ki value use karein, controller.text ki nahi
              value: currentSelected.isEmpty ? null : currentSelected,
              hint: Text("Select Metal", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
              isExpanded: true,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFC5A059), size: 20),
              style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1A1A1A), fontWeight: FontWeight.w500),
              items: controller.metalOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  // Dono ko update karein: Filter (for API) aur Controller (for UI sync)
                  controller.metalFilter.value = newValue;
                  controller.metalController.text = newValue;
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _premiumFilterField(TextEditingController ctrl, String label, IconData? icon, {TextInputType? type}) {
    return TextField(
      controller: ctrl, keyboardType: type,
      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
        prefixIcon: icon != null ? Icon(icon, size: 20, color: goldAccent) : null,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: goldAccent, width: 1)),
      ),
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Luxury Icon with Gradient/Shadow
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: goldAccent.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.diamond_outlined, // Ya fir Icons.search_off_rounded
                size: 80,
                color: goldAccent.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            // Main Title in Luxury Font
            Text(
              "NO DESIGNS FOUND",
              style: GoogleFonts.cinzel(
                color: deepBlack,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "We couldn't find any jewelry matching your current filters. Try adjusting your search or filters.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Clear Filters Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: deepBlack,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () {
                controller.clearFilters();
               },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                "RESET ALL FILTERS",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}