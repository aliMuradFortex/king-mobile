import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_assets.dart';
import '../controllers/application_process_controller.dart';

class VerifyIdentityStep extends StatelessWidget {
  final ApplicationProcessController controller;

  const VerifyIdentityStep({
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
          // 1. Upload Instruction Text
          const Text(
            AppStrings.uploadInstruction,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // 2. Front CNIC Upload Card
          Obx(() {
            final isUploaded = controller.frontCnicPath.isNotEmpty;
            return _buildUploadCard(
              title: AppStrings.cnicFrontSide,
              isUploaded: isUploaded,
              fileName: controller.frontCnicPath.value,
              onTap: controller.pickCnicFront,
              onClear: controller.resetCnicFront,
            );
          }),
          const SizedBox(height: 20),

          // 3. Back CNIC Upload Card
          Obx(() {
            final isUploaded = controller.backCnicPath.isNotEmpty;
            return _buildUploadCard(
              title: AppStrings.cnicBackSide,
              isUploaded: isUploaded,
              fileName: controller.backCnicPath.value,
              onTap: controller.pickCnicBack,
              onClear: controller.resetCnicBack,
            );
          }),
          const SizedBox(height: 24),

          // 4. Privacy Guaranteed Dark Navy Banner
          _buildPrivacyBanner(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Upload card container
  Widget _buildUploadCard({
    required String title,
    required bool isUploaded,
    required String fileName,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: isUploaded ? Colors.green : const Color(0xFFCBD5E1),
          strokeWidth: isUploaded ? 2.0 : 1.5,
          borderRadius: 24,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: isUploaded ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon block (Camera or Checkmark)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isUploaded ? Colors.green.shade100 : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: isUploaded
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 32,
                      )
                    : Center(
                        child: Image.asset(
                          AppAssets.camera,
                          width: 28,
                          height: 28,
                          color: AppColors.primary,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.primary,
                              size: 28,
                            );
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Title label
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              // Subtext or Uploaded Filename
              if (isUploaded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        fileName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.cancel_rounded, color: Colors.grey, size: 18),
                      onPressed: () {
                        onClear();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ] else ...[
                const Text(
                  AppStrings.ensureEdgesVisible,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Privacy Guaranteed Dark Banner
  Widget _buildPrivacyBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark slate/navy banner background
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Shield Lock Icon
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Image.asset(
              AppAssets.privacyGuaranteed,
              width: 28,
              height: 28,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.shield_rounded,
                  color: Colors.white,
                  size: 28,
                );
              },
            ),
          ),
          const SizedBox(width: 16),

          // Banner texts column
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.privacyGuaranteedTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  AppStrings.privacyGuaranteedDesc,
                  style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for drawing rounded dashed borders
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    this.color = const Color(0xFFCBD5E1),
    this.strokeWidth = 1.5,
    this.gap = 5.0,
    this.dashLength = 6.0,
    this.borderRadius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    // Draw dashed path
    final dashPath = _buildDashedPath(path, dashLength, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashedPath(Path source, double dashWidth, double dashGap) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashWidth : dashGap;
        if (distance + len >= metric.length) {
          if (draw) {
            dest.addPath(metric.extractPath(distance, metric.length), Offset.zero);
          }
          break;
        }
        if (draw) {
          dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is DashedBorderPainter) {
      return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
    }
    return true;
  }
}
