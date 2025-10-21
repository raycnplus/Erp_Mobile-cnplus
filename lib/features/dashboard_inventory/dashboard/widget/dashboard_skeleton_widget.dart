import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fl_chart/fl_chart.dart'; // <-- TAMBAHKAN IMPORT INI

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian lain tetap sama...
              const _ShimmerBox(height: 50, width: double.infinity),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _ShimmerStatCard(),
                  _ShimmerStatCard(),
                  _ShimmerStatCard(),
                  _ShimmerStatCard(),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _ShimmerStatCard(width: 150),
                    SizedBox(width: 10),
                    _ShimmerStatCard(width: 150),
                    SizedBox(width: 10),
                    _ShimmerStatCard(width: 150),
                    SizedBox(width: 10),
                    _ShimmerStatCard(width: 150),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _ShimmerBox(height: 20, width: 100),
              const SizedBox(height: 16),
              const _ShimmerBox(height: 45, width: double.infinity, radius: 12),
              const SizedBox(height: 16),

              // --- BAGIAN PIE CHART DIUBAH DI SINI ---
              _ShimmerDetailedPieChart(), // <-- Menggunakan widget skeleton pie chart yang baru
              
              const SizedBox(height: 24),
              const _ShimmerBox(height: 20, width: 200),
              const SizedBox(height: 8),
              const _ShimmerBox(height: 200, width: double.infinity, radius: 12),
              const SizedBox(height: 24),
              const _ShimmerBox(height: 20, width: 150),
              const SizedBox(height: 16),
              const _ShimmerBox(height: 250, width: double.infinity, radius: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET SKELETON PIE CHART YANG BARU DAN DETAIL ---
class _ShimmerDetailedPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Row(
        children: [
          // Placeholder untuk Pie Chart menggunakan fl_chart
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(enabled: false), // Matikan interaksi
                sectionsSpace: 2,
                centerSpaceRadius: 45, // Membuat lubang di tengah (donut chart)
                sections: List.generate(4, (i) {
                  // Membuat 4 slice palsu untuk membentuk chart
                  return PieChartSectionData(
                    color: Colors.white, // Warna harus putih agar efek shimmer terlihat
                    value: 25,
                    title: '', // Tidak perlu judul
                    radius: 15,
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Placeholder untuk Legend (tetap sama)
          const Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ShimmerBox(height: 16, width: double.infinity),
                SizedBox(height: 8),
                _ShimmerBox(height: 16, width: double.infinity),
                SizedBox(height: 8),
                _ShimmerBox(height: 16, width: double.infinity),
                SizedBox(height: 8),
                _ShimmerBox(height: 16, width: double.infinity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// --- Widget-widget bantu lainnya (tidak ada perubahan) ---
class _ShimmerStatCard extends StatelessWidget {
  final double? width;
  const _ShimmerStatCard({this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            children: const [
              _ShimmerBox(height: 24, width: 50),
              SizedBox(height: 8),
              _ShimmerBox(height: 14, width: 70),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final double radius;

  const _ShimmerBox({this.height, this.width, this.radius = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}