import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/splash_controller.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated Logo Container
        Obx(() => AnimatedScale(
              scale: controller.logoScale.value,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: controller.logoOpacity.value,
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.logo,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback icon if logo image fails to load
                        return const Icon(
                          Icons.phone_android_rounded,
                          size: 55,
                          color: AppColors.secondary,
                        );
                      },
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 28),
        // Animated App Title Text
        Obx(() => AnimatedOpacity(
              opacity: controller.textOpacity.value,
              duration: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  const Text(
                    'K I N G',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 6.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MOBILES',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
