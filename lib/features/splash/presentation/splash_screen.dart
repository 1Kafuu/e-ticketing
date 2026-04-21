import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../auth/presentation/screens/login_screen.dart'; // Pastikan file ini ada meski kosong

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    // 1. Tunggu minimal 3 detik untuk estetika splash
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // 2. Cek status login melalui repository
    final authRepo = ref.read(authRepositoryProvider);
    final user = await authRepo.getCurrentUser();

    if (user != null) {
      // 3. Jika user ditemukan, update state global dan ke Dashboard
      ref.read(currentUserProvider.notifier).setUser(user);
      _navigate(const DashboardScreen());
    } else {
      // 4. Jika tidak ada user, arahkan ke Login
      _navigate(const LoginScreen());
    }
  }

  // Fungsi helper navigasi dengan FadeTransition yang sudah kita buat sebelumnya
  void _navigate(Widget destination) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.white),
            SizedBox(height: 24),
            LoadingWidget(),
          ],
        ),
      ),
    );
  }
}