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

  // Selected variation index
  final RxInt selectedVariationIndex = 0.obs;

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
          selectedPlan.value = plans.first['label'] ?? plans.first['name'] ?? '';
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

  // Get variations
  List<dynamic> get variations {
    final details = productDetails;
    if (details.isNotEmpty && details['variations'] != null) {
      return details['variations'] as List<dynamic>;
    }
    return [];
  }

  // Get active variation map
  Map<String, dynamic>? get activeVariation {
    final list = variations;
    if (list.isNotEmpty) {
      final index = selectedVariationIndex.value;
      if (index >= 0 && index < list.length) {
        return list[index] as Map<String, dynamic>;
      }
      return list.first as Map<String, dynamic>;
    }
    return null;
  }

  // Get active price dynamically from chosen variation
  double get activePrice {
    final activeVar = activeVariation;
    if (activeVar != null && activeVar['cash_price'] != null) {
      return double.tryParse(activeVar['cash_price'].toString()) ?? 0.0;
    }
    final details = productDetails;
    if (details.isNotEmpty) {
      final p = details['cash_price'] ?? details['price'] ?? product['cash_price'] ?? product['price'] ?? product['min_price'];
      if (p != null) {
        return double.tryParse(p.toString()) ?? 0.0;
      }
    }
    return 0.0;
  }

  // Get active advance dynamically from chosen variation
  double get activeAdvanceAmount {
    final activeVar = activeVariation;
    if (activeVar != null && activeVar['advance_amount'] != null) {
      return double.tryParse(activeVar['advance_amount'].toString()) ?? 0.0;
    }
    final details = productDetails;
    if (details.isNotEmpty) {
      final p = details['advance_amount'] ?? product['advance_amount'];
      if (p != null) {
        return double.tryParse(p.toString()) ?? 0.0;
      }
    }
    return 0.0;
  }

  // Get active installment plans from the selected variation
  List<Map<String, dynamic>> get activeInstallmentPlans {
    final activeVar = activeVariation;
    if (activeVar != null && activeVar['installment_plans'] != null) {
      final plans = activeVar['installment_plans'] as List<dynamic>;
      return plans.whereType<Map<String, dynamic>>().toList();
    }
    if (productDetails.isNotEmpty && productDetails['installment_plans'] != null) {
      final plans = productDetails['installment_plans'] as List<dynamic>;
      return plans.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  // Generates plan list with dynamic prices calculated from base product price
  List<Map<String, dynamic>> get planOptions {
    final officialPlans = activeInstallmentPlans;
    if (officialPlans.isNotEmpty) {
      return officialPlans.map((plan) {
        final double advance = double.tryParse(plan['advance_amount']?.toString() ?? 
                                               plan['advance_payment']?.toString() ?? '') ?? 0.0;
        final double monthly = double.tryParse(plan['monthly_installment']?.toString() ?? '') ?? 0.0;
        final months = plan['duration_months'] ?? plan['number_of_months'] ?? 3;
        final total = double.tryParse(plan['total_amount']?.toString() ?? '') ?? 0.0;
        
        return {
          'months': plan['label'] ?? '$months Months Plan',
          'monthlyPrice': 'Rs. ${formatPrice(monthly)}/mo',
          'isPopular': months == 6,
          'description': 'Rs. ${formatPrice(advance)} Down Payment • Total Rs. ${formatPrice(total)}',
        };
      }).toList();
    }

    final double price = activePrice;
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
    final activeVar = activeVariation;
    if (activeVar != null) {
      if (activeVar['specifications'] is Map) {
        return activeVar['specifications'] as Map<String, dynamic>;
      }
      if (activeVar['features'] != null) {
        return _extractSpecs(activeVar['features'] as List<dynamic>);
      }
    }
    if (productDetails.isNotEmpty && productDetails['specifications'] is Map) {
      return productDetails['specifications'] as Map<String, dynamic>;
    }
    return product['specs'] ?? product['specifications'] ?? {};
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
            return item['url'] ?? item['image_path'] ?? '';
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
    final baseProduct = productDetails.isNotEmpty ? productDetails : product;
    final Map<String, dynamic> mergedProduct = Map<String, dynamic>.from(baseProduct);
    
    final activeVar = activeVariation;
    if (activeVar != null) {
      mergedProduct['price'] = activeVar['cash_price'];
      mergedProduct['cash_price'] = activeVar['cash_price'];
      mergedProduct['advance_amount'] = activeVar['advance_amount'];
      mergedProduct['specifications'] = activeVar['specifications'];
      mergedProduct['installment_plans'] = activeVar['installment_plans'];
      mergedProduct['selected_variation_id'] = activeVar['id'];
      
      mergedProduct['storage'] = activeVar['storage'];
      mergedProduct['color'] = activeVar['color'];
      mergedProduct['code'] = activeVar['code'];
      mergedProduct['name'] = '${baseProduct['name'] ?? ''} (${activeVar['storage'] ?? ''} - ${activeVar['color'] ?? ''})';
    }
    
    context.push(
      '/application-process',
      extra: {
        'product': mergedProduct,
        'plan': selectedPlan.value,
        'branch': const <String, dynamic>{},
      },
    );
  }
}
