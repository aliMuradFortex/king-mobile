import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/brands_controller.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandsController>();

    return Obx(() {
      final products = controller.filteredProducts;

      if (products.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Text(
              'No products found in this category.',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.73,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product);
        },
      );
    });
  }
}
