
/// API URLs configuration file for Flutter app

class ApiUrls {
  /// 🔹 Base URL
  // static const String baseUrl = "http://65.0.100.3:3000/api/";
  // static const String baseUrl2 = "http://65.0.100.3:3000/";
  static const String baseUrl = "https://stephine-unsplendid-unharshly.ngrok-free.dev/api/";
  static const String baseUrl2 = "https://stephine-unsplendid-unharshly.ngrok-free.dev/";


  /// 🔹 Auth Endpoints
  static const String login = "${baseUrl}auth/e-jeweller-login";
  static const String loginOtp = "${baseUrl}auth/e-jeweller-login-verify";
  static const String refreshToken = "${baseUrl}auth/refresh";



  /// 🔹 Firm Endpoints
  static const String firm = "${baseUrl}firm";

  /// 🔹 Stock Endpoints
  static const String stockTransactionsQuery = "${baseUrl}stock/transactions/query";
  static const String stockDetail = "${baseUrl}stock/";

  /// 🔹 Metal Rates Endpoints
  static const String metalRates = "${baseUrl}metal-rates";
  static const String metalRatesList = "${baseUrl}metal-rates/list";


  /// 🔹 Accounts Endpoints
  static const String accounts = "${baseUrl}accounts/query";

  /// 🔹 udhaar api
  static const String udharAdvanceList = "${baseUrl}udhaar/udhar-advance-list";
  static const String udharAdvanceDetail = "${baseUrl}udhaar/udhar-details";


  // E - commerce api
  static const String productListApi = "${baseUrl}e-jewellery/products/list";
  static const String productListDetail = "${baseUrl}e-jewellery/products/";


  /// eccomerce track user interactions api
  static const String interactionsLog = "${baseUrl}interactions/log";
  static const String interactionsDuration = "${baseUrl}interactions/update-duration";

}
