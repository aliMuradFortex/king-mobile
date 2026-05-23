import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SetNewPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final RxBool hasMinLength = false.obs;
  final RxBool hasNumber = false.obs;
  final RxBool hasSpecialChar = false.obs;

  final RxString passwordStrength = 'WEAK'.obs;
  final RxDouble strengthProgress = 0.33.obs;
  final Rx<Color> strengthColor = const Color(0xFFD97706).obs; // Weak Amber

  @override
  void onInit() {
    super.onInit();
    passwordController.addListener(() {
      checkPassword(passwordController.text);
    });
  }

  void checkPassword(String val) {
    hasMinLength.value = val.length >= 8;
    hasNumber.value = val.contains(RegExp(r'[0-9]'));
    hasSpecialChar.value = val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_#\-+=[]\/~`|]'));

    int score = 0;
    if (hasMinLength.value) score++;
    if (hasNumber.value) score++;
    if (hasSpecialChar.value) score++;

    if (score <= 1) {
      passwordStrength.value = 'WEAK';
      strengthProgress.value = 0.33;
      strengthColor.value = const Color(0xFFD97706);
    } else if (score == 2) {
      passwordStrength.value = 'MEDIUM';
      strengthProgress.value = 0.66;
      strengthColor.value = Colors.orange;
    } else {
      passwordStrength.value = 'STRONG';
      strengthProgress.value = 1.0;
      strengthColor.value = const Color(0xFF10B981);
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void handleContinue(BuildContext context) {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Please fill in both password fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Mismatch',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    if (!hasMinLength.value || !hasNumber.value || !hasSpecialChar.value) {
      Get.snackbar(
        'Weak Password',
        'Password does not meet all security checklist items.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    // Success dialog & Navigate to home/profile
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 28),
              SizedBox(width: 12),
              Text(
                'Success',
                style: TextStyle(
                  color: Color(0xFF001E40),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text('Your new password has been set successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Pop back to home profile tab
                context.go('/home');
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Color(0xFF001E40),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
