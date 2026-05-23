import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/splash_controller.dart';

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Obx(() => AnimatedOpacity(
          opacity: controller.footerOpacity.value,
          duration: const Duration(milliseconds: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rich Text for: Pakistan's Cheapest Installment Plan Platform
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: "Pakistan's "),
                      TextSpan(
                        text: "Cheapest",
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: AppColors.secondary.withValues(alpha: 0.4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const TextSpan(text: " Installment\nPlan Platform"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle: Secure. Transparent. Instant Approval.
              Text(
                AppStrings.splashSubTagline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ));
  }
}
