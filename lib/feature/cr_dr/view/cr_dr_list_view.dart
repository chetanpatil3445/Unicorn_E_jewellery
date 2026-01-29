import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/cr_dr_controller.dart';
import '../model/cr_dr_model.dart';

class CrDrListView extends StatefulWidget {
  final bool showAddButton;
  const CrDrListView({super.key, this.showAddButton = true});

  @override
  State<CrDrListView> createState() => _CrDrListViewState();
}

class _CrDrListViewState extends State<CrDrListView> with SingleTickerProviderStateMixin {
  final CrDrController controller = Get.find();
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();


  bool isCrTab = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _scrollController.addListener(_onScroll);
    _handleTabChange();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {
          isCrTab = _tabController.index == 1; // 0 = Udhaar, 1 = Advance
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      controller.fetchData(isCr: _tabController.index == 1, isRefresh: false);
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      bool isCr = _tabController.index == 1;
      if (isCr) {
        if (!controller.isCrFetched.value) controller.fetchCrData();
      } else {
        if (!controller.isDrFetched.value) controller.fetchDrData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AllTextColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'CR/DR Reports',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: AllTextColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: primaryDark, size: 24),
            onPressed: () => _showFilterBottomSheet(context, controller),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: lightBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: primaryIndigo.withOpacity(0.7),
              labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
              indicator: BoxDecoration(
                color: primaryDark,
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [Tab(text: 'Udhaar'), Tab(text: 'Advance')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFilteredList(controller, isCr: false),
          _buildFilteredList(controller, isCr: true),
        ],
      ),
      floatingActionButton: widget.showAddButton
          ? FloatingActionButton(
        mini: true,
        backgroundColor: primaryDark,
        onPressed: () => _navigateToAdd(isCrTab),
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,

    );
  }

  void _navigateToAdd(bool isCrTab) {
    if (isCrTab) {
      // Advance tab
      Get.toNamed(AppRoutes.addCrForm);
    } else {
      // Udhaar tab
      Get.toNamed(AppRoutes.addDrForm);
    }
  }

  Widget _buildFilteredList(CrDrController controller, {required bool isCr}) {
    return Obx(() {
      final isFetched = isCr ? controller.isCrFetched.value : controller.isDrFetched.value;
      final list = controller.getFilteredList(isCr);

      if (!isFetched) return _buildShimmerList();

      return RefreshIndicator(
        onRefresh: () => controller.fetchData(isCr: isCr, isRefresh: true),
        color: primaryDark,
        child: list.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            Center(
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined, size: 50, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text("No entries found", style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 14)),
                ],
              ),
            ),
          ],
        )
            : ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: list.length + 1,
          itemBuilder: (context, index) {
            if (index == list.length) {
              return Obx(() => controller.isLoadMore.value
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: primaryDark)),
              )
                  : const SizedBox(height: 80));
            }

            final item = list[index];
            final isAdvance = item.isCr;
            final isSettled = isAdvance ? item.isSettled : item.isPaid;
            final paidOrSettledAmt = item.amount - item.balanceAmt;

            return InkWell(
              onTap: (){
                if (isAdvance){
                  Get.toNamed(AppRoutes.advanceDetailsScreen, arguments: item.id);
                } else {
                  Get.toNamed(AppRoutes.udhaarDetailsScreen, arguments: item.id);
                }
              },
              child: Card(
                color: isAdvance ? primaryGreen.withOpacity(0.05): gradientPinkFaint.withOpacity(0.07),
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: borderColor, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(item.partyName,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.bold, color: AllTextColor)),
                          ),
                          _buildCompactBadge(item),

                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("${item.date} • Inv: ${item.invoiceNumber}",
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600)),
                      _gradientDivider2(),

                      if (item.isMetalDue) ...[
                        // 🔶 METAL DUE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCompactAmount(
                              "Total Amount",
                              "₹${item.amount.toStringAsFixed(0)}",
                              AllTextColor,
                              isBold: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCompactAmount("Gold Due", "${item.goldDueWt} wt", Colors.amber.shade800),
                            _buildCompactAmount("Silver Due", "${item.silverDueWt} wt", Colors.grey.shade700),
                            _buildCompactAmount("Stone Due", "${item.stoneDueWt} wt", Colors.blueGrey),
                          ],
                        ),

                      ] else if (item.isMetalAdvance) ...[
                        // 🔷 METAL ADVANCE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCompactAmount(
                              "Total Amount",
                              "₹${item.amount.toStringAsFixed(0)}",
                              AllTextColor,
                              isBold: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCompactAmount("Gold Adv", "${item.goldAdvanceWt} wt", Colors.amber.shade800),
                            _buildCompactAmount("Silver Adv", "${item.silverAdvanceWt} wt", Colors.grey.shade700),
                            _buildCompactAmount("Stone Adv", "${item.stoneAdvanceWt} wt", Colors.blueGrey),
                          ],
                        ),

                      ] else ...[
                        // 🔥 OLD UI — untouched
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCompactAmount("Total", "₹${item.amount.toStringAsFixed(0)}", AllTextColor),
                            _buildCompactAmount(
                              isSettled ? "Settled" : "Paid",
                              "₹$paidOrSettledAmt",
                              Colors.green,
                            ),
                            _buildCompactAmount(
                              "Balance",
                              "₹${item.balanceAmt.toStringAsFixed(0)}",
                              isAdvance ? primaryGreen : Colors.red.shade400,
                              isBold: true,
                            ),
                          ],
                        ),
                      ]


                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }


  // Widget _buildCompactBadge(CrDrEntry item) {
  //   if (item.isMetalAdvance) {
  //     return _badge("METAL ADVANCE", Colors.blue);
  //   }
  //   if (item.isMetalDue) {
  //     return _badge("METAL DUE", Colors.orange);
  //   }
  //
  //   // existing logic
  //   Color baseColor = item.isCr
  //       ? (item.isSettled ? Colors.green : Colors.blue)
  //       : (item.isPaid ? Colors.green : Colors.orange);
  //
  //   return _badge(
  //     item.isCr
  //         ? (item.isSettled ? "SETTLED" : "ADVANCE")
  //         : (item.isPaid ? "PAID" : "UDHAAR"),
  //     baseColor,
  //   );
  // }

  Widget _buildCompactBadge(CrDrEntry item) {
    // Sabse pehle Status check karein (Metal ho ya Udhaar, agar settled hai toh Green dikhao)
    final bool settled = item.isCr ? item.isSettled : item.isPaid;

    if (settled) {
      return _badge("SETTLED", Colors.green);
    }

    // Agar settled nahi hai, tab specific badges dikhao
    if (item.isMetalAdvance) {
      return _badge("METAL ADVANCE", Colors.blue);
    }
    if (item.isMetalDue) {
      return _badge("METAL DUE", Colors.orange);
    }

    // Default unpaid badges
    return _badge(
      item.isCr ? "ADVANCE" : "UDHAAR",
      item.isCr ? Colors.blue : Colors.orange,
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }


  Widget _buildCompactAmount(String title, String value, Color color, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color)),
      ],
    );
  }

  // --- Shimmer and other helpers with new design ---
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 110,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, CrDrController controller) {
    final isAdvanceTab = _tabController.index == 1;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 16),
            Text(isAdvanceTab ? "Advance Filters" : "Udhaar Filters", style: HeadingStyle.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            if (!isAdvanceTab) ...[
              _filterOption("Udhaar - Unpaid", 'unpaid', Icons.arrow_upward, Colors.red, controller, isCr: false),
              _filterOption("Paid Udhaar", 'paid', Icons.check_circle, Colors.green, controller, isCr: false),
            ] else ...[
              _filterOption("Advance - Unpaid", 'unpaid', Icons.arrow_downward, Colors.blue, controller, isCr: true),
              _filterOption("Settled Advance", 'paid', Icons.check_circle, Colors.green, controller, isCr: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _filterOption(String title, String filterValue, IconData icon, Color color, CrDrController controller, {required bool isCr}) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Obx(() {
        final currentFilter = isCr ? controller.crFilter.value : controller.drFilter.value;
        return currentFilter == filterValue ? const Icon(Icons.check, color: primaryDark, size: 20) : const SizedBox();
      }),
      onTap: () {
        if (isCr) controller.crFilter.value = filterValue;
        else controller.drFilter.value = filterValue;
        Get.back();
      },
    );
  }


  Widget _gradientDivider2() {
    return Container(
      height: 1.5, // Divider ki thickness
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryPink.withOpacity(0.1), // Shuruat faint teal se
            primaryPink,                  // Beech mein dark teal
            primaryTeal,             // Phir light blue
            primaryTeal.withOpacity(0.1), // Khatam faint blue par
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

}