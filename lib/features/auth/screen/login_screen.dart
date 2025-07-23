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
  final databaseController = TextEditingController(text: 'mysql'); // default value
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
        // TODO: Simpan token dan navigasi ke halaman berikutnya
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
          emailController: usernameController, // ganti jadi username
          passwordController: passwordController,
          onLogin: handleLogin,
          isLoading: isLoading,
          // Jika ingin input database, tambahkan controller di LoginForm
        ),
      ),
    );
  }
}