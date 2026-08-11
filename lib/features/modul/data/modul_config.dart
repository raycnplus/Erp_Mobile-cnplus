import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';

class ModulConfig {
  final String imagePath;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String? route;

  const ModulConfig ({
    required this.imagePath,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.route,
  });
}

const Map<String, ModulConfig> modulConfigMap = {
  'general_dashboard': ModulConfig(
    imagePath: 'assets/images/icons/general_dashboard.png',
    iconBackgroundColor: Color(0xFFFFF8E1),
    iconColor: Color(0xFFFFB300),
    route: AppRoutes.generalDashboard,
  ),
  'sales': ModulConfig(
    imagePath: 'assets/images/icons/sales.png',
    iconBackgroundColor: Color(0xFFFFF3E0),
    iconColor: Color(0xFFEF6C00),
    route: AppRoutes.dashboardSales,
  ),
  'inventory': ModulConfig(
    imagePath: 'assets/images/icons/inventory.png',
    iconBackgroundColor: Color(0xFFE8EAF6),
    iconColor: Color(0xFF3949AB),
    route: AppRoutes.dashboardInventory,
  ),
  'purchase': ModulConfig(
    imagePath: 'assets/images/icons/purchase.png',
    iconBackgroundColor: Color(0xFFFFF8E1),
    iconColor: Color(0xFFFBD013),
    route: AppRoutes.dashboardPurchase,
  ),
  'accounting': ModulConfig(
    imagePath: 'assets/images/icons/accounting.png',
    iconBackgroundColor: Color(0xFFE0F2F1),
    iconColor: Color(0xFF00796B),
    route: AppRoutes.dashboardAccounting,
  ),
  'pos': ModulConfig(
    imagePath: 'assets/images/icons/pos.png',
    iconBackgroundColor: Color(0xFFE8F5E9),
    iconColor: Color(0xFF388E3C),
    route: AppRoutes.dashboardPos,
  ),
  'manufacturing': ModulConfig(
    imagePath: 'assets/images/icons/manufacturing.png',
    iconBackgroundColor: Color(0xFFECEFF1),
    iconColor: Color(0xFF546E7A),
    route: AppRoutes.dashboardManufacturing,
  ),
  'hr': ModulConfig(
    imagePath: 'assets/images/icons/hr.png',
    iconBackgroundColor: Color(0xFFFCE4EC),
    iconColor: Color(0xFFC2185B),
    route: AppRoutes.dashboardHr,
  ),
  'crm': ModulConfig(
    imagePath: 'assets/images/icons/crm.png',
    iconBackgroundColor: Color(0xFFE3F2FD),
    iconColor: Color(0xFF1565C0),
    route: AppRoutes.dashboardCrm,
  ),
};