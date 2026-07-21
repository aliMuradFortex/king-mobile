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

  // Dynamic API Filter States
  final RxMap<String, dynamic> apiFilterOptions = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> apiFilters = <String, dynamic>{}.obs;
  final RxDouble apiMinPrice = 0.0.obs;
  final RxDouble apiMaxPrice = 150000.0.obs;

  // Applied Filters
  final Rx<RangeValues> priceRange = const RangeValues(0, 150000).obs;
  final RxString installmentPlan = '6 Months'.obs;
  final RxString ram = '8GB'.obs;
  final RxString storage = '128 GB'.obs;
  final RxString backCamera = '16MP'.obs;
  final RxString frontCamera = '16MP'.obs;

  // Temporary/Draft Filters for Bottom Sheet UI
  final Rx<RangeValues> tempPriceRange = const RangeValues(0, 150000).obs;
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

  // Sliders State
  final RxList<dynamic> sliders = <dynamic>[].obs;
  final RxBool isSlidersLoading = false.obs;

  // My Orders / Plans State
  final RxList<dynamic> myOrders = <dynamic>[].obs;
  final RxBool isOrdersLoading = false.obs;

  final ApiService _apiService = DioApiService();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchSliders();
    fetchMyOrders();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    debounce(searchQuery, (String query) {
      fetchProducts(query);
    }, time: const Duration(milliseconds: 400));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchSliders() async {
    try {
      isSlidersLoading.value = true;
      final response = await _apiService.getSliders();
      isSlidersLoading.value = false;
      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        sliders.value = data['sliders'] as List<dynamic>? ?? [];
      }
    } catch (e) {
      isSlidersLoading.value = false;
      debugPrint('Error fetching sliders: $e');
    }
  }

  Future<void> fetchProducts([String? search]) async {
    try {
      isProductsLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.getProducts(search);
      isProductsLoading.value = false;

      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        products.value = data['products'] as List<dynamic>? ?? [];
        brands.value = data['brands'] as List<dynamic>? ?? [];
        apiFilterOptions.value = data['filter_options'] as Map<String, dynamic>? ?? {};
        apiFilters.value = data['filters'] as Map<String, dynamic>? ?? {};
        _initializePriceRange();
        _initializeDefaultFilterValues();
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
    // 1. Try to read from specifications map if available in the API response
    final specObj = product['specifications'];
    if (specObj is Map) {
      return {
        'ram': specObj['ram']?.toString() ?? 'N/A',
        'storage': specObj['storage']?.toString() ?? 'N/A',
        'backCamera': specObj['back_camera']?.toString() ?? specObj['backCamera']?.toString() ?? 'N/A',
        'frontCamera': specObj['front_camera']?.toString() ?? specObj['frontCamera']?.toString() ?? 'N/A',
      };
    }

    // 2. Fall back to parsing name/description
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
    final isMaxPriceCap = maxPriceFilter >= apiMaxPrice.value;

    final ramFilter = ram.value;
    final storageFilter = storage.value;
    final backCameraFilter = backCamera.value;
    final frontCameraFilter = frontCamera.value;
    final installmentPlanFilter = installmentPlan.value;

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
        final minPriceStr = p['min_price'] ?? p['cash_price'] ?? '0.00';
        final price = double.tryParse(minPriceStr) ?? 0.0;
        if (price < minPriceFilter) {
          return false;
        }
        if (!isMaxPriceCap && price > maxPriceFilter) {
          return false;
        }

        // Installment Plan Filter
        if (installmentPlanFilter.isNotEmpty) {
          final plans = p['installment_plans'] as List<dynamic>?;
          if (plans != null) {
            final hasMatchingPlan = plans.any((plan) {
              final label = (plan['label'] as String?)?.toLowerCase() ?? '';
              final duration = '${plan['duration_months']} months';
              return label == installmentPlanFilter.toLowerCase() ||
                  duration == installmentPlanFilter.toLowerCase();
            });
            if (!hasMatchingPlan) {
              return false;
            }
          }
        }

        final specs = getProductSpecs(p);
        final pRam = specs['ram'];
        final pStorage = specs['storage'];
        final pBackCamera = specs['backCamera'];
        final pFrontCamera = specs['frontCamera'];

        if (pRam != null && pRam != 'N/A' && _normalize(pRam) != _normalize(ramFilter)) {
          return false;
        }
        if (pStorage != null &&
            pStorage != 'N/A' &&
            _normalize(pStorage) != _normalize(storageFilter)) {
          return false;
        }
        if (pBackCamera != null && pBackCamera != 'N/A' && _normalize(pBackCamera) != _normalize(backCameraFilter)) {
          return false;
        }
        if (pFrontCamera != null && pFrontCamera != 'N/A' && _normalize(pFrontCamera) != _normalize(frontCameraFilter)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Future<void> fetchMyOrders() async {
    try {
      isOrdersLoading.value = true;
      final response = await _apiService.getMyOrders();
      isOrdersLoading.value = false;
      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        myOrders.value = data['orders'] as List<dynamic>? ?? [];
      }
    } catch (e) {
      isOrdersLoading.value = false;
      debugPrint('Error fetching my orders: $e');
    }
  }

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

  List<Map<String, dynamic>> get myInstallmentPlans {
    if (myOrders.isEmpty) return [];

    final list = <Map<String, dynamic>>[];
    for (var o in myOrders) {
      if (o is! Map) continue;
      
      final productMap = o['product'] ?? o['website_product'] ?? {};
      final double price = double.tryParse(o['total_amount']?.toString() ?? productMap['cash_price']?.toString() ?? '0.00') ?? 0.0;
      final double advance = double.tryParse(o['advance_amount']?.toString() ?? '0.00') ?? (price * 0.1);
      final double monthly = double.tryParse(o['monthly_installment']?.toString() ?? '0.00') ?? (price * 0.9 / 6);
      
      final status = o['status']?.toString().toLowerCase() ?? 'pending';
      final isActive = status != 'completed';
      
      final duration = o['duration_months'] ?? 6;
      final paidInstallments = o['paid_installments'] ?? 0;
      final totalInstallments = o['total_installments'] ?? duration;
      
      list.add({
        'product': productMap,
        'modelName': productMap['name'] ?? o['product_name'] ?? 'King Mobile Product',
        'planDuration': '$duration Months Plan',
        'isActive': isActive,
        'paid': '$paidInstallments/$totalInstallments',
        'remaining': '${totalInstallments - paidInstallments} Installments',
        'monthly': 'Rs. ${formatPrice(monthly)}',
        'downpayment': 'Rs. ${formatPrice(advance)}',
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

  // Reset Draft Filters to Mockup Defaults / Dynamic Limits
  void resetDraftFilters() {
    tempPriceRange.value = RangeValues(apiMinPrice.value, apiMaxPrice.value);
    
    final rams = getRamOptions();
    tempRam.value = rams.contains('8GB') ? '8GB' : (rams.isNotEmpty ? rams.first : '8GB');
    
    final storages = getStorageOptions();
    tempStorage.value = storages.contains('128 GB') 
        ? '128 GB' 
        : (storages.contains('128GB') 
            ? '128GB' 
            : (storages.isNotEmpty ? storages.first : '128 GB'));
            
    final backCams = getBackCameraOptions();
    tempBackCamera.value = backCams.contains('16MP') ? '16MP' : (backCams.isNotEmpty ? backCams.first : '16MP');
    
    final frontCams = getFrontCameraOptions();
    tempFrontCamera.value = frontCams.contains('16MP') ? '16MP' : (frontCams.isNotEmpty ? frontCams.first : '16MP');
    
    tempInstallmentPlan.value = '6 Months';
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

  // Dynamic filter helpers
  void _initializePriceRange() {
    if (apiFilters.containsKey('price_range')) {
      final priceRangeData = apiFilters['price_range'];
      if (priceRangeData is Map && priceRangeData.containsKey('cash_price')) {
        final cashPrice = priceRangeData['cash_price'];
        if (cashPrice is Map) {
          final min = double.tryParse(cashPrice['min']?.toString() ?? '') ?? 0.0;
          double max = double.tryParse(cashPrice['max']?.toString() ?? '') ?? 150000.0;
          if (max <= min) {
            max = min + 10000.0;
          }
          apiMinPrice.value = min;
          apiMaxPrice.value = max;
          
          if (!isFilterApplied.value) {
            priceRange.value = RangeValues(min, max);
            tempPriceRange.value = RangeValues(min, max);
          }
        }
      }
    }
  }

  void _initializeDefaultFilterValues() {
    final rams = getRamOptions();
    if (rams.isNotEmpty) {
      if (!rams.contains(ram.value)) {
        ram.value = rams.contains('8GB') ? '8GB' : rams.first;
        tempRam.value = ram.value;
      }
    }
    
    final storages = getStorageOptions();
    if (storages.isNotEmpty) {
      final currentStorageNormalized = storage.value.replaceAll(' ', '').toLowerCase();
      final hasMatch = storages.any((s) => s.replaceAll(' ', '').toLowerCase() == currentStorageNormalized);
      if (!hasMatch) {
        final defaultStorage = storages.any((s) => s.contains('128')) 
            ? storages.firstWhere((s) => s.contains('128')) 
            : storages.first;
        storage.value = defaultStorage;
        tempStorage.value = defaultStorage;
      }
    }

    final backCams = getBackCameraOptions();
    if (backCams.isNotEmpty) {
      if (!backCams.contains(backCamera.value)) {
        backCamera.value = backCams.contains('16MP') ? '16MP' : backCams.first;
        tempBackCamera.value = backCamera.value;
      }
    }

    final frontCams = getFrontCameraOptions();
    if (frontCams.isNotEmpty) {
      if (!frontCams.contains(frontCamera.value)) {
        frontCamera.value = frontCams.contains('16MP') ? '16MP' : frontCams.first;
        tempFrontCamera.value = frontCamera.value;
      }
    }
  }

  List<String> getRamOptions() {
    final specData = apiFilterOptions['specifications'];
    if (specData is Map && specData.containsKey('ram')) {
      final ramData = specData['ram'];
      if (ramData is Map && ramData.containsKey('options')) {
        final optionsMap = ramData['options'];
        if (optionsMap is Map) {
          return optionsMap.keys.map((k) => k.toString()).toList();
        }
      }
    }
    return ['4GB', '6GB', '8GB', '12GB'];
  }

  List<String> getStorageOptions() {
    final specData = apiFilterOptions['specifications'];
    if (specData is Map && specData.containsKey('storage')) {
      final storageData = specData['storage'];
      if (storageData is Map && storageData.containsKey('options')) {
        final optionsMap = storageData['options'];
        if (optionsMap is Map) {
          return optionsMap.keys.map((k) => k.toString()).toList();
        }
      }
    }
    return ['64 GB', '128 GB', '256 GB', '512 GB'];
  }

  List<String> getBackCameraOptions() {
    final specData = apiFilterOptions['specifications'];
    if (specData is Map && specData.containsKey('back_camera')) {
      final camData = specData['back_camera'];
      if (camData is Map && camData.containsKey('options')) {
        final optionsMap = camData['options'];
        if (optionsMap is Map) {
          return optionsMap.keys.map((k) => k.toString()).toList();
        }
      }
    }
    return ['8MP', '12MP', '16MP', '32MP'];
  }

  List<String> getFrontCameraOptions() {
    final specData = apiFilterOptions['specifications'];
    if (specData is Map && specData.containsKey('front_camera')) {
      final camData = specData['front_camera'];
      if (camData is Map && camData.containsKey('options')) {
        final optionsMap = camData['options'];
        if (optionsMap is Map) {
          return optionsMap.keys.map((k) => k.toString()).toList();
        }
      }
    }
    return ['8MP', '12MP', '16MP', '32MP'];
  }

  String _normalize(String value) {
    return value.replaceAll(' ', '').toLowerCase();
  }
}
