import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModulCard extends StatelessWidget {
  final String label;
  final String description; // ✅ Tambahkan parameter deskripsi
  final String imagePath;
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const ModulCard({
    super.key,
    required this.label,
    required this.description, // ✅ Jadikan wajib diisi
    required this.imagePath,
    this.onTap,
    this.iconBackgroundColor = const Color(0xFFE0F2F1),
    required this.iconColor,
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
                color: iconColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              // [DIUBAH] Menggunakan Column untuk menampung judul dan deskripsi
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ini adalah Judul Modul (Label)
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600, // Poppins Semi-Bold
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4), // Jarak kecil
                  // [BARU] Ini adalah Deskripsi
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12, // Font kecil
                      fontWeight: FontWeight.w400, // Poppins Regular (lebih tipis)
                      color: Colors.grey.shade600, // Font halus (abu-abu)
                    ),
                  ),
                ],
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