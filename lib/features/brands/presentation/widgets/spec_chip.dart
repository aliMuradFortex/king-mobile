import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SpecChip extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;

  const SpecChip({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Image
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            color: AppColors.primary,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.star_rounded,
                size: 24,
                color: AppColors.primary,
              );
            },
          ),
          const SizedBox(height: 10),
          
          // Spec Label
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          
          // Spec Value
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
