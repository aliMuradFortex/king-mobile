import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    bool isError = false,
  }) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;

    final snackBar = SnackBar(
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? const Color(0xFFC0392B) : AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      dismissDirection: DismissDirection.up,
      margin: EdgeInsets.only(
        top: statusBarHeight + 8,
        left: 16,
        right: 16,
        bottom: screenHeight - statusBarHeight - 120 > 0 
            ? screenHeight - statusBarHeight - 120 
            : 16,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null && title.isNotEmpty) ...[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: title != null ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
