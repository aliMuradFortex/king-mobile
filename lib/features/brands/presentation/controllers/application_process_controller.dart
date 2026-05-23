import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ApplicationProcessController extends GetxController {
  // Wizard active step (1 or 2)
  final RxInt activeStep = 1.obs;

  // Form Fields Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cnicController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();

  // Mock Upload Paths
  final RxString frontCnicPath = ''.obs;
  final RxString backCnicPath = ''.obs;

  // Validation observables for inline error feedback if needed
  final RxBool hasValidationError = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    addressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }

  // Pick/Capture Front CNIC
  void pickCnicFront() {
    // Mimic taking/uploading photo
    frontCnicPath.value = 'CNIC_Front_Captured.jpg';
  }

  // Pick/Capture Back CNIC
  void pickCnicBack() {
    // Mimic taking/uploading photo
    backCnicPath.value = 'CNIC_Back_Captured.jpg';
  }

  // Reset CNIC Front
  void resetCnicFront() {
    frontCnicPath.value = '';
  }

  // Reset CNIC Back
  void resetCnicBack() {
    backCnicPath.value = '';
  }

  // Handle Transition / Continue action
  void handleContinue(
    BuildContext context, {
    required Map<String, dynamic> product,
    required String plan,
    required Map<String, String> branch,
  }) {
    if (activeStep.value == 1) {
      // Validate Step 1
      if (nameController.text.trim().isEmpty ||
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
      // Validate Step 2
      if (frontCnicPath.isEmpty || backCnicPath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload both Front and Back sides of your CNIC.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Route to Review Order Screen instead of showing dialog
      context.push(
        '/review-order',
        extra: {
          'product': product,
          'plan': plan,
          'branch': branch,
          'personalDetails': {
            'name': nameController.text.trim(),
            'phone': phoneController.text.trim(),
            'cnic': cnicController.text.trim(),
            'address': addressController.text.trim(),
            'city': cityController.text.trim(),
            'postalCode': postalCodeController.text.trim(),
          },
          'frontCnic': frontCnicPath.value,
          'backCnic': backCnicPath.value,
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

  // Final Order Submission Routing
  void submitOrder(
    BuildContext context, {
    required Map<String, dynamic> product,
    required String plan,
    required Map<String, String> branch,
  }) {
    // Generate a mock transaction ID (e.g. #KM-98231)
    final int randomNum = 10000 + (DateTime.now().microsecondsSinceEpoch % 90000);
    final String transactionId = '#KM-$randomNum';

    // Route to Order Submitted Screen
    context.push(
      '/order-submitted',
      extra: {
        'transactionId': transactionId,
      },
    );
  }
}
