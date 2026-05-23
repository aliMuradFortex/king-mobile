import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';

import '../../../../core/widgets/custom_snackbar.dart';

class SetPinController extends GetxController {
  final RxString pin = ''.obs;
  final RxBool isLoading = false.obs;

  final ApiService _apiService = DioApiService();

  void addDigit(String digit) {
    if (pin.value.length < 4) {
      pin.value += digit;
    }
  }

  void removeDigit() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  void submitPin(BuildContext context) async {
    if (pin.value.length < 4) {
      CustomSnackBar.show(
        context,
        title: 'Incomplete PIN',
        message: 'Please enter a 4-digit security PIN.',
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await _apiService.setPin(pin.value);
      isLoading.value = false;

      final success = response['success'] as bool? ?? false;
      final message = response['message'] as String? ?? 'PIN set successfully.';

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
      CustomSnackBar.show(
        context,
        title: 'Error',
        message: e.toString(),
        isError: true,
      );
    }
  }
}
