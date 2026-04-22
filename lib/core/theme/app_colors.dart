import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF003D7C);
  static const secondary = Color(0xFF1976D2);
  static const accent = Color(0xFFE3F2FD);

  // Latar Belakang & Teks
  static const background = Color(0xFFF9FAFC);
  static const textPrimary = Color(0xFF0A1F44);
  static const textSecondary = Color(0xFF757F91);
  
  // Status Warna (Sesuai SRS untuk status tiket)
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);

  // Tambahkan ini di dalam class AppColors
  static const backgroundDark = Color(0xFF121212);
  static const surfaceDark = Color(0xFF1E1E1E);
  static const textPrimaryDark = Color(0xFFE1E1E1);
  static const textSecondaryDark = Color(0xFFA0A0A0);
}

// Extension untuk mendapatkan warna berdasarkan tema (light/dark)
extension ThemeColors on BuildContext {
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get textColor => Theme.of(this).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
  Color get textPrimaryColor => Theme.of(this).textTheme.titleLarge?.color ?? AppColors.textPrimary;
  Color get textSecondaryColor => Theme.of(this).textTheme.bodySmall?.color ?? AppColors.textSecondary;
  Color get errorColor => Theme.of(this).colorScheme.error;
  Color get successColor => Theme.of(this).colorScheme.primary;
  Color get warningColor => const Color(0xFFFFC107);
  Color get borderColor => Theme.of(this).brightness == Brightness.dark 
      ? const Color(0xFF333333) 
      : const Color(0xFFE0E0E0);
  Color get cardBackgroundColor => Theme.of(this).brightness == Brightness.dark 
      ? const Color(0xFF1E1E1E) 
      : const Color(0xFFFFFFFF);
}
