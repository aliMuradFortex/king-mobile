import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';

class HomeController extends GetxController {
  // Active Navigation Tab
  final RxInt tabIndex = 0.obs;

  // Active Promo Banner Page
  final RxInt bannerIndex = 0.obs;

  // Applied Filters
  final Rx<RangeValues> priceRange = const RangeValues(50000, 90000).obs;
  final RxString installmentPlan = '6 Months'.obs;
  final RxString ram = '8GB'.obs;
  final RxString storage = '128 GB'.obs;
  final RxString backCamera = '16MP'.obs;
  final RxString frontCamera = '16MP'.obs;

  // Temporary/Draft Filters for Bottom Sheet UI
  final Rx<RangeValues> tempPriceRange = const RangeValues(50000, 90000).obs;
  final RxString tempInstallmentPlan = '6 Months'.obs;
  final RxString tempRam = '8GB'.obs;
  final RxString tempStorage = '128 GB'.obs;
  final RxString tempBackCamera = '16MP'.obs;
  final RxString tempFrontCamera = '16MP'.obs;

  // Search and Filter States
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isFilterApplied = false.obs;

  // Live Products and Brands State
  final RxList<dynamic> products = <dynamic>[].obs;
  final RxList<dynamic> brands = <dynamic>[].obs;
  final RxBool isProductsLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ApiService _apiService = DioApiService();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchProducts() async {
    try {
      isProductsLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.getProducts();
      isProductsLoading.value = false;

      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        products.value = data['products'] as List<dynamic>? ?? [];
        brands.value = data['brands'] as List<dynamic>? ?? [];
      } else {
        errorMessage.value =
            response['message'] as String? ?? 'Failed to load products.';
      }
    } catch (e) {
      isProductsLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  List<dynamic> get featuredProducts {
    return products.where((p) => p['is_featured'] == true).toList();
  }

  Map<String, String> getProductSpecs(Map<String, dynamic> product) {
    final name = (product['name'] as String?)?.toLowerCase() ?? '';
    final desc = (product['description'] as String?)?.toLowerCase() ?? '';

    // Extract RAM
    String ramVal = '8GB';
    if (name.contains('12gb') || desc.contains('12gb')) {
      ramVal = '12GB';
    } else if (name.contains('8gb') || desc.contains('8gb')) {
      ramVal = '8GB';
    } else if (name.contains('6gb') || desc.contains('6gb')) {
      ramVal = '6GB';
    } else if (name.contains('4gb') || desc.contains('4gb')) {
      ramVal = '4GB';
    } else {
      if (name.contains('ultra') ||
          name.contains('fold') ||
          name.contains('pro max') ||
          name.contains('oneplus 12') ||
          name.contains('reno 11 pro')) {
        ramVal = '12GB';
      } else if (name.contains('pro') || name.contains('find x7')) {
        ramVal = '8GB';
      } else if (name.contains('airpods')) {
        ramVal = 'N/A';
      }
    }

    // Extract Storage
    String storageVal = '128 GB';
    if (name.contains('512gb') ||
        desc.contains('512gb') ||
        name.contains('512 gb') ||
        desc.contains('512 gb')) {
      storageVal = '512 GB';
    } else if (name.contains('256gb') ||
        desc.contains('256gb') ||
        name.contains('256 gb') ||
        desc.contains('256 gb')) {
      storageVal = '256 GB';
    } else if (name.contains('128gb') ||
        desc.contains('128gb') ||
        name.contains('128 gb') ||
        desc.contains('128 gb')) {
      storageVal = '128 GB';
    } else if (name.contains('64gb') ||
        desc.contains('64gb') ||
        name.contains('64 gb') ||
        desc.contains('64 gb')) {
      storageVal = '64 GB';
    } else {
      if (name.contains('fold') ||
          name.contains('ultra') ||
          name.contains('pro max')) {
        storageVal = '256 GB';
      } else if (name.contains('airpods')) {
        storageVal = 'N/A';
      }
    }

    // Extract Back Camera
    String backCameraVal = '16MP';
    if (desc.contains('200mp')) {
      backCameraVal = '32MP';
    } else if (desc.contains('50mp') || desc.contains('48mp')) {
      backCameraVal = '32MP';
    } else if (desc.contains('12mp') || desc.contains('16mp')) {
      backCameraVal = '16MP';
    } else {
      if (name.contains('pro') ||
          name.contains('ultra') ||
          name.contains('fold') ||
          name.contains('oneplus')) {
        backCameraVal = '32MP';
      }
    }

    // Extract Front Camera
    String frontCameraVal = '16MP';
    if (name.contains('ultra') ||
        name.contains('pro max') ||
        name.contains('reno 11 pro')) {
      frontCameraVal = '32MP';
    } else if (name.contains('pro') || name.contains('fold')) {
      frontCameraVal = '16MP';
    } else {
      frontCameraVal = '12MP';
    }

    return {
      'ram': ramVal,
      'storage': storageVal,
      'backCamera': backCameraVal,
      'frontCamera': frontCameraVal,
    };
  }

  List<dynamic> get filteredProducts {
    final query = searchQuery.value.trim().toLowerCase();
    final applyFilters = isFilterApplied.value;

    final minPriceFilter = priceRange.value.start;
    final maxPriceFilter = priceRange.value.end;
    final isMaxPriceCap = maxPriceFilter >= 150000;

    final ramFilter = ram.value;
    final storageFilter = storage.value;
    final backCameraFilter = backCamera.value;
    final frontCameraFilter = frontCamera.value;

    return products.where((p) {
      // 1. Search Query Match
      if (query.isNotEmpty) {
        final name = (p['name'] as String?)?.toLowerCase() ?? '';
        final desc = (p['description'] as String?)?.toLowerCase() ?? '';
        final brandName = p['brand'] is Map
            ? (p['brand']['name'] as String?)?.toLowerCase() ?? ''
            : '';
        if (!name.contains(query) &&
            !desc.contains(query) &&
            !brandName.contains(query)) {
          return false;
        }
      }

      // 2. Active Filters Match
      if (applyFilters) {
        final minPriceStr = p['min_price'] ?? '0.00';
        final price = double.tryParse(minPriceStr) ?? 0.0;
        if (price < minPriceFilter) {
          return false;
        }
        if (!isMaxPriceCap && price > maxPriceFilter) {
          return false;
        }

        final specs = getProductSpecs(p);
        final pRam = specs['ram'];
        final pStorage = specs['storage'];
        final pBackCamera = specs['backCamera'];
        final pFrontCamera = specs['frontCamera'];

        if (pRam != null && pRam != 'N/A' && pRam != ramFilter) {
          return false;
        }
        if (pStorage != null && pStorage != 'N/A' && pStorage != storageFilter) {
          return false;
        }
        if (pBackCamera != null && pBackCamera != backCameraFilter) {
          return false;
        }
        if (pFrontCamera != null && pFrontCamera != frontCameraFilter) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get myInstallmentPlans {
    if (products.isEmpty) return [];

    final list = <Map<String, dynamic>>[];
    for (int i = 0; i < products.length && i < 3; i++) {
      final p = products[i];
      final minPriceStr = p['min_price'] ?? '0.00';
      final minPrice = double.tryParse(minPriceStr) ?? 0.0;
      final installmentStr = p['min_installment'] ?? '0.00';
      final installment = double.tryParse(installmentStr) ?? 0.0;
      final downpayment = minPrice * 0.2; // 20% downpayment

      final isActive = i != 2; // Make the 3rd one completed
      final paid = isActive ? '08/12' : '06/06';
      final remaining = isActive ? '04 Installments' : '00 Installments';

      list.add({
        'product': p,
        'modelName': p['name'] ?? '',
        'planDuration': isActive ? '12 Months Plan' : '6 Months Plan',
        'isActive': isActive,
        'paid': paid,
        'remaining': remaining,
        'monthly': 'Rs. ${installment.toStringAsFixed(0)}',
        'downpayment': 'Rs. ${downpayment.toStringAsFixed(0)}',
      });
    }
    return list;
  }

  void updateTab(int index) {
    tabIndex.value = index;
  }

  void updateBannerPage(int index) {
    bannerIndex.value = index;
  }

  // Copy current active filters to draft variables before opening sheet
  void initializeDraftFilters() {
    tempPriceRange.value = priceRange.value;
    tempInstallmentPlan.value = installmentPlan.value;
    tempRam.value = ram.value;
    tempStorage.value = storage.value;
    tempBackCamera.value = backCamera.value;
    tempFrontCamera.value = frontCamera.value;
  }

  // Reset Draft Filters to Mockup Defaults
  void resetDraftFilters() {
    tempPriceRange.value = const RangeValues(50000, 90000);
    tempInstallmentPlan.value = '6 Months';
    tempRam.value = '8GB';
    tempStorage.value = '128 GB';
    tempBackCamera.value = '16MP';
    tempFrontCamera.value = '16MP';
    isFilterApplied.value = false;
  }

  // Commit Draft Filters to Active Filters
  void commitFilters() {
    priceRange.value = tempPriceRange.value;
    installmentPlan.value = tempInstallmentPlan.value;
    ram.value = tempRam.value;
    storage.value = tempStorage.value;
    backCamera.value = tempBackCamera.value;
    frontCamera.value = tempFrontCamera.value;
  }

  // Open Filters Bottom Sheet Modal
  void openFilters(BuildContext context) {
    initializeDraftFilters();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}
