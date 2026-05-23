import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class ForgotPasswordVerifyController extends GetxController {
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  
  final RxInt timerSeconds = 59.obs;
  Timer? _timer;
  final RxString flow = 'recovery'.obs;
  final RxString phone = ''.obs;
  final RxBool isLoading = false.obs;

  final ApiService _apiService = DioApiService();

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

  void resendOtp(BuildContext context) async {
    if (flow.value == 'registration' && phone.value.isNotEmpty) {
      try {
        isLoading.value = true;
        await _apiService.sendOtp(phone.value);
        isLoading.value = false;
        startTimer();
        CustomSnackBar.show(
          context,
          title: 'OTP Resent',
          message: 'A new verification code has been sent.',
          isError: false,
        );
      } catch (e) {
        isLoading.value = false;
        CustomSnackBar.show(
          context,
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    } else {
      startTimer();
      CustomSnackBar.show(
        context,
        title: 'OTP Resent',
        message: 'A new verification code has been sent.',
        isError: false,
      );
    }
  }

  void onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
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

  void verifyCode(BuildContext context) async {
    final code = controllers.map((c) => c.text).join();
    if (code.length < 6) {
      CustomSnackBar.show(
        context,
        title: 'Invalid Code',
        message: 'Please enter the full 6-digit code.',
        isError: true,
      );
      return;
    }

    if (flow.value == 'registration') {
      try {
        isLoading.value = true;
        final response = await _apiService.verifyOtp(phone.value, code);
        isLoading.value = false;

        final success = response['success'] as bool? ?? false;
        final message = response['message'] as String? ?? 'OTP verified successfully.';
        final data = response['data'] as Map<String, dynamic>?;

        if (success && data != null) {
          final token = data['token'] as String?;
          if (token != null) {
            await SecureStorageService.instance.saveToken(token);
          }

          CustomSnackBar.show(
            context,
            title: 'Success',
            message: message,
            isError: false,
          );

          // Route to Set PIN screen
          if (context.mounted) {
            context.push('/set-pin');
          }
        } else {
          CustomSnackBar.show(
            context,
            title: 'Verification Failed',
            message: message,
            isError: true,
          );
        }
      } catch (e) {
        isLoading.value = false;
        CustomSnackBar.show(
          context,
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    } else {
      // Go to verification complete screen with flow parameter (recovery flow)
      if (context.mounted) {
        context.push('/verification-complete?flow=${flow.value}');
      }
    }
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
