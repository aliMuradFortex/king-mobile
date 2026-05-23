import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingPageWidget extends StatelessWidget {
  final int pageIndex;
  final String imagePath;
  final String title;
  final Widget sheetContent;

  const OnboardingPageWidget({
    super.key,
    required this.pageIndex,
    required this.imagePath,
    required this.title,
    required this.sheetContent,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Header containing Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    AppStrings.skip,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMuted.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ),
            
            // 2. Illustration Image
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // 3. Central Title under the image
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.8,
                ),
              ),
            ),
            
            // 4. White Bottom Sheet Container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: 4,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Render custom sheet content (different for Page 1 & Page 2)
                      sheetContent,
                      
                      const SizedBox(height: 32),
                      
                      // Row with Page Indicators & Nav Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dots Page Indicators
                          Row(
                            children: List.generate(2, (index) {
                              return Obx(() {
                                final isActive = controller.currentPage.value == index;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 8),
                                  width: isActive ? 24 : 8,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? AppColors.primary
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                );
                              });
                            }),
                          ),
                          
                          // Navigation Button
                          ElevatedButton(
                            onPressed: controller.nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              padding: EdgeInsets.symmetric(
                                horizontal: pageIndex == 0 ? 28 : 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: pageIndex == 0
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppStrings.next,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  )
                                : const Text(
                                    AppStrings.getStarted,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
