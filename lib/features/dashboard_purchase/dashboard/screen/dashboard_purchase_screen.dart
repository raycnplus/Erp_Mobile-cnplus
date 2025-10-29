import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/purchase_dashboard_shimmer.dart';
import 'dart:ui';
import '../models/purchase_models.dart';
import '../widget/purchase_analysis_chart.dart';
import '../widget/top_list_card.dart';
import '../widget/stat_card_widget.dart';
import '../models/purchase_chart_data_model.dart';
import '../widget/purchase_bar_chart_widget.dart';
import '../widget/purchase_dashboard_drawer_widget.dart';
import '../services/purchase_service.dart';
import '../../../../core/routes/app_routes.dart';
import '../models/purchase_dashboard_model.dart' as ApiModel;
import '../utils/formatters.dart';
import '../../../../shared/widgets/personalized_header.dart';
import '../../../../shared/logout/screen/profile_screen.dart';

class DashboardPurchaseScreen extends StatefulWidget {
  const DashboardPurchaseScreen({super.key});

  @override
  State<DashboardPurchaseScreen> createState() =>
      _DashboardPurchaseScreenState();
}

class _DashboardPurchaseScreenState extends State<DashboardPurchaseScreen> {
  Future<ApiModel.PurchaseDashboardResponse>? _dashboardDataFuture;

  final PurchaseService _purchaseService = PurchaseService();
  int _selectedChart = 0;

  // [BARU] Menambahkan ScrollController
  late ScrollController _scrollController;

  // --- [BARU] ANIMASI ---
  final Alignment _initialTitleAlignment = const Alignment(-0.6, 0.0);
  final Alignment _scrolledTitleAlignment = const Alignment(-1.20, 0.0);
  final TextStyle _initialTitleStyle = GoogleFonts.poppins(
    color: Colors.black87,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  final TextStyle _scrolledTitleStyle = GoogleFonts.poppins(
    color: Colors.black87,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  final double _initialIconSize = 28.0;
  final double _scrolledIconSize = 24.0;
  final double _scrollThreshold = 50.0;
  // --- END ANIMASI ---

  @override
  void initState() {
    super.initState();
    _dashboardDataFuture = _purchaseService.fetchDashboardData();
    // [BARU] Inisialisasi ScrollController
    _scrollController = ScrollController();
  }

  // [BARU] Dispose ScrollController
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ---  Helper widget untuk membuat toggle buttons yang modern ---
  Widget _buildChartToggleButtons() {
    // ... (Fungsi tidak berubah)
    const Color selectedColor = Color(0xFF2D6A4F);
    const Color unselectedColor = Colors.white;
    const Color selectedTextColor = Colors.white;
    const Color unselectedTextColor = Colors.black54;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChart = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedChart == 0 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedChart == 0
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
                  "Top 5 Product",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: _selectedChart == 0
                        ? selectedTextColor
                        : unselectedTextColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChart = 1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedChart == 1 ? selectedColor : unselectedColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedChart == 1
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
                  "Top 5 Vendor",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: _selectedChart == 1
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

  // --- Sisa method lainnya tidak berubah ---
  List<PurchaseChartData> _transformToProductChartData(
    List<ApiModel.TopProduct> products,
  ) {
    // ... (Fungsi tidak berubah)
    return products
        .map(
          (p) => PurchaseChartData(
            label: p.productName,
            value: p.totalSpent,
            color: Colors.pinkAccent,
          ),
        )
        .toList();
  }

  List<PurchaseChartData> _transformToVendorChartData(
    List<ApiModel.TopVendor> vendors,
  ) {
    // ... (Fungsi tidak berubah)
    return vendors
        .map(
          (v) => PurchaseChartData(
            label: v.vendorName,
            value: v.totalSpent,
            color: Colors.cyan,
          ),
        )
        .toList();
  }

  List<MonthlyPurchaseData> _transformToAnalysisData(
    ApiModel.SpendingByMonth spending,
  ) {
    // ... (Fungsi tidak berubah)
    List<MonthlyPurchaseData> chartData = [];
    for (int i = 0; i < spending.labels.length; i++) {
      final month = int.tryParse(spending.labels[i].split('-')[0]) ?? (i + 1);
      chartData.add(
        MonthlyPurchaseData(month: month, amount: spending.data[i]),
      );
    }
    return chartData;
  }

  List<TopListData> _transformToCategoryList(
    List<ApiModel.TopCategory> categories,
  ) {
    // ... (Fungsi tidak berubah)
    return categories
        .map(
          (c) => TopListData(
            title: c.productCategoryName,
            value: formatCurrency(c.totalAmount),
          ),
        )
        .toList();
  }

  List<TopListData> _transformToPurchaseOrderList(
    List<ApiModel.TopPurchaseOrder> orders,
  ) {
    // ... (Fungsi tidak berubah)
    return orders
        .map(
          (o) => TopListData(
            title: o.reference,
            value: formatCurrency(o.totalAmount),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // [DIUBAH] AppBar diganti total
      appBar: AppBar(
        automaticallyImplyLeading: false,

        // [BARU] AnimatedBuilder untuk Ikon Menu
        leading: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double progress = 0.0;
            if (_scrollController.hasClients && _scrollController.offset > 0) {
              progress = (_scrollController.offset / _scrollThreshold).clamp(
                0.0,
                1.0,
              );
            }
            final double currentIconSize = lerpDouble(
              _initialIconSize,
              _scrolledIconSize,
              progress,
            )!;
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
                size: currentIconSize,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),

        // [BARU] AnimatedBuilder untuk Title
        title: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double progress = 0.0;
            if (_scrollController.hasClients && _scrollController.offset > 0) {
              progress = (_scrollController.offset / _scrollThreshold).clamp(
                0.0,
                1.0,
              );
            }
            final Alignment currentAlignment = Alignment.lerp(
              _initialTitleAlignment,
              _scrolledTitleAlignment,
              progress,
            )!;
            final TextStyle currentTitleStyle = TextStyle.lerp(
              _initialTitleStyle,
              _scrolledTitleStyle,
              progress,
            )!;

            return Container(
              width: double.infinity,
              child: Align(
                alignment: currentAlignment,
                child: Text(
                  'Dashboard Purchase', // Teks diubah
                  style: currentTitleStyle,
                ),
              ),
            );
          },
        ),

        // [BARU] Menambahkan ikon profil di sebelah kanan
        actions: [
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double progress = 0.0;
              if (_scrollController.hasClients &&
                  _scrollController.offset > 0) {
                progress = (_scrollController.offset / _scrollThreshold).clamp(
                  0.0,
                  1.0,
                );
              }
              final double currentIconSize = lerpDouble(
                _initialIconSize,
                _scrolledIconSize,
                progress,
              )!;
              return IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.black,
                  size: currentIconSize,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );

                  print('Profile icon tapped');
                },
              );
            },
          ),
          const SizedBox(width: 8), // Padding di kanan
        ],

        backgroundColor: Colors.white,
        elevation: 1,
      ),

      drawerScrimColor: Colors.black.withOpacity(0.25),
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: const PurchaseDashboardDrawer(),
      ),
      body: FutureBuilder<ApiModel.PurchaseDashboardResponse>(
        future: _dashboardDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PurchaseDashboardShimmer();
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data!;
          final summary = data.summary;
          final top5ProductData = _transformToProductChartData(
            data.topProducts,
          );
          final top5VendorData = _transformToVendorChartData(data.topVendors);
          final purchaseAnalysisData = _transformToAnalysisData(
            data.charts.spendingByMonth,
          );
          final topCategoryData = _transformToCategoryList(data.topCategories);
          final topPurchaseOrderData = _transformToPurchaseOrderList(
            data.topPurchaseOrders,
          );

          return SingleChildScrollView(
            // [BARU] Menghubungkan controller
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... (Sisa isi body tidak berubah) ...
                const PersonalizedHeader(),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                  children: [
                    StatCard(
                      title: "Purchase Request",
                      value: summary.purchaseRequest.toString(),
                    ),
                    StatCard(
                      title: "Request For Quotation",
                      value: summary.rfq.toString(),
                    ),
                    StatCard(
                      title: "Purchase Order",
                      value: summary.purchaseOrder.toString(),
                    ),
                    StatCard(
                      title: "Direct Purchase",
                      value: summary.directPurchase.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildChartToggleButtons(),

                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedChart == 0
                      ? Column(
                          key: const ValueKey('top5product'),
                          children: [
                            PurchaseBarChart(
                              data: top5ProductData,
                              title: "Top 5 Product",
                            ),
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
                          key: const ValueKey('top5vendor'),
                          children: [
                            PurchaseBarChart(
                              data: top5VendorData,
                              title: "Top 5 Vendor",
                            ),
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
                const SizedBox(height: 24),

                PurchaseAnalysisChart(purchaseData: purchaseAnalysisData),
                const SizedBox(height: 24),
                TopListCard(
                  title: 'Top 5 Category Product',
                  items: topCategoryData,
                ),
                const SizedBox(height: 24),
                TopListCard(
                  title: 'Top 5 Purchase Order',
                  items: topPurchaseOrderData,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
