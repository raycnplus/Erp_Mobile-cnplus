import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/auth/data/repositories/auth_repository.dart';
import 'package:erp_mobile_cnplus/features/auth/presentation/screens/login_screen.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  
  const AuthGuard({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.data == true) {
          return child;
        }
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        });
        
        return const SizedBox.shrink();
      },
    );
  }
  
  Future<bool> _checkAuth() async {
    final authRepository = getIt<AuthRepository>();
    return await authRepository.isLoggedIn();
  }
}