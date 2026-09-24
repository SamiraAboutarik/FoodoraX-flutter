import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF5A36);
  static const secondary = Color(0xFFFFB703);

  static const background = Color(0xFFF8F8F8);
  static const text = Color(0xFF1F2937);
  static const mutedText = Color(0xFF8A8A8A);

  static const white = Colors.white;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ),

    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      foregroundColor: AppColors.text,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
        borderSide: BorderSide.none,
      ),
    ),
  );
}