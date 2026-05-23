import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SelectBranchController extends GetxController {
  // Active search query
  final RxString searchQuery = ''.obs;

  // Selected branch identifier (defaulting to the first branch)
  final RxString selectedBranchId = 'branch_1'.obs;

  // Mock list of branches matching the mockup
  final List<Map<String, String>> branches = [
    {
      'id': 'branch_1',
      'name': 'King Mobile',
      'address': 'Main Boulevard, Gulberg III\nLahore',
    },
    {
      'id': 'branch_2',
      'name': 'King Mobile',
      'address': 'Block H, Commercial Area\nLahore',
    },
    {
      'id': 'branch_3',
      'name': 'King Mobile',
      'address': 'Y Block, Johar town\nLahore',
    },
    {
      'id': 'branch_4',
      'name': 'King Mobile',
      'address': 'Block H, Commercial Area\nLahore',
    },
    {
      'id': 'branch_5',
      'name': 'King Mobile',
      'address': 'Block H, Commercial Area\nLahore',
    },
  ];

  // Filtering getter by search query
  List<Map<String, String>> get filteredBranches {
    if (searchQuery.value.trim().isEmpty) {
      return branches;
    }
    final query = searchQuery.value.trim().toLowerCase();
    return branches.where((b) {
      final name = b['name']?.toLowerCase() ?? '';
      final address = b['address']?.toLowerCase() ?? '';
      return name.contains(query) || address.contains(query);
    }).toList();
  }

  void selectBranch(String id) {
    selectedBranchId.value = id;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Action on Continue button
  void submit(BuildContext context, Map<String, dynamic> product, String plan) {
    final selectedBranch = branches.firstWhere(
      (b) => b['id'] == selectedBranchId.value,
      orElse: () => branches.first,
    );

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
