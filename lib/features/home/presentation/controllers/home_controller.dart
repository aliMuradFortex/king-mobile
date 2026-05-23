import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/filter_bottom_sheet.dart';

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
