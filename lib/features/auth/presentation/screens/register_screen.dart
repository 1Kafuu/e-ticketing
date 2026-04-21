import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // 1. Validasi Form
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authRepo = ref.read(authRepositoryProvider);
      
      // 2. Panggil method register yang baru di Repository
      final newUser = await authRepo.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (newUser != null) {
        // 3. Update State Global (Auto Login)
        ref.read(currentUserProvider.notifier).setUser(newUser);
        
        if (mounted) {
          // 4. Navigasi ke Dashboard
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selamat datang, ${newUser.name}!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mendaftar. Silakan coba lagi.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buat Akun Baru',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Silakan isi data diri Anda untuk bergabung'),
              const SizedBox(height: 32),
              
              CustomTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                icon: Icons.person_outline,
                validator: AppValidators.validateName,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Masukkan email anda',
                icon: Icons.email_outlined,
                validator: AppValidators.validateEmail,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Masukkan password',
                icon: Icons.lock_outline,
                isPassword: true,
                validator: AppValidators.validatePassword,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Konfirmasi Password',
                hint: 'Ulangi password',
                icon: Icons.lock_reset_outlined,
                isPassword: true,
                validator: (val) => AppValidators.validateConfirmPassword(
                  val, 
                  _passwordController.text,
                ),
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const LoadingWidget() 
                    : const Text(
                        'Daftar Sekarang', 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Sudah punya akun? Login di sini'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}