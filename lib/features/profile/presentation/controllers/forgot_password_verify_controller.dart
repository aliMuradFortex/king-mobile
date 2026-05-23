import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordVerifyController extends GetxController {
  final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  
  final RxInt timerSeconds = 59.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timerSeconds.value = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void resendOtp() {
    startTimer();
    Get.snackbar(
      'OTP Resent',
      'A new verification code has been sent.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF001E40),
      colorText: Colors.white,
    );
  }

  void onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  void verifyCode(BuildContext context) {
    final code = controllers.map((c) => c.text).join();
    if (code.length < 4) {
      Get.snackbar(
        'Invalid Code',
        'Please enter the full 4-digit code.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    // Go to verification complete screen
    context.push('/verification-complete');
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
