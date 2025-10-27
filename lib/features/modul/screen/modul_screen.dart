// Ganti seluruh isi file: modul_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/modul_card.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/fade_in_up.dart'; 

class ModulScreen extends StatelessWidget {
  const ModulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    "Welcome Back,",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    "Select a module to open its dashboard.",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: ModulCard(
                    label: "Inventory",
                    description: "Manage products and stock levels.", // ✅ Deskripsi ditambahkan
                    imagePath: "assets/products.png",
                    iconBackgroundColor: const Color(0xFFE0F7FA), // Light Cyan
                    iconColor: const Color(0xFF00838F), // Dark Cyan
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.dashboardInventory);
                    },
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: ModulCard(
                    label: "Sales",
                    description: "Track sales orders and revenue.", // ✅ Deskripsi ditambahkan
                    imagePath: "assets/sales.png",
                    iconBackgroundColor: const Color(0xFFFFF3E0), // Light Orange
                    iconColor: const Color(0xFFEF6C00), // Dark Orange
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.dashboardSales);
                    },
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: ModulCard(
                    label: "Purchase",
                    description: "Create purchase orders and manage vendors.", // ✅ Deskripsi ditambahkan
                    imagePath: "assets/purchase.png",
                    iconBackgroundColor: const Color(0xFFE8EAF6), // Light Indigo
                    iconColor: const Color(0xFF303F9F), // Dark Indigo
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.dashboardPurchase);
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}