import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    
    // Konfigurasi Font (Menggunakan Google Fonts Poppins agar sesuai desain)
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        color: AppColors.textPrimary, 
        fontWeight: FontWeight.bold, 
        fontSize: 28
      ),
      titleLarge: GoogleFonts.poppins(
        color: AppColors.textPrimary, 
        fontWeight: FontWeight.w600, 
        fontSize: 20
      ),
      bodyMedium: GoogleFonts.poppins(
        color: AppColors.textPrimary, 
        fontSize: 14
      ),
      bodySmall: GoogleFonts.poppins(
        color: AppColors.textSecondary, 
        fontSize: 12
      ),
    ),
    
    // Tampilan AppBar yang transparan dan bersih
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      centerTitle: false,
    ),
  );
  
  // Implementasi Dark Mode (Menyesuaikan warna utama)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: AppColors.primary,
  );
}