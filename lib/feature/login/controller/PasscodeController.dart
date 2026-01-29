import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/controller/AppDataController.dart';
import '../../../routes/app_routes.dart';
import '../services/BiometricService.dart';

class PasscodeController extends GetxController {
  // Passcode storage key
  static const String _passcodeKey = 'local_app_passcode';

  // Dependencies
  final storage = GetStorage();
  final BiometricService biometricService = BiometricService();

  // Reactive state
  var isPasscodeSet = false.obs;
  var enteredPin = ''.obs;
  var isBiometricAvailable = false.obs;
  var isAuthenticating = false.obs;
  var isPinError = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPasscodeStatusAndBiometrics();
  }

  /// Checks if a passcode is already set in local storage
  void checkPasscodeStatusAndBiometrics() async {
    final userInfo = storage.read('userInfo');

    if (userInfo != null && userInfo['user'] != null) {
      final user = userInfo['user'];

      AppDataController.to.staffId.value = user['userId'];
      AppDataController.to.ids['ownerId'] = user['ownerId'];
      AppDataController.to.roles['staff_role'] = user['role'];

      print('🔁 Restored staffId from storage: ''${AppDataController.to.staffId.value}',);
    }

    final storedPasscode = storage.read(_passcodeKey);
    isPasscodeSet.value = storedPasscode != null && storedPasscode.length == 4;
    isBiometricAvailable.value = await biometricService.canCheckBiometrics();
  }

  /// Handles PIN input and validation on the login screen
  void handlePinInput(String pin) {
    if (isPinError.isTrue) {
      isPinError.value = false;
    }

    // Append the new digit
    if (enteredPin.value.length < 4) {
      enteredPin.value += pin;
      if (enteredPin.value.length == 4) {
        // Automatically attempt login after 4 digits
        validatePasscode();
      }
    }
  }

  /// Clears the last digit or the entire PIN
  void clearLastDigit() {
    if (enteredPin.value.isNotEmpty) {
      enteredPin.value = enteredPin.value.substring(0, enteredPin.value.length - 1);
    }
    if (isPinError.isTrue) {
      isPinError.value = false;
    }
  }

  /// Validates the entered PIN against the stored one
  void validatePasscode() {
    final storedPasscode = storage.read(_passcodeKey);
    if (enteredPin.value == storedPasscode) {
      // Passcode successful, navigate to the dashboard
      enteredPin.value = '';
      // Get.offAllNamed(AppRoutes.DashboardView);
      Get.offAllNamed(AppRoutes.MainNavigation);
    } else {
      // Passcode failed
      isPinError.value = true;
      enteredPin.value = '';
      Get.snackbar('Error', 'Invalid Passcode',
          backgroundColor: Colors.red.shade400, colorText: Colors.white);
    }
  }

  /// Handles the "Forget Passcode" flow (requires re-login)
  void forgotPasscode() {
    // 1. Clear local passcode
    storage.remove(_passcodeKey);
    isPasscodeSet.value = false;
    // 2. Clear user session (requires the user to re-login via API)
    storage.remove('isLoggedIn');
    storage.remove('userInfo');

    Get.offAllNamed(AppRoutes.LOGIN);
    Get.snackbar('Passcode Reset', 'Please log in again to set a new Passcode.',
        backgroundColor: Colors.blue.shade400, colorText: Colors.white);
  }


  // --- Passcode Creation/Modification Logic ---

  var newPasscode1 = ''.obs;
  var newPasscode2 = ''.obs;
  var isConfirming = false.obs;
  var creationMessage = 'Enter a 4-digit Passcode'.obs;

  void handleCreationPinInput(String pin) {
    if (isConfirming.isFalse) {
      // First PIN entry
      if (newPasscode1.value.length < 4) {
        newPasscode1.value += pin;
        if (newPasscode1.value.length == 4) {
          isConfirming.value = true;
          creationMessage.value = 'Confirm your 4-digit Passcode';
        }
      }
    } else {
      // Second (Confirmation) PIN entry
      if (newPasscode2.value.length < 4) {
        newPasscode2.value += pin;
        if (newPasscode2.value.length == 4) {
          attemptPasscodeCreation();
        }
      }
    }
  }

  void clearCreationLastDigit() {
    if (isConfirming.isFalse) {
      if (newPasscode1.value.isNotEmpty) {
        newPasscode1.value = newPasscode1.value.substring(0, newPasscode1.value.length - 1);
      }
    } else {
      if (newPasscode2.value.isNotEmpty) {
        newPasscode2.value = newPasscode2.value.substring(0, newPasscode2.value.length - 1);
        if (newPasscode2.value.isEmpty) {
          // Allow going back to first entry
          isConfirming.value = false;
          creationMessage.value = 'Enter a 4-digit Passcode';
        }
      }
    }
  }

  void attemptPasscodeCreation() {
    if (newPasscode1.value == newPasscode2.value) {
      // Match! Save the passcode.
      storage.write(_passcodeKey, newPasscode1.value);
      isPasscodeSet.value = true;

      Get.offAllNamed(AppRoutes.MainNavigation);
      Get.snackbar('Success', 'Passcode Set Successfully!',
          backgroundColor: Colors.green.shade400, colorText: Colors.white);

      // Reset fields
      newPasscode1.value = '';
      newPasscode2.value = '';
      isConfirming.value = false;
      creationMessage.value = 'Enter a 4-digit Passcode';

    } else {
      // No match
      Get.snackbar('Error', 'Passcodes do not match. Please try again.',
          backgroundColor: Colors.red.shade400, colorText: Colors.white);

      // Reset for re-entry
      newPasscode1.value = '';
      newPasscode2.value = '';
      isConfirming.value = false;
      creationMessage.value = 'Enter a 4-digit Passcode';
    }
  }

  // --- Biometric Authentication ---

  Future<void> authenticateWithBiometrics() async {
    isAuthenticating.value = true;
    final isAuthenticated = await biometricService.authenticate();
    isAuthenticating.value = false;

    if (isAuthenticated) {
      Get.offAllNamed(AppRoutes.MainNavigation);
     } else {
      Get.snackbar('Authentication Failed', 'Please enter your 4-digit Passcode.',
          backgroundColor: Colors.red.shade400, colorText: Colors.white);
    }
  }
}