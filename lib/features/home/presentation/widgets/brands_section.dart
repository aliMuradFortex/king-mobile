import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Correct mapping of logos to labels
    final List<Map<String, String>> brands = [
      {'logo': AppAssets.samsung, 'label': 'Samsung'},
      {'logo': AppAssets.apple, 'label': 'Apple'},
      {'logo': AppAssets.infinix, 'label': 'Infinix'},
      {'logo': AppAssets.vivo, 'label': 'Vivo'},
      {'logo': AppAssets.mi, 'label': 'Xiaomi'},
    ];

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
                AppStrings.popularBrands,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Action for See All Brands
                },
                child: const Text(
                  AppStrings.seeAll,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B5B88), // Medium blue color from mockup
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Horizontal list of brands
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Logo circular container
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            brand['logo']!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.phone_iphone_rounded, color: AppColors.primary);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Brand name label
                    Text(
                      brand['label']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
