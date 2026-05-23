import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/promo_banner.dart';
import '../widgets/brands_section.dart';
import '../widgets/handsets_section.dart';
import '../widgets/home_nav_bar.dart';
import '../../../brands/presentation/views/brands_view.dart';
import 'my_plans_view.dart';
import '../../../profile/presentation/views/profile_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject HomeController into GetX dependency manager
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const HomeNavBar(),
      body: SafeArea(
        child: Obx(() {
          final activeTab = controller.tabIndex.value;
          
          if (activeTab == 1) {
            return const BrandsView();
          }
          
          if (activeTab == 2) {
            return const MyPlansView();
          }
          
          if (activeTab == 3) {
            return const ProfileView();
          }
          
          if (activeTab != 0) {
            // Render placeholder screens for non-Home tabs
            return _buildTabPlaceholder(activeTab);
          }
          
          // Render Home Dashboard screen
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchProducts();
            },
            color: AppColors.primary,
            child: controller.isProductsLoading.value && controller.products.isEmpty
                ? const SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                  SizedBox(height: 12),
                  // 1. Top Greeting Header
                  HomeHeader(),
                  
                  // 2. Search Box & Filter Button
                  SearchFilterBar(),
                  
                  // 3. Promo Banner PageView Carousel
                  PromoBanner(),
                  SizedBox(height: 20),
                  
                  // 4. Popular Brands Section
                  BrandsSection(),
                  SizedBox(height: 12),
                  
                  // 5. Featured Handsets Grid Section
                  HandsetsSection(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabPlaceholder(int tabIndex) {
    String title;
    IconData icon;

    switch (tabIndex) {
      case 1:
        title = 'Popular Brands';
        icon = Icons.grid_view_rounded;
        break;
      case 2:
        title = 'My Installment Plans';
        icon = Icons.assignment_rounded;
        break;
      case 3:
        title = 'User Profile Settings';
        icon = Icons.person_rounded;
        break;
      default:
        title = 'Screen';
        icon = Icons.home_rounded;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This screen is coming soon!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
