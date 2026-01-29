import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'controller/PasscodeController.dart';
import 'controller/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
class PasscodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PasscodeController>(PasscodeController());
  }
}

