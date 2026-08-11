import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/models/inventory_dashboard_model.dart';

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

class StockToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const StockToggleButtons({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ToggleButtons(
      selectedIndex: selectedIndex,
      onTap: onTap,
      labels: const ['By Warehouse', 'By Location'],
    );
  }
}

class StockMovesToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const StockMovesToggleButtons({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ToggleButtons(
      selectedIndex: selectedIndex,
      onTap: onTap,
      labels: const ['By Product', 'By Location'],
    );
  }
}

class _ToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  static const Color _selectedColor = Color(0xFF2D6A4F);
  static const double _gap = 6;

  const _ToggleButtons({
    required this.selectedIndex,
    required this.onTap,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = selectedIndex == i;
          final isLast = i == labels.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : _gap),
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? _selectedColor : Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _selectedColor.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    labels[i],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class StockLegend extends StatelessWidget {
  final List<ChartItem> data;

  const StockLegend({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double total = data.fold(0, (sum, item) => sum + item.value);
    if (data.isEmpty || total == 0) return const SizedBox.shrink();

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: data.map((d) {
            final pct = (d.value / total) * 100;
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
                    '${pct.toStringAsFixed(1)}%',
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