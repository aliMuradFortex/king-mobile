import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          // 1. User Avatar Image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: ClipOval(
              child: Obx(() {
                final profileController = Get.find<ProfileController>();
                final imageUrl =
                    profileController.profileData['image'] as String?;
                if (imageUrl != null && imageUrl.isNotEmpty) {
                  final cleanUrl = imageUrl.contains('/storage/http')
                      ? imageUrl.substring(imageUrl.indexOf('http', 5))
                      : imageUrl;
                  return Image.network(
                    cleanUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(AppAssets.person, fit: BoxFit.cover),
                  );
                }
                return Image.asset(AppAssets.person, fit: BoxFit.cover);
              }),
            ),
          ),
          const SizedBox(width: 12),

          // 2. Greeting Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getGreeting(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() {
                  final profileController = Get.find<ProfileController>();
                  final name =
                      profileController.profileData['name'] as String? ??
                      'Affan';
                  return Text(
                    'Hello $name!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  );
                }),
              ],
            ),
          ),

          // 3. Notification Button
          _buildIconButton(
            iconPath: AppAssets.bell,
            fallbackIcon: Icons.notifications_none_rounded,
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 12),

          // 4. Settings Button
          _buildIconButton(
            iconPath: AppAssets.settings,
            fallbackIcon: Icons.settings_outlined,
            onPressed: () => context.push('/profile-settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required String iconPath,
    required IconData fallbackIcon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Image.asset(
          iconPath,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(fallbackIcon, color: AppColors.primary, size: 20);
          },
        ),
        onPressed: onPressed,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning 👋';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon 👋';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening 👋';
    } else {
      return 'Good Night 👋';
    }
  }
}
