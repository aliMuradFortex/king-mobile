import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/application_process_controller.dart';

class ReviewOrderView extends StatelessWidget {
  final Map<String, dynamic> product;
  final String plan;
  final Map<String, dynamic> branch;
  final Map<String, String> personalDetails;
  final String frontCnic;
  final String backCnic;
  final String frontCnicRelative;
  final String backCnicRelative;

  const ReviewOrderView({
    super.key,
    required this.product,
    required this.plan,
    required this.branch,
    required this.personalDetails,
    required this.frontCnic,
    required this.backCnic,
    required this.frontCnicRelative,
    required this.backCnicRelative,
  });

  @override
  Widget build(BuildContext context) {
    // Find the active ApplicationProcessController
    final controller = Get.find<ApplicationProcessController>();

    final String modelName = product['model'] ?? product['name'] ?? '';

    // Calculate installment price dynamically based on product price and months
    int months = 6;
    final RegExp regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(plan);
    if (match != null) {
      months = int.tryParse(match.group(0) ?? '') ?? 6;
    }
    
    final double price = (product['price'] is num)
        ? (product['price'] as num).toDouble()
        : double.tryParse(product['price']?.toString() ?? '') ??
            double.tryParse(product['min_price']?.toString() ?? '') ??
            385000.0;
            
    double advance = price * 0.10;
    double monthlyAmount = (price * 0.9) / months;

    final plans = product['installment_plans'] as List<dynamic>?;
    if (plans != null) {
      final matchingPlan = plans.firstWhereOrNull((p) {
        final label = (p['label'] as String?)?.toLowerCase() ?? '';
        final duration = '${p['duration_months']} months';
        return label == plan.toLowerCase() || duration == plan.toLowerCase();
      });
      if (matchingPlan != null) {
        advance = double.tryParse(matchingPlan['advance_amount']?.toString() ?? 
                                  matchingPlan['advance_payment']?.toString() ?? '') ?? advance;
        monthlyAmount = double.tryParse(matchingPlan['monthly_installment']?.toString() ?? '') ?? monthlyAmount;
      }
    }
    
    // Format helpers
    final String monthlyFormatted = 'Rs. ${monthlyAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/month';
    final String advanceFormatted = 'Rs. ${advance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    // Mask CNIC number (Format: 35201-XXXXXXX-X)
    final String rawCnic = personalDetails['cnic'] ?? '';
    String maskedCnic = rawCnic;
    if (rawCnic.length >= 15) {
      maskedCnic = '${rawCnic.substring(0, 6)}XXXXXXX-${rawCnic.substring(14)}';
    }

    // Concatenate full address
    final String fullAddress = "${personalDetails['address']}, ${personalDetails['city']}, ${personalDetails['postalCode']}, Pakistan";

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
          AppStrings.reviewOrderTitle,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_horiz_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Handset summary card
                  _buildProductCard(
                    context: context,
                    modelName: modelName,
                    planName: plan,
                    monthlyFormatted: monthlyFormatted,
                    advanceFormatted: advanceFormatted,
                  ),
                  const SizedBox(height: 24),

                  // PAYMENT METHOD SECTION
                  const Text(
                    'PAYMENT METHOD',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final selectedMethod = controller.paymentMethod.value;
                    return Row(
                      children: [
                        // Installment Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.paymentMethod.value = 'installment',
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: selectedMethod == 'installment' ? const Color(0xFFF1F5F9) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selectedMethod == 'installment' ? AppColors.primary : const Color(0xFFE2E8F0),
                                  width: selectedMethod == 'installment' ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selectedMethod == 'installment'
                                        ? Icons.check_box_rounded
                                        : Icons.check_box_outline_blank_rounded,
                                    color: selectedMethod == 'installment' ? AppColors.primary : const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Installment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Cash Option
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.paymentMethod.value = 'cash',
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: selectedMethod == 'cash' ? const Color(0xFFF1F5F9) : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selectedMethod == 'cash' ? AppColors.primary : const Color(0xFFE2E8F0),
                                  width: selectedMethod == 'cash' ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selectedMethod == 'cash'
                                        ? Icons.check_box_rounded
                                        : Icons.check_box_outline_blank_rounded,
                                    color: selectedMethod == 'cash' ? AppColors.primary : const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Cash',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),

                  // 3. Personal Details header & summary card
                  _buildSectionHeader(
                    title: AppStrings.personalDetailsTitle,
                    actionText: AppStrings.editDetailsText,
                    icon: Icons.edit_outlined,
                    onTap: () {
                      // Navigate back to step 1
                      controller.activeStep.value = 1;
                      context.pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPersonalDetailsCard(
                    name: personalDetails['name'] ?? '',
                    fatherName: personalDetails['father_name'] ?? '',
                    cnic: maskedCnic,
                    address: fullAddress,
                  ),
                  const SizedBox(height: 24),

                  // 4. Documents header & checklist
                  _buildSectionHeader(
                    title: AppStrings.documentsHeader,
                    actionText: AppStrings.reUploadText,
                    icon: Icons.replay_rounded,
                    onTap: () {
                      // Navigate back to step 2
                      controller.activeStep.value = 2;
                      context.pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildDocumentRow(
                    title: AppStrings.cnicCopyLabel,
                    subtitle: AppStrings.cnicCopySub,
                    icon: Icons.credit_card_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildDocumentRow(
                    title: AppStrings.securityChequeLabel,
                    subtitle: AppStrings.securityChequeSub,
                    icon: Icons.wallet_rounded,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Submit Action Button
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
                child: Obx(() {
                  final isSubmitting = controller.isSubmittingOrder.value;
                  return ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => controller.submitOrder(
                              context,
                              product: product,
                              plan: plan,
                              branch: branch,
                              personalDetails: personalDetails,
                              frontCnicRelative: frontCnicRelative,
                              backCnicRelative: backCnicRelative,
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: isSubmitting
                        ? const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.submitOrderButton,
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
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handset Card
  Widget _buildProductCard({
    required BuildContext context,
    required String modelName,
    required String planName,
    required String monthlyFormatted,
    required String advanceFormatted,
  }) {
    // Get product image
    final List<dynamic> images = product['images'] ?? [];
    String imagePath = '';
    if (product['featured_image'] != null) {
      imagePath = product['featured_image'];
    } else if (images.isNotEmpty) {
      final first = images.first;
      if (first is Map) {
        imagePath = first['image_path'] ?? '';
      } else {
        imagePath = first.toString();
      }
    }
    if (imagePath.isEmpty) {
      imagePath = AppAssets.iphone15;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Handset thumbnail
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: imagePath.startsWith('http')
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.phone_iphone_rounded, color: Colors.white, size: 36);
                      },
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.phone_iphone_rounded, color: Colors.white, size: 36);
                      },
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Handset info texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        modelName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Pop twice to return to details page
                        Navigator.of(context).pop(); // Pop ReviewOrder
                        Navigator.of(context).pop(); // Pop ApplicationProcess
                        Navigator.of(context).pop(); // Pop SelectBranch
                      },
                      child: const Text(
                        AppStrings.editText,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: Colors.white54, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      planName,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, color: Colors.white54, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      monthlyFormatted,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.percent_rounded, color: Colors.white54, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '$advanceFormatted Down Payment',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  // Section header
  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF1E5B99), size: 14),
              const SizedBox(width: 4),
              Text(
                actionText,
                style: const TextStyle(
                  color: Color(0xFF1E5B99),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Personal details summary container
  Widget _buildPersonalDetailsCard({
    required String name,
    required String fatherName,
    required String cnic,
    required String address,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(AppStrings.fullNameHeader, name),
          const SizedBox(height: 16),
          _buildDetailRow("FATHER'S NAME", fatherName),
          const SizedBox(height: 16),
          _buildDetailRow(AppStrings.cnicNumberHeader, cnic),
          const SizedBox(height: 16),
          _buildDetailRow(AppStrings.currentAddressHeader, address),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Document uploaded row card
  Widget _buildDocumentRow({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Icon avatar (emblem yellow circle)
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD97706),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Right checkbox status
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                AppStrings.uploadedBadge,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
