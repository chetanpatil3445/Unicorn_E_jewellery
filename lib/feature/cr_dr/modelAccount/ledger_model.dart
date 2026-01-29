import 'dart:convert';

class LedgerResponse {
  final bool success;
  final int accountId;
  final double openingBalance;
  final String openingBalanceCRDR;
  final List<LedgerEntry> ledger;
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;
  final String closingBalanceCRDR;

  LedgerResponse({
    required this.success,
    required this.accountId,
    required this.openingBalance,
    required this.openingBalanceCRDR,
    required this.ledger,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
    required this.closingBalanceCRDR,
  });

  factory LedgerResponse.fromJson(Map<String, dynamic> json) {
    return LedgerResponse(
      success: json['success'] ?? false,
      accountId: json['account_id'] ?? 0,
      openingBalance: (json['opening_balance'] ?? 0).toDouble(),
      openingBalanceCRDR: json['opening_balance_CRDR'] ?? '',
      ledger: (json['ledger'] as List? ?? [])
          .map((e) => LedgerEntry.fromJson(e))
          .toList(),
      totalDebit: (json['total_debit'] ?? 0).toDouble(),
      totalCredit: (json['total_credit'] ?? 0).toDouble(),
      closingBalance: (json['closing_balance'] ?? 0).toDouble(),
      closingBalanceCRDR: json['closing_balance_CRDR'] ?? '',
    );
  }
}

class LedgerEntry {
  final int jrtrId;
  final DateTime date;
  final String particulars;
  final String referenceNo;
  final String transType;
  final double debit;
  final double credit;
  final double runningBalance;
  final double openingBalance;
  final String openingBalanceCRDR;
  final double closingBalance;
  final String closingBalanceCRDR;

  LedgerEntry({
    required this.jrtrId,
    required this.date,
    required this.particulars,
    required this.referenceNo,
    required this.transType,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    required this.openingBalance,
    required this.openingBalanceCRDR,
    required this.closingBalance,
    required this.closingBalanceCRDR,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      jrtrId: json['jrtr_id'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      particulars: json['particulars'] ?? '',
      referenceNo: json['reference_no'] ?? '',
      transType: json['trans_type'] ?? '',
      debit: (json['debit'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      runningBalance: (json['running_balance'] ?? 0).toDouble(),
      openingBalance: (json['opening_balance'] ?? 0).toDouble(),
      openingBalanceCRDR: json['opening_balance_CRDR'] ?? '',
      closingBalance: (json['closing_balance'] ?? 0).toDouble(),
      closingBalanceCRDR: json['closing_balance_CRDR'] ?? '',
    );
  }
}
