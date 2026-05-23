import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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

  void submit(BuildContext context) {
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
    
    // Route to verification screen under the registration flow
    context.push('/verify-phone?flow=registration');
  }
}
