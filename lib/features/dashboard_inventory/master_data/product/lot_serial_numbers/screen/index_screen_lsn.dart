import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/index_widget_lsn.dart';

class LotSerialIndexScreen extends StatelessWidget {
  const LotSerialIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        // Menggunakan Column untuk menata judul dan subjudul
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lot/Serial Number",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "List of all tracked items",
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: const LotSerialIndexWidget(),
    );
  }
}
