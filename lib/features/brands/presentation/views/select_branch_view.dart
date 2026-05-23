import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/select_branch_controller.dart';
import '../widgets/branch_card.dart';

class SelectBranchView extends StatelessWidget {
  final Map<String, dynamic> product;
  final String plan;

  const SelectBranchView({
    super.key,
    required this.product,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    // Inject and register the SelectBranchController
    final controller = Get.put(SelectBranchController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ),
        title: const Text(
          AppStrings.selectBranchTitle,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Bar Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: controller.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: AppStrings.searchBranchHint,
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Image.asset(
                      AppAssets.search,
                      width: 18,
                      height: 18,
                      color: const Color(0xFF94A3B8),
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        );
                      },
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          
          // 2. Scrollable list of branches
          Expanded(
            child: Obx(() {
              final branchList = controller.filteredBranches;
              final selectedId = controller.selectedBranchId.value;

              if (branchList.isEmpty) {
                return const Center(
                  child: Text(
                    'No branches found.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: branchList.length,
                itemBuilder: (context, index) {
                  final branch = branchList[index];
                  final id = branch['id']!;
                  return BranchCard(
                    name: branch['name']!,
                    address: branch['address']!,
                    isSelected: selectedId == id,
                    onTap: () => controller.selectBranch(id),
                  );
                },
              );
            }),
          ),
          
          // 3. Bottom Sticky Action Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => controller.submit(context, product, plan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28), // Pill shape matching mockup
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
