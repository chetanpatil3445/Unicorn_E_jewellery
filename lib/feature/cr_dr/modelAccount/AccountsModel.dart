class Accounts {
  final int accId;
  final int accFirmId;
  final String accMainAcc;
  final String accUserAcc;

  Accounts({
    required this.accId,
    required this.accFirmId,
    required this.accMainAcc,
    required this.accUserAcc,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) {
    return Accounts(
      accId: json['acc_id'] as int,
      accFirmId: json['acc_firm_id'] as int,
      accMainAcc: json['acc_main_acc'] as String,
      accUserAcc: json['acc_user_acc'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acc_id': accId,
      'acc_firm_id': accFirmId,
      'acc_main_acc': accMainAcc,
      'acc_user_acc': accUserAcc,
    };
  }
}
