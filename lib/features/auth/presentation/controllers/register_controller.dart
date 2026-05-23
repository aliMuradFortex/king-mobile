import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routing/app_router.dart';

class RegisterController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final RxString verificationMethod = 'SMS'.obs;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void setMethod(String method) {
    verificationMethod.value = method;
  }

  void submit() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your phone number to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );
      return;
    }
    
    // In a real application, this would trigger verification code dispatch.
    // Here we navigate to the home route as a successful flow.
    AppRouter.router.go('/home');
  }
}
