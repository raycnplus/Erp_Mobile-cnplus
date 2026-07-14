import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/models/crm_dashboard_models.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/presentation/controllers/crm_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/presentation/widgets/crm_dashboard_shimmer.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/presentation/widgets/crm_line_chart.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';

class DashboardCrmScreen extends StatefulWidget {
  const DashboardCrmScreen({super.key});

  @override
  State<DashboardCrmScreen> createState() => _DashboardCrmScreenState();
}

class _DashboardCrmScreenState extends State<DashboardCrmScreen> {
  late CrmDashboardController _controller;
  late ScrollController _scrollController;

  static const Color _theme = Color(0xFF1565C0);
  final double _scrollThreshold = 50.0;

  @override
  void initState() {
    super.initState();
    _controller = getIt<CrmDashboardController>();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CrmDashboardController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        drawerScrimColor: Colors.black.withOpacity(0.25),
        drawer: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const UniversalDrawer(currentModule: AppModule.crm),
        ),
        body: Consumer<CrmDashboardController>(
          builder: (context, ctrl, _) {
            if (ctrl.status == CrmDashboardStatus.error) return _buildError(ctrl);
            if (ctrl.status == CrmDashboardStatus.loading) {
              return const CrmDashboardShimmer();
            }
            if (ctrl.status == CrmDashboardStatus.loaded && ctrl.hasData) {
              return _buildContent(ctrl);
            }
            return const Center(child: Text('No data available'));
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
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: lerpDouble(28, 24, p)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final p = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
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
                'Dashboard CRM',
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
                ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
                : 0.0;
            return IconButton(
              icon: Icon(
                Icons.person_outline,
                color: Colors.black,
                size: lerpDouble(28, 24, p),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildError(CrmDashboardController ctrl) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            ctrl.errorMessage ?? 'An error occurred',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: ctrl.loadDashboard,
            style: ElevatedButton.styleFrom(backgroundColor: _theme),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CrmDashboardController ctrl) {
    final s = ctrl.data!.summary;

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
            Row(
              children: [
                Expanded(child: StatCard(
                  title: 'Total Leads',
                  value: s.totalLeads.toString(),
                  icon: Icons.people_outline,
                )),
                const SizedBox(width: 10),
                Expanded(child: StatCard(
                  title: 'Opportunities',
                  value: s.opportunities.toString(),
                  icon: Icons.track_changes_outlined,
                )),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: StatCard(
                  title: 'Customers',
                  value: s.customers.toString(),
                  icon: Icons.group_outlined,
                )),
                const SizedBox(width: 10),
                Expanded(child: StatCard(
                  title: 'Closed Deals',
                  value: s.closedDeals.toString(),
                  icon: Icons.handshake_outlined,
                )),
              ],
            ),
            const SizedBox(height: 10),
            _buildAiAgentCard(s),
            const SizedBox(height: 24),
            Consumer<CrmDashboardController>(
              builder: (_, ctrl, __) => CrmLineChart(
                title: 'Conversation Volume',
                chartData: ctrl.convChart,
                isLoading: ctrl.convChartLoading,
                selected: ctrl.convGranularity,
                onGranularityChanged: ctrl.changeConvGranularity,
                lineColor: _theme,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<CrmDashboardController>(
              builder: (_, ctrl, __) => CrmLineChart(
                title: 'Message Volume',
                chartData: ctrl.msgChart,
                isLoading: ctrl.msgChartLoading,
                selected: ctrl.msgGranularity,
                onGranularityChanged: ctrl.changeMsgGranularity,
                lineColor: const Color(0xFF00897B),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAiAgentCard(CrmSummary s) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.smart_toy_outlined, color: Color(0xFF7B1FA2), size: 22),
                const SizedBox(width: 8),
                Text(
                  'AI Agent Performance',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${s.avgResponseTime} s',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _theme,
                        ),
                      ),
                      Text(
                        'Avg Response',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 48, color: Colors.grey.shade200),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${s.avgErrorRate} %',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade600,
                          ),
                        ),
                        Text(
                          'Error Rate',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}