import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class ProfileController extends GetxController {
  final RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiService _apiService = DioApiService();

  @override
  void onInit() {
    super.onInit();
    _fetchProfileIfTokenExists();
  }

  Future<void> _fetchProfileIfTokenExists() async {
    final token = await SecureStorageService.instance.getToken();
    if (token != null && token.isNotEmpty) {
      await fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.getProfile();
      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        profileData.value = response['data'] as Map<String, dynamic>;
      } else {
        errorMessage.value =
            response['message'] as String? ?? 'Failed to load profile.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    String? localImagePath,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      String? serverImagePath;
      if (localImagePath != null && localImagePath.isNotEmpty) {
        // First step: upload the image to /upload
        final uploadResponse = await _apiService.uploadSingleFile(
          localImagePath,
          'cnic_images',
        );
        final uploadSuccess = uploadResponse['success'] as bool? ?? false;
        if (uploadSuccess && uploadResponse['data'] != null) {
          final uploadData = uploadResponse['data'] as Map<String, dynamic>;
          serverImagePath = uploadData['path'] as String?;
        } else {
          throw Exception(uploadResponse['message'] ?? 'Image upload failed.');
        }
      }

      // Second step: call update profile API
      final response = await _apiService.updateProfile(name, serverImagePath);
      final success = response['success'] as bool? ?? false;
      if (success) {
        if (context.mounted) {
          CustomSnackBar.show(
            context,
            title: 'Profile Updated',
            message: 'Your profile has been updated successfully.',
            isError: false,
          );
        }
        // Reload details
        await fetchProfile();
        if (context.mounted) {
          Navigator.of(context).pop(); // Go back
        }
      } else {
        errorMessage.value =
            response['message'] as String? ?? 'Failed to update profile.';
        if (context.mounted) {
          CustomSnackBar.show(
            context,
            title: 'Update Failed',
            message: errorMessage.value,
            isError: true,
          );
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
