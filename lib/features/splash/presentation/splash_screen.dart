import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../dashboard/presentation/screens/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Tunggu 3 detik sesuai rencana awal
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          // Sesuaikan dengan nama class Dashboard kamu
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Menggunakan FadeTransition untuk kehalusan maksimal
            return FadeTransition(opacity: animation, child: child);
          },
          // 800ms adalah angka 'sweet spot' untuk transisi halus
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary, // Warna Oceanic Blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bisa tambahkan logo di sini
            Icon(
              Icons.confirmation_number_outlined,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            LoadingWidget(), // Widget SpinKit yang sudah kita buat
          ],
        ),
      ),
    );
  }
}
