import 'package:erp_mobile_cnplus/features/dashboard/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final List<String> databaseOptions = ['mysql', 'postgresql', 'oracle'];
  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);
    final loginReq = LoginRequest(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
      database: databaseController.text.trim(),
    );

    final url = Uri.parse('${ApiBase.baseUrl}/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(loginReq.toJson()),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'];
        print('Login berhasil! Token: $token');
         Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const DashboardScreen()),
  );
      } else {
        print('Login gagal: ${data['message']}');
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() => isLoading = false);
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFE0F8E8), // warna gradasi hijau muda
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