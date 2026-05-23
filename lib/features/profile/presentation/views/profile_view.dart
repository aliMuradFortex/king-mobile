import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../controllers/profile_settings_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    Get.put(ProfileSettingsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => homeController.updateTab(0), // Back to home dashboard
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
          AppStrings.myProfileTitle,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // 1. Large Circle Avatar with Verified gold Badge overlay
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF1F5F9),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.person,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.account_circle,
                                size: 120,
                                color: AppColors.textMuted,
                              ),
                        ),
                      ),
                    ),

                    // Verified gold checkmark badge
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCD34D), // Gold badge color
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          AppAssets.profileCheck,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.check_rounded,
                                color: AppColors.primary,
                                size: 16,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Name and Phone
              Center(
                child: Column(
                  children: [
                    const Text(
                      AppStrings.profileUserName,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.profileUserPhone,
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 3. Menu list enclosed in a light gray rounded card container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Edit Profile
                    _buildMenuItem(
                      iconPath: AppAssets.editProfile,
                      title: AppStrings.editProfileLabel,
                      fallbackIcon: Icons.edit_rounded,
                      onTap: () {
                        // Action for Edit Profile
                      },
                    ),
                    const SizedBox(height: 12),

                    // My Plans (Dark Navy Blue special banner item)
                    InkWell(
                      onTap: () {
                        homeController.updateTab(2); // Jump to Plans tab
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // White plans icon circular box
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                AppAssets.navPlansActive,
                                color: Colors.white,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.assignment_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    AppStrings.myPlansLabel,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    AppStrings.myPlansSubLabel,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // White chevron icon
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Recover Account
                    _buildMenuItem(
                      iconPath: AppAssets.recoverAccount,
                      title: AppStrings.recoverAccountLabel,
                      fallbackIcon: Icons.shield_outlined,
                      onTap: () => context.push('/recover-account'),
                    ),
                    const SizedBox(height: 12),

                    // Help & Support (Tapping this opens settings page per mockup rules)
                    _buildMenuItem(
                      iconPath: AppAssets.helpAndSupport,
                      title: AppStrings.helpAndSupportLabel,
                      fallbackIcon: Icons.help_outline_rounded,
                      onTap: () => context.push('/profile-settings'),
                    ),
                    const SizedBox(height: 12),

                    // Logout (Styled in Red)
                    _buildLogoutItem(context),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required IconData fallbackIcon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon circular box
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(9),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(fallbackIcon, color: AppColors.primary, size: 20),
              ),
            ),
            const SizedBox(width: 14),

            // Text Label
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Slate Gray trailing arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    final controller = Get.find<ProfileSettingsController>();
    return InkWell(
      onTap: () {
        // Pop dialog or route to register
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => Obx(() {
            final isLoading = controller.isLoading.value;
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => controller.logout(dialogContext),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        )
                      : const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                ),
              ],
            );
          }),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Light red icon box
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2), // Light red bg
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(9),
              child: Image.asset(
                AppAssets.logout,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Text Label in red
            const Expanded(
              child: Text(
                AppStrings.logoutLabel,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
