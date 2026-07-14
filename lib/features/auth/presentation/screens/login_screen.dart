import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../shared/widgets/fade_in_up.dart';
import '../../../../core/network/dio_client.dart';
import '../widgets/login_form.dart';
import '../controllers/auth_controller.dart';
import '../../../modul/presentation/screens/modul_screen.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final databaseController = TextEditingController(text: 'mysql');

  List<Map<String, String>> databaseOptions = [];
  bool isLoadingDatabases = true;

  final _dioClient = DioClient();

  @override
  void initState() {
    super.initState();
    _fetchDatabases();
  }

  Future<void> _fetchDatabases() async {
    try {
      final response = await _dioClient.dio.get('/auth/databases');
      print('🔍 Raw databases response: ${response.data}');
      final List list = response.data['databases'];
      setState(() {
        databaseOptions = list
            .map((e) => {
                  'value': e['value'] as String,
                  'label': e['label'] as String,
                })
            .toList();
        if (databaseOptions.isNotEmpty) {
          databaseController.text = databaseOptions.first['value']!;
        }
        isLoadingDatabases = false;
      });
    } catch (e) {
      setState(() {
        databaseOptions = [
          {'value': 'mysql', 'label': 'Production (Default)'},
        ];
        isLoadingDatabases = false;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    databaseController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada koneksi internet. Silakan cek jaringan Anda.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final authController    = context.read<AuthController>();
    final profileController = context.read<ProfileController>();

    final success = await authController.login(
      username: usernameController.text,
      password: passwordController.text,
      database: databaseController.text,
    );

    if (mounted && success) {
      await profileController.loadProfile();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ModulScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.errorMessage ?? 'Login gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Image.asset('assets/images/logo.png', height: 65),
              ),
              const SizedBox(height: 40),
              if (isLoadingDatabases)
                const CircularProgressIndicator()
              else
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    return LoginForm(
                      emailController: usernameController,
                      passwordController: passwordController,
                      databaseController: databaseController,
                      onLogin: _handleLogin,
                      isLoading: authController.isLoading,
                      databaseOptions: databaseOptions,
                      animationDelay: const Duration(milliseconds: 300),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}