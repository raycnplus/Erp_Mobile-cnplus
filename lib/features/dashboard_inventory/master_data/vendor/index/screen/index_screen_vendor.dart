import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Tambahkan import GoogleFonts
import '../widget/index_widget_vendor.dart';

class VendorIndexScreen extends StatelessWidget {
  const VendorIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87), // Icon back
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vendor List", // Judul utama yang jelas
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, 
                color: Colors.black87, 
                fontSize: 20
              )
            ),
            Text(
              'Tap an item for details and actions', // Informasi kecil di bawah judul
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal, 
                color: Colors.grey.shade600, 
                fontSize: 12
              )
            ),
          ],
        ),
        elevation: 0.5, // Shadow tipis di AppBar
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: const VendorIndexWidget(),
      
      // Tombol FAB untuk Create Vendor (jika ada)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementasi navigasi ke halaman Create Vendor
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("TODO: Aksi Tambah Vendor Baru"))
          );
        },
        tooltip: 'Add New Vendor',
        backgroundColor: const Color(0xFF2D6A4F), // Menggunakan warna aksen hijau
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}