import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final Color? themeColor; // TAMBAHKAN: Properti warna tema (opsional)

  const SuccessBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.themeColor, // TAMBAHKAN: Parameter di constructor
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna yang akan digunakan. Jika themeColor tidak diisi, default-nya hijau.
    final Color color = themeColor ?? const Color(0xFF679436);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          // Ikon centang dengan warna dinamis
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15), // Gunakan warna dari variabel
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: color, // Gunakan warna dari variabel
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                "Got It!",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
