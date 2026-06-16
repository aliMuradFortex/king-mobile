import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/home_controller.dart';

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 64 + bottomPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withValues(alpha: 0.5),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final selectedIndex = controller.tabIndex.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                label: 'HOME',
                activeIcon: AppAssets.navHomeActive,
                inactiveIcon: AppAssets.navHomeInactive,
                isSelected: selectedIndex == 0,
                onTap: () => controller.updateTab(0),
              ),
              _buildNavItem(
                index: 1,
                label: 'BRANDS',
                activeIcon: AppAssets.navBrandActive,
                inactiveIcon: AppAssets.navBrandInactive,
                isSelected: selectedIndex == 1,
                onTap: () => controller.updateTab(1),
              ),
              _buildNavItem(
                index: 2,
                label: 'MY PLANS',
                activeIcon: AppAssets.navPlansActive,
                inactiveIcon: AppAssets.navPlansInactive,
                isSelected: selectedIndex == 2,
                onTap: () => controller.updateTab(2),
              ),
              _buildNavItem(
                index: 3,
                label: 'PROFILE',
                activeIcon: AppAssets.navProfileActive,
                inactiveIcon: AppAssets.navProfileInactive,
                isSelected: selectedIndex == 3,
                onTap: () => controller.updateTab(3),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required String activeIcon,
    required String inactiveIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isSelected ? activeIcon : inactiveIcon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  _getDefaultIconData(index),
                  color: isSelected ? Colors.white : AppColors.textMuted,
                  size: 20,
                );
              },
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDefaultIconData(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.grid_view_rounded;
      case 2:
        return Icons.assignment_rounded;
      case 3:
        return Icons.person_rounded;
      default:
        return Icons.home_rounded;
    }
  }
}
