import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/presentation/controllers/hr_dashboard_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/models/hr_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/universal_drawer.dart';
import 'package:erp_mobile_cnplus/shared/widgets/drawer_menu_config.dart';
import 'package:erp_mobile_cnplus/shared/widgets/personalized_header.dart';
import 'package:erp_mobile_cnplus/shared/widgets/stat_card.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/screens/my_payslip_detail_screen.dart';

class DashboardHrScreen extends StatefulWidget {
  const DashboardHrScreen({
    super.key,
  });
  @override
  State<DashboardHrScreen> createState() => _DashboardHrScreenState();
}

class _DashboardHrScreenState extends State<DashboardHrScreen> {
  late HrDashboardController _controller;
  late ScrollController _scrollController;

  static const Color _themeColor = Color(0xFF2D6A4F);
  final _dateFormat = DateFormat('dd MMM yyyy');

  final double _scrollThreshold = 50.0;
  final double _initialIconSize = 28.0;
  final double _scrolledIconSize = 24.0;
  final TextStyle _initialTitleStyle = GoogleFonts.poppins(
      color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600);
  final TextStyle _scrolledTitleStyle = GoogleFonts.poppins(
      color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600);
  final Alignment _initialAlign = const Alignment(-0.6, 0.0);
  final Alignment _scrolledAlign = const Alignment(-1.2, 0.0);

  @override
  void initState() {
    super.initState();
    _controller = getIt<HrDashboardController>();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadDashboard();
    });
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
          colorScheme: const ColorScheme.light(primary: _themeColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _controller.loadDashboard(start: picked.start, end: picked.end);
    }
  }

@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider<HrDashboardController>.value(
    value: _controller,
    child: Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: _buildAppBar(),

      drawerScrimColor:
          Colors.black.withOpacity(0.25),

      drawer: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2.5,
          sigmaY: 2.5,
        ),
        child: const UniversalDrawer(
          currentModule: AppModule.hr,
        ),
      ),

      body: Consumer<HrDashboardController>(
        builder: (context, controller, _) {
          if (controller.status ==
              HrDashboardStatus.error) {
            return _buildErrorState(
              controller,
            );
          }

          if (controller.status ==
              HrDashboardStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: _themeColor,
              ),
            );
          }

          if (controller.status ==
                  HrDashboardStatus.loaded &&
              controller.hasData) {
            if (controller.isAdminView) {
              return _buildAdminDashboard(
                controller,
              );
            }

            if (controller.isStaffView) {
              return _buildUserDashboard(
                controller,
              );
            }

            return const Center(
              child: Text(
                'Unknown dashboard mode',
              ),
            );
          }

          return const Center(
            child: Text(
              'No data available',
            ),
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
              ? (_scrollController.offset / _scrollThreshold).clamp(0.0, 1.0)
              : 0.0;
          return IconButton(
            icon: Icon(Icons.menu, color: Colors.black,
                size: lerpDouble(_initialIconSize, _scrolledIconSize, p)),
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
              alignment: Alignment.lerp(_initialAlign, _scrolledAlign, p)!,
              child: Text('Dashboard HR',
                  style: TextStyle.lerp(
                      _initialTitleStyle, _scrolledTitleStyle, p)!),
            ),
          );
        },
      ),
actions: [
  Consumer<HrDashboardController>(
    builder: (context, controller, _) {
      if (!controller.userIsAdmin) {
        return const SizedBox.shrink();
      }

      return PopupMenuButton<HrDashboardViewMode>(
        tooltip: 'Switch Dashboard',
        icon: const Icon(
          Icons.swap_horiz_rounded,
          color: Colors.black,
        ),
        onSelected: (mode) async {
          if (mode ==
              HrDashboardViewMode.admin) {
            await controller
                .switchToAdminView();
          } else {
            await controller
                .switchToStaffView();
          }
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value:
                  HrDashboardViewMode.admin,
              child: Row(
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    color:
                        controller.isAdminView
                            ? _themeColor
                            : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Admin Dashboard',
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value:
                  HrDashboardViewMode.staff,
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color:
                        controller.isStaffView
                            ? _themeColor
                            : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Personal Dashboard',
                  ),
                ],
              ),
            ),
          ];
        },
      );
    },
  ),

  AnimatedBuilder(
    animation: _scrollController,
    builder: (context, _) {
      final p = _scrollController.hasClients
          ? (_scrollController.offset /
                  _scrollThreshold)
              .clamp(0.0, 1.0)
          : 0.0;

      return IconButton(
        icon: Icon(
          Icons.person_outline,
          color: Colors.black,
          size: lerpDouble(
            _initialIconSize,
            _scrolledIconSize,
            p,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const ProfileScreen(),
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

  Widget _buildErrorState(HrDashboardController controller) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(controller.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.loadDashboard(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _themeColor, foregroundColor: Colors.white),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );

  // ================================================================
  // ADMIN DASHBOARD
  // ================================================================
  Widget _buildAdminDashboard(HrDashboardController controller) {
    final admin = controller.dashboardData!.admin!;
    final s = admin.todaySummary;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: _themeColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PersonalizedHeader(),
            const SizedBox(height: 16),

            _buildDateFilter(controller),
            const SizedBox(height: 16),

            Row(children: [
              Expanded(
                  child: StatCard(
                      title: "Total Employee",
                      value: s.totalEmployees.toString(),
                      icon: Icons.groups_outlined)),
              const SizedBox(width: 10),
              Expanded(
                  child: StatCard(
                      title: "Attendance Rate",
                      value: '${s.attendanceRate.toStringAsFixed(1)}%',
                      icon: Icons.trending_up)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                  child: StatCard(
                      title: "Late Today",
                      value: s.lateToday.toString(),
                      icon: Icons.schedule_outlined)),
              const SizedBox(width: 10),
              Expanded(
                  child: StatCard(
                      title: "Early Leave Today",
                      value: s.earlyLeaveToday.toString(),
                      icon: Icons.exit_to_app_outlined)),
            ]),
            const SizedBox(height: 24),

            Text('Today Attendance',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildTodayAttendanceGrid(s),
            const SizedBox(height: 24),

            _buildEmployeeStatusCard(s),
            const SizedBox(height: 24),

            _buildAttendanceChartCard(
              admin.charts.attendance7Days,
            ),
            const SizedBox(height: 24),

            _buildTopLateCard(
              admin.topLateEmployees,
            ),
            const SizedBox(height: 24),

            _buildTopPresentCard(
              admin.topPresentEmployees,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter(HrDashboardController controller) {
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
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: _themeColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_dateFormat.format(controller.startDate)}  →  ${_dateFormat.format(controller.endDate)}',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: _themeColor,
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Filter',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayAttendanceGrid(HrTodaySummary s) {
    return Row(
      children: [
        Expanded(
          child: Column(children: [
            _buildAttendanceSmallCard(
                'Checked In', s.checkedIn, Icons.check_circle_outline,
                Colors.green),
            const SizedBox(height: 10),
            _buildAttendanceSmallCard(
                'On Leave', s.onLeave, Icons.person_off_outlined,
                Colors.orange),
          ]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(children: [
            _buildAttendanceSmallCard(
                'Checked Out', s.checkedOut, Icons.logout_outlined,
                Colors.blue),
            const SizedBox(height: 10),
            _buildAttendanceSmallCard(
                'Not Check In', s.notCheckedIn, Icons.cancel_outlined,
                Colors.red),
          ]),
        ),
      ],
    );
  }

  Widget _buildAttendanceSmallCard(
      String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade600)),
                Text(value.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeStatusCard(HrTodaySummary s) {
    final total = s.checkedIn + s.notCheckedIn + s.onLeave + s.checkedOut;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee Status',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 180,
              width: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(180, 180),
                    painter: _DonutChartPainter(
                      checkedIn: s.checkedIn,
                      notCheckedIn: s.notCheckedIn,
                      onLeave: s.onLeave,
                      checkedOut: s.checkedOut,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(total.toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 28, fontWeight: FontWeight.w700)),
                      Text('Total',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _legendItem('Checked In', Colors.green, s.checkedIn)),
              Expanded(
                  child: _legendItem(
                      'Not Check In', Colors.red, s.notCheckedIn)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _legendItem('On Leave', Colors.orange, s.onLeave)),
              Expanded(
                  child:
                      _legendItem('Checked Out', Colors.blue, s.checkedOut)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Attendance Rate',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade900)),
                Text('${s.attendanceRate.toStringAsFixed(2)}%',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, int value) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Flexible(
          child: Text('$label: $value',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildAttendanceChartCard(Attendance7DaysChart chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.bar_chart_rounded, color: _themeColor, size: 24),
            const SizedBox(width: 8),
            Text('7 Days Attendance',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: chart.labels.isEmpty
                ? Center(
                    child: Text('No data',
                        style: GoogleFonts.poppins(color: Colors.grey)))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, gi, rod, ri) {
                            final label = chart.labels.length > gi
                                ? chart.labels[gi]
                                : '';
                            final val = rod.toY.toInt();
                            final type = ri == 0 ? 'Present' : 'Late';
                            return BarTooltipItem(
                              '$label\n$type: $val',
                              GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, meta) {
                              final i = val.toInt();
                              if (i >= chart.labels.length) {
                                return const SizedBox.shrink();
                              }
                              final parts = chart.labels[i].split(' ');
                              final short = parts.length >= 2
                                  ? '${parts[0]}\n${parts[1]}'
                                  : chart.labels[i];
                              return SideTitleWidget(
                                  meta: meta,
                                  child: Text(short,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 9,
                                          color: Colors.grey.shade600)));
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (val, meta) {
                              if (val == meta.min || val == meta.max) {
                                return const SizedBox.shrink();
                              }
                              return Text(val.toInt().toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.grey.shade600));
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (v) => FlLine(
                            color: Colors.grey.shade200, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(chart.labels.length, (i) {
                        final present = chart.present.length > i
                            ? chart.present[i].toDouble()
                            : 0.0;
                        final late = chart.late.length > i
                            ? chart.late[i].toDouble()
                            : 0.0;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                                toY: present,
                                color: Colors.blue.shade300,
                                width: 10,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4))),
                            BarChartRodData(
                                toY: late,
                                color: Colors.red.shade300,
                                width: 10,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4))),
                          ],
                        );
                      }),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chartLegend('Present', Colors.blue.shade300),
              const SizedBox(width: 24),
              _chartLegend('Late', Colors.red.shade300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartLegend(String label, Color color) {
    return Row(children: [
      Container(
          width: 16,
          height: 10,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 6),
      Text(label,
          style:
              GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700)),
    ]);
  }

  Widget _buildTopLateCard(List<TopLateEmployee> items) {
    return _buildRankCard(
      title: 'Top Late Employee',
      icon: Icons.schedule_outlined,
      iconColor: Colors.orange,
      emptyText: 'No late employees in this period',
      itemCount: items.length,
      itemBuilder: (i) {
        final e = items[i];
        return _rankRow(
            rank: i + 1,
            name: e.name,
            value: e.lateFormat,
            valueColor: Colors.orange.shade700);
      },
    );
  }

  Widget _buildTopPresentCard(List<TopPresentEmployee> items) {
    return _buildRankCard(
      title: 'Top Present Employee',
      icon: Icons.emoji_events_outlined,
      iconColor: Colors.green,
      emptyText: 'No data in this period',
      itemCount: items.length,
      itemBuilder: (i) {
        final e = items[i];
        return _rankRow(
            rank: i + 1,
            name: e.name,
            value: '${e.totalPresent} days',
            valueColor: Colors.green.shade700);
      },
    );
  }

  Widget _buildRankCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String emptyText,
    required int itemCount,
    required Widget Function(int) itemBuilder,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600)),
            ]),
          ),
          const Divider(height: 1),
          itemCount == 0
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(emptyText,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade500, fontSize: 14)),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemCount,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 60, endIndent: 16),
                  itemBuilder: (_, i) => itemBuilder(i),
                ),
        ],
      ),
    );
  }

  Widget _rankRow({
    required int rank,
    required String name,
    required String value,
    required Color valueColor,
  }) {
    final isTop3 = rank <= 3;
    final badgeColors = [
      Colors.amber.shade700,
      Colors.grey.shade500,
      Colors.brown.shade400,
    ];
    final bgColor = isTop3
        ? badgeColors[rank - 1].withOpacity(0.12)
        : _themeColor.withOpacity(0.08);
    final textColor = isTop3 ? badgeColors[rank - 1] : _themeColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration:
                BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Center(
              child: Text('$rank',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Text(value,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: valueColor)),
        ],
      ),
    );
  }

  // ================================================================
  // STAFF DASHBOARD (tanpa shortcut menu)
  // ================================================================
  Widget _buildUserDashboard(HrDashboardController controller) {
    final staff = controller.dashboardData!.staff!;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: _themeColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PersonalizedHeader(),
            const SizedBox(height: 20),

            // TODAY STATUS
            _buildTodayStatusCard(staff.todayAttendance),
            const SizedBox(height: 16),

            // KPI CARDS
            _buildKpiRow(staff.monthlyStats, staff.leave, staff.overtime),
            const SizedBox(height: 20),

            // LATE CHART (14 DAYS)
            _buildStaffAttendanceChart(staff.charts.attendanceLate14Days),
            const SizedBox(height: 20),

            // PAYSLIP + RIWAYAT ABSENSI
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                final payslip = _buildPayslipPanel(staff.latestPayslip);
                final history =
                    _buildAttendanceHistoryTable(staff.recentAttendance);

                if (isWide) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 4, child: payslip),
                        const SizedBox(width: 16),
                        Expanded(flex: 6, child: history),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    payslip,
                    const SizedBox(height: 16),
                    history,
                  ],
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ---------------- TODAY STATUS ----------------
  Widget _buildTodayStatusCard(HrStaffTodayAttendance attendance) {
    final checkedIn = attendance.checkedIn;
    final checkedOut = attendance.checkedOut;

    String statusLabel;
    Color statusColor;
    if (!checkedIn) {
      statusLabel = 'Not Checked In';
      statusColor = Colors.grey;
    } else if (attendance.lateMinutes > 0) {
      statusLabel = 'Late';
      statusColor = Colors.orange;
    } else {
      statusLabel = 'Present';
      statusColor = Colors.green;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today Status',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 14),
          if (!checkedIn)
            Center(
              child: Column(
                children: [
                  Text("You haven't checked in today.",
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.attendance);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _themeColor,
                        foregroundColor: Colors.white),
                    child: const Text('Check In Now'),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child:
                      _todayStatusItem('Check In', attendance.checkInTime),
                ),
                Expanded(
                  child: _todayStatusItem(
                      'Check Out',
                      checkedOut ? attendance.checkOutTime : '-'),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(statusLabel,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: statusColor)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _todayStatusItem(
                      'Late',
                      attendance.lateMinutes > 0
                          ? '${attendance.lateMinutes} minute'
                          : '-'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _todayStatusItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value,
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
      ],
    );
  }

// ---------------- KPI CARDS ----------------
Widget _buildKpiRow(
  HrStaffMonthlyStats monthlyStats,
  HrStaffLeave leave,
  HrStaffOvertime overtime,
) {
  final items = [
    _KpiItem('Attendance Record for This Month',
        monthlyStats.presentDays.toString(), ''),
    _KpiItem('Leave Quota Remaining',
        leave.remaining.toStringAsFixed(1), 'days'),
    _KpiItem('Overtime for This Month', overtime.thisMonthDisplay, ''),
    _KpiItem('Total Late', monthlyStats.lateDays.toString(), 'days'),
  ];

  return Column(
    children: [
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _kpiCard(items[0])),
            const SizedBox(width: 10),
            Expanded(child: _kpiCard(items[1])),
          ],
        ),
      ),
      const SizedBox(height: 10),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _kpiCard(items[2])),
            const SizedBox(width: 10),
            Expanded(child: _kpiCard(items[3])),
          ],
        ),
      ),
    ],
  );
}

Widget _kpiCard(_KpiItem item) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(item.label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(item.value,
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            if (item.unit.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(item.unit,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey.shade600)),
            ],
          ],
        ),
      ],
    ),
  );
}

  // ---------------- LATE ATTENDANCE CHART (14 DAYS) ----------------
  Widget _buildStaffAttendanceChart(AttendanceLate14DaysChart chart) {
    return _buildWhiteCard(
      title: 'Late Attendance - 14 Days',
      icon: Icons.bar_chart_rounded,
      child: SizedBox(
        height: 200,
        child: chart.labels.isEmpty
            ? Center(
                child: Text(
                  'No data',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              )
            : BarChart(
                BarChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index < 0 || index >= chart.labels.length) {
                            return const SizedBox.shrink();
                          }

                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              chart.labels[index],
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    chart.labels.length,
                    (index) {
                      final value = chart.lateMinutes.length > index
                          ? chart.lateMinutes[index].toDouble()
                          : 0.0;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            color: Colors.orange.shade300,
                            width: 12,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  // ---------------- PAYSLIP PANEL ----------------
  Widget _buildPayslipPanel(HrStaffPayslip? payslip) {
    return _buildWhiteCard(
      title: 'Last PaySlip',
      icon: Icons.payments_outlined,
      child: payslip == null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('No payslip is available yet.',
                  style: GoogleFonts.poppins(color: Colors.grey.shade600)),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payslip.periodName,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Text(
                  NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                      .format(payslip.takeHomePay),
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: payslip.encryption == null ||
                            payslip.encryption!.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MyPaySlipDetailScreen(
                                  encryption: payslip.encryption!,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _themeColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Show PaySlip Detail'),
                  ),
                ),
              ],
            ),
    );
  }

  // ---------------- ATTENDANCE HISTORY TABLE ----------------
  Widget _buildAttendanceHistoryTable(List<HrRecentAttendance> items) {
    return _buildWhiteCard(
      title: 'Attendance History for the Last 7 Days',
      icon: Icons.table_rows_outlined,
      child: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('There is no attendance data yet.',
                    style: GoogleFonts.poppins(color: Colors.grey)),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(_themeColor.withOpacity(0.08)),
                columns: [
                  DataColumn(
                      label: Text('Date',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600))),
                  DataColumn(
                      label: Text('Check In',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600))),
                  DataColumn(
                      label: Text('Check Out',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600))),
                  DataColumn(
                      label: Text('Status',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600))),
                ],
                rows: items.map((row) {
                  return DataRow(cells: [
                    DataCell(Text(row.date,
                        style: GoogleFonts.poppins(fontSize: 12))),
                    DataCell(Text(row.checkIn,
                        style: GoogleFonts.poppins(fontSize: 12))),
                    DataCell(Text(row.checkOut,
                        style: GoogleFonts.poppins(fontSize: 12))),
                    DataCell(_statusBadge(row.status)),
                  ]);
                }).toList(),
              ),
            ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'present':
        color = Colors.green;
        break;
      case 'late':
        color = Colors.orange;
        break;
      case 'permission':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.isEmpty ? '-' : status[0].toUpperCase() + status.substring(1),
        style: GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  // ---------------- SHARED WHITE CARD ----------------
Widget _buildWhiteCard({
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
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
              color: _themeColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Expanded(                                  // ⬅️ TAMBAH INI
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,                            // ⬅️ TAMBAH INI
                overflow: TextOverflow.ellipsis,         // ⬅️ TAMBAH INI
              ),
            ),                                          // ⬅️ TUTUP Expanded
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}
}

class _KpiItem {
  final String label;
  final String value;
  final String unit;
  _KpiItem(this.label, this.value, this.unit);
}

class _DonutChartPainter extends CustomPainter {
  final int checkedIn;
  final int notCheckedIn;
  final int onLeave;
  final int checkedOut;

  _DonutChartPainter({
    required this.checkedIn,
    required this.notCheckedIn,
    required this.onLeave,
    required this.checkedOut,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = checkedIn + notCheckedIn + onLeave + checkedOut;
    if (total == 0) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18
        ..color = Colors.grey.shade200;
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), size.width * 0.4, paint);
      return;
    }

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final strokeWidth = size.width * 0.18;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const gap = 0.02;
    double startAngle = -1.5707963;

    final segments = [
      MapEntry(checkedIn, Colors.green),
      MapEntry(notCheckedIn, Colors.red),
      MapEntry(onLeave, Colors.orange),
      MapEntry(checkedOut, Colors.blue),
    ];

    for (final seg in segments) {
      if (seg.key == 0) continue;
      final sweep = (seg.key / total) * 2 * 3.14159265 - gap;
      paint.color = seg.value;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + gap / 2,
        sweep,
        false,
        paint,
      );
      startAngle += seg.key / total * 2 * 3.14159265;
    }
  }

  @override
  bool shouldRepaint(_DonutChartPainter old) =>
      old.checkedIn != checkedIn ||
      old.notCheckedIn != notCheckedIn ||
      old.onLeave != onLeave ||
      old.checkedOut != checkedOut;
}