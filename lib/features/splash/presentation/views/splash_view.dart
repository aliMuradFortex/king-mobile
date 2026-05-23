import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/splash_controller.dart';
import '../widgets/splash_logo.dart';
import '../widgets/splash_badge.dart';
import '../widgets/splash_progress.dart';
import '../widgets/splash_footer.dart';
import '../../../../core/theme/app_theme.dart';
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject SplashController into GetX dependency manager
    // This will trigger onInit() automatically and start the animations
    Get.put(SplashController());

    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        body: Stack(
          children: [
          // 1. Background Image with covering fit
          Positioned.fill(
            child: Image.asset(
              AppAssets.splashBackground,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback solid gradient if background image fails to load
                return Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.splashGradient,
                  ),
                );
              },
            ),
          ),
          
          // 2. Premium Dark Navy Gradient Overlay to ensure readable contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.85),
                    AppColors.background.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),
          
          // 3. Foreground content
          const SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(flex: 3),
                  
                  // Centered Logo & Brand Name
                  SplashLogo(),
                  
                  SizedBox(height: 24),
                  
                  // Authorized Sovereign Retailer Badge
                  SplashBadge(),
                  
                  Spacer(flex: 2),
                  
                  // Loading progress bar
                  SplashProgress(),
                  
                  Spacer(flex: 2),
                  
                  // Footer platform tagging
                  SplashFooter(),
                  
                  SizedBox(height: 24),
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
