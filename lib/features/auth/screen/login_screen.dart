import 'package:erp_mobile_cnplus/features/modul/screen/modul_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/login_form.dart';
import '../models/login_request.dart';
import '../../../services/api_base.dart';

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

  // Inisialisasi secure storage
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    try {
      final loginReq = LoginRequest(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        database: databaseController.text.trim(),
      );

      final url = Uri.parse('${ApiBase.baseUrl}/auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(loginReq.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        final user = data['user'];

        final prefs = await SharedPreferences.getInstance();

        // Simpan JWT token ke secure storage
        await secureStorage.write(key: 'user_token', value: token);

        // Simpan user info ke shared preferences
        if (user != null) {
          if (user['username'] != null)
            await prefs.setString('username', user['username']);
          if (user['email'] != null)
            await prefs.setString('email', user['email']);
          if (user['nama_lengkap'] != null)
            await prefs.setString('nama_lengkap', user['nama_lengkap']);
        }

        print(
          'Token JWT disimpan di secure storage dan detail pengguna di shared preferences.',
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ModulScreen()),
          );
        }
      } else {
        // Log kegagalan dan tampilkan pesan dari server
        print('Login gagal: ${data['message']}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login gagal: ${data['message'] ?? 'Terjadi kesalahan'}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Menangani error jaringan atau parsing
      print('Error saat login: $e');
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F8E8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/logo.png', height: 80),
              const SizedBox(height: 20),
              const SizedBox(height: 40),
              // Form Login
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
    );
  }
}
