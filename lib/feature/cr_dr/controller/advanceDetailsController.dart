import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../../core/apiUrls/api_urls.dart';
import '../../../core/utils/token_helper.dart';
import '../model/UdhaarDetailResponse.dart';
import '../modelAccount/AccountsModel.dart';

class AdvanceDetailsController extends GetxController {


  final TextEditingController transactionType1Controller = TextEditingController();
  final TextEditingController transactionType2Controller = TextEditingController();
  final TextEditingController transactionType3Controller = TextEditingController();
  final TextEditingController transactionType4Controller = TextEditingController();

  final TextEditingController narration1Controller = TextEditingController();
  final TextEditingController narration2Controller = TextEditingController();
  final TextEditingController narration3Controller = TextEditingController();
  final TextEditingController narration4Controller = TextEditingController();
  final TextEditingController cashAmt1Controller = TextEditingController();
  final TextEditingController cashAmt2Controller = TextEditingController();
  final TextEditingController cashAmt3Controller = TextEditingController();
  final TextEditingController cashAmt4Controller = TextEditingController();

  final amountController = TextEditingController();
  final startDateController = TextEditingController();



  var firmId = 0.obs;
  var userId = 0.obs;
  var userName = "".obs;
  var staffId = 0.obs;
  var isLoading = true.obs;
  var udhaarData = Rxn<Data>();
  dynamic utinId;

  @override
  void onInit() {
    utinId = Get.arguments;
    fetchUdhaarDetails();
    String formattedDate = DateFormat('dd MMM yy').format(DateTime.now());
    startDateController.text = formattedDate;
    super.onInit();
  }

  final ApiClient _apiClient = ApiClient();


  Future<void> fetchUdhaarDetails() async {
    try {
      if (utinId == null) return; // Safety check
      isLoading(true);
      var response = await _apiClient.post(
        Uri.parse(ApiUrls.udharAdvanceDetail),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "utin_id": utinId,
          "filters": {},
          "page": 1,
          "limit": 20,
          "sort": {"field": "utin_createdAt", "order": "asc"}
        }),
      );

      if (response.statusCode == 200) {
        var result = UdhaarDetailResponse.fromJson(jsonDecode(response.body));
        udhaarData.value = result.data;
        firmId.value = udhaarData.value!.main!.utinFirmId!;
        userId.value = udhaarData.value!.main!.utinUserId!;
        staffId.value = udhaarData.value!.main!.utinStaffId!;
        userName.value = udhaarData.value!.main!.utinUserName!;
        fetchAccountData(firmId.value);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  var accountList = <Accounts>[].obs;

  var selectedBankAccountMap = <String, dynamic>{}.obs;
  var selectedCashInHandMap = <String, dynamic>{}.obs;
  var selectedCardBankAccountMap = <String, dynamic>{}.obs;
  var selectedOnlineBankAccountMap = <String, dynamic>{}.obs;
  var userAccToIdMap = <String, String>{}.obs;

  Future<void> fetchAccountData(int? firmId) async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(ApiUrls.accounts);

      final body = {
        "filters": [
          {
            "field": "acc_firm_id",
            "operator": "=",
            "value": firmId
          },
          {
            "field": "acc_status",
            "operator": "ILIKE",
            "value": "%active%"
          },
          {
            "field": "acc_main_acc",
            "operator": "IN",
            "value": [
              "Cash in Hand",
              "Bank Account",
              "Card Payment",
              "Online Payment",
            ]
          }
        ],
        "sort_by": "acc_updated_at",
        "sort_order": "DESC",
        "page": 1,
        "page_size": 10000,
        "include_system": true
      };

      final response = await _apiClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        final List<dynamic> dataList = decodedResponse['data'];

        accountList.value = dataList.map((e) => Accounts.fromJson(e)).toList();

        userAccToIdMap.clear();
        for (final account in accountList) {
          userAccToIdMap[account.accUserAcc] = account.accId.toString();
        }

        _updateSelectedAccountMap(accountList, 'Cash in Hand', selectedCashInHandMap, transactionType1Controller);
        _updateSelectedAccountMap(accountList, 'Bank Account', selectedBankAccountMap, transactionType2Controller);
        _updateSelectedAccountMap(accountList, 'Card Payment', selectedCardBankAccountMap, transactionType3Controller);
        _updateSelectedAccountMap(accountList, 'Online Payment', selectedOnlineBankAccountMap, transactionType4Controller);

      }
    } catch (e, st) {
      debugPrint('fetchAccountData error: $e');
      debugPrintStack(stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateSelectedAccountMap(
      List<Accounts> accounts,
      String accountType,
      RxMap<String, dynamic> selectedMap,
      TextEditingController? controller, // optional controller to update
      )
  {
    final account = accounts.firstWhereOrNull((a) => a.accMainAcc == accountType);

    if (account == null) return;

    selectedMap.assignAll({
      'acc_user_acc': account.accUserAcc,
      'acc_id': account.accId,
    });

    // Update the controller with the default account id
    if (controller != null) {
      controller.text = account.accId.toString();
    }
  }


  void calculationPaymentPanel() {
    double totalLimit = double.tryParse(amountController.text) ?? 0.0;

    List<TextEditingController> typeControllers = [
      cashAmt1Controller,
      cashAmt2Controller,
      cashAmt3Controller,
      cashAmt4Controller,
    ];

    double currentSum = 0.0;
    for (var controller in typeControllers) {
      double val = double.tryParse(controller.text) ?? 0.0;

      if (currentSum + val > totalLimit) {
        double allowedAmount = totalLimit - currentSum;

        controller.text = allowedAmount > 0 ? allowedAmount.toStringAsFixed(2) : "0";

        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
        val = allowedAmount > 0 ? allowedAmount : 0;
      }
      currentSum += val;
    }
  }



}