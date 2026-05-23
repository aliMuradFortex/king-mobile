import 'package:get/get.dart';

class BrandsController extends GetxController {
  // Currently selected category chip, default is 'All'
  final RxString selectedCategory = 'All'.obs;

  // List of category names matching the mockup filter options
  final List<String> categories = ['All', 'Samsung', 'Apple', 'Vivo', 'Oppo', 'Infinix'];

  // Master product list corresponding to mockup details with spec details
  final List<Map<String, dynamic>> products = [
    {
      'id': 'iphone_15_pro_max',
      'brand': 'Apple',
      'model': 'iPhone 15 Pro Max',
      'price': 425000.0,
      'priceFormatted': 'Rs. 425,000',
      'instalmentPrice': 'Rs. 24,500/mo',
      'tag': 'HOT DEAL',
      'images': [
        'assets/images/iphone15.png',
        'assets/images/featured_handset.png',
      ],
      'specs': {
        'battery': '4441 mAh',
        'ram': '8 GB',
        'storage': '256 GB',
        'camera': '48 MP',
        'display': '6.7 inches'
      }
    },
    {
      'id': 'galaxy_s24_ultra',
      'brand': 'Samsung',
      'model': 'Galaxy S24 Ultra',
      'price': 385000.0,
      'priceFormatted': 'Rs. 385,000',
      'instalmentPrice': 'Rs. 18,200/mo',
      'tag': null,
      'images': [
        'assets/images/featured_handset.png',
        'assets/images/iphone15.png',
      ],
      'specs': {
        'battery': '5000 mAh',
        'ram': '12 GB',
        'storage': '256 GB',
        'camera': '200 MP',
        'display': '6.8 inches'
      }
    },
    {
      'id': 'pixel_8_pro',
      'brand': 'Google',
      'model': 'Pixel 8 Pro',
      'price': 245000.0,
      'priceFormatted': 'Rs. 245,000',
      'instalmentPrice': 'Rs. 12,000/mo',
      'tag': null,
      'images': [
        'assets/images/featured_handset.png',
      ],
      'specs': {
        'battery': '5050 mAh',
        'ram': '12 GB',
        'storage': '128 GB',
        'camera': '50 MP',
        'display': '6.7 inches'
      }
    },
    {
      'id': 'find_x6_pro',
      'brand': 'Oppo',
      'model': 'Find X6 Pro',
      'price': 210000.0,
      'priceFormatted': 'Rs. 210,000',
      'instalmentPrice': 'Rs. 9,500/mo',
      'tag': 'HOT DEAL',
      'images': [
        'assets/images/featured_handset.png',
      ],
      'specs': {
        'battery': '5000 mAh',
        'ram': '12 GB',
        'storage': '256 GB',
        'camera': '50 MP',
        'display': '6.82 inches'
      }
    },
    {
      'id': 'x100_premium',
      'brand': 'Vivo',
      'model': 'X100 Premium',
      'price': 180000.0,
      'priceFormatted': 'Rs. 180,000',
      'instalmentPrice': 'Rs. 8,000/mo',
      'tag': null,
      'images': [
        'assets/images/featured_handset.png',
      ],
      'specs': {
        'battery': '5000 mAh',
        'ram': '16 GB',
        'storage': '512 GB',
        'camera': '50 MP',
        'display': '6.78 inches'
      }
    },
    {
      'id': 'zero_30_ultra',
      'brand': 'Infinix',
      'model': 'Zero 30 Ultra',
      'price': 125000.0,
      'priceFormatted': 'Rs. 125,000',
      'instalmentPrice': 'Rs. 5,500/mo',
      'tag': null,
      'images': [
        'assets/images/featured_handset.png',
      ],
      'specs': {
        'battery': '5000 mAh',
        'ram': '8 GB',
        'storage': '256 GB',
        'camera': '108 MP',
        'display': '6.78 inches'
      }
    }
  ];

  // Reactively filter product list based on the selected brand category
  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory.value == 'All') {
      return products;
    }
    return products
        .where((product) =>
            product['brand'].toString().toLowerCase() ==
            selectedCategory.value.toLowerCase())
        .toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
