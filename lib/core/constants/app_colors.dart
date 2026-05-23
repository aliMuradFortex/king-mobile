import 'package:flutter/material.dart';

class AppColors {
  // Primary Color: Deep dark blue (from design)
  static const Color primary = Color(0xFF001E40);
  
  // Secondary Color: Golden yellow (from design)
  static const Color secondary = Color(0xFFFFE088);
  
  // A secondary accent variation (slightly darker gold)
  static const Color secondaryDark = Color(0xFFE5B842);
  
  // Neutral Colors
  static const Color background = Color(0xFF00142A); // Extra dark navy for background overlay
  static const Color surface = Color(0xFF0A2B4E); // Card/surface navy blue
  static const Color surfaceLight = Color(0xFF143B66); // Lighter surface blue
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0C4DE);
  static const Color textMuted = Color(0xFF6B8A9E);
  
  // Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF002B5C), // Rich dark blue top
      Color(0xFF001124), // Very dark blue bottom
    ],
  );

  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFFE088),
      Color(0xFFE5B842),
    ],
  );
}
