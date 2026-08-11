import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/models/sales_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/widgets/sales_bar_chart_widget.dart';

class SalesChartToggleSection extends StatefulWidget {
  final List<SalesChartData> revenuePerDay;
  final List<SalesChartData> quantityPerDay;
  final Color themeColor;

  const SalesChartToggleSection({
    super.key,
    required this.revenuePerDay,
    required this.quantityPerDay,
    this.themeColor = const Color(0xFF409c9c),
  });

  @override
  State<SalesChartToggleSection> createState() => _SalesChartToggleSectionState();
}

class _SalesChartToggleSectionState extends State<SalesChartToggleSection> {
  int _selectedChart = 0;

  Widget _buildToggleButton(String label, int index) {
    final isSelected = _selectedChart == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedChart = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? widget.themeColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? widget.themeColor : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: widget.themeColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _buildToggleButton('Daily Revenue', 0),
            const SizedBox(width: 10),
            _buildToggleButton('Quantity Sold', 1),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedChart == 0
              ? Column(
                  key: const ValueKey('dailyRevenue'),
                  children: [
                    SalesBarChart(data: widget.revenuePerDay, title: "Daily Revenue"),
                    const SizedBox(height: 8),
                    Text(
                      "Tap a bar for more details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('quantitySold'),
                  children: [
                    SalesBarChart(data: widget.quantityPerDay, title: "Quantity Sold"),
                    const SizedBox(height: 8),
                    Text(
                      "Tap a bar for more details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}