import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class SetPinController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordObscured = true.obs;
  final RxBool isLoading = false.obs;

  final ApiService _apiService = DioApiService();

  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  void submitPin(BuildContext context) async {
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      CustomSnackBar.show(
        context,
        title: 'Required',
        message: 'Please enter a password to continue.',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.setPin(password);
      isLoading.value = false;

      if (!context.mounted) return;

      final success = response['success'] as bool? ?? false;
      final message = response['message'] as String? ?? 'Password set successfully.';

      if (success) {
        CustomSnackBar.show(
          context,
          title: 'Success',
          message: message,
          isError: false,
        );
        // Navigate to verification completed screen for registration flow
        if (context.mounted) {
          context.push('/verification-complete?flow=registration');
        }
      } else {
        CustomSnackBar.show(
          context,
          title: 'Failed',
          message: message,
          isError: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    }
  }
}
