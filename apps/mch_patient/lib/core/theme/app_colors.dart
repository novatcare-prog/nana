import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Pink/Purple Theme
  static const Color primaryPink = Color(0xFFE91E63); // Material Pink
  static const Color primaryPinkLight = Color(0xFFF06292);
  static const Color primaryPinkDark = Color(0xFFC2185B);
  
  static const Color accentPurple = Color(0xFF9C27B0); // Material Purple
  static const Color accentPurpleLight = Color(0xFFBA68C8);
  static const Color accentPurpleDark = Color(0xFF7B1FA2);

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  
  static const Color error = Color(0xFFF44336); // Red
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);
  
  static const Color info = Color(0xFF2196F3); // Blue
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFFBDBDBD);
  
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textDisabledDark = Color(0xFF666666);

  // Divider Colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Shadow Colors
  static const Color shadowLight = Color(0x1F000000);
  static const Color shadowDark = Color(0x3F000000);

  // Special Colors
  static const Color pregnancy = Color(0xFFE91E63); // Pink for pregnancy
  static const Color child = Color(0xFF9C27B0); // Purple for children
  static const Color appointment = Color(0xFF2196F3); // Blue for appointments
  static const Color vaccination = Color(0xFF4CAF50); // Green for vaccinations
  static const Color growth = Color(0xFFFF9800); // Orange for growth tracking

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPink, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [successLight, success],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warningLight, warning],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}