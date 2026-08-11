import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/models/pos_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/presentation/controllers/pos_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/presentation/widgets/pos_bar_chart.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/presentation/widgets/pos_dashboard_shimmer.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/presentation/widgets/pos_pie_chart.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';

class DashboardPosScreen extends StatefulWidget {
  const DashboardPosScreen({super.key});

  @override
  State<DashboardPosScreen> createState() => _DashboardPosScreenState();
}

class _DashboardPosScreenState extends State<DashboardPosScreen> {
  late PosDashboardController _controller;
  late ScrollController _scrollController;

  final _dateFmt = DateFormat('dd MMM yyyy');

  static const Color _theme = Color(0xFF2D6A4F);
  final double _scrollThreshold = 50.0;

  @override
  void initState() {
    super.initState();

    _controller = getIt<PosDashboardController>();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.loadDashboard(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _controller.startDate,
        end: _controller.endDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _theme,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _controller.updateDateRange(
        picked.start,
        picked.end,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PosDashboardController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        drawerScrimColor: Colors.black.withOpacity(0.25),
        drawer: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.5,
            sigmaY: 2.5,
          ),
          child: const UniversalDrawer(
            currentModule: AppModule.pos,
          ),
        ),
        body: Consumer<PosDashboardController>(
          builder: (context, ctrl, _) {
            if (ctrl.status == PosDashboardStatus.error) {
              return _buildError(ctrl);
            }

            if (ctrl.status == PosDashboardStatus.loading) {
              return const PosDashboardShimmer();
            }

            if (ctrl.status == PosDashboardStatus.loaded &&
                ctrl.hasData) {
              return _buildContent(ctrl);
            }

            return const Center(
              child: Text('No data available'),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final p = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold)
                  .clamp(0.0, 1.0)
              : 0.0;

          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: lerpDouble(28, 24, p),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final p = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold)
                  .clamp(0.0, 1.0)
              : 0.0;

          return SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.lerp(
                const Alignment(-0.6, 0),
                const Alignment(-1.2, 0),
                p,
              )!,
              child: Text(
                'Dashboard PoS',
                style: TextStyle.lerp(
                  GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  p,
                )!,
              ),
            ),
          );
        },
      ),
      actions: [
        AnimatedBuilder(
          animation: _scrollController,
          builder: (context, _) {
            final p = _scrollController.hasClients
                ? (_scrollController.offset / _scrollThreshold)
                    .clamp(0.0, 1.0)
                : 0.0;

            return IconButton(
              icon: Icon(
                Icons.person_outline,
                color: Colors.black,
                size: lerpDouble(28, 24, p),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildError(PosDashboardController ctrl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            ctrl.errorMessage ?? 'An error occurred',
            style: const TextStyle(
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: ctrl.loadDashboard,
            style: ElevatedButton.styleFrom(
              backgroundColor: _theme,
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilter(PosDashboardController ctrl) {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: _theme,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_dateFmt.format(ctrl.startDate)}  →  ${_dateFmt.format(ctrl.endDate)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _theme,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(PosDashboardController ctrl) {
    final s = ctrl.data!.summary;
    final growthPositive = s.comparisonPct >= 0;

    return RefreshIndicator(
      onRefresh: ctrl.refresh,
      color: _theme,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PersonalizedHeader(),
            const SizedBox(height: 16),
            _buildDateFilter(ctrl),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: [
                _PosStatCard(
                  value: s.totalTransactions.toString(),
                  label: 'Transactions Today',
                  icon: Icons.receipt_outlined,
                  iconColor: _theme,
                ),
                _PosStatCard(
                  value: formatCurrency(s.totalSales),
                  label: 'Sales Today',
                  icon: Icons.point_of_sale_outlined,
                  iconColor: Colors.blue.shade600,
                ),
                _PosStatCard(
                  value: formatCurrency(s.yesterdaySales),
                  label: 'Sales Yesterday',
                  icon: Icons.history_outlined,
                  iconColor: Colors.orange.shade600,
                ),
                _PosGrowthCard(
                  pct: s.comparisonPct,
                  positive: growthPositive,
                ),
                _PosStatCard(
                  value: formatCurrency(s.salesThisWeek),
                  label: 'Sales This Week',
                  icon: Icons.calendar_view_week_outlined,
                  iconColor: Colors.purple.shade600,
                ),
                _PosStatCard(
                  value: formatCurrency(s.salesThisMonth),
                  label: 'Sales This Month',
                  icon: Icons.calendar_month_outlined,
                  iconColor: Colors.teal.shade600,
                ),
              ],
            ),
            const SizedBox(height: 24),
            PosTopProductChart(
              products: ctrl.data!.topProducts,
            ),
            const SizedBox(height: 16),
            PosPaymentPieChart(
              paymentMethods: ctrl.data!.paymentMethods,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PosStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _PosStatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                icon,
                color: iconColor.withOpacity(0.3),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosGrowthCard extends StatelessWidget {
  final double pct;
  final bool positive;

  const _PosGrowthCard({
    required this.pct,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive
        ? Colors.green.shade700
        : Colors.red.shade700;

    final icon = positive
        ? Icons.trending_up
        : Icons.trending_down;

    final sign = positive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 14,
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  'Growth\nvs Yesterday',
                  maxLines: 2,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$sign${pct.toStringAsFixed(1)}%',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}