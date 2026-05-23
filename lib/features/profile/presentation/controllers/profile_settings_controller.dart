import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class ProfileSettingsController extends GetxController {
  final RxBool biometricsEnabled = true.obs;
  final RxBool isLoading = false.obs;

  final ApiService _apiService = DioApiService();

  void toggleBiometrics(bool value) {
    biometricsEnabled.value = value;
  }

  Future<void> logout(BuildContext context) async {
    try {
      isLoading.value = true;
      await _apiService.logout();
    } catch (e) {
      debugPrint('Logout API error: $e');
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          title: 'Logout Info',
          message: 'Session cleared locally.',
          isError: false,
        );
      }
    } finally {
      await SecureStorageService.instance.clearToken();
      isLoading.value = false;
      if (context.mounted) {
        Navigator.of(context).pop();
        context.go('/login');
      }
    }
  }
}
