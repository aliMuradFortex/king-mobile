import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/home_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (Filters title & close button)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.filtersTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  AppAssets.cross,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.cancel_rounded, color: Colors.grey.shade400, size: 24);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Scrollable filter contents to prevent overflow on smaller devices
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Price Range Selector
                  _buildSectionTitle(context, AppStrings.filterPriceRange),
                  const SizedBox(height: 12),
                  _buildPriceRangeCard(controller),
                  const SizedBox(height: 24),
                  
                  // 3. Installment Plan Selector
                  Row(
                    children: [
                      _buildSectionTitle(context, AppStrings.filterInstallmentPlan),
                      const SizedBox(width: 8),
                      const Icon(Icons.verified_rounded, color: Color(0xFFD4AF37), size: 18), // Gold verification badge
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInstallmentSelector(controller),
                  const SizedBox(height: 24),
                  
                  // 4. RAM Option Selector
                  _buildSectionTitle(context, AppStrings.filterRam),
                  const SizedBox(height: 12),
                  _buildRamSelector(controller),
                  const SizedBox(height: 24),
                  
                  // 5. Storage Option Selector
                  _buildSectionTitle(context, AppStrings.filterStorage),
                  const SizedBox(height: 12),
                  _buildStorageSelector(controller),
                  const SizedBox(height: 24),
                  
                  // 6. Back Camera Option Selector
                  _buildSectionTitle(context, AppStrings.filterBackCamera),
                  const SizedBox(height: 12),
                  _buildCameraSelector(controller, isBackCamera: true),
                  const SizedBox(height: 24),
                  
                  // 7. Front Camera Option Selector
                  _buildSectionTitle(context, AppStrings.filterFrontCamera),
                  const SizedBox(height: 12),
                  _buildCameraSelector(controller, isBackCamera: false),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // 8. Bottom Action Buttons (Reset and Apply)
          Row(
            children: [
              // Reset Button
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: controller.resetDraftFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F3F6),
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    AppStrings.filterReset,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Apply Filters Button
              Expanded(
                flex: 7,
                child: ElevatedButton(
                  onPressed: () {
                    controller.commitFilters();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    AppStrings.filterApply,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
    );
  }

  // Price Range Double Slider Container Card
  Widget _buildPriceRangeCard(HomeController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        final currentValues = controller.tempPriceRange.value;
        return Column(
          children: [
            // Dual Slider widget
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Colors.white,
                trackHeight: 6,
                overlayColor: AppColors.primary.withValues(alpha: 0.1),
                rangeThumbShape: const RoundRangeSliderThumbShape(
                  enabledThumbRadius: 10,
                  elevation: 4,
                ),
              ),
              child: RangeSlider(
                values: currentValues,
                min: 10000,
                max: 150000,
                divisions: 14,
                onChanged: (RangeValues newValues) {
                  controller.tempPriceRange.value = newValues;
                },
              ),
            ),
            const SizedBox(height: 8),
            // Min/Max Price Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      AppStrings.filterMinPrice,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${currentValues.start.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      AppStrings.filterMaxPrice,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${currentValues.end.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  // Installment Plan Horizontal Pill Selector
  Widget _buildInstallmentSelector(HomeController controller) {
    final plans = ['3 Months', '6 Months', '12 Months'];
    return Obx(() {
      final selected = controller.tempInstallmentPlan.value;
      return Row(
        children: plans.map((plan) {
          final isSelected = selected == plan;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => controller.tempInstallmentPlan.value = plan,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.secondaryDark : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Text(
                  plan,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF6B5115) : AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // RAM Circular Selector
  Widget _buildRamSelector(HomeController controller) {
    final options = ['4GB', '6GB', '8GB', '12GB'];
    return Obx(() {
      final selected = controller.tempRam.value;
      return Row(
        children: options.map((option) {
          final isSelected = selected == option;
          return Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: GestureDetector(
              onTap: () => controller.tempRam.value = option,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // Storage Two-Line Circular Selector
  Widget _buildStorageSelector(HomeController controller) {
    final options = ['64 GB', '128 GB', '256 GB', '512 GB'];
    return Obx(() {
      final selected = controller.tempStorage.value;
      return Row(
        children: options.map((option) {
          final isSelected = selected == option;
          final parts = option.split(' ');
          return Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: GestureDetector(
              onTap: () => controller.tempStorage.value = option,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        parts[0],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        parts[1],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white70 : Colors.grey.shade500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // Camera Circular Selector
  Widget _buildCameraSelector(HomeController controller, {required bool isBackCamera}) {
    final options = ['8MP', '12MP', '16MP', '32MP'];
    return Obx(() {
      final selected = isBackCamera ? controller.tempBackCamera.value : controller.tempFrontCamera.value;
      return Row(
        children: options.map((option) {
          final isSelected = selected == option;
          return Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: GestureDetector(
              onTap: () {
                if (isBackCamera) {
                  controller.tempBackCamera.value = option;
                } else {
                  controller.tempFrontCamera.value = option;
                }
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
