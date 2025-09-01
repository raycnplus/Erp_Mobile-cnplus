import 'package:flutter/material.dart';

class ModulCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback? onTap;

  const ModulCard({
    super.key,
    required this.label,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(
                      0xff409c9c,
                    ), // kiri: terang (sama dengan button login)
                    Color(
                      0xff2b6e6e,
                    ), // kanan: gelap (sama dengan button login)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.15,
                    ), // Sedikit lebih gelap
                    blurRadius: 20, // Ditingkatkan agar sangat halus
                    offset: const Offset(
                      0,
                      8,
                    ), // Jarak ke bawah ditambah agar 'terangkat'
                    spreadRadius: 1, // Sedikit menyebar agar lebih berisi
                  ),
                ],
              ),
            ),
            Positioned(
              left: 24,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              right: 24,
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
