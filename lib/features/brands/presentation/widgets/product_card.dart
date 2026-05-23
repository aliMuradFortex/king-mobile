import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final String brandName = product['brand'] is Map
        ? (product['brand']['name'] ?? '')
        : (product['brand'] ?? '');
    final String modelName = product['model'] ?? product['name'] ?? '';
    
    final double minPrice = double.tryParse(product['min_price'] ?? '') ?? 0.0;
    final String priceFormatted = product['priceFormatted'] ??
        (minPrice > 0 ? 'Rs. ${minPrice.toStringAsFixed(0)}' : '');

    final double minInstallment = double.tryParse(product['min_installment'] ?? '') ?? 0.0;
    final String instalmentPrice = product['instalmentPrice'] ??
        (minInstallment > 0 ? 'Rs. ${minInstallment.toStringAsFixed(0)}/mo' : '');

    final String? tag = product['tag'] ?? (product['is_featured'] == true ? 'HOT DEAL' : null);
    final List<dynamic> images = product['images'] ?? [];
    
    String mainImage = '';
    if (product['featured_image'] != null) {
      mainImage = product['featured_image'];
    } else if (images.isNotEmpty) {
      final first = images.first;
      if (first is Map) {
        mainImage = first['image_path'] ?? '';
      } else {
        mainImage = first.toString();
      }
    }

    return GestureDetector(
      onTap: () {
        context.push('/product-detail', extra: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with badge overlay
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: mainImage.startsWith('http')
                          ? Image.network(
                              mainImage,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.phone_iphone_rounded,
                                  size: 56,
                                  color: AppColors.textMuted,
                                );
                              },
                            )
                          : Image.asset(
                              mainImage.isNotEmpty ? mainImage : 'assets/images/featured_handset.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.phone_iphone_rounded,
                                  size: 56,
                                  color: AppColors.textMuted,
                                );
                              },
                            ),
                    ),
                  ),
                ),
                
                // Hot Deal Tag
                if (tag != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Text Details Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    modelName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    priceFormatted,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5B99),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Monthly installment pill
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Instalment from ',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          TextSpan(
                            text: instalmentPrice,
                            style: const TextStyle(
                              color: Color(0xFF1E5B99),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
