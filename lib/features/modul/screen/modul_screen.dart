import 'package:flutter/material.dart';
// import '../widgets/modul_background.dart'; // Dihapus karena sudah tidak digunakan
import '../widgets/modul_card.dart';
import '../../../core/routes/app_routes.dart';

class ModulScreen extends StatelessWidget {
  const ModulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body diubah dari Stack menjadi Container
      body: Container(
        // Menambahkan dekorasi gradasi yang sama seperti login screen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0F2F1), // Warna terang (cyan/teal lembut)
              Color(0xFFFFFCFB), // Warna putih gading
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.8],
          ),
        ),
        // Menggunakan SafeArea dan SingleChildScrollView agar bisa di-scroll
        // jika konten melebihi layar (berguna untuk layar kecil)
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ganti Text dengan logo
                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/logo.png', // ganti sesuai path logo kamu
                      height: 60, // atur tinggi sesuai kebutuhan
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 32),

                    const SizedBox(height: 32),
                    ModulCard(
                      label: "Inventory",
                      imagePath: "assets/products.png",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.dashboardInventory,
                        );
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
                        Navigator.pushNamed(
                          context,
                          AppRoutes.dashboardPurchase,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ), // Memberi sedikit ruang di bawah
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
