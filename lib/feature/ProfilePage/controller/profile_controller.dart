import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/jwt_helper.dart';
import '../../../Routes/app_routes.dart';

class ProfileController extends GetxController {
  final storage = GetStorage();

  final userName = ''.obs;
  final email = ''.obs;
  final role = ''.obs;
  final userImageUrl = ''.obs;
  final initials = ''.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final storedData = storage.read('userInfo') ?? {};
    final user = storedData['user'] ?? {};

    userName.value = user['name'] ?? 'Guest User';
    email.value = user['email'] ?? 'guest@example.com';
    role.value = user['role'] ?? 'Not Set';
    userImageUrl.value = user['userImageUrl'] ?? '';

    initials.value = _getInitials(userName.value);
  }

  String _getInitials(String fullName) {
    fullName = fullName.trim();
    if (fullName.isEmpty) return 'GU';

    final parts = fullName.split(' ').where((e) => e.isNotEmpty).toList();

    if (parts.length > 1) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  void openWishlist() => Get.toNamed(AppRoutes.wishlist);

  void openOrders() => Get.toNamed(AppRoutes.wishlist);

  void openEditProfile() => Get.toNamed(AppRoutes.wishlist);

  void logout() => JwtHelper.Logout();
}
