import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/register_controller.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/verification_method_card.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller into Get dependency manager
    final controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            // Navigate back to onboarding (placeholder for user backtracking)
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
                Text(
                  AppStrings.welcomeTitlePart1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                ),
                Text(
                  AppStrings.welcomeTitlePart2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryDark,
                        fontSize: 28,
                      ),
                ),
                const SizedBox(height: 12),
                
                // 3. Subtitle
                Text(
                  AppStrings.registerSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                
                // 5. Custom Phone Input Field
                PhoneInputField(controller: controller.phoneController),
                const SizedBox(height: 28),
                
                // 6. Verification Code Section Label
                Text(
                  AppStrings.receiveCodeLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                
                // 7. Method Choice Cards (SMS vs WhatsApp)
                Obx(() {
                  final isSMS = controller.verificationMethod.value == 'SMS';
                  
                  return Row(
                    children: [
                      VerificationMethodCard(
                        title: AppStrings.receiveViaSMS,
                        iconPath: AppAssets.sms,
                        isSelected: isSMS,
                        onTap: () => controller.setMethod('SMS'),
                      ),
                      const SizedBox(width: 16),
                      VerificationMethodCard(
                        title: AppStrings.receiveViaWhatsApp,
                        iconPath: AppAssets.whatsapp,
                        isSelected: !isSMS,
                        onTap: () => controller.setMethod('WhatsApp'),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 48),
                
                ElevatedButton(
                  onPressed: () => controller.submit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.continueText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
