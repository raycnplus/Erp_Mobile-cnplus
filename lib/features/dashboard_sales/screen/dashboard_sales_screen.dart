import 'package:flutter/material.dart';
import '../models/sales_dashboard_model.dart';
import '../widget/stat_card_widget.dart';
import '../widget/sales_bar_chart_widget.dart';
import '../widget/top_list_card.dart';
import '../widget/sales_dashboard_drawer_widget.dart';
import '../services/sales_dashboard_service.dart';
import '../helpers/currency_helper.dart';
import '../../../core/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/personalized_header.dart';

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
    return Scaffold(
      drawer: const SalesDashboardDrawer(),
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
      title: GestureDetector(
      onTap: () {
      Navigator.pushNamed(context, AppRoutes.modul);
      },
      child: const Text(
        'Sales',
      style: TextStyle(color: Colors.black),
     ),
   ),
   centerTitle: false ,
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
          final double spacing = 8;
          final double horizontalPadding = 16;
          final double screenWidth = MediaQuery.of(context).size.width;
          final double cardWidth4 =
              (screenWidth - horizontalPadding * 2 - spacing * 3) / 4;
          final double cardWidth2 =
              (screenWidth - horizontalPadding * 2 - spacing) / 2;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const PersonalizedHeader(),
                const SizedBox(height: 16,),
                Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    SizedBox(
                      width: cardWidth4,
                      child: StatCard(
                        title: "Quotations",
                        value: data.quotation.toString(),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth4,
                      child: StatCard(
                        title: "Sales Order",
                        value: data.salesOrder.toString(),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth4,
                      child: StatCard(
                        title: "Direct Sales",
                        value: data.directSales.toString(),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth4,
                      child: StatCard(
                        title: "Invoices",
                        value: data.invoice.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 2 StatCard dalam 1 baris
                Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    SizedBox(
                      width: cardWidth2,
                      child: StatCard(
                        title: "Products",
                        value: data.salesProductCount.toString(),
                        titleStyle: const TextStyle(
                          fontSize: 11,
                          // color: const Color(0xFF2D6A4F)
                        ),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth2,
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