import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/presentation/controllers/manufacturing_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/presentation/widgets/manufacturing_dashboard_shimmer.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/presentation/widgets/manufacturing_bar_chart.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/presentation/widgets/manufacturing_wip_table.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';

class DashboardManufacturingScreen extends StatefulWidget {
  const DashboardManufacturingScreen({super.key});

  @override
  State<DashboardManufacturingScreen> createState() => _DashboardManufacturingScreenState();
}

class _DashboardManufacturingScreenState extends State<DashboardManufacturingScreen> {
  late ManufacturingDashboardController _controller;
  late ScrollController _scrollController;
  int _selectedChart = 0;

  static const Color _theme = Color(0xFF2D6A4F);
  final _dateFormat = DateFormat('dd MMM yyyy');
  final double _scrollThreshold = 50.0;

  @override
  void initState() {
    super.initState();
    _controller = getIt<ManufacturingDashboardController>();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.loadDashboard());
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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: _theme),
        ),
        child: child!,
      ),
    );
    if (picked != null) _controller.updateDateRange(picked.start, picked.end);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManufacturingDashboardController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        drawerScrimColor: Colors.black.withOpacity(0.25),
        drawer: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const UniversalDrawer(currentModule: AppModule.manufacturing),
        ),
        body: Consumer<ManufacturingDashboardController>(
          builder: (context, ctrl, _) {
            if (ctrl.status == ManufacturingDashboardStatus.error) {
              return _buildError(ctrl);
            }
            if (ctrl.status == ManufacturingDashboardStatus.loading) {
              return const ManufacturingDashboardShimmer();
            }
            if (ctrl.status == ManufacturingDashboardStatus.loaded && ctrl.hasData) {
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
          final progress = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: lerpDouble(28, 24, progress)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final progress = _scrollController.hasClients
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
          return SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.lerp(
                const Alignment(-0.6, 0),
                const Alignment(-1.2, 0),
                progress,
              )!,
              child: Text(
                'Dashboard Manufacturing',
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
                  progress,
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
            final progress = _scrollController.hasClients
                ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
                : 0.0;
            return IconButton(
              icon: Icon(
                Icons.person_outline,
                color: Colors.black,
                size: lerpDouble(28, 24, progress),
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

  Widget _buildError(ManufacturingDashboardController ctrl) {
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

  Widget _buildDateFilter(ManufacturingDashboardController ctrl) {
    return GestureDetector(
      onTap: _pickDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
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
            const Icon(Icons.calendar_today_outlined, color: _theme, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_dateFormat.format(ctrl.startDate)}  →  ${_dateFormat.format(ctrl.endDate)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _theme,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Filter',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartToggle() {
    final labels = ['Top 5 Finished Products', 'Top 5 Used Materials'];
    return Row(
      children: List.generate(2, (i) {
        final isSelected = _selectedChart == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == 0 ? 5 : 0, left: i == 1 ? 5 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedChart = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? _theme : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? _theme : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _theme.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContent(ManufacturingDashboardController ctrl) {
    final data = ctrl.dashboardData!;
    final s = data.summary;

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
            Row(
              children: [
                Expanded(child: StatCard(
                  title: 'Manufacturing Orders',
                  value: s.manufacturingOrders.toString(),
                  icon: Icons.factory_outlined,
                )),
                const SizedBox(width: 10),
                Expanded(child: StatCard(
                  title: 'Active Operations',
                  value: s.activeOperations.toString(),
                  icon: Icons.play_circle_outline,
                )),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: StatCard(
                  title: 'Unbuild Orders',
                  value: s.unbuildOrders.toString(),
                  icon: Icons.undo_outlined,
                )),
                const SizedBox(width: 10),
                Expanded(child: StatCard(
                  title: 'Bill of Materials',
                  value: s.bom.toString(),
                  icon: Icons.list_alt_outlined,
                )),
              ],
            ),
            const SizedBox(height: 24),
            _buildChartToggle(),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedChart == 0
                  ? ManufacturingBarChart(
                      key: const ValueKey('finished'),
                      data: data.charts.finishedProducts,
                      title: 'Top 5 Finished Products',
                      barColor: const Color(0xFF42A5F5),
                      legendLabel: 'Quantity Produced',
                    )
                  : ManufacturingBarChart(
                      key: const ValueKey('materials'),
                      data: data.charts.usedMaterials,
                      title: 'Top 5 Used Materials',
                      barColor: const Color(0xFFEF9A9A),
                      legendLabel: 'Quantity Used',
                    ),
            ),
            const SizedBox(height: 24),
            ManufacturingWipTable(items: data.workInProgress),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}