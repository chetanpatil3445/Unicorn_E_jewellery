import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'controller/NotificationController.dart';
import 'controller/DrawerController.dart' as drawer_controller;



 class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<drawer_controller.CustomDrawerController>(() => drawer_controller.CustomDrawerController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

