import 'package:flutter/material.dart';
import '../widgets/modul_background.dart';
import '../widgets/modul_card.dart';
import '../../../core/routes/app_routes.dart'; 

class ModulScreen extends StatelessWidget {
  const ModulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: ModulBackground()),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  "ERP SORLEM",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF227C5A),
                  ),
                ),
                const SizedBox(height: 32),
                ModulCard(
                  label: "Inventory",
                  imagePath: "assets/products.png",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.dashboardInventory);
                  },
                ),
                ModulCard(
                  label: "Sales",
                  imagePath: "assets/sales.png",
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.dashboardSales);
                  },
                ),
                ModulCard(
                  label: "Purchase",
                  imagePath: "assets/purchase.png",
                  onTap: () {
                  Navigator.pushNamed(context, AppRoutes.dashboardPurchase);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}