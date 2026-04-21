import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'package:e_ticketing/core/providers/shared_prefs_provider.dart';

void main() async {
  // 1. Wajib panggil ini agar SharedPreferences bisa berjalan di native
  WidgetsFlutterBinding.ensureInitialized(); 

  // 2. Inisialisasi SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // 3. Masukkan instance prefs ke provider agar bisa dipakai di tempat lain
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tambahan agar rapi
      title: 'E-Ticketing Helpdesk',
      theme: AppTheme.lightTheme, 
      darkTheme: AppTheme.darkTheme, 
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}