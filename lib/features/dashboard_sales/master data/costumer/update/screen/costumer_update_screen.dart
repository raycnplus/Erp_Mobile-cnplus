// lib/features/dashboard_sales/master data/costumer/update/screen/costumer_update_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/costumer_update_widget.dart';

class CustomerUpdateScreen extends StatelessWidget {
  final int id;
  final ScrollController? scrollController; // Controller untuk scrolling di dalam modal

  const CustomerUpdateScreen({
    super.key, 
    required this.id,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Desain modal yang sama dengan referensi
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9), // Warna latar belakang modal
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        children: [
          // Handle drag
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Judul Modal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              "Edit Customer",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          // Expanded agar form mengisi sisa ruang
          Expanded(
            child: CustomerUpdateWidget(id: id),
          ),
        ],
      ),
    );
  }
}