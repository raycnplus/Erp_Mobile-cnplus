import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/login_form.dart';
import '../models/login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    final loginReq = LoginRequest(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final url = Uri.parse('https://your-api-link.com/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginReq.toJson()),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data['token'];
        print('Login berhasil! Token: $token');
        
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(
          emailController: emailController,
          passwordController: passwordController,
          onLogin: handleLogin,
          isLoading: isLoading,
        ),
      ),
    );
  }
}