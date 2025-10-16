// Ganti seluruh isi file: modul_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModulCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final Color iconBackgroundColor;
  final Color iconColor; // ✅ Tambahkan parameter ini
  final VoidCallback? onTap;

  const ModulCard({
    super.key,
    required this.label,
    required this.imagePath,
    this.onTap,
    this.iconBackgroundColor = const Color(0xFFE0F2F1),
    required this.iconColor, // ✅ Jadikan wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                imagePath,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
                color: iconColor, // ✅ Terapkan warna pada ikon di sini
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}