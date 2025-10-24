import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shimmer/shimmer.dart'; 
import '../models/sales_dashboard_model.dart';
import '../widget/stat_card_widget.dart';
import '../widget/sales_bar_chart_widget.dart';
import '../widget/top_list_card.dart';
import '../widget/sales_dashboard_drawer_widget.dart';
import '../services/sales_dashboard_service.dart';
import '../helpers/currency_helper.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/personalized_header.dart';

class DashboardSalesScreen extends StatefulWidget {
  const DashboardSalesScreen({super.key});

  @override
  State<DashboardSalesScreen> createState() => _DashboardSalesScreenState();
}

class _DashboardSalesScreenState extends State<DashboardSalesScreen> {
  late Future<SalesDashboardResponse> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = SalesDashboardService.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF2D6A4F);

    return Scaffold(
      drawerScrimColor: Colors.black.withOpacity(0.25),
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: const SalesDashboardDrawer(),
      ),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.modul);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: accentColor,
              border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  'Sales',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<SalesDashboardResponse>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _DashboardSalesShimmer(); // Tampilkan shimmer
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }
          final data = snapshot.data!;

          // Tampilan data asli jika sudah selesai loading
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const PersonalizedHeader(),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatCard(
                      title: "Quotations",
                      value: data.quotation.toString(),
                      useFittedBox: true,
                    ),
                    StatCard(
                      title: "Sales Order",
                      value: data.salesOrder.toString(),
                      useFittedBox: true,
                    ),
                    StatCard(
                      title: "Direct Sales",
                      value: data.directSales.toString(),
                      useFittedBox: true,
                    ),
                    StatCard(
                      title: "Invoices",
                      value: data.invoice.toString(),
                      useFittedBox: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: "Products",
                        value: data.salesProductCount.toString(),
                        titleStyle: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        title: "Revenue",
                        value: formatCurrency(data.grandTotal),
                        valueColor: const Color(0xFF2D6A4F),
                        titleStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SalesBarChart(data: data.revenuePerDay, title: "Daily Revenue"),
                
                // --- [DIUBAH] Menambahkan teks petunjuk ---
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
                // --- Akhir Perubahan ---

                const SizedBox(height: 24),
                SalesBarChart(
                  data: data.quantityPerDay,
                  title: "Quantity Sold",
                ),

                // --- [DIUBAH] Menambahkan teks petunjuk ---
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
                // --- Akhir Perubahan ---

                const SizedBox(height: 24),
                TopListCard(
                  title: "Top 5 Customers",
                  items: data.topCustomers
                      .map(
                        (c) => [
                          c.customerName,
                          c.categoryName,
                          formatCurrency(c.totalAmount),
                        ],
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                TopListCard(
                  title: "Top 5 Invoices",
                  items: data.topInvoices
                      .map(
                        (i) => [
                          i.reference,
                          i.customerName,
                          formatCurrency(i.grandTotal),
                        ],
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =======================================================================
// >>> WIDGET BARU: Shimmer Layout untuk Sales Dashboard <<<
// =======================================================================

class _DashboardSalesShimmer extends StatelessWidget {
  const _DashboardSalesShimmer();

  /// Helper widget untuk membuat blok skeleton
  Widget _buildSkeletonBlock({
    double? height,
    double? width,
    double radius = 12.0,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white, // Warna dasar shimmer
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(radius) : null,
        shape: shape,
      ),
    );
  }

  /// Helper untuk skeleton Card (Chart)
  Widget _buildSkeletonChartBlock() {
    return Container(
      height: 280, // Tinggi kira-kira SalesBarChart
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBlock(height: 20, width: 150, radius: 8), // Title
          const SizedBox(height: 8),
          _buildSkeletonBlock(height: 14, width: 100, radius: 8), // Subtitle
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSkeletonBlock(height: 100, width: 22, radius: 4),
                _buildSkeletonBlock(height: 150, width: 22, radius: 4),
                _buildSkeletonBlock(height: 80, width: 22, radius: 4),
                _buildSkeletonBlock(height: 120, width: 22, radius: 4),
                _buildSkeletonBlock(height: 160, width: 22, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper untuk skeleton Card (TopListCard)
  Widget _buildSkeletonListBlock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBlock(height: 20, width: 150, radius: 8), // Title
          const SizedBox(height: 16),
          // Table header
          Row(
            children: [
              Expanded(child: _buildSkeletonBlock(height: 16, radius: 8)),
              const SizedBox(width: 8),
              Expanded(child: _buildSkeletonBlock(height: 16, radius: 8)),
              const SizedBox(width: 8),
              Expanded(child: _buildSkeletonBlock(height: 16, radius: 8)),
            ],
          ),
          const SizedBox(height: 12),
          // Table row 1
          Row(
            children: [
              Expanded(child: _buildSkeletonBlock(height: 14, radius: 8)),
              const SizedBox(width: 8),
              Expanded(child: _buildSkeletonBlock(height: 14, radius: 8)),
              const SizedBox(width: 8),
              Expanded(child: _buildSkeletonBlock(height: 14, radius: 8)),
            ],
          ),
          const SizedBox(height: 12),
          // Table row 2
          Row(
            children: [
              Expanded(child: _buildSkeletonBlock(height: 14, radius: 8)),
              const SizedBox(width: 8),
              Expanded(child: _buildSkeletonBlock(height: 14, radius: 8)),
              const SizedBox(width: 8),
              Expanded(child: _buildSkeletonBlock(height: 14, radius: 8)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: SingleChildScrollView(
        // Penting: nonaktifkan scroll saat loading
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Skeleton untuk PersonalizedHeader
            Row(
              children: [
                _buildSkeletonBlock(
                    height: 50, width: 50, shape: BoxShape.circle),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBlock(height: 20, width: 150, radius: 8),
                    const SizedBox(height: 8),
                    _buildSkeletonBlock(height: 16, width: 100, radius: 8),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),

            // 2. Skeleton untuk GridView (4 StatCard)
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                  4, (index) => _buildSkeletonBlock(radius: 12)),
            ),
            const SizedBox(height: 16),

            // 3. Skeleton untuk Row (2 StatCard)
            Row(
              children: [
                Expanded(child: _buildSkeletonBlock(height: 100, radius: 12)),
                const SizedBox(width: 10),
                Expanded(child: _buildSkeletonBlock(height: 100, radius: 12)),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Skeleton untuk SalesBarChart (Revenue)
            _buildSkeletonChartBlock(),
            const SizedBox(height: 24),

            // 5. Skeleton untuk SalesBarChart (Quantity)
            _buildSkeletonChartBlock(),
            const SizedBox(height: 24),

            // 6. Skeleton untuk TopListCard (Customers)
            _buildSkeletonListBlock(),
            const SizedBox(height: 24),

            // 7. Skeleton untuk TopListCard (Invoices)
            _buildSkeletonListBlock(),
          ],
        ),
      ),
    );
  }
}