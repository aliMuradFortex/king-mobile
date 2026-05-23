import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/forgot_password_verify_controller.dart';

class ForgotPasswordVerifyView extends StatelessWidget {
  final String flow;
  final String? phone;

  const ForgotPasswordVerifyView({
    super.key,
    required this.flow,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordVerifyController());
    controller.flow.value = flow;
    if (phone != null) {
      controller.phone.value = phone!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ),
        title: const Text(
          AppStrings.recoverAccountTitle,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    
                    // 1. Center Wireless Antenna Icon (matches Mockup)
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F0F8), // Light blue base
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sensors_rounded, // Antenna/wireless representation
                          color: Color(0xFF0F3A5F),
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    // 2. Title & Description
                    const Text(
                      'Verify Your Number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Enter the 6-digit code sent to ${controller.phone.value.isNotEmpty ? controller.phone.value : "+92 3XX XXXXXXX"}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF0F3A5F), // Slate/Navy color matching mockup
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    )),
                    const SizedBox(height: 36),
                    
                    // 3. OTP 6-Circle Fields Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: TextField(
                              controller: controller.controllers[index],
                              focusNode: controller.focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: '•',
                                hintStyle: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (value) => controller.onDigitChanged(index, value),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 36),
                    
                    // 4. Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () => controller.verifyCode(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
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
                            : const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                    ),
                    const SizedBox(height: 28),
                    
                    // 5. Timer with Clock Icon
                    Obx(() {
                      final seconds = controller.timerSeconds.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFF855D11), // Goldish timer icon
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Resend code in 00:${seconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Color(0xFF855D11),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 14),
                    
                    // 6. Resend OTP Link
                    Obx(() {
                      final seconds = controller.timerSeconds.value;
                      return Center(
                        child: TextButton(
                          onPressed: seconds > 0 ? null : () => controller.resendOtp(context),
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: seconds > 0 ? Colors.grey.shade400 : AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    
                    // 7. Change Phone Number Link
                    Center(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Change Phone Number',
                            style: TextStyle(
                              color: Color(0xFF0F3A5F),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
