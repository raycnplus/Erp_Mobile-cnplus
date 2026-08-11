import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/models/pos_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class PosPaymentPieChart extends StatefulWidget {
  final List<PosPaymentMethod> paymentMethods;

  const PosPaymentPieChart({super.key, required this.paymentMethods});

  @override
  State<PosPaymentPieChart> createState() => _PosPaymentPieChartState();
}

class _PosPaymentPieChartState extends State<PosPaymentPieChart> {
  int _touched = -1;

  static const List<Color> _palette = [
    Color(0xFF00BFA5),
    Color(0xFF0288D1),
    Color(0xFFF57C00),
    Color(0xFF7B1FA2),
    Color(0xFFD32F2F),
    Color(0xFF388E3C),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.paymentMethods.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              'No payment data',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    final total = widget.paymentMethods.fold<double>(
      0,
      (sum, p) => sum + p.totalAmount,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Methods',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, resp) {
                      setState(() {
                        _touched =
                            resp?.touchedSection?.touchedSectionIndex ?? -1;
                      });
                    },
                  ),
                  sections: widget.paymentMethods.asMap().entries.map((e) {
                    final isTouched = e.key == _touched;
                    final pct = total > 0
                        ? (e.value.totalAmount / total * 100)
                        : 0.0;
                    return PieChartSectionData(
                      value: e.value.totalAmount,
                      color: _palette[e.key % _palette.length],
                      radius: isTouched ? 72 : 60,
                      title: '${pct.toStringAsFixed(1)}%',
                      titleStyle: GoogleFonts.poppins(
                        fontSize: isTouched ? 13 : 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: widget.paymentMethods.asMap().entries.map((e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _palette[e.key % _palette.length],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      e.value.paymentMethod,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}