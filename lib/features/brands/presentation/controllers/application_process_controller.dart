import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/dio_api_service.dart';

class ApplicationProcessController extends GetxController {
  // Wizard active step (1 or 2)
  final RxInt activeStep = 1.obs;

  // Selected payment method ('installment' or 'cash')
  final RxString paymentMethod = 'installment'.obs;

  // Form Fields Controllers
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final phoneController = TextEditingController();
  final cnicController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();

  // Local Image Display Paths (URLs once uploaded)
  final RxString frontCnicPath = ''.obs;
  final RxString backCnicPath = ''.obs;

  // Server Relative Paths for Order API
  final RxString frontCnicRelativePath = ''.obs;
  final RxString backCnicRelativePath = ''.obs;

  // Uploading status
  final RxBool isUploadingFront = false.obs;
  final RxBool isUploadingBack = false.obs;

  // Submitting Order status
  final RxBool isSubmittingOrder = false.obs;

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = DioApiService();

  @override
  void onClose() {
    nameController.dispose();
    fatherNameController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    addressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }

  // Pick & Upload Front CNIC
  Future<void> pickCnicFront(BuildContext context) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        frontCnicPath.value = file.name;
        isUploadingFront.value = true;

        final response = await _apiService.uploadMultipleFiles([file.path], 'cnic_images');
        isUploadingFront.value = false;

        final success = response['success'] as bool? ?? false;
        if (success && response['data'] != null && response['data']['files'] != null) {
          final files = response['data']['files'] as List<dynamic>;
          if (files.isNotEmpty) {
            frontCnicRelativePath.value = files.first['path'] ?? '';
            frontCnicPath.value = files.first['url'] ?? file.name;
          }
        } else {
          frontCnicPath.value = '';
          frontCnicRelativePath.value = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] as String? ?? 'Failed to upload CNIC front.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      isUploadingFront.value = false;
      frontCnicPath.value = '';
      frontCnicRelativePath.value = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking/uploading CNIC front: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Pick & Upload Back CNIC
  Future<void> pickCnicBack(BuildContext context) async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        backCnicPath.value = file.name;
        isUploadingBack.value = true;

        final response = await _apiService.uploadMultipleFiles([file.path], 'cnic_images');
        isUploadingBack.value = false;

        final success = response['success'] as bool? ?? false;
        if (success && response['data'] != null && response['data']['files'] != null) {
          final files = response['data']['files'] as List<dynamic>;
          if (files.isNotEmpty) {
            backCnicRelativePath.value = files.first['path'] ?? '';
            backCnicPath.value = files.first['url'] ?? file.name;
          }
        } else {
          backCnicPath.value = '';
          backCnicRelativePath.value = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] as String? ?? 'Failed to upload CNIC back.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      isUploadingBack.value = false;
      backCnicPath.value = '';
      backCnicRelativePath.value = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking/uploading CNIC back: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Reset CNIC Front
  void resetCnicFront() {
    frontCnicPath.value = '';
    frontCnicRelativePath.value = '';
  }

  // Reset CNIC Back
  void resetCnicBack() {
    backCnicPath.value = '';
    backCnicRelativePath.value = '';
  }

  // Handle Transition / Continue action
  void handleContinue(
    BuildContext context, {
    required Map<String, dynamic> product,
    required String plan,
    required Map<String, dynamic> branch,
  }) {
    if (activeStep.value == 1) {
      // Validate Step 1
      if (nameController.text.trim().isEmpty ||
          fatherNameController.text.trim().isEmpty ||
          phoneController.text.trim().isEmpty ||
          cnicController.text.trim().isEmpty ||
          addressController.text.trim().isEmpty ||
          cityController.text.trim().isEmpty ||
          postalCodeController.text.trim().isEmpty) {
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all details to proceed.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      
      // Basic CNIC length validation check (Pakistan CNIC format has 13 digits)
      final cleanCnic = cnicController.text.replaceAll(RegExp(r'\D'), '');
      if (cleanCnic.length < 13) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid CNIC number.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Move to Step 2
      activeStep.value = 2;
    } else if (activeStep.value == 2) {
      // Validate Step 2 - check relative server paths are populated
      if (frontCnicRelativePath.isEmpty || backCnicRelativePath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload both Front and Back sides of your CNIC.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Route to Review Order Screen
      context.push(
        '/review-order',
        extra: {
          'product': product,
          'plan': plan,
          'branch': branch,
          'personalDetails': {
            'name': nameController.text.trim(),
            'father_name': fatherNameController.text.trim(),
            'phone': phoneController.text.trim(),
            'cnic': cnicController.text.trim(),
            'address': addressController.text.trim(),
            'city': cityController.text.trim(),
            'postalCode': postalCodeController.text.trim(),
          },
          'frontCnic': frontCnicPath.value,
          'backCnic': backCnicPath.value,
          'frontCnicRelative': frontCnicRelativePath.value,
          'backCnicRelative': backCnicRelativePath.value,
        },
      );
    }
  }

  // Back Navigation / Back Step
  void handleBack(BuildContext context) {
    if (activeStep.value == 2) {
      activeStep.value = 1;
    } else {
      context.pop();
    }
  }

  // Final Order Submission Routing via API
  Future<void> submitOrder(
    BuildContext context, {
    required Map<String, dynamic> product,
    required String plan,
    required Map<String, dynamic> branch,
    required Map<String, String> personalDetails,
    required String frontCnicRelative,
    required String backCnicRelative,
  }) async {
    try {
      isSubmittingOrder.value = true;

      int variationId = product['selected_variation_id'] is int 
          ? product['selected_variation_id'] 
          : int.tryParse(product['selected_variation_id']?.toString() ?? '') ?? 1;

      if (variationId == 1 && product['variations'] != null && (product['variations'] as List).isNotEmpty) {
        final v = product['variations'].first;
        if (v is Map && v['id'] != null) {
          variationId = v['id'] is int ? v['id'] : int.tryParse(v['id'].toString()) ?? 1;
        }
      }

      final int productId = product['id'] is int ? product['id'] : int.tryParse(product['id'].toString()) ?? 1;

      final cleanCnic = personalDetails['cnic']?.replaceAll(RegExp(r'\D'), '') ?? '';
      
      String phoneVal = personalDetails['phone'] ?? '';
      phoneVal = phoneVal.replaceAll(RegExp(r'\D'), ''); // Strip non-digits
      if (!phoneVal.startsWith('0') && phoneVal.isNotEmpty) {
        phoneVal = '0$phoneVal';
      }

      int months = 6;
      final RegExp regExp = RegExp(r'\d+');
      final match = regExp.firstMatch(plan);
      if (match != null) {
        months = int.tryParse(match.group(0) ?? '') ?? 6;
      }
      
      final Map<String, dynamic> orderData = {
        'product_id': productId,
        'website_product_id': productId,
        'product_variation_id': variationId,
        'website_product_variation_id': variationId,
        'name': personalDetails['name'] ?? '',
        'father_name': personalDetails['father_name'] ?? '',
        'phone_no_1': phoneVal,
        'cnic_number': cleanCnic,
        'address': "${personalDetails['address']}, ${personalDetails['city']}, ${personalDetails['postalCode']}, Pakistan",
        'cnic_front_path': frontCnicRelative,
        'cnic_back_path': backCnicRelative,
        'payment_method': paymentMethod.value,
        'installment_duration': months,
      };

      final response = await _apiService.createOrder(orderData);
      isSubmittingOrder.value = false;

      final success = response['success'] as bool? ?? false;
      if (success && response['data'] != null) {
        final orderDetails = response['data'] as Map<String, dynamic>;
        final orderNumber = orderDetails['order_number']?.toString() ?? '#ORD-000000';

        context.push(
          '/order-submitted',
          extra: {
            'transactionId': orderNumber,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] as String? ?? 'Failed to place order.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      isSubmittingOrder.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting order: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
