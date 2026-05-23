import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_snackbar.dart';

class RecoverAccountController extends GetxController {
  final phoneController = TextEditingController();

  void handleContinue(BuildContext context) {
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      CustomSnackBar.show(
        context,
        title: 'Required Field',
        message: 'Please enter your phone number to continue.',
        isError: true,
      );
      return;
    }
    
    CustomSnackBar.show(
      context,
      title: 'Recovery Initialized',
      message: 'A 4-digit OTP has been sent to +92 $phoneNumber',
      isError: false,
    );

    context.push('/verify-phone?flow=recovery');
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
