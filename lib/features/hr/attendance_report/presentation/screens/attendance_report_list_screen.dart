import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/models/attendance_report_models.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_report/presentation/controllers/attendance_report_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_report/presentation/widgets/attendance_report_list_item.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_report/presentation/widgets/attendance_report_filter_sheet.dart';

class AttendanceReportListScreen
    extends StatefulWidget {
  const AttendanceReportListScreen({
    super.key,
  });

  @override
  State<AttendanceReportListScreen>
      createState() =>
          _AttendanceReportListScreenState();
}

class _AttendanceReportListScreenState
    extends State<
        AttendanceReportListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      final ctrl =
          context.read<
              AttendanceReportController>();

      ctrl.fetchFormOptions();

      // Tidak fetchList otomatis.
      // User wajib pilih date range.
    });
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _handleRefresh() {
    return context
        .read<
            AttendanceReportController>()
        .fetchList();
  }

  // ============================================================
  // FILTER
  // ============================================================

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          colorCard,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top:
              Radius.circular(
            16,
          ),
        ),
      ),
      builder: (_) =>
          ChangeNotifierProvider.value(
        value: context.read<
            AttendanceReportController>(),
        child:
            const AttendanceReportFilterSheet(),
      ),
    );
  }

  // ============================================================
  // SUMMARY STATUS
  // ============================================================

  Widget _buildStatusSummary(
    AttendanceReportSummary summary,
  ) {
    final statuses =
        summary.byStatus.entries.toList();

    if (statuses.isEmpty) {
      return const SizedBox
          .shrink();
    }

    return Container(
      width:
          double.infinity,
      margin:
          const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        0,
      ),
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color: colorPrimary
            .withOpacity(
          0.08,
        ),
        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Summary',
            style:
                GoogleFonts.poppins(
              fontSize: 12,
              color:
                  colorTextSubtle,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                statuses.map(
              (entry) {
                return Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
decoration: BoxDecoration(
  color: colorWhite,
  borderRadius: BorderRadius.circular(8),
  border: Border.all(
    color: colorGreyLight,
    width: 1,
  ),
),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style:
                        GoogleFonts.poppins(
                      fontSize:
                          11,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          colorTextPrimary,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          colorBackground,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        leading:
            IconButton(
          icon:
              const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () =>
              Navigator.of(context)
                  .pop(),
        ),
        title: Text(
          'Attendance Report',
          style:
              GoogleFonts.poppins(
            fontWeight:
                FontWeight.w600,
            color:
                colorTextPrimary,
            fontSize: 20,
          ),
        ),
        elevation: 0.5,
        backgroundColor:
            colorWhite,
        foregroundColor:
            colorTextPrimary,
        actions: [
          Consumer<
              AttendanceReportController>(
            builder: (
              context,
              ctrl,
              child,
            ) {
              return Stack(
                children: [
                  IconButton(
                    icon:
                        const Icon(
                      Icons.filter_list,
                    ),
                    onPressed:
                        _openFilterSheet,
                  ),
                  if (ctrl
                      .hasActiveFilter)
                    Positioned(
                      right:
                          10,
                      top:
                          10,
                      child:
                          Container(
                        width: 8,
                        height: 8,
                        decoration:
                            const BoxDecoration(
                          color:
                              colorPrimary,
                          shape:
                              BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: Consumer<
          AttendanceReportController>(
        builder: (
          context,
          ctrl,
          child,
        ) {
          if (!ctrl
              .hasFetchedOnce) {
            return _buildInitialPromptState();
          }

          if (ctrl
              .isLoadingList) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    colorPrimary,
              ),
            );
          }

          if (ctrl
                      .listError !=
                  null &&
              ctrl.list.isEmpty) {
            return _buildErrorState(
              ctrl.listError!,
              _handleRefresh,
            );
          }

          return Column(
            children: [
              if (ctrl.summary != null)
                _buildStatusSummary(
                  ctrl.summary!,
                ),

              Expanded(
                child:
                    ctrl.list.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh:
                                _handleRefresh,
                            color:
                                colorPrimary,
                            child:
                                ListView
                                    .builder(
                              padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                16,
                                12,
                                16,
                                16,
                              ),
                              itemCount:
                                  ctrl
                                      .list
                                      .length,
                              itemBuilder:
                                  (
                                context,
                                index,
                              ) =>
                                      AttendanceReportListItem(
                                item:
                                    ctrl.list[
                                        index],
                              ),
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // INITIAL
  // ============================================================

  Widget _buildInitialPromptState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'Search or select a filter\nto display data',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight:
                    FontWeight.w500,
                color: colorTextSubtle,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed:
                  _openFilterSheet,
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color: colorPrimary,
              ),
              label: Text(
                'Open Filter',
                style:
                    GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w600,
                  color: colorPrimary,
                ),
              ),
              style:
                  OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: colorPrimary,
                ),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState(
    String error,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color:
                  colorError,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              error,
              style:
                  GoogleFonts.poppins(
                color:
                    colorError,
              ),
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed:
                  onRetry,
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    colorPrimary,
                foregroundColor:
                    colorWhite,
              ),
              child:
                  const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            const Icon(
              Icons
                  .event_busy_outlined,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'No attendance data found',
              style:
                  GoogleFonts.poppins(
                fontSize:
                    18,
                fontWeight:
                    FontWeight.w500,
                color:
                    colorTextSubtle,
              ),
              textAlign:
                  TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}