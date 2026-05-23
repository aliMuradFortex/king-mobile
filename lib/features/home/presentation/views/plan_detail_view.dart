import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';

class PlanDetailView extends StatelessWidget {
  final String modelName;
  final String planDuration;
  final bool isActive;
  final String paid;
  final String remaining;
  final String monthly;
  final String downpayment;

  const PlanDetailView({
    super.key,
    required this.modelName,
    required this.planDuration,
    required this.isActive,
    required this.paid,
    required this.remaining,
    required this.monthly,
    required this.downpayment,
  });

  @override
  Widget build(BuildContext context) {
    // Determine summary details based on mockup values
    String paidInstallmentText;
    String remainingInstallmentText;
    String amountPaidText;
    String remainingAmountText;

    if (isActive) {
      // Mockup active values (matches image details)
      paidInstallmentText = '02 of 06';
      remainingInstallmentText = remaining;
      amountPaidText = 'Rs. 183,340';
      remainingAmountText = 'Rs. 146,668';
    } else {
      // Completed plan values
      paidInstallmentText = '06 of 06';
      remainingInstallmentText = '00 Installments';
      amountPaidText = 'Rs. 330,008';
      remainingAmountText = 'Rs. 0';
    }

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
          AppStrings.planDetailTitle,
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Plan Card (same style as in MyPlansView)
              _buildTopPlanCard(),
              const SizedBox(height: 24),
              
              // 2. Payment Summary Card Section
              Text(
                AppStrings.paymentSummaryTitle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildPaymentSummaryCard(
                paidInstallment: paidInstallmentText,
                remainingInstallment: remainingInstallmentText,
                amountPaid: amountPaidText,
                remainingAmount: remainingAmountText,
              ),
              const SizedBox(height: 24),
              
              // 3. Installmet History Section
              Text(
                AppStrings.installmentHistoryTitle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Installment cards list
              if (isActive) ...[
                // Item 1: Paid (Green)
                _buildHistoryItem(
                  title: 'Installment -01',
                  date: 'Nov 2025',
                  amount: 'Rs. 36,667',
                  status: 'Paid',
                  borderType: 'green',
                  icon: Icons.check_circle_outlined,
                ),
                const SizedBox(height: 12),
                
                // Item 2: Due (Red)
                _buildHistoryItem(
                  title: 'Installment -02',
                  date: 'Dec 2025',
                  amount: 'Rs. 36,667',
                  status: 'Due',
                  borderType: 'red',
                  icon: Icons.history_toggle_off_rounded,
                ),
                const SizedBox(height: 12),
                
                // Item 3: Upcoming (Blue)
                _buildHistoryItem(
                  title: 'Installment -03',
                  date: 'Jan 2026',
                  amount: 'Rs. 36,667',
                  status: 'Upcoming',
                  borderType: 'blue',
                  icon: Icons.access_time_rounded,
                ),
              ] else ...[
                // Completed items (all green checkmarks)
                _buildHistoryItem(
                  title: 'Installment -01',
                  date: 'Nov 2025',
                  amount: 'Rs. 36,667',
                  status: 'Paid',
                  borderType: 'green',
                  icon: Icons.check_circle_outlined,
                ),
                const SizedBox(height: 12),
                _buildHistoryItem(
                  title: 'Installment -02',
                  date: 'Dec 2025',
                  amount: 'Rs. 36,667',
                  status: 'Paid',
                  borderType: 'green',
                  icon: Icons.check_circle_outlined,
                ),
                const SizedBox(height: 12),
                _buildHistoryItem(
                  title: 'Installment -03',
                  date: 'Jan 2026',
                  amount: 'Rs. 36,667',
                  status: 'Paid',
                  borderType: 'green',
                  icon: Icons.check_circle_outlined,
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopPlanCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dark navy thumbnail
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    AppAssets.featuredHandset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.phone_iphone_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                
                // Model details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modelName,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        planDuration,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status Badge pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF10B981) : AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isActive ? AppStrings.activeStatus : AppStrings.completedStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Far right chevron arrow
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 24,
                ),
              ],
            ),
            
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Container(
                height: 1,
                color: const Color(0xFFE2E8F0),
              ),
            ),
            
            // Bottom grid section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopCardRow(AppStrings.paidLabel, paid),
                      const SizedBox(height: 12),
                      _buildTopCardRow(AppStrings.monthlyLabel, monthly),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopCardRow(AppStrings.remainingLabel, remaining),
                      const SizedBox(height: 12),
                      _buildTopCardRow(AppStrings.downpaymentLabel, downpayment),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCardRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
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

  // Payment Summary Card
  Widget _buildPaymentSummaryCard({
    required String paidInstallment,
    required String remainingInstallment,
    required String amountPaid,
    required String remainingAmount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light background card
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildSummaryRow(AppStrings.paidInstallmentLabel, paidInstallment),
          const SizedBox(height: 14),
          _buildSummaryRow(AppStrings.remainingInstallmentLabel, remainingInstallment),
          const SizedBox(height: 14),
          _buildSummaryRow(AppStrings.amountPaidLabel, amountPaid),
          const SizedBox(height: 14),
          _buildSummaryRow(AppStrings.remainingAmountLabel, remainingAmount, isHighlighted: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlighted ? const Color(0xFFEF4444) : AppColors.primary, // Red for highlights
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Installment History Items
  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String amount,
    required String status,
    required String borderType, // 'green', 'red', 'blue'
    required IconData icon,
  }) {
    Color borderColor;
    Color iconColor;
    Color iconBgColor;

    switch (borderType) {
      case 'green':
        borderColor = const Color(0xFF10B981);
        iconColor = const Color(0xFF10B981);
        iconBgColor = const Color(0xFFD1FAE5);
        break;
      case 'red':
        borderColor = const Color(0xFFEF4444);
        iconColor = const Color(0xFFEF4444);
        iconBgColor = const Color(0xFFFEE2E2);
        break;
      case 'blue':
      default:
        borderColor = const Color(0xFF3B82F6);
        iconColor = const Color(0xFF3B82F6);
        iconBgColor = const Color(0xFFDBEAFE);
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        children: [
          // Left circle icon
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          
          // Details (Installment and Month)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Right details (Amount and status)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
