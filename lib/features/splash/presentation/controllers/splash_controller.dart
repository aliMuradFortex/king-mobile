import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/secure_storage_service.dart';

class SplashController extends GetxController {
  // Reactive animation states
  final RxDouble logoScale = 0.5.obs;
  final RxDouble logoOpacity = 0.0.obs;
  final RxDouble textOpacity = 0.0.obs;
  final RxDouble badgeOpacity = 0.0.obs;
  final RxDouble footerOpacity = 0.0.obs;
  final RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimations();
  }

  void _startAnimations() async {
    // 1. Logo Scale and Opacity
    await Future.delayed(const Duration(milliseconds: 200));
    logoScale.value = 1.0;
    logoOpacity.value = 1.0;

    // 2. Text / Title Opacity
    await Future.delayed(const Duration(milliseconds: 400));
    textOpacity.value = 1.0;

    // 3. Badge Opacity
    await Future.delayed(const Duration(milliseconds: 300));
    badgeOpacity.value = 1.0;

    // 4. Footer Opacity
    await Future.delayed(const Duration(milliseconds: 200));
    footerOpacity.value = 1.0;

    // 5. Progress Bar Filling up (simulating loading)
    _startProgressBar();
  }

  void _startProgressBar() {
    const Duration stepDuration = Duration(milliseconds: 20); // 20ms * 100 = 2 seconds total progress

    Timer.periodic(stepDuration, (timer) {
      if (progress.value >= 1.0) {
        timer.cancel();
        _determineNextScreen();
      } else {
        progress.value += 0.01;
      }
    });
  }

  void _determineNextScreen() async {
    // Hold at 100% progress briefly for smoothness
    await Future.delayed(const Duration(milliseconds: 400));
    
    final storage = SecureStorageService.instance;
    final String? onboardingSeen = await storage.read('onboarding_seen');
    
    if (onboardingSeen != 'true') {
      AppRouter.router.go('/onboarding');
      return;
    }

    final String? token = await storage.getToken();
    if (token != null && token.isNotEmpty) {
      AppRouter.router.go('/home');
    } else {
      AppRouter.router.go('/login');
    }
  }
}
