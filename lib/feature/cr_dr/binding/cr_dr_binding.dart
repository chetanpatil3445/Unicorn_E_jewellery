import 'package:get/get.dart';
import '../controller/cr_dr_controller.dart';

class CrDrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CrDrController());
  }
}

