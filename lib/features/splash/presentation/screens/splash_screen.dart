import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../features/profile/presentation/controllers/profile_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authController    = context.read<AuthController>();
    final profileController = context.read<ProfileController>();

    await authController.checkAuthStatus();
    if (!mounted) return;

    if (authController.status == AuthStatus.authenticated) {
      await profileController.loadProfile();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.modul);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}