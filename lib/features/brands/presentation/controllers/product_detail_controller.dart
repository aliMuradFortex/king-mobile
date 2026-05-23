import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';

class ProductDetailController extends GetxController {
  final Map<String, dynamic> product;

  ProductDetailController({required this.product});

  // Loading state
  final RxBool isLoading = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  // Active product details from API
  final RxMap<String, dynamic> productDetails = <String, dynamic>{}.obs;

  // Carousel active image index
  final RxInt carouselIndex = 0.obs;

  // Selected plan option duration
  final RxString selectedPlan = '3 Months'.obs;

  final ApiService _apiService = DioApiService();

  @override
  void onInit() {
    super.onInit();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final id = product['id'];
    if (id == null) {
      productDetails.value = product;
      return;
    }
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.getProductDetails(id is int ? id : int.parse(id.toString()));
      isLoading.value = false;

      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        productDetails.value = response['data'] as Map<String, dynamic>;
        
        final plans = activeInstallmentPlans;
        if (plans.isNotEmpty) {
          selectedPlan.value = plans.first['name'] ?? '';
        }
      } else {
        errorMessage.value = response['message'] as String? ?? 'Failed to load product details.';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  // Formatting helper for currency strings
  String formatPrice(double amount) {
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

  // Get active installment plans from the first active variation
  List<Map<String, dynamic>> get activeInstallmentPlans {
    final details = productDetails;
    if (details.isNotEmpty && details['variations'] != null) {
      final variations = details['variations'] as List<dynamic>;
      if (variations.isNotEmpty) {
        final firstVariation = variations.first;
        if (firstVariation is Map && firstVariation['installment_plans'] != null) {
          final plans = firstVariation['installment_plans'] as List<dynamic>;
          return plans.whereType<Map<String, dynamic>>().toList();
        }
      }
    }
    return [];
  }

  // Generates plan list with dynamic prices calculated from base product price
  List<Map<String, dynamic>> get planOptions {
    final officialPlans = activeInstallmentPlans;
    if (officialPlans.isNotEmpty) {
      return officialPlans.map((plan) {
        final double advance = double.tryParse(plan['advance_payment']?.toString() ?? '') ?? 0.0;
        final double monthly = double.tryParse(plan['monthly_installment']?.toString() ?? '') ?? 0.0;
        final months = plan['number_of_months'] ?? 3;
        final total = double.tryParse(plan['total_amount']?.toString() ?? '') ?? 0.0;
        
        return {
          'months': plan['name'] ?? '$months Months Plan',
          'monthlyPrice': 'Rs. ${formatPrice(monthly)}/mo',
          'isPopular': months == 6,
          'description': 'Rs. ${formatPrice(advance)} Down Payment • Total Rs. ${formatPrice(total)}',
        };
      }).toList();
    }

    final double price = (productDetails['price'] is num)
        ? (productDetails['price'] as num).toDouble()
        : double.tryParse(productDetails['price']?.toString() ?? '') ??
            double.tryParse(product['min_price']?.toString() ?? '') ??
            0.0;
    
    if (price <= 0.0) return [];

    final double price3 = price / 3;
    final double price6 = price / 6;
    final double price12 = price / 12;

    return [
      {
        'months': '3 Months Plan',
        'monthlyPrice': 'Rs. ${formatPrice(price3)}/mo',
        'isPopular': false,
        'description': '0% Down Payment • No Markup',
      },
      {
        'months': '6 Months Plan',
        'monthlyPrice': 'Rs. ${formatPrice(price6)}/mo',
        'isPopular': true,
        'description': '0% Down Payment • No Markup',
      },
      {
        'months': '12 Months Plan',
        'monthlyPrice': 'Rs. ${formatPrice(price12)}/mo',
        'isPopular': false,
        'description': '0% Down Payment • No Markup',
      },
    ];
  }

  // Get specs extracted from variations
  Map<String, dynamic> get specs {
    final details = productDetails;
    if (details.isNotEmpty && details['variations'] != null) {
      final variations = details['variations'] as List<dynamic>;
      if (variations.isNotEmpty) {
        final firstVariation = variations.first;
        if (firstVariation is Map && firstVariation['features'] != null) {
          return _extractSpecs(firstVariation['features'] as List<dynamic>);
        }
      }
    }
    return product['specs'] ?? {};
  }

  Map<String, dynamic> _extractSpecs(List<dynamic> features) {
    final specsMap = <String, dynamic>{};
    for (var f in features) {
      if (f is Map) {
        final name = (f['name'] as String?)?.toLowerCase();
        final val = f['value']?.toString() ?? '';
        if (name != null && val.isNotEmpty) {
          if (name.contains('ram')) {
            specsMap['ram'] = val;
          } else if (name.contains('storage')) {
            specsMap['storage'] = val;
          } else if (name.contains('battery')) {
            specsMap['battery'] = val;
          } else if (name.contains('camera')) {
            specsMap['camera'] = val;
          } else if (name.contains('display')) {
            specsMap['display'] = val;
          } else if (name.contains('processor')) {
            specsMap['processor'] = val;
          } else if (name.contains('os')) {
            specsMap['os'] = val;
          }
        }
      }
    }
    return specsMap;
  }

  // Get image paths list
  List<dynamic> get productImages {
    final details = productDetails;
    if (details.isNotEmpty && details['images'] != null) {
      final list = details['images'] as List<dynamic>;
      if (list.isNotEmpty) {
        return list.map((item) {
          if (item is Map) {
            return item['image_path'] ?? '';
          }
          return item.toString();
        }).toList();
      }
    }
    if (product['featured_image'] != null) {
      return [product['featured_image']];
    }
    final List<dynamic> fallbackImages = product['images'] ?? [];
    if (fallbackImages.isNotEmpty) {
      return fallbackImages;
    }
    return [];
  }

  void updateCarouselIndex(int index) {
    carouselIndex.value = index;
  }

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  void proceed(BuildContext context) {
    context.push(
      '/select-branch',
      extra: {
        'product': productDetails.isNotEmpty ? productDetails : product,
        'plan': selectedPlan.value,
      },
    );
  }
}
