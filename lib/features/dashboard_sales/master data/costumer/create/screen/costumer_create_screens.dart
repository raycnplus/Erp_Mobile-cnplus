// costumer_create_screens.dart

import 'package:flutter/material.dart';
import '../widget/costumer_create_widget.dart';

class CustomerCreateScreen extends StatelessWidget {
  const CustomerCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold dan AppBar sekarang menjadi bagian dari widget itu sendiri
    // untuk konsistensi desain yang lebih baik.
    return const CustomerCreateWidget();
  }
}