import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chart_data_model.dart';

/// [BARU] Widget untuk judul setiap bagian
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

/// [BARU] Widget untuk tombol toggle "Stock" (Warehouse/Location)
class StockToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const StockToggleButtons({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  // Definisi warna agar mudah diubah
  static const Color selectedColor = Color(0xFF2D6A4F);
  static const Color unselectedColor = Colors.white;
  static const Color selectedTextColor = Colors.white;
  static const Color unselectedTextColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Tombol "By Warehouse"
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selectedIndex == 0
                      ? [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  "By Warehouse",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 0
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
          // Tombol "Per Location"
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selectedIndex == 1
                      ? [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  "By Location",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 1
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [BARU] Widget untuk tombol toggle "Stock Moves" (Product/Location)
class StockMovesToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const StockMovesToggleButtons({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  // Definisi warna
  static const Color selectedColor = Color(0xFF2D6A4F);
  static const Color unselectedColor = Colors.white;
  static const Color selectedTextColor = Colors.white;
  static const Color unselectedTextColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Tombol "By Product"
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selectedIndex == 0
                      ? [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  "By Product",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 0
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
          // Tombol "By Location"
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selectedIndex == 1
                      ? [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  "By Location",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: selectedIndex == 1
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [BARU] Widget untuk legenda chart "Stock"
class StockLegend extends StatelessWidget {
  final List<ChartData> data;

  const StockLegend({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double totalValue = data.fold(
      0,
      (previousValue, element) => previousValue + element.value,
    );

    if (data.isEmpty || totalValue == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: data.map((d) {
            final percentage = (d.value / totalValue) * 100;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: d.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(d.label, style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}