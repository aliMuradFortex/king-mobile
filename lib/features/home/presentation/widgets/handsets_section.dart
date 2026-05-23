import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';

class HandsetsSection extends StatelessWidget {
  const HandsetsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                  // Action for See All Featured Handsets
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
        
        // Two columns of handsets
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Handset Card 1 (with 20% off badge)
              Expanded(
                child: _buildHandsetCard(
                  context,
                  modelName: 'Galaxy S10+',
                  brandName: 'Samsung',
                  price: 'Rs. 70,000/',
                  instalment: 'Rs. 24,500/mo',
                  discount: '20% off',
                ),
              ),
              const SizedBox(width: 12),
              
              // Handset Card 2 (no badge)
              Expanded(
                child: _buildHandsetCard(
                  context,
                  modelName: 'Galaxy S10+',
                  brandName: 'Samsung',
                  price: 'Rs. 70,000/',
                  instalment: 'Rs. 24,500/mo',
                  discount: null,
                ),
              ),
            ],
          ),
        ),
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
    String? discount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Handset Image Container Card
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      AppAssets.featuredHandset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.phone_android_rounded,
                          size: 64,
                          color: AppColors.textMuted,
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              // 20% off Badge (if applicable)
              if (discount != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA4A4).withValues(alpha: 0.9), // Soft red/coral badge
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      discount,
                      style: const TextStyle(
                        color: Color(0xFF7A1D1D),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 2. Title & Brand Labels
          Text(
            modelName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          Text(
            brandName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
          ),
          const SizedBox(height: 4),
          
          // 3. Price
          Text(
            price,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E5B99), // Price color from mockup
            ),
          ),
          const SizedBox(height: 8),
          
          // 4. Installment Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  const TextSpan(
                    text: 'Instalment from ',
                    style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFF4C6A8D)),
                  ),
                  TextSpan(
                    text: instalment,
                    style: const TextStyle(color: Color(0xFF1E5B99)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
