
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/appcolors.dart'; // Ensure these colors exist
import '../controller/advanceDetailsController.dart';

class AdvanceDetailsScreen extends StatelessWidget {
  final controller = Get.put(AdvanceDetailsController());
  final RxBool isEditMode = false.obs;

  AdvanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.udhaarData.value == null) return const Center(child: Text("No Data Found"));

        // JSON key names ke mutabiq data access
        var main = controller.udhaarData.value!.main;
        var list = controller.udhaarData.value!.subtransactions ?? [];

        // Total Deposit Calculation
        double totalDeposit = list.fold(0.0, (sum, item) => sum + (double.tryParse(item.utinTotalAmt.toString()) ?? 0.0));

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeaderCard(main),
                  _buildTableSection(list),
                ],
              ),
            ),
            _buildBottomSummary(totalDeposit , context , main),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      surfaceTintColor: Colors.white,
      title: Text('Advance Details',
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back()),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 22),
          onPressed: () => print("Download Report"),
        ),
      ],
    );
  }

  Widget _buildHeaderCard(dynamic main) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile("Invoice No", main.utinFullInvNo ?? "-", Icons.tag),
                _infoTile("Bill Date", DateFormat('dd MMM yyyy').format(DateTime.parse(main.utinDate!)), Icons.calendar_month),
              ],
            ),
            const Divider(height: 24, thickness: 0.6),
            Row(
              children: [
                _statBox("Advance Amount", "₹${main.utinTotalAmt}", const Color(0xFF5A67D8)),
                const SizedBox(width: 10),
                _statBox(
                  "Remaining Amt",
                  "₹${main.utinOutstandingAmt ?? 0}",
                  primaryGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
            Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
            Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSection(List<dynamic> list) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverToBoxAdapter(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              // Header bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                color: const Color(0xFF6A5ACD).withOpacity(0.08),
                child: Row(
                  children: [
                    Text("ADVANCE RETURN HISTORY", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: tableHeaders)),
                    const Spacer(),
                    Obx(() => InkWell(
                      onTap: () => isEditMode.value = !isEditMode.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isEditMode.value ? Colors.red : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: isEditMode.value ? Colors.red : Colors.grey.shade300),
                        ),
                        child: Text(isEditMode.value ? "Cancel" : "Edit",
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600,
                                color: isEditMode.value ? Colors.white : tableHeaders)),
                      ),
                    )),
                  ],
                ),
              ),

              // DataTable with specific borders
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => DataTable(
                  headingRowHeight: 40,
                  dataRowHeight: 45,
                  columnSpacing: 22,
                  horizontalMargin: 12,
                  border: TableBorder(
                    verticalInside: BorderSide(color: Colors.grey.shade200, width: 1),
                    horizontalInside: BorderSide(color: Colors.grey.shade100, width: 1),
                  ),
                  columns: [
                    _col('Date'),
                    _col('Inv No'),
                    _col('Returned'),
                    _col('Remaining'),
                    _col('PDF'),
                    if (isEditMode.value) _col('Action'),
                  ],
                  rows: list.map((item) => DataRow(cells: [
                    DataCell(Text(DateFormat('dd MMM yyyy').format(DateTime.parse(item.utinDate!)), style: const TextStyle(fontSize: 11),),),
                    DataCell(Text(item.utinFullInvNo ?? '-', style: const TextStyle(fontSize: 11))),
                    DataCell(Text('₹${item.utinTotalAmt}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38A169)))),
                    DataCell(Text('₹${item.utinCashBalance ?? "0"}', style: const TextStyle(fontSize: 11, color: Colors.blueGrey))),
                    DataCell(const Icon(Icons.picture_as_pdf_outlined, size: 18, color: Colors.redAccent)),
                    if (isEditMode.value)
                      DataCell(IconButton(icon: const Icon(Icons.delete_sweep, color: Colors.red, size: 20), onPressed: () {})),
                  ])).toList(),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataColumn _col(String label) => DataColumn(label: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: tableHeaders)));

  Widget _buildBottomSummary(double total , BuildContext context, dynamic main) {
    final double cashBalance =
        double.tryParse(main.utinCashBalance?.toString() ?? '0') ?? 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Returned", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700)),
              Text("₹${total.toStringAsFixed(2)}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark)),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }




  Widget buildFinalPaymentModes(AdvanceDetailsController controller) {
    return Obx(() =>  Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          _paymentRowWrapper([
            _compactDropdown(
              controller,
              label: "Cash",
              value: controller.selectedCashInHandMap['acc_user_acc'],
              items: 'Cash in Hand',
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.transactionType1Controller.text = "${controller.userAccToIdMap[newValue]}";
                  controller.selectedCashInHandMap.assignAll({
                    'acc_user_acc': newValue,
                    'acc_id': controller.userAccToIdMap[newValue]!,
                  });
                }
              },
            ),
            _compactTextField(controller.narration1Controller, "Remarks", isNumber: false),
            _compactTextField(controller.cashAmt1Controller, "Amount", isNumber: true , onChanged: (value) {controller.calculationPaymentPanel(); },),
          ]),
          const SizedBox(height: 10),

          // --- BANK SECTION ---
          _paymentRowWrapper([
            _compactDropdown(
              controller,
              label: "Bank",
              value: controller.selectedBankAccountMap['acc_user_acc'],
              items: 'Bank Account',
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.transactionType2Controller.text = "${controller.userAccToIdMap[newValue]}";
                  controller.selectedBankAccountMap.assignAll({
                    'acc_user_acc': newValue,
                    'acc_id': controller.userAccToIdMap[newValue]!,
                  });
                }
              },
            ),
            _compactTextField(controller.narration2Controller, "Remarks", isNumber: false),
            _compactTextField(controller.cashAmt2Controller, "Amount", isNumber: true, onChanged: (value) {controller.calculationPaymentPanel(); },),
          ]),
          const SizedBox(height: 10),

          // --- CARD SECTION ---
          _paymentRowWrapper([
            _compactDropdown(
              controller,
              label: "Card",
              value: controller.selectedCardBankAccountMap['acc_user_acc'],
              items: 'Card Payment',
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.transactionType3Controller.text = "${controller.userAccToIdMap[newValue]}";
                  controller.selectedCardBankAccountMap.assignAll({
                    'acc_user_acc': newValue,
                    'acc_id': controller.userAccToIdMap[newValue]!,
                  });
                }
              },
            ),
            _compactTextField(controller.narration3Controller, "Remarks", isNumber: false),
            _compactTextField(controller.cashAmt3Controller, "Amount", isNumber: true, onChanged: (value) {controller.calculationPaymentPanel(); },),
          ]),
          const SizedBox(height: 10),

          // --- ONLINE SECTION ---
          _paymentRowWrapper([
            _compactDropdown(
              controller,
              label: "Online",
              value: controller.selectedOnlineBankAccountMap['acc_user_acc'],
              items: 'Online Payment',
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.transactionType4Controller.text = "${controller.userAccToIdMap[newValue]}";
                  controller.selectedOnlineBankAccountMap.assignAll({
                    'acc_user_acc': newValue,
                    'acc_id': controller.userAccToIdMap[newValue]!,
                  });
                }
              },
            ),
            _compactTextField(controller.narration4Controller, "Remarks", isNumber: false),
            _compactTextField(controller.cashAmt4Controller, "Amount", isNumber: true, onChanged: (value) {controller.calculationPaymentPanel(); },),
          ]),
        ],
      ),
    ));
  }


  Widget _compactDropdown(AdvanceDetailsController controller, {
    required String label,
    required String? value,
    required String items,
    required Function(String?) onChanged,
  }) {
    return SizedBox(
      height: 45,
      child: Obx(() => DropdownButtonFormField2<String>(
        isDense: true,
        decoration: compactInputDecoration(label),
        isExpanded: true,
        value: value,
        selectedItemBuilder: (context) {
          return controller.accountList
              .where((account) => account.accMainAcc == items)
              .map((account) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                account.accUserAcc,
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList();
        },
        items: controller.accountList
            .where((account) => account.accMainAcc == items)
            .map((account) => DropdownMenuItem<String>(
          value: account.accUserAcc,
          child: Text(
            account.accUserAcc,
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )).toList(),
        onChanged: onChanged,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.zero,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: primaryPurple, size: 20),
        ),
      )),
    );
  }

  Widget _compactTextField(
      TextEditingController ctrl,
      String hint, {
        bool isNumber = false,
        Function(String)? onChanged,
      }) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        textAlign: isNumber ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isNumber ? FontWeight.bold : FontWeight.normal,
            color: isNumber ? Colors.green.shade700 : Colors.black87
        ),
        onChanged: onChanged,
        decoration: compactInputDecoration(hint),
      ),
    );
  }

  Widget _buildCompactField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType? keyboardType,
        int maxLines = 1,
        void Function(String)? onChanged, // Optional onChanged parameter
      }) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 11.5, color: Colors.grey.shade700),
        prefixIcon: Icon(icon, size: 17, color: primaryColor),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryColor, width: 1.6)),
      ),
    );
  }

  Widget _buildCompactDateField(BuildContext context, TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: primaryColor)), child: child!),
        );
        if (picked != null) controller.text = DateFormat('dd MMM yy').format(picked);
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 11.5, color: Colors.grey.shade700),
        prefixIcon: Icon(Icons.calendar_today_rounded, size: 17, color: primaryColor),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryColor, width: 1.6)),
      ),
    );
  }

  Widget _paymentRowWrapper(List<Widget> children) {
    return Row(
      children: [
        Expanded(flex: 4, child: children[0]),
        const SizedBox(width: 6),
        Expanded(flex: 3, child: children[1]),
        const SizedBox(width: 6),
        Expanded(flex: 3, child: children[2]),
      ],
    );
  }

  InputDecoration compactInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600),
      floatingLabelStyle: GoogleFonts.poppins(fontSize: 12, color: primaryPurple, fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      filled: true,
      fillColor: bgColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: primaryPurple, width: 1.5),
      ),
    );
  }

}