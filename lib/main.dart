import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Wajib sesuai CLAUDE.md
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp())); // ProviderScope untuk Riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Ticketing Helpdesk',
      theme: AppTheme.lightTheme, // Integrasi Tema Light sesuai reference
      darkTheme: AppTheme.darkTheme, // Integrasi Tema Dark
      themeMode: ThemeMode.light, // Menampilkan Tema Light secara default
      home: const DashboardScreen(), // Tampilkan Dashboard Screen sebagai default
    );
  }
}