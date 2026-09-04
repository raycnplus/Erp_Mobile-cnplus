import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/presentation/controllers/leave_report_controller.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/presentation/widgets/leave_report_list_item.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/presentation/widgets/leave_report_filter_sheet.dart';

class LeaveReportListScreen
    extends StatefulWidget {
  const LeaveReportListScreen({
    super.key,
  });

  @override
  State<LeaveReportListScreen>
      createState() =>
          _LeaveReportListScreenState();
}

class _LeaveReportListScreenState
    extends State<LeaveReportListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<LeaveReportController>()
          .fetchFormOptions();

      // Tidak auto fetch list.
      // User wajib pilih date range terlebih dahulu.
    });
  }

  Future<void> _handleRefresh() {
    return context
        .read<LeaveReportController>()
        .fetchList();
  }

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
              Radius.circular(16),
        ),
      ),
      builder: (_) =>
          ChangeNotifierProvider.value(
        value: context.read<
            LeaveReportController>(),
        child:
            const LeaveReportFilterSheet(),
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
          'Leave Report',
          style:
              GoogleFonts.poppins(
            fontWeight:
                FontWeight.w600,
            color:
                colorTextPrimary,
            fontSize: 20,
          ),
        ),
        elevation:
            0.5,
        backgroundColor:
            colorWhite,
        foregroundColor:
            colorTextPrimary,
        actions: [
          Consumer<
              LeaveReportController>(
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
          LeaveReportController>(
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
                Container(
                  width:
                      double.infinity,
                  margin:
                      const EdgeInsets
                          .fromLTRB(
                    16,
                    12,
                    16,
                    0,
                  ),
                  padding:
                      const EdgeInsets
                          .all(14),
                  decoration:
                      BoxDecoration(
                    color: colorPrimary
                        .withOpacity(
                      0.08,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      12,
                    ),
                  ),
                  child:
                      Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          _summaryItem(
                            'Total Records',
                            ctrl
                                .summary!
                                .totalRecords
                                .toString(),
                          ),
                          _summaryItem(
                            'Total Request',
                            ctrl
                                .summary!
                                .grandTotalRequest
                                .toString(),
                          ),
                          _summaryItem(
                            'Total Days',
                            _formatDays(
                              ctrl
                                  .summary!
                                  .grandTotalDays,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                                      LeaveReportListItem(
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

  Widget _summaryItem(
    String title,
    String value,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            textAlign:
                TextAlign.center,
            style:
                GoogleFonts.poppins(
              fontSize:
                  10,
              color:
                  colorTextSubtle,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            value,
            textAlign:
                TextAlign.center,
            style:
                GoogleFonts.poppins(
              fontSize:
                  15,
              fontWeight:
                  FontWeight.w700,
              color:
                  colorTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDays(
    double value,
  ) {
    if (value ==
        value.truncateToDouble()) {
      return value
          .toInt()
          .toString();
    }

    return value
        .toStringAsFixed(2);
  }

  Widget _buildInitialPromptState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal:
              32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            const Icon(Icons.search, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'Search or select a filter\nto display data',
              textAlign:
                  TextAlign.center,
              style:
                  GoogleFonts.poppins(
                fontSize:
                    15,
                fontWeight:
                    FontWeight.w500,
                color:
                    colorTextSubtle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
              onPressed:
                  _openFilterSheet,
              icon:
                  const Icon(
                Icons.filter_list,
                size: 18,
                color:
                    colorPrimary,
              ),
              label:
                  Text(
                'Open Filter',
                style:
                    GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w600,
                  color:
                      colorPrimary,
                ),
              ),
              style:
                  OutlinedButton.styleFrom(
                side:
                    const BorderSide(
                  color:
                      colorPrimary,
                ),
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal:
                      20,
                  vertical:
                      12,
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

  Widget _buildErrorState(
    String error,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal:
              32,
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
              height:
                  16,
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
              height:
                  16,
            ),
            ElevatedButton(
              onPressed:
                  onRetry,
              style:
                  ElevatedButton.styleFrom(
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal:
              32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [
            const Icon(
              Icons.event_busy_outlined,
              size: 80,
              color:
                  colorGrey,
            ),
            const SizedBox(
              height:
                  16,
            ),
            Text(
              'No leave data found',
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