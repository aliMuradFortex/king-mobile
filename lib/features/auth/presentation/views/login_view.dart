import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/login_controller.dart';
import '../widgets/phone_input_field.dart';

class LoginView extends StatelessWidget {
  final String? phone;
  const LoginView({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    if (phone != null && phone!.isNotEmpty && controller.phoneController.text.isEmpty) {
      controller.phoneController.text = phone!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            // Navigate back
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top Logo Circle
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Image.asset(
                        AppAssets.logo,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.phone_android_rounded,
                            size: 36,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // 2. Welcome Title
                const Text(
                  'Welcome Back to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'King Mobiles',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryDark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                // 3. Subtitle
                Text(
                  'Enter your registered phone number and PIN to access your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 36),
                
                // 4. Phone Number Section Label
                Text(
                  AppStrings.phoneLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                
                // 5. Phone Input Field
                PhoneInputField(controller: controller.phoneController),
                const SizedBox(height: 24),
                
                // 6. Password Label
                Text(
                  'PASSWORD',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                
                // 7. Password Input Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() => TextField(
                          controller: controller.pinController,
                          keyboardType: TextInputType.text,
                          obscureText: controller.isPinObscured.value,
                          obscuringCharacter: '•',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: controller.isPinObscured.value ? 2.0 : 1.0,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 1.0,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        )),
                      ),
                      Obx(() => IconButton(
                        icon: Icon(
                          controller.isPinObscured.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        onPressed: controller.togglePinVisibility,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                
                // 8. Sign In Button
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                )),
                const SizedBox(height: 24),
                
                // 9. Don't have an account / Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.push('/register');
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: AppColors.secondaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
