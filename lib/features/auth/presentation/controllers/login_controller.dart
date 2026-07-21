import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';
import '../../../../core/services/secure_storage_service.dart';

import '../../../../core/widgets/custom_snackbar.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isPinObscured = true.obs;

  final ApiService _apiService = DioApiService();

  @override
  void onClose() {
    phoneController.dispose();
    pinController.dispose();
    super.onClose();
  }

  void togglePinVisibility() {
    isPinObscured.value = !isPinObscured.value;
  }

  void login(BuildContext context) async {
    final phone = phoneController.text.trim();
    final pin = pinController.text.trim();

    if (phone.isEmpty) {
      CustomSnackBar.show(
        context,
        title: 'Required',
        message: 'Please enter your phone number to continue.',
        isError: true,
      );
      return;
    }

    if (pin.isEmpty) {
      CustomSnackBar.show(
        context,
        title: 'Required',
        message: 'Please enter your password.',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.login(phone, pin);
      isLoading.value = false;

      if (!context.mounted) return;

      final success = response['success'] as bool? ?? false;
      final message =
          response['message'] as String? ?? 'Logged in successfully.';
      final data = response['data'] as Map<String, dynamic>?;

      if (success && data != null) {
        final token = data['token'] as String?;
        if (token != null) {
          await SecureStorageService.instance.saveToken(token);
          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().fetchProfile();
          }
        }

        CustomSnackBar.show(
          context,
          title: 'Welcome Back',
          message: message,
          isError: false,
        );

        // Go to home screen
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        CustomSnackBar.show(
          context,
          title: 'Login Failed',
          message: message,
          isError: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          title: 'Login Error',
          message: e.toString(),
          isError: true,
        );
      }
    }
  }
}
