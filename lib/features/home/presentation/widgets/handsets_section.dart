import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/home_controller.dart';

class HandsetsSection extends StatelessWidget {
  const HandsetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.featuredHandsets,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.updateTab(1);
                },
                child: const Text(
                  AppStrings.seeAll,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B5B88),
                  ),
                ),
              ),
            ],
          ),
        ),

        Obx(() {
          final list = controller.filteredProducts;
          final isLoading = controller.isProductsLoading.value;

          if (isLoading && list.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (list.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Text(
                  'No handsets found matching your search.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: list.length > 4 ? 4 : list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final p = list[index];
              final minPrice = double.tryParse(p['min_price'] ?? '0') ?? 0;
              final minInstallment =
                  double.tryParse(p['min_installment'] ?? '0') ?? 0;
              final isFeatured = p['is_featured'] as bool? ?? false;
              final brandName = p['brand'] is Map
                  ? (p['brand']['name'] ?? '')
                  : '';

              return _buildHandsetCard(
                context,
                modelName: p['name'] ?? '',
                brandName: brandName,
                price: 'Rs. ${minPrice.toStringAsFixed(0)}',
                instalment: 'Rs. ${minInstallment.toStringAsFixed(0)}/mo',
                imageUrl: p['featured_image'] ?? '',
                discount: isFeatured ? 'Featured' : null,
                onTap: () {
                  context.push('/product-detail', extra: p);
                },
              );
            },
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHandsetCard(
    BuildContext context, {
    required String modelName,
    required String brandName,
    required String price,
    required String instalment,
    required String imageUrl,
    String? discount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Handset Image Container Card
              Stack(
                children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: imageUrl.startsWith('http')
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.phone_android_rounded,
                                    size: 48,
                                    color: AppColors.textMuted,
                                  );
                                },
                              )
                            : Image.asset(
                                imageUrl.isNotEmpty
                                    ? imageUrl
                                    : AppAssets.featuredHandset,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.phone_android_rounded,
                                    size: 48,
                                    color: AppColors.textMuted,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),

                  // Featured Badge (if applicable)
                  if (discount != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 2. Title & Brand Labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  modelName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  brandName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // 3. Price
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E5B99),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 4. Installment Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Instalment ',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF4C6A8D),
                          ),
                        ),
                        TextSpan(
                          text: instalment,
                          style: const TextStyle(color: Color(0xFF1E5B99)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
