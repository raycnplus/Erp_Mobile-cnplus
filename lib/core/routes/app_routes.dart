import 'package:erp_mobile_cnplus/features/modul/screen/modul_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/screen/login_screen.dart';
import '../../features/dashboard_inventory/screen/dashboard_inventory.dart';
import '../../features/dashboard_purchase/screen/dashboard_purchase_screen.dart';
import '../../features/dashboard_sales/screen/dashboard_sales_screen.dart';

class AppRoutes {
  static const String initial = '/login';
  static const String modul = '/modul';
  static const String dashboardInventory = '/dashboard_inventory';
  static const String dashboardPurchase = '/dashboard_purchase';
  static const String dashboardSales = '/dashboard_sales';  

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    modul: (context) => const ModulScreen(), 
    dashboardInventory: (context) => const DashboardInventoryScreen(),
    dashboardPurchase: (context) => const DashboardPurchaseScreen(),
    dashboardSales: (context) => const DashboardSalesScreen(),
  };
}