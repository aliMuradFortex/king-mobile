import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';
import '../../../../core/services/secure_storage_service.dart';

import '../../../../core/widgets/custom_snackbar.dart';

class RegisterController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final RxString verificationMethod = 'SMS'.obs;
  final RxBool isLoading = false.obs;

  final ApiService _apiService = DioApiService();

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void setMethod(String method) {
    verificationMethod.value = method;
  }

  void submit(BuildContext context) async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      CustomSnackBar.show(
        context,
        title: 'Required',
        message: 'Please enter your phone number to continue.',
        isError: true,
      );
      return;
    }
    
    try {
      isLoading.value = true;
      final response = await _apiService.sendOtp(phone);
      isLoading.value = false;

      if (!context.mounted) return;

      final success = response['success'] as bool? ?? false;
      final message = response['message'] as String? ?? 'OTP sent successfully.';
      final data = response['data'] as Map<String, dynamic>?;

      if (success) {
        CustomSnackBar.show(
          context,
          title: 'Success',
          message: message,
          isError: false,
        );
        
        final otpRequired = data?['otp_required'] as bool? ?? true;
        final isSuperUser = data?['is_super_user'] as bool? ?? false;
        final hasPassword = data?['has_password'] as bool? ?? false;

        // Save status to SecureStorage
        await SecureStorageService.instance.write('is_super_user', isSuperUser.toString());
        await SecureStorageService.instance.write('has_password', hasPassword.toString());

        if (isSuperUser && hasPassword) {
          final token = data?['token'] as String?;
          if (token != null) {
            await SecureStorageService.instance.saveToken(token);
          }
          if (context.mounted) {
            context.go('/login?phone=$phone');
          }
        } else if (!otpRequired) {
          final token = data?['token'] as String?;
          if (token != null) {
            await SecureStorageService.instance.saveToken(token);
          }
          if (context.mounted) {
            context.push('/set-pin');
          }
        } else {
          // Route to verification screen under the registration flow, passing phone
          if (context.mounted) {
            context.push('/verify-phone?flow=registration&phone=$phone');
          }
        }
      } else {
        CustomSnackBar.show(
          context,
          title: 'Error',
          message: message,
          isError: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          title: 'Connection Error',
          message: e.toString(),
          isError: true,
        );
      }
    }
  }
}
