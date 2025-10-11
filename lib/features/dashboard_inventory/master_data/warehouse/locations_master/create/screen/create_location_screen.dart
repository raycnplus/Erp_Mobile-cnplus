// create_location_screen.dart

import 'package:flutter/material.dart';
import '../widget/create_location_widget.dart';

class LocationCreateScreen extends StatelessWidget {
  const LocationCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold dan AppBar sekarang menjadi bagian dari widget itu sendiri
    // untuk konsistensi desain yang lebih baik.
    return const LocationCreateWidget();
  }
}