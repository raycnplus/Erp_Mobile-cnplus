import 'package:flutter/material.dart';
import '../../features/auth/screen/login_screen.dart';
import '../../features/dashboard_inventory/screen/dashboard_inventory.dart';

class AppRoutes {
  static const String initial = '/login';
  static const String dashboardInventory = '/dashboard_inventory';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    dashboardInventory: (context) => const DashboardScreen(),
  };
}
