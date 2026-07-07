import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/application_process_controller.dart';

class PersonalDetailsStep extends StatelessWidget {
  final ApplicationProcessController controller;

  const PersonalDetailsStep({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Text Field
          _buildTextField(
            controller: controller.nameController,
            hintText: AppStrings.nameLabel,
            keyboardType: TextInputType.name,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),

          // Father's Name Text Field
          _buildTextField(
            controller: controller.fatherNameController,
            hintText: "Father's Name (as per CNIC)",
            keyboardType: TextInputType.name,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),

          // Phone Number Text Field
          _buildPhoneField(),
          const SizedBox(height: 16),

          // CNIC Number Text Field
          _buildTextField(
            controller: controller.cnicController,
            hintText: AppStrings.cnicLabel,
            keyboardType: TextInputType.number,
            icon: Icons.credit_card_rounded,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(13),
              _CnicFormatter(),
            ],
          ),
          const SizedBox(height: 16),

          // Residential Address Text Field
          _buildTextField(
            controller: controller.addressController,
            hintText: AppStrings.addressLabel,
            keyboardType: TextInputType.streetAddress,
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: 16),

          // City and Postal Code (Side-by-Side Row)
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller.cityController,
                  hintText: AppStrings.cityLabel,
                  keyboardType: TextInputType.text,
                  icon: Icons.location_city_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: controller.postalCodeController,
                  hintText: AppStrings.postalCodeLabel,
                  keyboardType: TextInputType.number,
                  icon: Icons.markunread_mailbox_outlined,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Confidential Data Info Banner
          _buildConfidentialBanner(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Generic Text Field Builder matching mockup styling (rounded light grey)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    IconData? icon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light grey background
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: icon != null 
              ? Icon(icon, color: const Color(0xFF94A3B8), size: 20) 
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Phone Number Input with phone icon
  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light grey background
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.phone_android_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Actual input field
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11), // Limit Pakistani mobile number length (including 0)
              ],
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: '0300 1234567',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 18),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Confidentiality message banner with shield checkmark icon
  Widget _buildConfidentialBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.confidential,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.verified_user_rounded,
                color: Color(0xFF855D11), // Golden brown
                size: 24,
              );
            },
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              AppStrings.dataConfidentialText,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom formatter for CNIC format: 00000-0000000-0 (standard Pakistan ID card format)
class _CnicFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 5 || nonZeroIndex == 12) {
        if (nonZeroIndex != text.length) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
