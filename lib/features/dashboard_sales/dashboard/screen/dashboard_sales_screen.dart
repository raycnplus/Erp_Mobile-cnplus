import 'package:flutter/material.dart';
import 'dart:ui'; 
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
    // Definisi warna aksen utama
    const Color accentColor = Color(0xFF2D6A4F);

    return Scaffold(
      // =========================================================
      // >>> MODIFIKASI UNTUK EFEK BLUR LEBIH HALUS <<<
      // =========================================================
      drawerScrimColor: Colors.black.withOpacity(0.25), // Opasitas lebih rendah
      drawer: BackdropFilter(
        // Sigma yang lebih kecil untuk blur yang lebih halus
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5), 
        child: const SalesDashboardDrawer(),
      ),
      // =========================================================
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data'));
          }
          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const PersonalizedHeader(),
                const SizedBox(height: 16),

                // 4 StatCard atas dengan GridView dan FittedBox
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
                // 2 StatCard bawah dengan Row
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
                const SizedBox(height: 24),
                SalesBarChart(
                  data: data.quantityPerDay,
                  title: "Quantity Sold",
                ),
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