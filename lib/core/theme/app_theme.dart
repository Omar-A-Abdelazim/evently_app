import 'package:evently_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.mainLight,
      onPrimary: AppColors.inputsLight,
      secondary: AppColors.mainTextLight,
      onSecondary: AppColors.inputsLight,
      error: AppColors.red,
      onError: AppColors.inputsLight,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.mainTextLight,
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.mainTextLight,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mainLight,
        foregroundColor: AppColors.inputsLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.mainLight,
        side: BorderSide(width: 1, color: AppColors.mainLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.mainLight,
      foregroundColor: AppColors.inputsLight,
      shape: CircleBorder(),
      elevation: 4,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextLight,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextLight,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.mainTextLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.mainTextLight,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.mainTextLight,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextLight,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextLight,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextLight,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.mainDark,
      onPrimary: Colors.white,
      secondary: AppColors.secTextDark,
      onSecondary: Colors.white,
      error: AppColors.redDark,
      onError: Colors.white,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.mainTextDark,
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.mainTextDark,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mainDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.mainDark,
        side: BorderSide(width: 1, color: AppColors.mainDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        padding: EdgeInsets.all(16),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.mainDark,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      elevation: 4,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextDark,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextDark,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.mainTextDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.mainTextDark,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.secTextDark,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextDark,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.mainTextDark,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.secTextDark,
      ),
    ),
  );
}
