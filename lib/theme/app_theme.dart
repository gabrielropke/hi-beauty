import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme(ThemeColors colors) {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        surface: colors.background,
      ),
      scaffoldBackgroundColor: colors.background,
      fontFamily: 'Sora',
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600),
        displayMedium: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
        displaySmall: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500),
        headlineMedium: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        headlineSmall: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: Colors.black.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Sora',
        ),
      ),
    );
  }
}
