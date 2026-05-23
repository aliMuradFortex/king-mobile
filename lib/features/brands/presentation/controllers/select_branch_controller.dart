import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';

class SelectBranchController extends GetxController {
  // Active search query
  final RxString searchQuery = ''.obs;

  // Selected branch identifier
  final Rx<dynamic> selectedBranchId = Rx<dynamic>(null);

  // Dynamic list of branches
  final RxList<dynamic> branches = <dynamic>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  final ApiService _apiService = DioApiService();

  @override
  void onInit() {
    super.onInit();
    fetchBranches();
  }

  Future<void> fetchBranches() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _apiService.getBranches();
      isLoading.value = false;

      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        final list = response['data'] as List<dynamic>;
        branches.value = list;
        if (list.isNotEmpty) {
          selectedBranchId.value = list.first['id'];
        }
      } else {
        errorMessage.value = response['message'] as String? ?? 'Failed to load branches.';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  // Filtering getter by search query
  List<dynamic> get filteredBranches {
    if (searchQuery.value.trim().isEmpty) {
      return branches;
    }
    final query = searchQuery.value.trim().toLowerCase();
    return branches.where((b) {
      final name = b['name']?.toString().toLowerCase() ?? '';
      final address = b['address']?.toString().toLowerCase() ?? '';
      return name.contains(query) || address.contains(query);
    }).toList();
  }

  void selectBranch(dynamic id) {
    selectedBranchId.value = id;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Action on Continue button
  void submit(BuildContext context, Map<String, dynamic> product, String plan) {
    if (selectedBranchId.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pickup branch.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final selectedBranch = branches.firstWhere(
      (b) => b['id'] == selectedBranchId.value,
      orElse: () => null,
    );

    if (selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid branch selected.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.push(
      '/application-process',
      extra: {
        'product': product,
        'plan': plan,
        'branch': selectedBranch,
      },
    );
  }
}
