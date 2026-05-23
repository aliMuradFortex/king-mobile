import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';

class VerificationCompletedView extends StatelessWidget {
  final String flow;

  const VerificationCompletedView({
    super.key,
    required this.flow,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevent navigation backtracking
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Success Illustration
                    Center(
                      child:   Image.asset(
                          AppAssets.verificationCompleted,
                          fit: BoxFit.contain,
                          height: 220,
                          width: 260,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF10B981),
                            size: 60,
                          ),
                      )),
                      
                    const SizedBox(height: 36),
                    
                    // 2. Titles
                    const Text(
                      AppStrings.verificationCompletedTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        flow == 'registration'
                            ? 'Your phone number has been verified successfully. Let\'s explore flexible installment plans.'
                            : AppStrings.verificationCompletedDesc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 3. Continue to Set Password Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (flow == 'registration') {
                      context.go('/login');
                    } else {
                      context.push('/set-new-password');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        AppStrings.continueText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
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
