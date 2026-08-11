import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fl_chart/fl_chart.dart'; // Pastikan import ini ada

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
              // 1. PersonalizedHeader [DIUBAH]
              const _ShimmerPersonalizedHeader(), // Menggunakan widget baru
              const SizedBox(height: 16),

              // 2. GridView 4 Cards
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

              // 3. Horizontal ListView 4 Cards
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
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

              // 4. Section "Stock"
              const _ShimmerBox(height: 20, width: 100), // SectionTitle
              const SizedBox(height: 16),
              const _ShimmerToggleButtons(), // StockToggleButtons
              const SizedBox(height: 16),
              const _ShimmerBox(height: 18, width: 150), // PieChart Title
              const SizedBox(height: 8),
              const _ShimmerPieChartPlaceholder(), // PieChart
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.center,
                child: _ShimmerBox(height: 12, width: 200), // "Tap on a slice..." text
              ),
              const SizedBox(height: 16),
              const _ShimmerLegendCard(), // StockLegend
              const SizedBox(height: 24),

              // 5. Section "Top 5 Hand Stock"
              const _ShimmerBox(height: 20, width: 200), // SectionTitle
              const SizedBox(height: 8),
              const _ShimmerTopProductList(), // TopProductList
              const SizedBox(height: 24),

              // 6. Section "Product Category"
              const _ShimmerBox(height: 20, width: 150), // SectionTitle
              const SizedBox(height: 4),
              const _ShimmerBox(height: 12, width: 150), // "Tap a bar..." text
              const SizedBox(height: 12),
              const _ShimmerBarChart(), // ProductBarChart
              const SizedBox(height: 24),

              // 7. Section "Stock Moves"
              const _ShimmerBox(height: 20, width: 150), // SectionTitle
              const SizedBox(height: 4),
              const _ShimmerBox(height: 12, width: 150), // "Tap a bar..." text
              const SizedBox(height: 12),
              const _ShimmerToggleButtons(), // StockMovesToggleButtons
              const SizedBox(height: 16),
              const _ShimmerBarChart(), // ProductBarChart
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET BANTU (HELPER WIDGETS) ---

// [BARU] Skeleton untuk Personalized Header (Avatar + Teks)
class _ShimmerPersonalizedHeader extends StatelessWidget {
  const _ShimmerPersonalizedHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // Avatar
        _ShimmerBox(height: 50, width: 50, radius: 25), 
        SizedBox(width: 12),
        // Kolom Teks
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(height: 20, width: 150), // "Hai, Cahyanto"
              SizedBox(height: 8),
              _ShimmerBox(height: 16, width: 200), // "Selamat datang..."
            ],
          ),
        ),
      ],
    );
  }
}


// [BARU] Skeleton untuk Toggle Buttons (2 tombol)
class _ShimmerToggleButtons extends StatelessWidget {
  const _ShimmerToggleButtons();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang shimmer
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)))),
          const SizedBox(width: 4),
          Expanded(child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)))),
        ],
      ),
    );
  }
}

// [BARU] Skeleton untuk Placeholder Pie Chart
class _ShimmerPieChartPlaceholder extends StatelessWidget {
  const _ShimmerPieChartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(enabled: false),
          sectionsSpace: 2,
          centerSpaceRadius: 45,
          sections: List.generate(4, (i) {
            return PieChartSectionData(
              color: Colors.white, // Warna shimmer
              value: 25,
              title: '',
              radius: 15,
            );
          }),
        ),
      ),
    );
  }
}

// [BARU] Skeleton untuk Card Legend di bawah Pie Chart
class _ShimmerLegendCard extends StatelessWidget {
  const _ShimmerLegendCard();

  @override
  Widget build(BuildContext context) {
    return const _ShimmerBox(
      width: double.infinity,
      radius: 12,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _ShimmerLegendItem(),
            SizedBox(height: 12),
            _ShimmerLegendItem(),
            SizedBox(height: 12),
            _ShimmerLegendItem(),
          ],
        ),
      ),
    );
  }
}

// [BARU] Skeleton untuk 1 baris item di Legend
class _ShimmerLegendItem extends StatelessWidget {
  const _ShimmerLegendItem();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ShimmerBox(height: 12, width: 12, radius: 6), // Indikator warna
        const SizedBox(width: 12),
        const _ShimmerBox(height: 14, width: 100), // Label
        const Spacer(),
        const _ShimmerBox(height: 14, width: 50), // Persentase
      ],
    );
  }
}

// [BARU] Skeleton untuk Top Product List
class _ShimmerTopProductList extends StatelessWidget {
  const _ShimmerTopProductList();

  @override
  Widget build(BuildContext context) {
    return _ShimmerBox(
      width: double.infinity,
      radius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(height: 14, width: 60), // "Product"
                _ShimmerBox(height: 14, width: 40), // "QTY"
              ],
            ),
            const Divider(height: 24, color: Colors.transparent),
            // List Items
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => const _ShimmerProductItem(),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// [BARU] Skeleton untuk 1 baris item di Top Product
class _ShimmerProductItem extends StatelessWidget {
  const _ShimmerProductItem();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerBox(height: 14, width: 150), // Nama produk
        _ShimmerBox(height: 14, width: 50), // Kuantitas
      ],
    );
  }
}

// [BARU] Skeleton untuk Bar Chart
class _ShimmerBarChart extends StatelessWidget {
  const _ShimmerBarChart();

  @override
  Widget build(BuildContext context) {
    return _ShimmerBox(
      width: double.infinity,
      radius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ShimmerBox(height: 18, width: 150), // Title
            const SizedBox(height: 4),
            Row(
              children: [
                const _ShimmerBox(height: 12, width: 12, radius: 2), // Legend color
                const SizedBox(width: 8),
                const _ShimmerBox(height: 12, width: 80), // Legend text
              ],
            ),
            const SizedBox(height: 24),
            const _ShimmerBox(height: 200, width: double.infinity, radius: 8), // Chart area
          ],
        ),
      ),
    );
  }
}

// [TETAP] Skeleton untuk Stat Card (Grid & List)
class _ShimmerStatCard extends StatelessWidget {
  final double? width;
  const _ShimmerStatCard({this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: const Card(
        elevation: 0,
        color: Colors.transparent, // Biarkan shimmer yang mengatur warna
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            children: [
              _ShimmerBox(height: 24, width: 50), // Value
              SizedBox(height: 8),
              _ShimmerBox(height: 14, width: 70), // Title
            ],
          ),
        ),
      ),
    );
  }
}

// [TETAP] Widget dasar untuk semua placeholder shimmer
class _ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final double radius;
  final Widget? child; 

  const _ShimmerBox({
    this.height,
    this.width,
    this.radius = 4,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white, // Warna ini akan "diwarnai" oleh Shimmer
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}