import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Warna dan Style (Diambil dari file asli) ---
final softGreen = const Color(0xFF679436);
final lightGreen = const Color(0xFFC8E6C9);
final borderRadius = BorderRadius.circular(16.0);

// --- Helper Widgets untuk UI ---
InputDecoration getInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
    filled: true,
    fillColor: lightGreen.withOpacity(0.3),
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: softGreen.withOpacity(0.5), width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: softGreen, width: 2.0),
    ),
  );
}

Widget buildTitleSection(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 12),
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: softGreen,
      ),
    ),
  );
}
