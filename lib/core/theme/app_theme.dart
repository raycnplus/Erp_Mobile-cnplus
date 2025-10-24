import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.robotoTextTheme(),

    textSelectionTheme: TextSelectionThemeData(
      // Warna background teks yang diseleksi (ungu -> biru transparan)
      selectionColor: const Color.fromRGBO(58, 121, 183, 0.25),
      // Warna handle (bulatan) saat memilih teks
      selectionHandleColor: const Color.fromARGB(255, 58, 121, 183),
      // Warna kursor
      cursorColor: const Color.fromARGB(255, 58, 121, 183),
    ),
  );
}