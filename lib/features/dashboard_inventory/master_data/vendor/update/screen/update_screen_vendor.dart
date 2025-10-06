import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Tambahkan Google Fonts
import '../widget/update_widget_vendor.dart';

class VendorUpdateScreen extends StatelessWidget {
  final String vendorId;

  const VendorUpdateScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Update Vendor",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, 
            color: Colors.black87, 
            fontSize: 20
          )
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: VendorUpdateWidget(vendorId: vendorId),
    );
  }
}