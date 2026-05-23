import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/brands_controller.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_grid.dart';
import '../../../home/presentation/widgets/home_header.dart';
import '../../../home/presentation/widgets/search_filter_bar.dart';

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Register BrandsController
    Get.put(BrandsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // Action on pull-to-refresh
        },
        color: const Color(0xFF001E40),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              SizedBox(height: 12),
              // 1. Reuse existing greeting header
              HomeHeader(),
              
              // 2. Reuse search box & filter trigger bar
              SearchFilterBar(),
              SizedBox(height: 12),
              
              // 3. Category Chip Filter Row
              CategoryChips(),
              SizedBox(height: 8),
              
              // 4. Products list grid
              ProductGrid(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
