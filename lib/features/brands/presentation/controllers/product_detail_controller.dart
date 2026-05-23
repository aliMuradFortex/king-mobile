import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProductDetailController extends GetxController {
  final Map<String, dynamic> product;

  ProductDetailController({required this.product});

  // Carousel active image index
  final RxInt carouselIndex = 0.obs;

  // Selected plan option duration
  final RxString selectedPlan = '3 Months'.obs;

  // Formatting helper for currency strings
  String _formatPrice(double amount) {
    final int number = amount.round();
    final String str = number.toString();
    final List<String> list = [];
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      list.add(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        list.add(',');
      }
    }
    return list.reversed.join();
  }

  // Generates plan list with dynamic prices calculated from base product price
  List<Map<String, dynamic>> get planOptions {
    final double price = (product['price'] is num) ? (product['price'] as num).toDouble() : 0.0;
    
    final double price3 = price / 3;
    final double price6 = price / 6;
    final double price12 = price / 12;

    return [
      {
        'months': '3 Months',
        'monthlyPrice': 'Rs. ${_formatPrice(price3)}/mo',
        'isPopular': false,
        'description': '0% Down Payment • No Markup',
      },
      {
        'months': '6 Months',
        'monthlyPrice': 'Rs. ${_formatPrice(price6)}/mo',
        'isPopular': true,
        'description': '0% Down Payment • No Markup',
      },
      {
        'months': '12 Months',
        'monthlyPrice': 'Rs. ${_formatPrice(price12)}/mo',
        'isPopular': false,
        'description': '0% Down Payment • No Markup',
      },
    ];
  }

  void updateCarouselIndex(int index) {
    carouselIndex.value = index;
  }

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  // Trigger checkout process and navigate to branch selection
  void proceed(BuildContext context) {
    context.push(
      '/select-branch',
      extra: {
        'product': product,
        'plan': selectedPlan.value,
      },
    );
  }
}
