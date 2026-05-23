import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/home_controller.dart';

class MyPlansView extends StatelessWidget {
  const MyPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () {
              // Direct back to home dashboard tab
              final homeController = Get.find<HomeController>();
              homeController.updateTab(0);
            },
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
          AppStrings.myPlansTitle,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_horiz_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Centered Subtitle Tagline
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
              child: Text(
                AppStrings.myPlansSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary, // Navy text
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            
            // 2. Scrollable Cards List
            Expanded(
              child: Obx(() {
                final homeController = Get.find<HomeController>();
                final plans = homeController.myInstallmentPlans;

                if (plans.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'No installment plans yet.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final product = plan['product'] as Map<String, dynamic>?;
                    
                    final List<dynamic> images = product?['images'] ?? [];
                    String imagePath = '';
                    if (product?['featured_image'] != null) {
                      imagePath = product!['featured_image'];
                    } else if (images.isNotEmpty) {
                      final first = images.first;
                      if (first is Map) {
                        imagePath = first['image_path'] ?? '';
                      } else {
                        imagePath = first.toString();
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildPlanCard(
                        context,
                        modelName: plan['modelName'] ?? '',
                        planDuration: plan['planDuration'] ?? '',
                        isActive: plan['isActive'] ?? false,
                        paid: plan['paid'] ?? '',
                        remaining: plan['remaining'] ?? '',
                        monthly: plan['monthly'] ?? '',
                        downpayment: plan['downpayment'] ?? '',
                        imagePath: imagePath,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String modelName,
    required String planDuration,
    required bool isActive,
    required String paid,
    required String remaining,
    required String monthly,
    required String downpayment,
    required String imagePath,
  }) {
    return InkWell(
      onTap: () {
        context.push(
          '/plan-detail',
          extra: {
            'modelName': modelName,
            'planDuration': planDuration,
            'isActive': isActive,
            'paid': paid,
            'remaining': remaining,
            'monthly': monthly,
            'downpayment': downpayment,
          },
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Section (Image, Model details, Status badge & Arrow)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dark navy thumbnail box containing product image
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.phone_iphone_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        )
                      : Image.asset(
                          imagePath.isNotEmpty ? imagePath : AppAssets.featuredHandset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.phone_iphone_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                
                // Model info details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modelName,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        planDuration,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status Badge pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF10B981) : AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isActive ? AppStrings.activeStatus : AppStrings.completedStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Far right chevron arrow
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 24,
                ),
              ],
            ),
            
            // Thin horizontal line divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Container(
                height: 1,
                color: const Color(0xFFE2E8F0),
              ),
            ),
            
            // Bottom grid section (Paid, Remaining, Monthly, Downpayment)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(AppStrings.paidLabel, paid),
                      const SizedBox(height: 12),
                      _buildDetailRow(AppStrings.monthlyLabel, monthly),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(AppStrings.remainingLabel, remaining),
                      const SizedBox(height: 12),
                      _buildDetailRow(AppStrings.downpaymentLabel, downpayment),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
