import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:erp_mobile_cnplus/shared/widgets/fade_in_up.dart';
import 'package:erp_mobile_cnplus/core/network/dio_client.dart';
import 'package:erp_mobile_cnplus/features/auth/presentation/widgets/login_form.dart';
import 'package:erp_mobile_cnplus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:erp_mobile_cnplus/features/modul/presentation/screens/modul_screen.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/controllers/profile_controller.dart';

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
    if (mounted) {
      setState(() {
        isLoadingDatabases = true;
      });
    }

    try {
      final response = await _dioClient.dio.get('/auth/databases');

      print('🔍 Raw databases response: ${response.data}');

      final List list = response.data['databases'];

      if (!mounted) return;

      setState(() {
        databaseOptions = list
            .map(
              (e) => {
                'value': e['value'] as String,
                'label': e['label'] as String,
              },
            )
            .toList();

        if (databaseOptions.isNotEmpty) {
          databaseController.text = databaseOptions.first['value']!;
        }

        isLoadingDatabases = false;
      });
    } catch (e) {
      print('❌ Gagal mengambil database: $e');

      if (!mounted) return;

      setState(() {
        databaseOptions = [
          {
            'value': 'mysql',
            'label': 'Production (Default)',
          },
        ];

        databaseController.text = 'mysql';
        isLoadingDatabases = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil daftar database'),
          backgroundColor: Colors.red,
        ),
      );
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
            content: Text(
              'Tidak ada koneksi internet. Silakan cek jaringan Anda.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final authController = context.read<AuthController>();
    final profileController = context.read<ProfileController>();

    final success = await authController.login(
      username: usernameController.text,
      password: passwordController.text,
      database: databaseController.text,
    );

    if (mounted && success) {
      await profileController.loadProfile();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ModulScreen(),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authController.errorMessage ?? 'Login gagal',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: _fetchDatabases,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 65,
                    ),
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
                          animationDelay: const Duration(
                            milliseconds: 300,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}