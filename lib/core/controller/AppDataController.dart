import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppDataController extends GetxController {
  // Use RxnInt for nullable reactive integers
  RxnInt userId = RxnInt();
  RxnString userName = RxnString();
  RxnString staffName = RxnString();
  RxnString expiryCheck = RxnString();
  RxnString expiryDate = RxnString();
  RxnInt firmID = RxnInt();
  RxnInt staffId = RxnInt();
  RxnInt ownerId = RxnInt();
  RxnInt sellUserId = RxnInt();


  // Store multiple dynamic IDs if needed
  RxMap<String, int> ids = <String, int>{}.obs;

  static AppDataController get to => Get.find();

  void setId(String key, int id) {
    ids[key] = id;
  }
  int? getId(String key) {
    return ids[key];
  }
  void removeId(String key) {
    ids.remove(key);
  }

  RxMap<String, String> roles = <String, String>{}.obs;

  void setValues(String key, String id) {
    roles[key] = id;
  }

  String? getValues(String key) {
    return roles[key];
  }

  void removeValues(String key) {
    roles.remove(key);
  }
}



// // Set selected user
// AppDataController.to.userId.value = 42;
//
// // Set staff ID
// AppDataController.to.staffId.value = 10;
//
// // Set sell user ID
// AppDataController.to.sellUserId.value = 55;
//
// int? selectedUserId = AppDataController.to.userId.value;
//
// // Or using ids map
// int? selectedUserIdFromMap = AppDataController.to.getId('user_id');


// // Set any ID by key
// AppDataController.to.setId('user_id', 42);
// AppDataController.to.setId('staff_id', 10);
//
// // Get the ID
// int? selectedUserId = AppDataController.to.getId('user_id');
// int? selectedStaffId = AppDataController.to.getId('staff_id');


