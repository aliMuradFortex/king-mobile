import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/product_detail_controller.dart';
import '../widgets/spec_chip.dart';
import '../widgets/plan_card.dart';

class ProductDetailView extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Instantiate or retrieve ProductDetailController specific to this product
    final controller = Get.put(
      ProductDetailController(product: product),
      tag: product['id'],
    );

    final String brand = product['brand'] ?? '';
    final String model = product['model'] ?? '';
    final String priceFormatted = product['priceFormatted'] ?? '';
    final List<dynamic> images = product['images'] ?? [];
    final Map<String, dynamic> specs = product['specs'] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
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
          AppStrings.productDetailsTitle,
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
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable main content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Image Carousel Gallery
                  SizedBox(
                    height: 240,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.isNotEmpty ? images.length : 1,
                          onPageChanged: controller.updateCarouselIndex,
                          itemBuilder: (context, index) {
                            final image = images.isNotEmpty ? images[index] : '';
                            return Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              child: Image.asset(
                                image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.phone_iphone_rounded,
                                    size: 120,
                                    color: AppColors.textMuted,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        
                        // Dots Page Indicator
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Obx(() {
                            final activeIndex = controller.carouselIndex.value;
                            final total = images.isNotEmpty ? images.length : 1;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(total, (index) {
                                final isCurrent = index == activeIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  height: 6,
                                  width: isCurrent ? 18 : 6,
                                  decoration: BoxDecoration(
                                    color: isCurrent
                                        ? AppColors.primary
                                        : const Color(0xFFCBD5E1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 2. Info details section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // In Stock Badge & Brand row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              brand.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF94A3B8),
                                letterSpacing: 1.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    AppStrings.inStock,
                                    style: TextStyle(
                                      color: Color(0xFF16A34A),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        
                        // Product Model Name
                        Text(
                          model,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Price tag
                        Text(
                          priceFormatted,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E5B99),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          AppStrings.taxDisclaimer,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 3. Key Specifications Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          AppStrings.keySpecifications,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Horizontal scrollable list of key specification chips
                      SizedBox(
                        height: 96,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            if (specs['ram'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: SpecChip(
                                  iconPath: AppAssets.specRamIcon,
                                  label: AppStrings.specRam,
                                  value: specs['ram'],
                                ),
                              ),
                            if (specs['storage'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: SpecChip(
                                  iconPath: AppAssets.specStorageIcon,
                                  label: AppStrings.specStorage,
                                  value: specs['storage'],
                                ),
                              ),
                            if (specs['battery'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: SpecChip(
                                  iconPath: AppAssets.specBatteryIcon,
                                  label: AppStrings.specBattery,
                                  value: specs['battery'],
                                ),
                              ),
                            if (specs['camera'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: SpecChip(
                                  iconPath: AppAssets.specCameraIcon,
                                  label: AppStrings.specCamera,
                                  value: specs['camera'],
                                ),
                              ),
                            if (specs['display'] != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: SpecChip(
                                  iconPath: AppAssets.specDisplayIcon,
                                  label: AppStrings.specDisplay,
                                  value: specs['display'],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 4. Installment plan selection area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.chooseYourPlan,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Plan selector cards list
                        Obx(() {
                          final selected = controller.selectedPlan.value;
                          return Column(
                            children: controller.planOptions.map((option) {
                              final monthsName = option['months'] as String;
                              return PlanCard(
                                months: monthsName,
                                monthlyPrice: option['monthlyPrice'] as String,
                                description: option['description'] as String,
                                isPopular: option['isPopular'] as bool,
                                isSelected: selected == monthsName,
                                onTap: () => controller.selectPlan(monthsName),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // 5. Sticky Bottom Action Button Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => controller.proceed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    AppStrings.proceedWithPlan,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
