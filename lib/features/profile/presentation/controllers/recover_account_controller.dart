import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class RecoverAccountController extends GetxController {
  final phoneController = TextEditingController();

  void handleContinue(BuildContext context) {
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter your phone number to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }
    
    Get.snackbar(
      'Recovery Initialized',
      'A 4-digit OTP has been sent to +92 $phoneNumber',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF001E40),
      colorText: Colors.white,
    );

    context.push('/verify-phone?flow=recovery');
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
