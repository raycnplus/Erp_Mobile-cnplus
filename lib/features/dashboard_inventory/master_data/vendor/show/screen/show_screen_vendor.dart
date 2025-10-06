import 'package:flutter/material.dart';
import '../widget/show_widget_vendor.dart';
import '../../update/screen/update_screen_vendor.dart'; // pastikan path sesuai

class VendorShowScreen extends StatefulWidget {
  final String vendorId;

  const VendorShowScreen({super.key, required this.vendorId});

  @override
  State<VendorShowScreen> createState() => _VendorShowScreenState();
}

class _VendorShowScreenState extends State<VendorShowScreen> {
  bool refreshTrigger = false;

  // Warna Aksen
  static const Color accentColor = Color(0xFF2D6A4F); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendor Details"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      // Widget Detail sekarang menjadi body utama
      body: VendorDetailWidget(
        vendorId: widget.vendorId,
        key: ValueKey(refreshTrigger), // Digunakan untuk memaksa refresh
      ),

      // Floating Action Button untuk Edit
      floatingActionButton: FloatingActionButton(
        tooltip: "Edit Vendor",
        backgroundColor: accentColor,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorUpdateScreen(
                vendorId: widget.vendorId,
              ),
            ),
          );

          if (result == true) {
            setState(() => refreshTrigger = !refreshTrigger);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Vendor berhasil diperbarui")),
            );
          }
        },
      ),
    );
  }
}