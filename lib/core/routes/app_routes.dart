import 'package:flutter/material.dart';
import '../../features/auth/screen/login_screen.dart';
import '../../features/dashboard_inventory/screen/dashboard_inventory.dart';
import '../../features/dashboard_purchase/screen/dashboard_purchase_screen.dart';

class AppRoutes {
  static const String initial = '/login';
  static const String dashboardInventory = '/dashboard_inventory';
  static const String dashboardSales = '/dashboard_sales';
  static const String dashboardPurchase = '/dashboard_purchase';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    dashboardInventory: (context) => const DashboardInventoryScreen(),
    dashboardPurchase: (context) => const DashboardPurchaseScreen(),
  };
}