class UdhaarDetailResponse {
  bool? success;
  Data? data;

  UdhaarDetailResponse({this.success, this.data});

  UdhaarDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  MainData? main;
  List<Subtransaction>? subtransactions;

  Data({this.main, this.subtransactions});

  Data.fromJson(Map<String, dynamic> json) {
    main = json['main'] != null ? MainData.fromJson(json['main']) : null;
    if (json['subtransactions'] != null) {
      subtransactions = <Subtransaction>[];
      json['subtransactions'].forEach((v) {
        subtransactions!.add(Subtransaction.fromJson(v));
      });
    }
  }
}

class MainData {
  String? utinFullInvNo, utinDate, utinTotalAmt, utinOutstandingAmt,utinCashBalance, utinUserName,utinStatus;
  int? utinFirmId;
  int? utinUserId;
  int? utinStaffId;
  MainData({this.utinFullInvNo, this.utinDate, this.utinTotalAmt, this.utinOutstandingAmt, this.utinCashBalance,this.utinUserName,this.utinStatus, this.utinFirmId , this.utinUserId, this.utinStaffId});

  MainData.fromJson(Map<String, dynamic> json) {
    utinFullInvNo = json['utin_full_inv_no'];
    utinDate = json['utin_date'];
    utinTotalAmt = json['utin_total_amt'];
    utinOutstandingAmt = json['utin_outstanding_amt'];
    utinCashBalance = json['utin_cash_balance'];
    utinUserName = json['utin_user_name'];
    utinStatus = json['utin_status'];
    utinFirmId = json['utin_firm_id'];
    utinUserId = json['utin_user_id'];
    utinStaffId = json['utin_sales_person_id'];
  }
}

class Subtransaction {
  String? utinDate, utinTotalAmt, utinFullInvNo,utinCashBalance, utinUserName;
  int? utinFirmId;
  int? utinUserId;
  int? utinStaffId;
  Subtransaction({this.utinDate, this.utinTotalAmt, this.utinFullInvNo,this.utinCashBalance,this.utinUserName ,this.utinFirmId, this.utinUserId, this.utinStaffId});

  Subtransaction.fromJson(Map<String, dynamic> json) {
    utinDate = json['utin_date'];
    utinTotalAmt = json['utin_total_amt'];
    utinFullInvNo = json['utin_full_inv_no'];
    utinCashBalance = json['utin_cash_balance'];
    utinUserName = json['utin_user_name'];
    utinFirmId = json['utin_firm_id'];
    utinUserId = json['utin_user_id'];
    utinStaffId = json['utin_sales_person_id'];
  }
}