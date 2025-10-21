// login_screen.dart

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Sesuaikan path jika perlu
import '../../../shared/widgets/fade_in_up.dart';
import '../widgets/login_form.dart';
import '../models/login_request.dart';
import '../services/auth_service.dart';
import '../../modul/screen/modul_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final databaseController = TextEditingController();
  final List<String> databaseOptions = ['mysql', 'testing'];
  bool isLoading = false;

  Future<void> handleLogin() async {
    // ... (Fungsi handleLogin tidak ada perubahan)
    setState(() => isLoading = true);

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada koneksi internet. Silakan cek jaringan Anda.'),
          ),
        );
      }
      return;
    }

    try {
      final loginReq = LoginRequest(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        database: databaseController.text.trim(),
      );

      final result = await AuthService.login(loginReq);

      if (result['success'] == true) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ModulScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login gagal: ${result['message']}'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Tidak bisa terhubung ke server.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    databaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasi pada logo
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Image.asset('assets/logo.png', height: 65),
              ),
              const SizedBox(height: 40),

              // ❌ Teks sapaan dihapus dari sini

              // Bungkus LoginForm dengan animasi
              FadeInUp(
                delay: const Duration(milliseconds: 300), // Delay disesuaikan
                child: LoginForm(
                  emailController: usernameController,
                  passwordController: passwordController,
                  databaseController: databaseController,
                  onLogin: handleLogin,
                  isLoading: isLoading,
                  databaseOptions: databaseOptions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}