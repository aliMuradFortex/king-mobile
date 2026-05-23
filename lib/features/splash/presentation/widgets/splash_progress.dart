import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashProgress extends StatelessWidget {
  const SplashProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SplashController>();

    return Obx(() {
      final progressVal = controller.progress.value;

      return Container(
        width: 220,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // The loading progress fill
            FractionallySizedBox(
              widthFactor: progressVal,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.progressGradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
