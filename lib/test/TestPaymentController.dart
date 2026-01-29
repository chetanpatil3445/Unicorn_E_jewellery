// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:unicorn_billing_app/Routes/app_routes.dart';
// import '../../../core/apiUrls/api_urls.dart';
// import '../../../core/controller/AppDataController.dart';
// import '../../../core/utils/token_helper.dart';
// import '../../Metal_Rates/model/metal_rate_model.dart';
// import '../../firm/model/firm_model.dart';
// import '../../sell_stock/model/SellTransaction.dart';
// import '../../stock/model/stock_metal_rate_model.dart';
// import '../../stock/service/stock_metal_rate_service.dart';
// import '../model/AccountsModel.dart';
// class PaymentController extends GetxController {
//
//
//   /// ---------------- ACCOUNT DATA ---------------- STARTS HERE ---------------------------------------------------------------------------
//   var accountList = <Accounts>[].obs;
//   var selectedBankAccountMap = <String, dynamic>{}.obs;
//   var selectedCashInHandMap = <String, dynamic>{}.obs;
//   var selectedCardBankAccountMap = <String, dynamic>{}.obs;
//   var selectedOnlineBankAccountMap = <String, dynamic>{}.obs;
//   var selectedDRAccountMap = <String, dynamic>{}.obs;
//   var userAccToIdMap = <String, String>{}.obs;
//
//   /// Declare userAccToIdMap
//   Future<void> fetchAccountData() async {
//     isLoading.value = true;
//     try {
//       final uri = Uri.parse(ApiUrls.accounts);
//       final body = {
//         "filters": [
//           {
//             "field": "acc_firm_id",
//             "operator": "=",
//             "value": AppDataController.to.firmID.value
//           },
//           {
//             "field": "acc_status",
//             "operator": "ILIKE",
//             "value": "%active%"
//           },
//           {
//             "field": "acc_main_acc",
//             "operator": "IN",
//             "value": [
//               "Cash in Hand",
//               "Bank Account",
//               "Card Payment",
//               "Online Payment"
//             ]
//           }
//         ],
//         "sort_by": "acc_updated_at",
//         "sort_order": "DESC",
//         "page": 1,
//         "page_size": 10000,
//         "include_system": true
//       };
//
//       final response = await apiClient.post(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode != 200) {
//         throw Exception('Failed to load account data');
//       }
//
//       /// ✅ RESPONSE IS MAP
//       final Map<String, dynamic> decodedResponse =
//       jsonDecode(response.body);
//
//       /// ✅ DATA IS LIST
//       final List<dynamic> dataList = decodedResponse['data'];
//
//       accountList.value = dataList
//           .map((e) => Accounts.fromJson(e))
//           .toList();
//
//       userAccToIdMap.clear();
//       for (final account in accountList) {
//         userAccToIdMap[account.accUserAcc] = account.accId.toString();
//       }
//
//       _updateSelectedAccountMap(accountList, 'Cash in Hand', selectedCashInHandMap, transactionType1Controller);
//       _updateSelectedAccountMap(accountList, 'Bank Account', selectedBankAccountMap, transactionType2Controller);
//       _updateSelectedAccountMap(accountList, 'Card Payment', selectedCardBankAccountMap, transactionType3Controller);
//       _updateSelectedAccountMap(accountList, 'Online Payment', selectedOnlineBankAccountMap, transactionType4Controller);
//     } catch (e, st) {
//       debugPrint('fetchAccountData error: $e');
//       debugPrintStack(stackTrace: st);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _updateSelectedAccountMap(
//       List<Accounts> accounts,
//       String accountType,
//       RxMap<String, dynamic> selectedMap,
//       TextEditingController? controller, // optional controller to update
//       )
//   {
//     final account = accounts.firstWhereOrNull((a) => a.accMainAcc == accountType);
//
//     if (account == null) return;
//
//     selectedMap.assignAll({
//       'acc_user_acc': account.accUserAcc,
//       'acc_id': account.accId,
//     });
//
//     // Update the controller with the default account id
//     if (controller != null) {
//       controller.text = account.accId.toString();
//     }
//   }
//
//   /// ---------------- ACCOUNT DATA ---------------- ENDS HERE ---------------------------------------------------------------------------
//
//
//   ///  ---------------- CURRENT SELL SUMMARY  ---------------- START HERE ---------------------------------------------------------------------------
//
//   var isLoading = false.obs;
//
//   var currentSaleItemsWithoutStone = <Map<String, String>>[].obs;
//   var currentSaleItemsOnlyStone = <Map<String, String>>[].obs;
//   var currentSaleItemsOnlyGold = <Map<String, String>>[].obs;
//   var currentSaleItemsOnlySilver = <Map<String, String>>[].obs;
//
//   // Summary Table Totals (For Footer & API)
//   var summaryTotalQty = 0.0.obs;
//   var summaryTotalGwt = 0.0.obs;
//   var summaryTotalFwt = 0.0.obs;
//   var summaryTotalVal = 0.0.obs;
//   var summaryTotalMetalValWithoutStone = 0.0.obs;
//
//   var summaryTotalMetalValOnlyGold = 0.0.obs;
//   var summaryTotalMetalValOnlySilver = 0.0.obs;
//   var summaryTotalMetalValOnlyStone = 0.0.obs;
//
//   var summaryTotalGoldWt = 0.0.obs;
//   var summaryTotalSilverWt = 0.0.obs;
//   var summaryTotalStoneWt = 0.0.obs;
//
//   // Gold variables only for api
//   var totalGoldGsWt = 0.0.obs;    // Gold gross weight
//   var totalGoldQty = 0.0.obs;     // Gold quantity
//   var totalGoldNetWt = 0.0.obs;   // Gold net weight
//
//   // Silver variables only for api
//   var totalSilverGsWt = 0.0.obs;  // Silver gross weight
//   var totalSilverQty = 0.0.obs;   // Silver quantity
//   var totalSilverNetWt = 0.0.obs; // Silver net weight
//
//   // Stone variables only for api
//   var totalStoneQty = 0.0.obs;    // Stone quantity
//
//
//   final RxDouble goldAverageRatePer10Gram   = 0.0.obs;
//   final RxDouble silverAverageRatePer10Gram = 0.0.obs;
//   final RxDouble stoneAverageRatePerCT  = 0.0.obs;
//
//   var currentSaleItems = <Map<String, String>>[].obs;
//   var pendingSells = <SellTransaction>[].obs;
//
//   RxDouble totalGoldMetalValuation = 0.0.obs;
//   RxDouble totalSilverMetalValuation = 0.0.obs;
//   RxDouble totalStoneMetalValuation = 0.0.obs;
//
//   var goldMetBal = "0.000".obs;
//   var silverMetBal = "0.000".obs;
//   var diamondMetBal = "0.000".obs;
//
//   Future<void> fetchPendingPaymentsSellStocks() async {
//     final selectedUserId = AppDataController.to.userId.value;
//     if (selectedUserId == null) {
//       Get.snackbar('Error', 'User ID is null');
//       return;
//     }    isLoading.value = true;
//
//     try {
//       final uri = Uri.parse(ApiUrls.sellQuery);
//       final body = {
//         "filters": [
//           {"field": "sell_user_id", "operator": "=", "value": selectedUserId},
//           {"field": "sell_payment_status", "operator": "=", "value": "payment_pending"}
//         ],
//         "sort_by": "sell_id",
//         "sort_order": "DESC",
//         "get_images": true
//       };
//
//       final response = await apiClient.post(
//         uri,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         if (jsonResponse['success'] && jsonResponse['data'] != null) {
//           pendingSells.value = (jsonResponse['data'] as List).map((e) => SellTransaction.fromJson(e)).toList();
//
//           utinSellIdsForSettlement = pendingSells.value.map((e) => e.sellId).toList();
//           utinSttrIdsForSettlement = pendingSells.value.map((e) => e.sellsttrId ?? 0).toList();
//           selectedFirmId.value = pendingSells.value.first.sellFirmId;
//           _calculateTotals();
//
//         } else {
//           _resetTotals();
//         }
//       } else {
//         Get.snackbar('Error', 'Failed to fetch pending payments');
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void _calculateTotals() {
//     totalAmountToShow.value = 0.0;
//     double goldQty = 0, goldGwt = 0, goldVal = 0 , goldFFwt = 0 , goldNtwt = 0;
//     double silverQty = 0, silverGwt = 0, silverVal = 0 , silverFFwt = 0 ,silverNtwt = 0;
//     double stoneQty = 0, stoneGwt = 0, stoneVal = 0;
//     double otherChrg = 0;
//
//     double goldWeightedValue = 0;
//     double silverWeightedValue = 0;
//     double stoneWeightedValue = 0;
//
//
//
//     for (final item in pendingSells) {
//
//       final finalAmount = double.tryParse(item.sellFinalValuation) ?? 0.0;
//       final metalValuation = double.tryParse(item.sellValuation) ?? 0.0;
//       final qty = double.tryParse(item.sellQuantity) ?? 0.0;
//       final gwt = double.tryParse(item.sellgswt) ?? 0.0;
//       final ntwt = double.tryParse(item.sellNtwt) ?? 0.0;
//       final gwtType = item.sellgswtType; // String: GM / KG / MG
//       final ffwt = double.tryParse(item.sellFFwt) ?? 0.0;
//       final mkgCharge = double.tryParse(item.sellTotalMakingCharge ?? '0') ?? 0.0;
//       final gwtInGram = convertToGram(gwt, gwtType);
//       final ntWTInGram = convertToGram(ntwt, gwtType);
//       final ffwtInGram = convertToGram(ffwt, gwtType);
//
//       final metalRate = double.tryParse(item.sellMetalRate ?? '0') ?? 0.0;
//       final metalRatePer10 = convertMetalRateToPer10Gm(metalRate, item.sellMetalRatePer,);
//
//
//       totalAmountToShow.value += finalAmount;
//
//       if (item.sellMetal.toLowerCase().contains('gold')) {
//         goldQty += qty;
//         goldGwt += gwtInGram; // ✅ always in gram
//         goldNtwt += ntWTInGram; // ✅ always in gram
//         goldVal += metalValuation;
//         goldFFwt += ffwtInGram;
//         otherChrg += mkgCharge;
//         goldWeightedValue += (ffwtInGram * metalRatePer10) / 10;
//       }
//       else if (item.sellMetal.toLowerCase().contains('silver')) {
//         silverQty += qty;
//         silverGwt += gwtInGram; // ✅ always in gram
//         silverNtwt += ntWTInGram; // ✅ always in gram
//         silverVal += metalValuation;
//         silverFFwt += ffwtInGram;
//         otherChrg += mkgCharge;
//         silverWeightedValue += (ffwtInGram * metalRatePer10) / 10;
//       }
//
//       for (final stone in item.stones) {
//         final stoneQtyVal = double.tryParse(stone.stoneQuantity) ?? 0.0;
//         final stoneWt = double.tryParse(stone.stoneGsWeight) ?? 0.0;
//         final stoneWtType = stone.stoneGsWeightType; // CT / GM / MG / KG
//         final stoneWtInCarat = convertStoneToCarat(stoneWt, stoneWtType);
//
//         final ct = convertStoneToCarat(stoneWt, stone.stoneGsWeightType);
//         final rate = double.tryParse(stone.stoneSellRate ?? '0') ?? 0.0;
//         final ratePerCt = convertStoneRateToPerCt(rate, stone.stoneSellRateType, ct,);
//
//         stoneQty += stoneQtyVal;
//         stoneGwt += stoneWtInCarat; // ✅ always in CARAT
//         stoneVal += double.tryParse(stone.stoneValuation) ?? 0.0;
//         stoneWeightedValue += ct * ratePerCt;
//       }
//
//     }
//
//     // ---------- FINAL AVERAGE RATES (Safe) ----------
//
//
//     // // ---------- FINAL AVERAGE RATES ----------
//     final double goldAvgRatePer10 = goldFFwt > 0 ? (goldWeightedValue / goldFFwt) * 10 : 0.0;
//     final double silverAvgRatePer10 = silverFFwt > 0 ? (silverWeightedValue / silverFFwt) * 10 : 0.0;
//     final double stoneAvgRatePerCt = stoneGwt > 0 ? (stoneWeightedValue / stoneGwt) : 0.0;
//
// // ---------- STORE (RxDouble) ----------
//     goldAverageRatePer10Gram.value   = goldAvgRatePer10;
//     silverAverageRatePer10Gram.value = silverAvgRatePer10;
//     stoneAverageRatePerCT.value  = stoneAvgRatePerCt;
//
//     totalGoldMetalValuation.value = goldVal;
//     totalSilverMetalValuation.value = silverVal;
//     totalStoneMetalValuation.value = stoneVal;
//
//     goldMetBal.value = goldGwt.toStringAsFixed(2);
//     silverMetBal.value = silverGwt.toStringAsFixed(2);
//     diamondMetBal.value = stoneGwt.toStringAsFixed(2);
//
//     totalOtherCharges.value = otherChrg;
//
//     List<Map<String, String>> summaryRows = [];
//     List<Map<String, String>> summaryRowsWithoutStone = [];
//     List<Map<String, String>> summaryRowsOnlyStone = [];
//     List<Map<String, String>> summaryRowsOnlyGold = [];
//     List<Map<String, String>> summaryRowsOnlySilver = [];
//     if (goldQty > 0 || goldVal > 0) {
//       summaryRows.add({'metal': 'Gold', 'qty': goldQty.toStringAsFixed(0), 'gwt': goldGwt.toStringAsFixed(2), 'fwt': goldFFwt.toStringAsFixed(3), 'val': goldVal.toStringAsFixed(2), 'ntwt' : goldNtwt.toStringAsFixed(2)});
//       summaryRowsWithoutStone.add({'metal': 'Gold', 'qty': goldQty.toStringAsFixed(0), 'gwt': goldGwt.toStringAsFixed(2), 'fwt': goldFFwt.toStringAsFixed(3), 'val': goldVal.toStringAsFixed(2), 'ntwt' : goldNtwt.toStringAsFixed(2)});
//       summaryRowsOnlyGold.add({'metal': 'Gold', 'qty': goldQty.toStringAsFixed(0), 'gwt': goldGwt.toStringAsFixed(2), 'fwt': goldFFwt.toStringAsFixed(3), 'val': goldVal.toStringAsFixed(2), 'ntwt' : goldNtwt.toStringAsFixed(2)});
//     }
//     if (silverQty > 0 || silverVal > 0) {
//       summaryRows.add({'metal': 'Silver', 'qty': silverQty.toStringAsFixed(0), 'gwt': silverGwt.toStringAsFixed(2), 'fwt': silverFFwt.toStringAsFixed(3), 'val': silverVal.toStringAsFixed(2), 'ntwt' : goldNtwt.toStringAsFixed(2)});
//       summaryRowsWithoutStone.add({'metal': 'Silver', 'qty': silverQty.toStringAsFixed(0), 'gwt': silverGwt.toStringAsFixed(2), 'fwt': silverFFwt.toStringAsFixed(3), 'val': silverVal.toStringAsFixed(2), 'ntwt' : goldNtwt.toStringAsFixed(2)});
//       summaryRowsOnlySilver.add({'metal': 'Silver', 'qty': silverQty.toStringAsFixed(0), 'gwt': silverGwt.toStringAsFixed(2), 'fwt': silverFFwt.toStringAsFixed(3), 'val': silverVal.toStringAsFixed(2), 'ntwt' : goldNtwt.toStringAsFixed(2)});
//     }
//     if (stoneQty > 0 || stoneVal > 0) {
//       summaryRows.add({'metal': 'Stone', 'qty': stoneQty.toStringAsFixed(0), 'gwt': stoneGwt.toStringAsFixed(2), 'fwt': '0.00', 'val': stoneVal.toStringAsFixed(2)});
//       summaryRowsOnlyStone.add({'metal': 'Stone', 'qty': stoneQty.toStringAsFixed(0), 'gwt': stoneGwt.toStringAsFixed(2), 'fwt': '0.00', 'val': stoneVal.toStringAsFixed(2)});
//     }
//
//     currentSaleItems.value = summaryRows;
//     currentSaleItemsWithoutStone.value = summaryRowsWithoutStone;
//
//     currentSaleItemsOnlyStone.value = summaryRowsOnlyStone;
//     currentSaleItemsOnlyGold.value = summaryRowsOnlyGold;
//     currentSaleItemsOnlySilver.value = summaryRowsOnlySilver;
//
//     // Call footer calculation
//     updateSummaryTableTotals();
//     onPaymentTypeChanged();
//   }
//
//   double convertMetalRateToPer10Gm(double rate, String? type) {
//     switch (type) {
//       case 'per_1_gm':
//         return rate * 10;
//       case 'per_1_kg':
//         return rate / 100;
//       case 'per_10_gm':
//       default:
//         return rate;
//     }
//   }
//   double convertStoneRateToPerCt(
//       double rate,
//       String? type,
//       double stoneCt,
//       )
//   {
//     switch (type) {
//       case 'GM':
//         return rate * 0.2;
//       case 'KG':
//         return rate * 0.0002;
//       case 'MG':
//         return rate * 200;
//       case 'FR':
//       case 'PP':
//         return stoneCt > 0 ? rate / stoneCt : 0;
//       case 'CT':
//         return rate;
//       default:
//         return rate;
//     }
//   }
//
//   void updateSummaryTableTotals() {
//     double tQty = 0;
//     double tGwt = 0;
//     double tFwt = 0;
//     double tVal = 0;
//     double tMetVat = 0;
//     double tMetVatGold = 0;
//     double tMetVatSilver = 0;
//     double tMetVatStone = 0;
//
//     double tGoldFfwt = 0;
//     double tSilverFfwt = 0;
//     double tStonegswt = 0;
//
//     double goldGsWT = 0;
//     double silverGsWt = 0;
//
//     double goldNtWT = 0;
//     double silverNtWt = 0;
//
//     double goldQty = 0;
//     double silverQty = 0;
//     double stoneQty = 0;
//
//     for (var item in currentSaleItems) {
//       tQty += double.tryParse(item['qty'] ?? '0') ?? 0;
//       tGwt += double.tryParse(item['gwt'] ?? '0') ?? 0;
//       tFwt += double.tryParse(item['fwt'] ?? '0') ?? 0;
//       String valStr = item['val']?.replaceAll(',', '') ?? '0';
//       tVal += double.tryParse(valStr) ?? 0;
//     }
//
//     for (var item in currentSaleItemsWithoutStone) {
//       String valStri = item['val']?.replaceAll(',', '') ?? '0';
//       tMetVat += double.tryParse(valStri) ?? 0;
//     }
//
//     for (var item in currentSaleItemsOnlyGold) {
//       String valStrr = item['val']?.replaceAll(',', '') ?? '0';
//       tMetVatGold += double.tryParse(valStrr) ?? 0;
//       tGoldFfwt += double.tryParse(item['fwt'] ?? '0') ?? 0;
//       goldGsWT += double.tryParse(item['gwt'] ?? '0') ?? 0;
//       goldQty += double.tryParse(item['qty'] ?? '0') ?? 0;
//       goldNtWT += double.tryParse(item['ntwt'] ?? '0') ?? 0;
//     }
//
//     for (var item in currentSaleItemsOnlySilver) {
//       String valStrr = item['val']?.replaceAll(',', '') ?? '0';
//       tMetVatSilver += double.tryParse(valStrr) ?? 0;
//       tSilverFfwt += double.tryParse(item['fwt'] ?? '0') ?? 0;
//       silverGsWt += double.tryParse(item['gwt'] ?? '0') ?? 0;
//       silverQty += double.tryParse(item['qty'] ?? '0') ?? 0;
//       silverNtWt += double.tryParse(item['ntwt'] ?? '0') ?? 0;
//     }
//
//     for (var item in currentSaleItemsOnlyStone) {
//       String valStrr = item['val']?.replaceAll(',', '') ?? '0';
//       tMetVatStone += double.tryParse(valStrr) ?? 0;
//       tStonegswt += double.tryParse(item['gwt'] ?? '0') ?? 0;
//       stoneQty += double.tryParse(item['qty'] ?? '0') ?? 0;
//     }
//
//     summaryTotalQty.value = tQty;
//     summaryTotalGwt.value = tGwt;
//     summaryTotalFwt.value = tFwt;
//     summaryTotalVal.value = tVal;
//     summaryTotalMetalValWithoutStone.value = tMetVat;
//
//     summaryTotalMetalValOnlyGold.value = tMetVatGold;
//     summaryTotalMetalValOnlySilver.value = tMetVatSilver;
//     summaryTotalMetalValOnlyStone.value = tMetVatStone;
//
//     summaryTotalGoldWt.value = tGoldFfwt;
//     summaryTotalSilverWt.value = tSilverFfwt;
//     summaryTotalStoneWt.value = tStonegswt;
//
//     /// only for api send
//     totalGoldGsWt.value = goldGsWT;
//     totalSilverGsWt.value = silverGsWt;
//
//     totalGoldNetWt.value = goldNtWT;
//     totalSilverNetWt.value = silverNtWt;
//
//     totalGoldQty.value = goldQty;
//     totalSilverQty.value = silverQty;
//     totalStoneQty.value = stoneQty;
//
//     calculationPaymentPanel();
//   }
//
//   double convertToGram(double weight, String? type) {
//     switch (type?.toUpperCase()) {
//       case 'KG':
//         return weight * 1000;
//       case 'MG':
//         return weight / 1000;
//       case 'GM':
//       default:
//         return weight;
//     }
//   }
//
//   double convertStoneToCarat(double weight, String? type) {
//     switch (type?.toUpperCase()) {
//       case 'GM':
//         return weight * 5;
//       case 'MG':
//         return weight / 200;
//       case 'KG':
//         return weight * 5000;
//       case 'CT':
//       default:
//         return weight;
//     }
//   }
//
//   void _resetTotals() {
//     pendingSells.clear();
//     currentSaleItems.clear();
//     summaryTotalQty.value = 0;
//     summaryTotalGwt.value = 0;
//     summaryTotalFwt.value = 0;
//     summaryTotalVal.value = 0;
//     totalAmountToShow.value = 0.0;
//     totalGoldMetalValuation.value = 0.0;
//     totalSilverMetalValuation.value = 0.0;
//     totalStoneMetalValuation.value = 0.0;
//   }
//
//   ///  ---------------- CURRENT SELL SUMMARY  ---------------- ENDS HERE  ---------------------------------------------------------------------------
//
//
//
//
//   /// pending payment related functions starts here  ---------------- PENDING TRANSACTIONS -------------------------------------------------------------------------------------------
//
//   var settlementSelection = <int, Map<String, bool>>{}.obs;
//   var pendingTransactions = <Map<String, dynamic>>[].obs;
//
//   var netUdharAdvanceBalance = 0.0.obs;
//   var netUdharAdvanceType = "".obs;
//
//   Future<void> fetchPendingPaymentsList() async {
//     int? userId = AppDataController.to.userId.value;
//     int? firmId = AppDataController.to.firmID.value;
//
//     isLoading.value = true;
//     try {
//       final body = {
//         "filters": {
//           "utin_type": ["UDHAAR","ADVANCE","METAL_DUE","METAL_ADVANCE"],
//           "utin_transaction_type": ["SELL","DIRECT"],
//           "utin_status": ["DUE","PAYMENT_PENDING","ADVANCE"],
//           "utin_firm_id": firmId,
//           "utin_user_id": userId,
//         },
//         "sort": {
//           "field": "utin_createdAt",
//           "order": "desc"
//         },
//         "page": 1,
//         "limit": 200000
//       };
//
//       final response = await apiClient.post(
//         Uri.parse(ApiUrls.udharAdvanceList),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         if (jsonResponse['success'] && jsonResponse['data'] != null) {
//           final List<dynamic> data = jsonResponse['data'];
//           pendingTransactions.value = data.map((item) {
//             return {
//               'inv': item['utin_full_inv_no'] ?? '',
//               'gold': item['utin_gold_due_wt']?.toString() ?? '0.0',
//               'silver': item['utin_silver_due_wt']?.toString() ?? '0.0',
//               'stone': item['utin_stone_due_wt']?.toString() ?? '0.0',
//               'cash': item['utin_cash_balance']?.toString() ?? '0.0',
//               'isDr': item['utin_crdr'] == 'DR',
//               'utin_id': item['utin_id'],
//               'utin_type': item['utin_type'],
//               'utin_total_amt': item['utin_total_amt'],
//             };
//           }).toList();
//           _initSettlementSelection();
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching udhar advance list: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   void _initSettlementSelection() {
//     for (int i = 0; i < pendingTransactions.length; i++) {
//       settlementSelection[i] = {'gold': false, 'silver': false, 'stone': false, 'cash': false};
//     }
//   }
//
//   var selectedUtinIds = <int>[].obs;
//   void toggleUtinSelection(int utinId, bool selected) {
//     if (selected) {
//       if (!selectedUtinIds.contains(utinId)) selectedUtinIds.add(utinId);
//     } else {
//       selectedUtinIds.remove(utinId);
//     }
//   }
//
//   var netGold = 0.0.obs;
//   var netGoldType = "".obs;
//   var netSilver = 0.0.obs;
//   var netSilverType = "".obs;
//   var netStone = 0.0.obs;
//   var netStoneType = "".obs;
//   var netCash = 0.0.obs;
//   var netCashType = "".obs;
//   var netMetalTotalValuation = 0.0.obs;
//
//
//
//   void calculateSelectedTotals() {
//     // Reset totals
//     double totalGoldDR = 0, totalGoldCR = 0;
//     double totalSilverDR = 0, totalSilverCR = 0;
//     double totalStoneDR = 0, totalStoneCR = 0;
//     double totalCashDR = 0, totalCashCR = 0;
//
//     settlementSelection.forEach((index, values) {
//       var item = pendingTransactions[index];
//       bool isDR = item['isDr'] ?? false; // API se isDr check karein
//
//       void addToTotal(String type, double val) {
//         if (type == 'gold') isDR ? totalGoldDR += val : totalGoldCR += val;
//         if (type == 'silver') isDR ? totalSilverDR += val : totalSilverCR += val;
//         if (type == 'stone') isDR ? totalStoneDR += val : totalStoneCR += val;
//         if (type == 'cash') isDR ? totalCashDR += val : totalCashCR += val;
//       }
//
//       values.forEach((type, isSelected) {
//         if (isSelected) {
//           double val = double.tryParse(item[type].toString()) ?? 0.0;
//           addToTotal(type, val);
//         }
//       });
//     });
//
//     // Helper to set Net values
//     _setNetResult(totalGoldDR, totalGoldCR, netGold, netGoldType);
//     _setNetResult(totalSilverDR, totalSilverCR, netSilver, netSilverType);
//     _setNetResult(totalStoneDR, totalStoneCR, netStone, netStoneType);
//     _setNetResult(totalCashDR, totalCashCR, netCash, netCashType);
//
//     calculateUdharAdvanceSettlement();
//     _calculateMetalTotalValuation();
//     calculationPaymentPanel();
//   }
//   void _setNetResult(double dr, double cr, RxDouble obsVal, RxString obsType) {
//     if (cr > dr) {
//       obsVal.value = cr - dr;
//       obsType.value = "CR";
//     } else if (dr > cr) {
//       obsVal.value = dr - cr;
//       obsType.value = "DR";
//     } else {
//       obsVal.value = 0.0;
//       obsType.value = "";
//     }
//   }
//
//   void toggleValueSelection(int index, String type, bool value) {
//     if (!settlementSelection.containsKey(index)) {
//       settlementSelection[index] = {'gold': false, 'silver': false, 'stone': false, 'cash': false};
//     }
//     settlementSelection[index]![type] = value;
//     calculateSelectedTotals(); // Recalculate on every check
//     settlementSelection.refresh();
//
//   }
//
//   // ---- Udhar / Advance Settlement Breakdown ----
//   RxDouble totalUdharDR = 0.0.obs; // not in use but for future
//   RxDouble totalAdvanceCR = 0.0.obs; // not in use but for future
//   RxDouble remainingUdhar = 0.0.obs; // not in use but for future
//   RxDouble remainingAdvance = 0.0.obs; // not in use but for future
//   RxDouble internalAdjustedAmount = 0.0.obs; // not in use but for future
//
//   void calculateUdharAdvanceSettlement() {
//     // double drTotal = 0.0;
//     // double crTotal = 0.0;
//     //
//     // settlementSelection.forEach((index, values) {
//     //   final item = pendingTransactions[index];
//     //   final bool isDR = item['isDr'] ?? false;
//     //
//     //   values.forEach((type, isSelected) {
//     //     if (!isSelected || type != 'cash') return;
//     //
//     //     final double amount =
//     //         double.tryParse(item['cash']?.toString() ?? '0') ?? 0.0;
//     //
//     //     if (isDR) {
//     //       drTotal += amount;
//     //     } else {
//     //       crTotal += amount;
//     //     }
//     //   });
//     // });
//     //
//     // // 🔹 Store totals
//     // totalUdharDR.value = drTotal;
//     // totalAdvanceCR.value = crTotal;
//     //
//     // // 🔹 Internal adjustment
//     // final double adjustAmt = drTotal < crTotal ? drTotal : crTotal;
//     // internalAdjustedAmount.value = adjustAmt;
//     //
//     // // 🔹 Remaining balances
//     // remainingUdhar.value = drTotal - adjustAmt;
//     // remainingAdvance.value = crTotal - adjustAmt;
//
//     double drTotal = 0.0;
//     double crTotal = 0.0;
//
//     // 1. Purani selection calculate karein
//     settlementSelection.forEach((index, values) {
//       final item = pendingTransactions[index];
//       final bool isDR = item['isDr'] ?? false;
//       values.forEach((type, isSelected) {
//         if (!isSelected || type != 'cash') return;
//         final double amount = double.tryParse(item['cash']?.toString() ?? '0') ?? 0.0;
//         if (isDR) drTotal += amount; else crTotal += amount;
//       });
//     });
//
//     totalUdharDR.value = drTotal;
//     totalAdvanceCR.value = crTotal;
//
//     // 🔹 FIX: Agar sirf Advance (CR) hai, toh use pura adjust maano (Remaining = 0)
//     // Kyunki wo is bill mein consume ho raha hai.
//
//     if (drTotal > 0 && crTotal > 0) {
//       // Case 1: Dono hain (Purana Udhaar vs Purana Advance) - Tabhi internal adjustment karo
//       final double adjustAmt = drTotal < crTotal ? drTotal : crTotal;
//       internalAdjustedAmount.value = adjustAmt;
//       remainingUdhar.value = drTotal - adjustAmt;
//       remainingAdvance.value = crTotal - adjustAmt;
//     } else if (crTotal > 0) {
//       // Case 2: Sirf Advance select kiya hai (Bill ke liye)
//       internalAdjustedAmount.value = 0; // Dono purane nahi hain, isliye internal 0
//       remainingUdhar.value = 0;
//       remainingAdvance.value = 0; // ✅ Ye 0 hona chahiye taaki Node.js 95k consume kare
//     } else if (drTotal > 0) {
//       // Case 3: Sirf Udhaar select kiya hai (Bill mein settle karne ke liye)
//       internalAdjustedAmount.value = 0;
//       remainingUdhar.value = 0; // ✅ Ye 0 hona chahiye
//       remainingAdvance.value = 0;
//     }
//
//     final double adjustAmt = drTotal < crTotal ? drTotal : crTotal;
//
//     debugPrint("---- UDHAAR / ADVANCE SETTLEMENT ----");
//     debugPrint("Total Udhar DR : $drTotal");
//     debugPrint("Total Advance CR : $crTotal");
//     debugPrint("Internal Adjusted : $adjustAmt");
//     debugPrint("Remaining Udhar : ${remainingUdhar.value}");
//     debugPrint("Remaining Advance : ${remainingAdvance.value}");
//     debugPrint("Net Casg : ${netCash.value} ${netCashType.value}");
//   }
//
//   void _calculateMetalTotalValuation() {
//     double total = 0.0;
//
//     settlementSelection.forEach((index, values) {
//       final item = pendingTransactions[index];
//
//       // 🔹 check: koi bhi metal selected hai kya (cash ignore)
//       bool metalSelected =
//           (values['gold'] == true) ||
//               (values['silver'] == true) ||
//               (values['stone'] == true);
//
//       if (metalSelected) {
//         total += double.tryParse(
//             item['utin_total_amt']?.toString() ?? '0') ??
//             0.0;
//       }
//     });
//
//     netMetalTotalValuation.value = total;
//
//     debugPrint("Net Metal Total Valuation : ${netMetalTotalValuation.value}");
//   }
//
//
//   /// pending payment related functions endss here  ---------------- PENDING TRANSACTIONS -------------------------------------------------------------------------------------------
//
//
//   /// ---------------- METAL RECEIVE ---------------- STARTS HERE ---------------------------------------------------------------------------
//   var metalType = 'Gold'.obs;
//   final metalTypes = ['Gold', 'Silver'];
//
//   final firms = <Firm>[].obs;
//   final Rx<int?> selectedFirmId = Rx<int?>(null);
//
//   void fetchFirms() async {
//     final response = await apiClient.get(Uri.parse(ApiUrls.firm));
//     if (response.statusCode == 200) {
//       firms.value = firmFromJson(response.body);
//     }
//   }
//   void setSelectedFirm(int firmId) {
//     selectedFirmId.value = firmId;
//   }
//
//   final StockMetalRateService _metalRateService = StockMetalRateService();
//
//   /// metal rates api
//   var selectedRate = ''.obs;
//   var ratesList = <String>[].obs;
//   var metalRateMap = <String, MetalRate>{}.obs;
//
//   Future<void> fetchLatestRates(String selectedMetal) async {
//     try {
//
//       final rates = await _metalRateService.getMetalRates(
//         metal: selectedMetal,
//         purity: "100",
//       );
//
//       if (rates.isNotEmpty) {
//         rates.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
//         final latestRate = rates.first;
//
//         final rateWt = double.tryParse(latestRate.ratePerWt) ?? 0.0;
//
//         final internalRateKey = mapApiUnitToRateKey(
//           latestRate.ratePerWtUnit, // e.g., "GM"
//           rateWt,                   // e.g., 10.0
//         );
//         metalRateController.text = latestRate.rate.toString();
//         metalRatePerController.value = internalRateKey;
//
//         ratesList.value = rates.map((r) => r.rate.toString()).toList();
//         var metalRateMap = <String, StockMetalRate>{}.obs;
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load metal rates: $e');
//     }
//   }
//
//   String mapApiUnitToRateKey(String apiUnit, double rateWt) {
//     // Normalize the unit string for comparison
//     final unit = apiUnit.toUpperCase();
//
//     // Check against the weight and unit combinations
//     if (unit == 'GM' && rateWt == 1.0) {
//       return 'per_1_gm';
//     } else if (unit == 'GM' && rateWt == 10.0) {
//       return 'per_10_gm';
//     } else if (unit == 'KG' && rateWt == 1.0) {
//       return 'per_1_kg';
//     }
//
//     // You can add more mappings here if needed (e.g., 'OZ', 'per_5_gm')
//
//     // Default fallback if no match is found
//     return 'per_1_gm';
//   }
//
//   void onRateSelected(String value) {
//     selectedRate.value = value;
//
//     if (metalRateMap.containsKey(value)) {
//       final data = metalRateMap[value]!;
//
//       metalRateController.text = data.rate.toString();
//       metalRatePerController.value = data.ratePerWtUnit;
//     } else {
//       // User manually typed rate
//       metalRateController.text = value;
//     }
//     calculateMetalReceive();
//     calculationPaymentPanel();
//   }
//
//   final gswtCtrl = TextEditingController();
//   final lswtCtrl = TextEditingController();
//   final ntwtCtrl = TextEditingController();
//   final purityCtrl = TextEditingController();
//   final finewtCtrl = TextEditingController();
//   final metalRateController = TextEditingController();
//   var metalRatePerController = ''.obs;
//   final metalRecievedValuation = TextEditingController();
//
//   var oldMetalList = <Map<String, String>>[].obs;
//
//   void calculateMetalReceive() {
//     double gswt = double.tryParse(gswtCtrl.text) ?? 0;
//     double lswt = double.tryParse(lswtCtrl.text) ?? 0;
//     double purity = double.tryParse(purityCtrl.text) ?? 0;
//     double rate = double.tryParse(metalRateController.text) ?? 0;
//     double ntwt = gswt - lswt;
//     ntwtCtrl.text = ntwt.toStringAsFixed(3);
//     double finewt = (purity / 100) * ntwt;
//     finewtCtrl.text = finewt.toStringAsFixed(3);
//
//     double ratePerGram;
//     switch (metalRatePerController.value) {
//       case 'per_1_gm':
//         ratePerGram = rate;
//         break;
//       case 'per_1_kg':
//         ratePerGram = rate / 1000;
//         break;
//       case 'per_10_gm':
//       default:
//         ratePerGram = rate / 10;
//     }
//
//     double totalAmt = finewt * ratePerGram;
//     metalRecievedValuation.text = totalAmt.toStringAsFixed(2);
//     calculationPaymentPanel();
//   }
//
//   void addMetalReceive() {
//
//     oldMetalList.add({
//       'metal': metalType.value,
//       'firm_id': selectedFirmId.value?.toString() ?? '',
//       'gswt': gswtCtrl.text,
//       'lswt': lswtCtrl.text.isEmpty ? "0.0" : lswtCtrl.text,
//       'ntwt': ntwtCtrl.text,
//       'purity': purityCtrl.text.isEmpty ? "100" : purityCtrl.text,
//       'Fwt': finewtCtrl.text, // Fine Weight
//       'rate': metalRateController.text,
//       'rate_per': metalRatePerController.value, // e.g., per_10_gm
//       'amt': metalRecievedValuation.text,
//       'date': DateTime.now().toIso8601String(),
//     });
//
//     gswtCtrl.clear(); lswtCtrl.clear(); ntwtCtrl.clear(); purityCtrl.clear(); finewtCtrl.clear(); metalRateController.clear(); metalRecievedValuation.clear();
//
//     // 🔹 Recalculate totals
//     calculateTotalReceivedFineWT();
//     calculationPaymentPanel();
//   }
//
//   double get totalOldMetalAdj {
//     return oldMetalList.fold(0, (sum, item) => sum + (double.tryParse(item['amt'] ?? '0') ?? 0));
//   }
//
//   void calculateTotalReceivedFineWT() {
//     double goldTotal = 0.0;
//     double silverTotal = 0.0;
//
//     for (final item in oldMetalList) {
//       final metal = item['metal'];
//       final fineWt = double.tryParse(item['Fwt'] ?? '0') ?? 0.0;
//
//       if (metal == 'Gold') {
//         goldTotal += fineWt;
//       } else if (metal == 'Silver') {
//         silverTotal += fineWt;
//       }
//     }
//
//     // totalRecievedGoldFineWT.value   = double.parse(goldTotal.toStringAsFixed(2));
//     // totalRecievedSilverFineWT.value = double.parse(silverTotal.toStringAsFixed(2));
//
//     totalRecievedGoldFineWT.value   = goldTotal;
//     totalRecievedSilverFineWT.value = silverTotal;
//   }
//
//   final RxDouble totalRecievedGoldFineWT   = 0.0.obs;
//   final RxDouble totalRecievedSilverFineWT = 0.0.obs;
//
//
//   /// ---------------- METAL RECEIVE ---------------- ENDS HERE ---------------------------------------------------------------------------
//
//
//
//
//
//
//
//
//
//   final ApiClient apiClient = ApiClient();
//   var selectedPaymentType = 'Cash Only'.obs;
//   var selectedPayableUser = "Amount Received from Customer".obs;
//   final List<String> dropdownOptions = [
//     "Amount Paid to Customer",
//     "Amount Received from Customer"
//   ];
//
//   bool hasShownPopup = false;
//   void triggerDiscoveryIfActive(int currentIndex, BuildContext context, Function showPopup) {
//     // 2 is the index of JewelleryPaymentPage in your TabBarView
//     if (currentIndex == 2 && !hasShownPopup) {
//       hasShownPopup = true;
//       Future.delayed(const Duration(milliseconds: 500), () {
//         showPopup(context);
//       });
//     }
//   }
//
//   final TextEditingController transactionType1Controller =TextEditingController();
//   final TextEditingController transactionType2Controller =TextEditingController();
//   final TextEditingController transactionType3Controller =TextEditingController();
//   final TextEditingController transactionType4Controller =TextEditingController();
//   final TextEditingController narration1Controller = TextEditingController();
//   final TextEditingController narration2Controller = TextEditingController();
//   final TextEditingController narration3Controller = TextEditingController();
//   final TextEditingController narration4Controller = TextEditingController();
//   final TextEditingController cashAmt1Controller = TextEditingController();
//   final TextEditingController cashAmt2Controller = TextEditingController();
//   final TextEditingController cashAmt3Controller = TextEditingController();
//   final TextEditingController cashAmt4Controller = TextEditingController();
//
//   final TextEditingController invCodeController = TextEditingController(text: "INV");
//   final TextEditingController invNoController = TextEditingController();
//
//   final RxBool isSectionsVisible = false.obs;
//   List<int> utinSellIdsForSettlement = [];
//   List<int> utinSttrIdsForSettlement = [];
//
//   final RxString selectedCashToMetal = 'Gold'.obs;
//
//
//   final RxString currentPrefix = "".obs;
//   @override
//   void onInit() {
//     super.onInit();
//     fetchPendingPaymentsSellStocks();
//     fetchPendingPaymentsList();
//     _initSettlementSelection();
//     fetchAccountData();
//     fetchFirms();
//     fetchLatestRates("Gold");
//     onPaymentTypeChanged();
//     getNextInvoiceNumber();
//
//     ever(selectedPaymentType, (_) => onPaymentTypeChanged());
//     debounce(currentPrefix, (_) {
//       if (currentPrefix.value.isNotEmpty) {
//         getNextInvoiceNumber();
//       }
//     }, time: const Duration(milliseconds: 600));
//    }
//
//
//    void callAllPayment(){
//      fetchPendingPaymentsSellStocks();
//      fetchPendingPaymentsList();
//      _initSettlementSelection();
//      fetchAccountData();
//      fetchFirms();
//      fetchLatestRates("Gold");
//      onPaymentTypeChanged();
//      getNextInvoiceNumber();
//    }
//
//   // Simple Debounce Logic
//   Worker? _worker;
//   void _debouncedFetch() {
//     _worker?.dispose();
//     _worker = debounce(invCodeController.text.obs, (value) {
//       if (value.toString().isNotEmpty) {
//         getNextInvoiceNumber();
//       }
//     }, time: Duration(milliseconds: 600));
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   var isLoadingIn = false.obs;
//
//   Future<void> getNextInvoiceNumber() async {
//     String prefix = invCodeController.text.trim();
//     if (prefix.isEmpty) return;
//
//     try {
//       isLoadingIn.value = true;
//       final body = {"utin_pre_inv_no": prefix};
//
//       final response = await apiClient.post(
//         Uri.parse(ApiUrls.invoiceNumber),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode(body),
//       );
//
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && responseData['success'] == true) {
//         final data = responseData['data'];
//         invNoController.text = data['utin_new_inv_no'].toString();
//         print("New Invoice No: ${invNoController.text}");
//       } else {
//         print("API Error: ${responseData['message']}");
//       }
//     } catch (e) {
//       print("Fetch Error: $e");
//     } finally {
//       isLoadingIn.value = false;
//     }
//   }
//   /// RATE CUT NO RATE CUT --------------- STARTS HERE ------------------------------------------------------------------------------------------------------------------------
//
// // --- Rate Cut Wt (EDITABLE only in Rate Cut) ---
//   final RxDouble goldRateCutWt   = 0.0.obs;
//   final RxDouble silverRateCutWt = 0.0.obs;
//   final RxDouble stoneRateCutWt  = 0.0.obs;
//
// // --- Valuation ---
//   final RxDouble goldRateCutVal   = 0.0.obs;
//   final RxDouble silverRateCutVal = 0.0.obs;
//   final RxDouble stoneRateCutVal  = 0.0.obs;
//
// // --- Remaining Weight ---
//   final RxDouble goldRemainingWtPendingWT   = 0.0.obs;
//   final RxDouble silverRemainingWtPendingWT = 0.0.obs;
//   final RxDouble stoneRemainingWtPendingWT  = 0.0.obs;
//
//   final RxString goldRemainingWtPendingWTCRDR   = 'DR'.obs;
//   final RxString silverRemainingWtPendingWTCRDR = 'DR'.obs;
//   final RxString stoneRemainingWtPendingWTCRDR  = 'DR'.obs;
//
//
//   // TextEditingControllers for fields
//   Map<String, TextEditingController> rateCutTextControllers = {};
//   Map<String, TextEditingController> avgRateTextControllers = {};
//
//   void initTextControllers() {
//     // rateCutTextControllers['gold'] ??= TextEditingController(text: goldRateCutWt.value.toStringAsFixed(2));
//     // rateCutTextControllers['silver'] ??= TextEditingController(text: silverRateCutWt.value.toStringAsFixed(2));
//     // rateCutTextControllers['stone'] ??= TextEditingController(text: stoneRateCutWt.value.toStringAsFixed(2));
//     //
//     // avgRateTextControllers['gold'] ??= TextEditingController(text: goldAverageRatePer10Gram.value.toStringAsFixed(2));
//     // avgRateTextControllers['silver'] ??= TextEditingController(text: silverAverageRatePer10Gram.value.toStringAsFixed(2));
//     // avgRateTextControllers['stone'] ??= TextEditingController(text: stoneAverageRatePerCT.value.toStringAsFixed(2));
//     // Gold
//     rateCutTextControllers['gold'] = TextEditingController(text: goldRateCutWt.value.toStringAsFixed(2));
//     avgRateTextControllers['gold'] = TextEditingController(text: goldAverageRatePer10Gram.value.toStringAsFixed(2));
//
//     // Silver
//     rateCutTextControllers['silver'] = TextEditingController(text: silverRateCutWt.value.toStringAsFixed(2));
//     avgRateTextControllers['silver'] = TextEditingController(text: silverAverageRatePer10Gram.value.toStringAsFixed(2));
//
//     // Stone
//     rateCutTextControllers['stone'] = TextEditingController(text: stoneRateCutWt.value.toStringAsFixed(2));
//     avgRateTextControllers['stone'] = TextEditingController(text: stoneAverageRatePerCT.value.toStringAsFixed(2));
//   }
//
//   // void onPaymentTypeChanged() {
//   //   initTextControllers();
//   //   if (selectedPaymentType.value == 'Rate Cut') {
//   //     goldRateCutWt.value = summaryTotalGoldWt.value;
//   //     silverRateCutWt.value = summaryTotalSilverWt.value;
//   //     stoneRateCutWt.value = summaryTotalStoneWt.value;
//   //
//   //     rateCutTextControllers['gold']?.text = summaryTotalGoldWt.value.toStringAsFixed(2);
//   //     rateCutTextControllers['silver']?.text = summaryTotalSilverWt.value.toStringAsFixed(2);
//   //     rateCutTextControllers['stone']?.text = summaryTotalStoneWt.value.toStringAsFixed(2);
//   //   } else {
//   //     goldRateCutWt.value = 0;
//   //     silverRateCutWt.value = 0;
//   //     stoneRateCutWt.value = 0;
//   //
//   //     rateCutTextControllers['gold']!.text = "0.00";
//   //     rateCutTextControllers['silver']!.text = "0.00";
//   //     rateCutTextControllers['stone']!.text = "0.00";
//   //   }
//   //   calculationPaymentPanel();
//   // }
//   void onPaymentTypeChanged() {
//     initTextControllers();
//     calculationPaymentPanel();
//   }
//
//
//   /// RATE CUT NO RATE CUT --------------- ENDS  HERE ------------------------------------------------------------------------------------------------------------------------
//
//
//
//   /// PAYMENTS BREAKDOWN --------------- STARTS HERE ------------------------------------------------------------------------------------------------------------------------
//
//   RxDouble previousAmount = 0.0.obs;
//   RxDouble stoneAmountShowPurposeOnly = 0.0.obs;
//   RxDouble totalOtherCharges = 0.0.obs;
//   RxDouble taxableAmount = 0.0.obs;
//   RxDouble hallmarkCharges = 0.0.obs;
//   RxDouble amountPaid = 0.0.obs;
//   RxDouble loyaltyAmt = 0.0.obs;
//
//   RxDouble totalMetalAmountGoldSilver = 0.0.obs;
//   RxDouble totalAmountToShow = 0.0.obs;
//   RxDouble recievedAmountToShow = 0.0.obs;
//   RxDouble roundOffAmount = 0.0.obs; //round off amount
//   RxDouble finalCashBalanceValuation = 0.0.obs; // final cash balance plus minus of metal rec amt paid loylty amt and disc
//   RxDouble finalPayableAmount = 0.0.obs; // final cash balance plus minus of metal rec amt paid loylty amt and disc
//
//   final taxPercentCtrl = TextEditingController(text: "0");
//   final taxAmountResult = 0.0.obs;
//
//
//   void onCashToMetalChanged(String value) {
//     double rate;
//
//     switch (value) {
//       case 'Gold':
//         rate = goldAverageRatePer10Gram.value;
//         break;
//       case 'Silver':
//         rate = silverAverageRatePer10Gram.value;
//         break;
//       case 'Stone':
//         rate = stoneAverageRatePerCT.value;
//         break;
//       default:
//         rate = 0.0;
//     }
//
//     if (rate <= 0) {
//       // Show message in English & Hindi
//       Get.snackbar(
//         'Cannot Convert',
//         'No items sold for $value, conversion not possible.\n\n${
//             'इस $value के लिए कोई आइटम बेचा नहीं गया, इसलिए रूपांतरण संभव नहीं है।'
//         }',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red.withOpacity(0.8),
//         colorText: Colors.white,
//         margin: const EdgeInsets.all(12),
//         duration: const Duration(seconds: 3),
//       );
//       return; // Do not change selection
//     }
//
//     // Valid rate → update selection and recalc
//     selectedCashToMetal.value = value;
//     calculationPaymentPanel();
//   }
//
//   RxDouble cashConvertedToGoldGram = 0.0.obs;
//   RxDouble cashConvertedToSilverGram = 0.0.obs;
//   RxDouble cashConvertedToStoneCarat = 0.0.obs;
//
//   double _signedValue(double value) {
//     return netCashType.value == 'CR' ? -value : value;
//   }
//
//   RxBool isRateCutApplied = false.obs;
//
//   RxDouble goldExcludedRateCutGram = 0.0.obs;
//   RxDouble silverExcludedRateCutGram = 0.0.obs;
//   RxDouble stoneExcludedRateCutGram = 0.0.obs;
//
//   late Map<String, TextEditingController> excludedRateCutControllers;
//
//   void initExcludeRatecutTextControllers() {
//     excludedRateCutControllers = {
//       'gold': TextEditingController(
//         text: goldExcludedRateCutGram.value.toStringAsFixed(2),
//       ),
//       'silver': TextEditingController(
//         text: silverExcludedRateCutGram.value.toStringAsFixed(2),
//       ),
//       'stone': TextEditingController(
//         text: stoneExcludedRateCutGram.value.toStringAsFixed(2),
//       ),
//     };
//   }
//
//
//
//   void calculationPaymentPanel() {
//    /// 🔹 In cash-to-metal conversion as well, the rate changed manually by the user will be applied from the opening balance.
//     final goldRate = goldAverageRatePer10Gram.value / 10;
//     final silverRate = silverAverageRatePer10Gram.value/ 10;
//     final stoneRate = stoneAverageRatePerCT.value;
//
//
//     /// 🔹 for cash to metal conversion for which metal - logic here
//     if (selectedCashToMetal.value == '' ||
//         (selectedCashToMetal.value == 'Gold' && goldRate <= 0) ||
//         (selectedCashToMetal.value == 'Silver' && silverRate <= 0) ||
//         (selectedCashToMetal.value == 'Stone' && stoneRate <= 0)) {
//
//       if (goldRate > 0) {
//         selectedCashToMetal.value = 'Gold';
//       } else if (silverRate > 0) {
//         selectedCashToMetal.value = 'Silver';
//       } else if (stoneRate > 0) {
//         selectedCashToMetal.value = 'Stone';
//       } else {
//         selectedCashToMetal.value = 'Gold';
//       }
//     }
//
//     /// 🔹 for cash convert to grams
//     if (selectedPaymentType.value != 'Cash Only') {
//       final double cashAmount = netCash.value;
//       cashConvertedToGoldGram.value = 0.0;
//       cashConvertedToSilverGram.value = 0.0;
//       cashConvertedToStoneCarat.value = 0.0;
//
//       double perGramRate;
//       RxDouble? targetWeight;
//
//       switch (selectedCashToMetal.value) {
//         case 'Gold':
//           perGramRate = goldAverageRatePer10Gram.value / 10;
//           targetWeight = cashConvertedToGoldGram;
//           break;
//         case 'Silver':
//           perGramRate = silverAverageRatePer10Gram.value / 10;
//           targetWeight = cashConvertedToSilverGram;
//           break;
//         case 'Stone':
//           perGramRate = stoneAverageRatePerCT.value;
//           targetWeight = cashConvertedToStoneCarat;
//           break;
//         default:
//           perGramRate = stoneAverageRatePerCT.value;
//           targetWeight = cashConvertedToStoneCarat;
//       }
//
//       final double rawWeight = (perGramRate > 0) ? cashAmount / perGramRate : 0.0;
//       // targetWeight.value = double.parse(_signedValue(rawWeight).toStringAsFixed(2));
//       targetWeight.value = _signedValue(rawWeight);
//
//     }
//
//
//
//     /// 🔹 Here, we are checking the CR/DR type of the previous due metal and adjusting their values as negative or positive accordingly.
//     double signedNetGold = netGoldType.value == 'DR' ? netGold.value : -netGold.value;
//     double signedNetSilver = netSilverType.value == 'DR' ? netSilver.value : -netSilver.value;
//     double signedNetStone = netStoneType.value == 'DR' ? netStone.value : -netStone.value;
//
//     /// 🔹 Here, the rate cut calculation for the opening balance section is being performed.
//     if (selectedPaymentType.value == 'Rate Cut') {
//       if(isRateCutApplied.value == true){
//
//         goldRateCutWt.value = summaryTotalGoldWt.value + totalRecievedGoldFineWT.value + cashConvertedToGoldGram.value + signedNetGold - goldExcludedRateCutGram.value;
//         silverRateCutWt.value = summaryTotalSilverWt.value + totalRecievedSilverFineWT.value + cashConvertedToSilverGram.value + signedNetSilver - silverExcludedRateCutGram.value;
//         stoneRateCutWt.value = summaryTotalStoneWt.value + cashConvertedToStoneCarat.value + signedNetStone - stoneExcludedRateCutGram.value;
//
//         rateCutTextControllers['gold']?.text = goldRateCutWt.value.toStringAsFixed(2);
//         rateCutTextControllers['silver']?.text = silverRateCutWt.value.toStringAsFixed(2);
//         rateCutTextControllers['stone']?.text = stoneRateCutWt.value.toStringAsFixed(2);
//       } else{
//         goldRateCutWt.value = summaryTotalGoldWt.value + totalRecievedGoldFineWT.value + signedNetGold - goldExcludedRateCutGram.value;
//         silverRateCutWt.value = summaryTotalSilverWt.value + totalRecievedSilverFineWT.value + signedNetSilver - silverExcludedRateCutGram.value;
//         stoneRateCutWt.value = summaryTotalStoneWt.value + signedNetStone - stoneExcludedRateCutGram.value;
//
//         rateCutTextControllers['gold']?.text = goldRateCutWt.value.toStringAsFixed(2);
//         rateCutTextControllers['silver']?.text = silverRateCutWt.value.toStringAsFixed(2);
//         rateCutTextControllers['stone']?.text = stoneRateCutWt.value.toStringAsFixed(2);
//       }
//     } else {
//       goldRateCutWt.value = 0;
//       silverRateCutWt.value = 0;
//       stoneRateCutWt.value = 0;
//
//       rateCutTextControllers['gold']!.text = "0.00";
//       rateCutTextControllers['silver']!.text = "0.00";
//       rateCutTextControllers['stone']!.text = "0.00";
//     }
//
//     /// 🔹 Here, after the rate cut, the metal valuation is being calculated based on the average rate.
//     goldRateCutVal.value = goldRateCutWt.value * goldRate;
//     silverRateCutVal.value = silverRateCutWt.value * silverRate;
//     stoneRateCutVal.value = stoneRateCutWt.value * stoneRate;
//
//     ///🔹 Here, the calculation of the due/pending metal is done, whether after applying the rate cut or without any rate cut.
//     // goldRemainingWtPendingWT.value   = double.parse(((summaryTotalGoldWt.value + totalRecievedGoldFineWT.value + cashConvertedToGoldGram.value + signedNetGold) - goldRateCutWt.value).toStringAsFixed(2));
//     goldRemainingWtPendingWT.value   = double.parse(((summaryTotalGoldWt.value + totalRecievedGoldFineWT.value + cashConvertedToGoldGram.value + signedNetGold) - goldRateCutWt.value).toString());
//     silverRemainingWtPendingWT.value = double.parse(((summaryTotalSilverWt.value + totalRecievedSilverFineWT.value + cashConvertedToSilverGram.value + signedNetSilver) - silverRateCutWt.value).toStringAsFixed(2));
//     stoneRemainingWtPendingWT.value  = double.parse(((summaryTotalStoneWt.value + cashConvertedToStoneCarat.value + signedNetStone) - stoneRateCutWt.value ).toStringAsFixed(2));
//
//     /// 🔹 Here, the due weight is being set as either CR or DR.
//     goldRemainingWtPendingWTCRDR.value   = goldRemainingWtPendingWT.value < 0 ? 'CR' : 'DR';
//     silverRemainingWtPendingWTCRDR.value = silverRemainingWtPendingWT.value < 0 ? 'CR' : 'DR';
//     stoneRemainingWtPendingWTCRDR.value  = stoneRemainingWtPendingWT.value < 0 ? 'CR' : 'DR';
//
//
//
//
//     /// 🔹 Here, the amounts in Cash, Bank, Card, or Online are being summed up.
//     double parse(TextEditingController ctrl) => double.tryParse(ctrl.text) ?? 0.0;
//
//     amountPaid.value = parse(cashAmt1Controller) +
//                        parse(cashAmt2Controller) +
//                        parse(cashAmt3Controller) +
//                        parse(cashAmt4Controller);
//
//     /// 🔹Here, to display in the previous amount, the value is being set based on the cash rate cut or no-rate type.
//     if(selectedPaymentType.value == 'Cash Only'){
//       previousAmount.value = netCash.value;
//       totalMetalAmountGoldSilver.value =  summaryTotalMetalValWithoutStone.value;
//       stoneAmountShowPurposeOnly.value =  summaryTotalMetalValOnlyStone.value;
//     } else if (selectedPaymentType.value == 'Rate Cut'){
//       previousAmount.value = 0.0;
//       totalMetalAmountGoldSilver.value =  goldRateCutVal.value + silverRateCutVal.value;
//       stoneAmountShowPurposeOnly.value =  stoneRateCutVal.value;
//     } else{
//       previousAmount.value = 0.0;
//       totalMetalAmountGoldSilver.value = 0.0;
//       stoneAmountShowPurposeOnly.value =  0.0;
//     }
//
//
//
//     taxableAmount.value = totalMetalAmountGoldSilver.value + stoneAmountShowPurposeOnly.value + totalOtherCharges.value;
//
//     double percent = double.tryParse(taxPercentCtrl.text) ?? 0.0;
//     taxAmountResult.value = (taxableAmount.value * percent) / 100;
//
//     double baseAmount = taxableAmount.value  + taxAmountResult.value  + hallmarkCharges.value ;
//
//     /// 🔹 Here, the previous pending cash will be added if it is on credit (udhar) and deducted if it is an advance.
//     if (selectedPaymentType.value == 'Cash Only') {
//       if (netCashType.value == "DR") {
//         baseAmount += netCash.value;  // DR → add
//       } else if (netCashType.value == "CR") {
//         baseAmount -= netCash.value;  // CR → subtract
//       }
//     }
//
//     /// 🔹Here, the round-off amount is being calculated.
//     totalAmountToShow.value = baseAmount;
//     double roundedTotal = double.parse(totalAmountToShow.value.toStringAsFixed(0));
//     double roundOff = roundedTotal - totalAmountToShow.value;
//     totalAmountToShow.value = roundedTotal; // Rounded total
//     String roundOffs = roundOff.toStringAsFixed(2); // Round-off difference
//     roundOffAmount.value = double.tryParse(roundOffs)!; // Round-off difference
//
//     /// 🔹 Here, the final cash balance valuation is being calculated.
//     if(selectedPaymentType.value == 'Cash Only'){
//       finalCashBalanceValuation.value =  totalAmountToShow.value - totalOldMetalAdj;
//       finalPayableAmount.value = totalAmountToShow.value - totalOldMetalAdj;
//       recievedAmountToShow.value = totalOldMetalAdj;
//     } else{
//       finalCashBalanceValuation.value =  totalAmountToShow.value;
//       finalPayableAmount.value = totalAmountToShow.value;
//       recievedAmountToShow.value = 0.0;
//     }
//
//     /// 🔹 Here, the final cash balance valuation is being calculated by the type of recieve or paid.
//     if (selectedPayableUser.value == "Amount Received from Customer") {
//       finalCashBalanceValuation.value += totalAmountToShow.value < 0 ? -amountPaid.value : -amountPaid.value;
//     } else {
//       finalCashBalanceValuation.value += totalAmountToShow.value < 0 ? amountPaid.value : amountPaid.value;
//     }
//
//   }
//
//   /// PAYMENTS BREAKDOWN --------------- ENDSS HERE ------------------------------------------------------------------------------------------------------------------------
//
//
//
//
//
//
//
//
//
//   Future<void> paymentApi() async {
//
//     isLoading.value = true;
//     int? selectedFirmId = AppDataController.to.firmID.value;
//     int? selectedUserId = AppDataController.to.userId.value;
//     String? selectedUserName = AppDataController.to.userName.value;
//     int? selectedStaffID = AppDataController.to.staffId.value;
//     String? staffName = AppDataController.to.staffName.value;
//
//     try {
//
//       List<Map<String, dynamic>> mappedMetalReceive = oldMetalList.map((item) {
//         return {
//           "sttr_date": item['date'] ?? DateTime.now().toUtc().toIso8601String(),
//           "sttr_metal": item['metal'],
//           "sttr_firm_id": int.tryParse(item['firm_id'].toString()) ?? selectedFirmId,
//           "sttr_gswt": double.tryParse(item['gswt'].toString()) ?? 0.0,
//           "sttr_less_wt": double.tryParse(item['lswt'].toString()) ?? 0.0,
//           "sttr_ntwt": double.tryParse(item['ntwt'].toString()) ?? 0.0,
//           "sttr_purity": double.tryParse(item['purity'].toString()) ?? 0.0,
//           "sttr_fine_wt": double.tryParse(item['Fwt'].toString()) ?? 0.0,
//           "sttr_final_fine_wt": double.tryParse(item['Fwt'].toString()) ?? 0.0,
//           "sttr_metal_rate": double.tryParse(item['rate'].toString()) ?? 0.0,
//           "sttr_metal_rate_per": item['rate_per'] ?? "per_10_gm",
//           "sttr_metal_valuation": double.tryParse(item['amt'].toString()) ?? 0.0,
//           "sttr_final_valuation": double.tryParse(item['amt'].toString()) ?? 0.0,
//           "sttr_quantity": 1,
//           "sttr_gswt_type": "GM",
//           "sttr_less_wt_type": "GM",
//           "sttr_ntwt_type": "GM",
//           "sttr_category": "OLD METAL",
//           "sttr_product_name": "Old ${item['metal']}",
//           "sttr_status": "OLD_METAL",
//           "sttr_indicator": "OLD_METAL",
//           "sttr_staff_id": selectedStaffID,
//         };
//       }).toList();
//
//       final data = {
//
//         "utin_pre_inv_no": invCodeController.text,
//         "utin_inv_no": invNoController.text,
//         "utin_full_inv_no": "${invCodeController.text}-${invNoController.text}",
//
//         "utin_firm_id": selectedFirmId,
//         "utin_user_id": selectedUserId,
//         "utin_user_name": selectedUserName,
//         "utin_sales_person_id": selectedStaffID,
//         "utin_sales_person_name": staffName,
//
//         // send id for settlements
//         "utin_ids": selectedUtinIds.value, //  // for settlement of previous invoices
//         "utin_sell_ids": utinSellIdsForSettlement, // for change status of sell transaction rows - to payment done
//         "utin_stock_ids": utinSttrIdsForSettlement, // for get valuation for stock gold/silver/stone - actual add time valuation
//
//         "utin_total_amt": finalPayableAmount.value,
//         "utin_total_taxable_amt": taxableAmount.value,
//         "utin_crystal_amt": summaryTotalMetalValOnlyStone.value,
//         "utin_sales_gold_amt" :"${summaryTotalMetalValOnlyGold.value}",
//         "utin_sales_silver_amt" :"${summaryTotalMetalValOnlySilver.value}",
//         "utin_sales_stone_amt" :"${summaryTotalMetalValOnlyStone.value}",
//
//         "utin_date": DateTime.now().toUtc().toIso8601String(),
//         "utin_oth_info": "Metal sale entry for invoice ${invCodeController.text}-${invNoController.text}",
//
//         "utin_gold_due_wt": goldRemainingWtPendingWT.value,
//         "utin_silver_due_wt": silverRemainingWtPendingWT.value,
//         "utin_stone_due_wt": stoneRemainingWtPendingWT.value,
//         "utin_payment_mode": selectedPaymentType.value,
//         "utin_round_off_amt": roundOffAmount.value,
//
//         "utin_prev_due_metal_tot_amt": netMetalTotalValuation.value ?? 0.0,
//         "utin_prev_due_net_gold": netGold.value ?? 0.0,
//         "utin_prev_due_net_silver": netSilver.value ?? 0.0,
//         "utin_prev_due_net_stone": netStone.value ?? 0.0,
//
//
//         "utin_total_udhar": totalUdharDR.value, /// very important
//         "utin_total_advance": totalAdvanceCR.value, /// very important
//         "utin_udhar_remaining_amt": remainingUdhar.value, /// very important
//         "utin_advance_remaining_amt": remainingAdvance.value, /// very important
//         "utin_previous_amt": previousAmount.value, /// very important
//         "utin_previous_amt_crdr": netCashType.value, /// very important
//
//         "utin_cgst_amt": taxAmountResult.value / 2,
//         "utin_sgst_amt": taxAmountResult.value / 2,
//         "utin_cgst_per": double.tryParse(taxPercentCtrl.text)! / 2,
//         "utin_sgst_per": double.tryParse(taxPercentCtrl.text)! / 2,
//         "utin_igst_amt": "",
//         "utin_igst_per": "",
//
//         "utin_gd_qty": totalGoldQty.value,
//         "utin_gd_gs_wt": totalGoldGsWt.value,
//         "utin_gd_gs_wt_type": "GM",
//         "utin_gd_nt_wt_": totalGoldNetWt.value,
//         "utin_gd_nt_wt_type": "GM",
//         "utin_gd_fn_wt": summaryTotalGoldWt.value,
//         "utin_gd_fn_wt_type": "GM",
//         "utin_gd_ffn_wt": summaryTotalGoldWt.value,
//         "utin_gd_ffn_wt_type": "GM",
//
//
//         "utin_sl_qty": totalSilverQty.value,
//         "utin_sl_gs_wt": totalSilverGsWt.value,
//         "utin_sl_gs_wt_type": "GM",
//         "utin_sl_nt_wt_": totalSilverNetWt.value,
//         "utin_sl_nt_wt_type": "GM",
//         "utin_sl_fn_wt": summaryTotalSilverWt.value,
//         "utin_sl_fn_wt_type": "GM",
//         "utin_sl_ffn_wt": summaryTotalSilverWt.value,
//         "utin_sl_ffn_wt_type": "GM",
//
//
//         "utin_st_qty": totalStoneQty.value,
//         "utin_st_gs_wt": summaryTotalStoneWt.value,
//         "utin_st_gs_wt_type": "CT",
//         "utin_st_nt_wt_": summaryTotalStoneWt.value,
//         "utin_st_nt_wt_type": "CT",
//
//
//         "utin_gd_rate": goldAverageRatePer10Gram.value,
//         "utin_sl_rate": silverAverageRatePer10Gram.value,
//         "utin_st_rate": stoneAverageRatePerCT.value,
//
//         "utin_avg_gd_rate": goldAverageRatePer10Gram.value,
//         "utin_avg_sl_rate": silverAverageRatePer10Gram.value,
//         "utin_avg_st_rate": stoneAverageRatePerCT.value,
//
//         "utin_pay_cash_acc_id": transactionType1Controller.text,
//         "utin_pay_bank_acc_id": transactionType2Controller.text,
//         "utin_pay_card_acc_id": transactionType3Controller.text,
//         "utin_pay_online_acc_id": transactionType4Controller.text,
//
//         "utin_cash_detail": narration1Controller.text,
//         "utin_bank_detail": narration2Controller.text,
//         "utin_card_detail": narration3Controller.text,
//         "utin_online_detail": narration4Controller.text,
//
//         "utin_cash_amt_rec": double.tryParse(cashAmt1Controller.text) ?? 0,
//         "utin_bank_amt_rec": double.tryParse(cashAmt2Controller.text) ?? 0,
//         "utin_card_amt_rec": double.tryParse(cashAmt3Controller.text) ?? 0,
//         "utin_online_amt_rec": double.tryParse(cashAmt4Controller.text) ?? 0,
//
//         "utin_cash_balance_type": selectedPayableUser.value == "Amount Received from Customer" ? "RECEIVED" : "PAID",
//         "utin_cash_balance": finalCashBalanceValuation.value,
//
//
//         "utin_other_chgs" : totalOtherCharges.value, // FOR MAKING CHARGES - ALSO FOR JOURNAL ENTRY - IMPORTANT FOR JOURNAL ENTRY
//         "metal_receive": mappedMetalReceive
//       };
//       const encoder = JsonEncoder.withIndent('  ');
//       debugPrint(encoder.convert(data));
//
//       final response = await apiClient.post(
//         Uri.parse(ApiUrls.paymentApi),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode(data),
//       );
//
//       dynamic responseData;
//       try {
//         responseData = jsonDecode(response. body);
//       } catch (e) {
//         Get.snackbar('Error', 'Failed to parse response from server.',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//       if (response.statusCode == 201) {
//         final data =response.body;
//         if (responseData is Map && responseData['success'] == true) {
//           String successMessage = responseData['message'] ?? 'Invoice Created successfully.';
//
//           Get.snackbar('Success', successMessage, backgroundColor: Colors.green, colorText: Colors.white);
//           Get.toNamed(AppRoutes.sellReportsPage);
//         } else {
//           String failureMessage = responseData['message'] ?? 'Udhar addition failed.';
//           Get.snackbar('Failed', failureMessage, backgroundColor: Colors.red, colorText: Colors.white);
//         }
//       } else {
//         String errorMessage = 'Server error: Status ${response.statusCode}.';
//         if (responseData is Map && responseData.containsKey('message')) {errorMessage = responseData['message'];}
//         Get.snackbar('Failed', errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
//       }
//
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to add stock: $e', backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
// }