import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unicorn_e_jewellers/routes/app_pages.dart';
import 'Routes/app_routes.dart';
import 'core/controller/AppDataController.dart';


void main() async {
  Get.put(AppDataController(), permanent: true);
  WidgetsFlutterBinding.ensureInitialized();
  disableSSLCertValidation();
  await GetStorage.init();
  runApp(const MyApp());
}

// Function to disable SSL certificate validation (use with caution)
void disableSSLCertValidation() {
  HttpOverrides.global = MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Unicorn Billing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
