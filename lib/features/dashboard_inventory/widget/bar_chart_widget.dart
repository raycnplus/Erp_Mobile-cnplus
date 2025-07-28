import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/chart_data_model.dart'; 


const Color kPrimaryChartColor = Color(0xFF029379);

class ProductBarChart extends StatelessWidget {
  final List<ChartData> data;
  const ProductBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            const Text(
              'Product Category',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(width: 12, height: 12, color: kPrimaryChartColor),
                const SizedBox(width: 8),
                const Text(
                  'Total Product',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // --- Akhir Perubahan Header ---
            SizedBox(
              height: 200, 
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      // PERBAIKAN: Gunakan hanya parameter yang pasti ada di fl_chart 1.0.0
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${data[groupIndex].label}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: rod.toY.round().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        
                        getTitlesWidget: _getBottomTitles,
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        
                        getTitlesWidget: _getLeftTitles,
                        reservedSize: 30,
                        interval: _calculateInterval(),
                      ),
                    ),
                  ),
                  
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                      left: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true, // Menampilkan garis vertikal
                    verticalInterval: 1,
                    horizontalInterval: _calculateInterval(),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final d = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        
                        BarChartRodData(
                          toY: d.value,
                          color: kPrimaryChartColor, // Menggunakan warna utama
                          width: 22,
                          borderRadius: BorderRadius
                              .zero, // Menghilangkan sudut melengkung
                        ),
                        // --- Akhir Perubahan Style Bar ---
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    
    final style = TextStyle(color: Colors.grey.shade600, fontSize: 14);
    String text = data.length > value.toInt() ? data[value.toInt()].label : '';

    
    return Text(text, style: style);
  }

  Widget _getLeftTitles(double value, TitleMeta meta) {
    
    final style = TextStyle(color: Colors.grey.shade600, fontSize: 12);
    if (value % _calculateInterval() != 0 && value != _calculateMaxY()) {
      return Container();
    }

    
    return Text(
      value.toInt().toString(),
      style: style,
      textAlign: TextAlign.center,
    );
  }

  double _calculateMaxY() {
    double maxVal = 0;
    for (var d in data) {
      if (d.value > maxVal) {
        maxVal = d.value;
      }
    }
    
    return (maxVal / 5).ceil() * 5.0 + 5;
  }

  double _calculateInterval() {
    
    return 5;
  }
}
