import 'package:flutter/material.dart';

class ModulBackground extends StatelessWidget {
  const ModulBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE0F8E8), Color(0xFFABE6C1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}