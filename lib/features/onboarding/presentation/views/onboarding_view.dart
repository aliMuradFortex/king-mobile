import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_widget.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller into Get dependency manager
    final controller = Get.put(OnboardingController());

    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.updatePage,
      children: [
        // Page 1: 0% Markup Plan
        OnboardingPageWidget(
          pageIndex: 0,
          imagePath: AppAssets.onboarding1,
          title: AppStrings.onboarding1Title,
          sheetContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rich Title: Affordable Mobile Shopping
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                  children: const [
                    TextSpan(text: 'Affordable '),
                    TextSpan(
                      text: 'Mobile',
                      style: TextStyle(color: AppColors.secondaryDark),
                    ),
                    TextSpan(text: ' Shopping'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Bullet lists
              _buildBulletItem(context, '03', AppStrings.onboarding1Bullet03),
              const SizedBox(height: 12),
              _buildBulletItem(context, '06', AppStrings.onboarding1Bullet06),
              const SizedBox(height: 12),
              _buildBulletItem(context, '12', AppStrings.onboarding1Bullet12),
            ],
          ),
        ),

        // Page 2: Simple Application Process
        OnboardingPageWidget(
          pageIndex: 1,
          imagePath: AppAssets.onboarding2,
          title: AppStrings.onboarding2Title,
          sheetContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rich Title: Simple Application Process.
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                  children: const [
                    TextSpan(text: 'Simple '),
                    TextSpan(
                      text: 'Application',
                      style: TextStyle(color: AppColors.secondaryDark),
                    ),
                    TextSpan(text: ' Process.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle description
              Text(
                AppStrings.onboarding2SheetSub,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletItem(BuildContext context, String number, String text) {
    return Row(
      children: [
        const Text(
          '•  ',
          style: TextStyle(
            color: AppColors.secondaryDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$number ',
          style: const TextStyle(
            color: AppColors.secondaryDark,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
