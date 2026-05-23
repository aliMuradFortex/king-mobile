import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/secure_storage_service.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void updatePage(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value == 0) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      skip();
    }
  }

  void skip() async {
    await SecureStorageService.instance.write('onboarding_seen', 'true');
    AppRouter.router.go('/login');
  }
}
