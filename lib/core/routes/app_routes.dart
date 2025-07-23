import 'package:flutter/material.dart';
import '../../features/auth/screen/login_screen.dart';

class AppRoutes {
  static const String initial = '/login';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
  };
}
