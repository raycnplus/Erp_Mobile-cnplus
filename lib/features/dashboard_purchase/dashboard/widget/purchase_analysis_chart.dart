import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/purchase_models.dart';
import '../utils/formatters.dart'; // Pastikan Anda mengimpor formatters

class PurchaseAnalysisChart extends StatelessWidget {
  final List<MonthlyPurchaseData> purchaseData;
  final Color mainColor = const Color(0xFF029379); // Warna aksen utama

  const PurchaseAnalysisChart({super.key, required this.purchaseData});

  // Helper untuk mendapatkan rentang waktu
  String _getDateRange() {
    if (purchaseData.isEmpty) {
      return 'Data not available';
    }
    // Asumsi data sudah terurut berdasarkan bulan
    final firstMonth = DateFormat('MMM yyyy').format(DateTime(2025, purchaseData.first.month));
    final lastMonth = DateFormat('MMM yyyy').format(DateTime(2025, purchaseData.last.month));
    return '$firstMonth - $lastMonth';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Shadow lebih halus
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // [DIUBAH] Header/Judul Chart
            Text(
              'Purchase Analysis',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getDateRange(), // Rentang waktu dinamis
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineTouchData: _buildLineTouchData(),
                  gridData: _buildGridData(),
                  titlesData: _buildTitlesData(),
                  borderData: FlBorderData(show: false), // Menghilangkan border
                  lineBarsData: [_buildLineBarsData()],
                  // Menentukan batas sumbu X dan Y secara eksplisit
                  minX: 1,
                  maxX: 12,
                  minY: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => mainColor.withOpacity(0.9), // Warna tooltip disamakan
        tooltipBorderRadius: BorderRadius.circular(8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            // Format bulan menjadi nama (Contoh: "Jan", "Feb")
            final monthName = DateFormat('MMM').format(DateTime(0, spot.x.toInt()));
            // Format angka menjadi format Rupiah lengkap
            final amount = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(spot.y);

            return LineTooltipItem(
              '$monthName 2025\n',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              children: [
                TextSpan(
                  text: amount,
                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                ),
              ],
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(color: mainColor.withOpacity(0.5), strokeWidth: 2),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 8,
                color: mainColor,
                strokeWidth: 4,
                strokeColor: Colors.white,
              ),
            ),
          );
        }).toList();
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 2, // Menampilkan label setiap 2 bulan agar tidak terlalu padat
          getTitlesWidget: (value, meta) {
            final monthName = DateFormat('MMM').format(DateTime(0, value.toInt()));
            return SideTitleWidget(
              meta: meta,
              space: 8,
              child: Text(
                monthName,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 45, // Sedikit lebih lebar untuk format
          getTitlesWidget: (value, meta) {
            if (value == meta.max || value == meta.min) {
              return const SizedBox(); // Sembunyikan label teratas dan terbawah
            }
            // [DIUBAH] Menggunakan formatCurrency dari formatters.dart agar konsisten
            return Text(
              formatCurrency(value),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              textAlign: TextAlign.left,
            );
          },
        ),
      ),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false, // Garis vertikal disembunyikan agar lebih bersih
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.shade200,
        strokeWidth: 1,
      ),
    );
  }

  LineChartBarData _buildLineBarsData() {
    return LineChartBarData(
      spots: purchaseData.map((data) => FlSpot(data.month.toDouble(), data.amount)).toList(),
      isCurved: true,
      color: mainColor,
      barWidth: 4, // Garis sedikit lebih tebal
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false), // Titik pada data disembunyikan
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            mainColor.withOpacity(0.4),
            mainColor.withOpacity(0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}