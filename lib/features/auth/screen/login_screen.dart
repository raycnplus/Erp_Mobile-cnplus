import 'package:erp_mobile_cnplus/features/modul/screen/modul_screen.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/login_form.dart';
import '../models/login_request.dart';
import '../services/auth_service.dart';

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
    setState(() => isLoading = true);

    // Cek koneksi internet sebelum login
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
        // Simpan token ke secure storage dengan key 'token'
        final storage = const FlutterSecureStorage();
        final token = result['token'] ?? result['data']?['token'] ?? '';
        if (token.isNotEmpty) {
          await storage.write(key: 'token', value: token);
        }

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
      // backgroundColor dihapus dari sini dan dipindahkan ke dalam Container
      body: Container(
        // Menambahkan dekorasi gradasi pada background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5E9), // Warna hijau yang sangat terang (subtle)
              Color(0xFFFFFCFB), // Warna background asli
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.7], // Mengatur gradasi agar hijau lebih dominan di atas
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/logo.png', height: 80),
                const SizedBox(height: 20),
                const SizedBox(height: 40),
                LoginForm(
                  emailController: usernameController,
                  passwordController: passwordController,
                  databaseController: databaseController,
                  onLogin: handleLogin,
                  isLoading: isLoading,
                  databaseOptions: databaseOptions,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}