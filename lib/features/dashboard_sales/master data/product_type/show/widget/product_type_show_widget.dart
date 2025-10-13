import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/product_type_show_models.dart';

class ProductTypeDetailSheet extends StatelessWidget {  
  final ProductTypeShowModel productType;

  const ProductTypeDetailSheet({super.key, required this.productType});

  // Helper untuk format tanggal
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      // Format: 19 Sep 2025, 11:35
      return DateFormat('d MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Judul
          Text(
            "Product Type Detail",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          // Widget untuk menampilkan baris data
          _buildDetailRow("Type Name", productType.productTypeName),
          const Divider(height: 24),
          _buildDetailRow("Created Date", _formatDate(productType.createdDate)),
          const Divider(height: 24),
          _buildDetailRow("Created By", productType.createdBy ?? 'Unknown'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget helper untuk membuat baris detail agar rapi
  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}