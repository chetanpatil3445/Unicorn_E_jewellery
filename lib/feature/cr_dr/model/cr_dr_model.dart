  //
  //
  // class CrDrEntry {
  //   final int id;
  //   final String partyName;
  //   final double amount;
  //   final double balanceAmt;
  //   final String date;
  //   final String mode;        // primary payment mode: Cash/Bank/Card/Online
  //   final String invoiceNumber;
  //   final bool isCr;          // true for CR (Advance), false for DR (Udhaar)
  //   final bool isPaid;        // true if paid (DR), false if unpaid
  //   final bool isSettled;     // true if settled (CR), false if unsettled
  //
  //   final bool isMetalAdvance;
  //   final bool isMetalDue;
  //
  //   final double goldDueWt;
  //   final double silverDueWt;
  //   final double stoneDueWt;
  //
  //   final double goldAdvanceWt;
  //   final double silverAdvanceWt;
  //   final double stoneAdvanceWt;
  //
  //
  //   // Payment breakdown
  //   final double cashAmt;
  //   final double bankAmt;
  //   final double cardAmt;
  //   final double onlineAmt;
  //
  //   CrDrEntry({
  //     required this.id,
  //     required this.partyName,
  //     required this.amount,
  //     required this.balanceAmt,
  //     required this.date,
  //     required this.mode,
  //     required this.invoiceNumber,
  //     required this.isCr,
  //     this.isPaid = false,
  //     this.isSettled = false,
  //
  //     this.isMetalAdvance = false,
  //     this.isMetalDue = false,
  //     this.goldDueWt = 0,
  //     this.silverDueWt = 0,
  //     this.stoneDueWt = 0,
  //
  //     // ✅ new advance fields
  //     this.goldAdvanceWt = 0,
  //     this.silverAdvanceWt = 0,
  //     this.stoneAdvanceWt = 0,
  //
  //     this.cashAmt = 0,
  //     this.bankAmt = 0,
  //     this.cardAmt = 0,
  //     this.onlineAmt = 0,
  //   });
  //
  //   // Factory to create CrDrEntry from API response
  //   factory CrDrEntry.fromApi(Map<String, dynamic> e) {
  //     // Determine primary payment mode
  //     String primaryMode = 'Unknown';
  //     if ((e['utin_cash_amt_rec'] ?? '0') != '0') primaryMode = 'Cash';
  //     else if ((e['utin_bank_amt_rec'] ?? '0') != '0') primaryMode = 'Bank';
  //     else if ((e['utin_card_amt_rec'] ?? '0') != '0') primaryMode = 'Card';
  //     else if ((e['utin_online_amt_rec'] ?? '0') != '0') primaryMode = 'Online';
  //     final utinType = e['utin_type'];
  //
  //     return CrDrEntry(
  //       id: e['utin_id'] ?? 0,
  //       partyName: e['utin_user_name'] ?? '',
  //       amount: double.tryParse(e['utin_total_amt'] ?? '0') ?? 0,
  //       balanceAmt: double.tryParse(e['utin_cash_balance'] ?? '0') ?? 0,
  //       date: e['utin_date'] != null ? e['utin_date'].substring(0, 10) : '',
  //       mode: primaryMode,
  //       invoiceNumber: e['utin_full_inv_no'].toString(),
  //
  //
  //       // OLD logic (same)
  //       isCr: utinType == 'ADVANCE' || utinType == 'METAL_ADVANCE',
  //       isPaid: utinType == 'UDHAAR' ? e['utin_status'] == 'SETTLED' : false,
  //       isSettled: utinType == 'ADVANCE' ? e['utin_status'] == 'SETTLED' : false,
  //
  //       // ✅ NEW
  //       isMetalAdvance: utinType == 'METAL_ADVANCE',
  //       isMetalDue: utinType == 'METAL_DUE',
  //
  //       goldDueWt: double.tryParse(e['utin_gold_due_wt'] ?? '0') ?? 0,
  //       silverDueWt: double.tryParse(e['utin_silver_due_wt'] ?? '0') ?? 0,
  //       stoneDueWt: double.tryParse(e['utin_stone_due_wt'] ?? '0') ?? 0,
  //
  //       goldAdvanceWt: double.tryParse(e['utin_gold_due_wt'] ?? '0') ?? 0,
  //       silverAdvanceWt: double.tryParse(e['utin_silver_due_wt'] ?? '0') ?? 0,
  //       stoneAdvanceWt: double.tryParse(e['utin_stone_due_wt'] ?? '0') ?? 0,
  //
  //
  //
  //       cashAmt: double.tryParse(e['utin_cash_amt_rec'] ?? '0') ?? 0,
  //       bankAmt: double.tryParse(e['utin_bank_amt_rec'] ?? '0') ?? 0,
  //       cardAmt: double.tryParse(e['utin_card_amt_rec'] ?? '0') ?? 0,
  //       onlineAmt: double.tryParse(e['utin_online_amt_rec'] ?? '0') ?? 0,
  //     );
  //   }
  // }


  class CrDrEntry {
    final int id;
    final String partyName;
    final double amount;
    final double balanceAmt;
    final String date;
    final String mode;        // primary payment mode: Cash/Bank/Card/Online
    final String invoiceNumber;
    final bool isCr;          // true for CR (Advance/Metal Adv), false for DR (Udhaar/Metal Due)
    final bool isPaid;        // true if paid/settled (For Udhaar & Metal Due)
    final bool isSettled;     // true if settled (For Advance & Metal Advance)

    final bool isMetalAdvance;
    final bool isMetalDue;

    final double goldDueWt;
    final double silverDueWt;
    final double stoneDueWt;

    final double goldAdvanceWt;
    final double silverAdvanceWt;
    final double stoneAdvanceWt;

    // Payment breakdown
    final double cashAmt;
    final double bankAmt;
    final double cardAmt;
    final double onlineAmt;

    CrDrEntry({
      required this.id,
      required this.partyName,
      required this.amount,
      required this.balanceAmt,
      required this.date,
      required this.mode,
      required this.invoiceNumber,
      required this.isCr,
      this.isPaid = false,
      this.isSettled = false,
      this.isMetalAdvance = false,
      this.isMetalDue = false,
      this.goldDueWt = 0,
      this.silverDueWt = 0,
      this.stoneDueWt = 0,
      this.goldAdvanceWt = 0,
      this.silverAdvanceWt = 0,
      this.stoneAdvanceWt = 0,
      this.cashAmt = 0,
      this.bankAmt = 0,
      this.cardAmt = 0,
      this.onlineAmt = 0,
    });

    factory CrDrEntry.fromApi(Map<String, dynamic> e) {
      // Determine primary payment mode
      String primaryMode = 'Unknown';
      if ((e['utin_cash_amt_rec'] ?? '0') != '0') primaryMode = 'Cash';
      else if ((e['utin_bank_amt_rec'] ?? '0') != '0') primaryMode = 'Bank';
      else if ((e['utin_card_amt_rec'] ?? '0') != '0') primaryMode = 'Card';
      else if ((e['utin_online_amt_rec'] ?? '0') != '0') primaryMode = 'Online';

      final utinType = e['utin_type'] ?? '';
      final utinStatus = e['utin_status'] ?? '';

      return CrDrEntry(
        id: e['utin_id'] ?? 0,
        partyName: e['utin_user_name'] ?? '',
        amount: double.tryParse(e['utin_total_amt']?.toString() ?? '0') ?? 0,
        balanceAmt: double.tryParse(e['utin_cash_balance']?.toString() ?? '0') ?? 0,
        date: e['utin_date'] != null ? e['utin_date'].substring(0, 10) : '',
        mode: primaryMode,
        invoiceNumber: e['utin_full_inv_no'].toString(),

        // ✅ IS_CR logic: Advance aur Metal Advance dono true honge
        isCr: utinType == 'ADVANCE' || utinType == 'METAL_ADVANCE',

        // ✅ IS_PAID (Udhaar side): Agar type UDHAAR ya METAL_DUE hai aur status SETTLED hai
        isPaid: (utinType == 'UDHAAR' || utinType == 'METAL_DUE')
            ? utinStatus == 'SETTLED'
            : false,

        // ✅ IS_SETTLED (Advance side): Agar type ADVANCE ya METAL_ADVANCE hai aur status SETTLED hai
        isSettled: (utinType == 'ADVANCE' || utinType == 'METAL_ADVANCE')
            ? utinStatus == 'SETTLED'
            : false,

        isMetalAdvance: utinType == 'METAL_ADVANCE',
        isMetalDue: utinType == 'METAL_DUE',

        goldDueWt: double.tryParse(e['utin_gold_due_wt']?.toString() ?? '0') ?? 0,
        silverDueWt: double.tryParse(e['utin_silver_due_wt']?.toString() ?? '0') ?? 0,
        stoneDueWt: double.tryParse(e['utin_stone_due_wt']?.toString() ?? '0') ?? 0,

        goldAdvanceWt: double.tryParse(e['utin_gold_due_wt']?.toString() ?? '0') ?? 0,
        silverAdvanceWt: double.tryParse(e['utin_silver_due_wt']?.toString() ?? '0') ?? 0,
        stoneAdvanceWt: double.tryParse(e['utin_stone_due_wt']?.toString() ?? '0') ?? 0,

        cashAmt: double.tryParse(e['utin_cash_amt_rec']?.toString() ?? '0') ?? 0,
        bankAmt: double.tryParse(e['utin_bank_amt_rec']?.toString() ?? '0') ?? 0,
        cardAmt: double.tryParse(e['utin_card_amt_rec']?.toString() ?? '0') ?? 0,
        onlineAmt: double.tryParse(e['utin_online_amt_rec']?.toString() ?? '0') ?? 0,
      );
    }
  }