import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/profile_settings_controller.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject or find settings controller
    final controller = Get.put(ProfileSettingsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Mini Profile Header
              _buildMiniHeader(),
              const SizedBox(height: 24),

              // 2. Account Settings Section
              _buildSectionHeader(AppStrings.accountSettingsSection),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.person_outline_rounded,
                      title: AppStrings.settingsProfile,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.lock_outline_rounded,
                      title: AppStrings.settingsPassword,
                      onTap: () => context.push('/set-new-password'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.payment_rounded,
                      title: AppStrings.settingsPaymentMethods,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Preferences Section
              _buildSectionHeader(AppStrings.preferencesSection),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.notifications_none_rounded,
                      title: AppStrings.settingsNotifications,
                      onTap: () => context.push('/notifications'),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.language_rounded,
                      title: AppStrings.settingsLanguage,
                      subtitle: AppStrings.settingsLanguageSub,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Security Section
              _buildSectionHeader(AppStrings.securitySection),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    // Biometrics toggle switch item
                    Obx(() {
                      return _buildSwitchItem(
                        icon: Icons.fingerprint_rounded,
                        title: AppStrings.settingsBiometrics,
                        value: controller.biometricsEnabled.value,
                        onChanged: controller.toggleBiometrics,
                      );
                    }),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: AppStrings.settingsPrivacyPolicy,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. Support Section
              _buildSectionHeader(AppStrings.supportSection),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.help_outline_rounded,
                      title: AppStrings.settingsHelpCenter,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.mail_outline_rounded,
                      title: AppStrings.settingsContactUs,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.info_outline_rounded,
                      title: AppStrings.settingsAboutApp,
                      trailingText: AppStrings.settingsAppVersion,
                      isClickable: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 6. Outlined Logout Button
              _buildOutlinedLogoutButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniHeader() {
    return Row(
      children: [
        // Circular smaller avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  AppAssets.person,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_circle,
                    size: 68,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),

            // Gold checkmark badge overlay
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCD34D),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                padding: const EdgeInsets.all(2.5),
                child: Image.asset(
                  AppAssets.profileCheck,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),

        // Name & Phone
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                AppStrings.profileUserName,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                AppStrings.profileUserPhone,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    bool isClickable = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isClickable ? (onTap ?? () {}) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Left blue circle icon
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFDBEAFE), // Light blue circle background
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1E3A8A), // Dark blue icon color
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing Chevron or Text info
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              )
            else if (isClickable)
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

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Left blue circle icon
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFDBEAFE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
          ),
          const SizedBox(width: 14),

          // Label
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

          // Switch widget
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 1,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildOutlinedLogoutButton(BuildContext context) {
    final controller = Get.find<ProfileSettingsController>();
    return OutlinedButton(
      onPressed: () {
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
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.exit_to_app_rounded, color: Colors.red),
          SizedBox(width: 8),
          Text(
            AppStrings.logoutLabel,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
