import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',

    // Tambahkan kode ini
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: const Color.fromARGB(255, 58, 121, 183), // Warna handle (bentuk tetesan air)
    ),
  );
}