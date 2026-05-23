import 'package:get/get.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class BrandsController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();

  // Currently selected category chip, default is 'All'
  final RxString selectedCategory = 'All'.obs;

  // List of category names matching the brands
  List<String> get categories {
    final list = ['All'];
    for (var b in _homeController.brands) {
      final name = b['name'] as String?;
      if (name != null && !list.contains(name)) {
        list.add(name);
      }
    }
    return list;
  }

  // Reactively filter product list based on the selected brand category
  List<dynamic> get filteredProducts {
    final allProducts = _homeController.filteredProducts;
    if (selectedCategory.value == 'All') {
      return allProducts;
    }
    return allProducts.where((product) {
      final brandName = product['brand'] is Map
          ? (product['brand']['name'] ?? '')
          : '';
      return brandName.toString().toLowerCase() ==
          selectedCategory.value.toLowerCase();
    }).toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
