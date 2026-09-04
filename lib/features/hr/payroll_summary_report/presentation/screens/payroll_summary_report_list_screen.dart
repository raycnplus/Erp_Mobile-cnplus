import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/presentation/controllers/payroll_summary_report_controller.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/presentation/widgets/payroll_summary_report_filter_sheet.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/presentation/widgets/payroll_summary_report_list_item.dart';

class PayrollSummaryReportListScreen
    extends StatefulWidget {
  const PayrollSummaryReportListScreen({
    super.key,
  });

  @override
  State<PayrollSummaryReportListScreen>
      createState() =>
          _PayrollSummaryReportListScreenState();
}

class _PayrollSummaryReportListScreenState
    extends State<
        PayrollSummaryReportListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<
              PayrollSummaryReportController>()
          .fetchFormOptions();

      // Tidak auto fetch list.
    });
  }

  Future<void> _handleRefresh() {
    return context
        .read<
            PayrollSummaryReportController>()
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
            PayrollSummaryReportController>(),
        child:
            const PayrollSummaryReportFilterSheet(),
      ),
    );
  }

  String _formatRupiahString(
    String value,
  ) {
    final clean =
        value.replaceAll('.', '');

    if (clean.isEmpty) {
      return 'Rp 0';
    }

    final buffer =
        StringBuffer();

    for (int i = 0;
        i < clean.length;
        i++) {
      if (i > 0 &&
          (clean.length - i) % 3 ==
              0) {
        buffer.write('.');
      }

      buffer.write(clean[i]);
    }

    return 'Rp $buffer';
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
          'Payroll Summary Report',
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
              PayrollSummaryReportController>(
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
          PayrollSummaryReportController>(
        builder: (
          context,
          ctrl,
          child,
        ) {
          // ======================================================
          // INITIAL
          // ======================================================

          if (!ctrl
              .hasFetchedOnce) {
            return _buildInitialPromptState();
          }

          // ======================================================
          // LOADING
          // ======================================================

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

          // ======================================================
          // ERROR
          // ======================================================

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
              // ==================================================
              // SUMMARY
              // ==================================================

              if (ctrl.summary != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    0,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorPrimary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payroll Summary',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colorTextSubtle,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          _summaryItem(
                            'Basic',
                            _formatRupiahString(
                              ctrl.summary!.totalBasic,
                            ),
                          ),
                          _summaryItem(
                            'Allowance',
                            _formatRupiahString(
                              ctrl.summary!.totalAllowance,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          _summaryItem(
                            'Overtime',
                            _formatRupiahString(
                              ctrl.summary!.totalOvertime,
                            ),
                          ),
                          _summaryItem(
                            'Deductions',
                            _formatRupiahString(
                              ctrl.summary!.totalDeductions,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          _summaryItem(
                            'Allowance + Overtime',
                            _formatRupiahString(
                              ctrl.summary!.totalAllowanceOvertime,
                            ),
                          ),
                          _summaryItem(
                            'Net Salary',
                            _formatRupiahString(
                              ctrl.summary!.totalNet,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                            // ==================================================
                            // LIST
                            // ==================================================

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
                                                    PayrollSummaryReportListItem(
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              GoogleFonts.poppins(
                            fontSize: 10,
                            color:
                                colorTextSubtle,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          value,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              GoogleFonts.poppins(
                            fontSize: 13,
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

                Widget _buildInitialPromptState() {
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
                          const Icon(Icons.search, size: 80, color: colorGrey),
                          const SizedBox(height: 16),
                          Text(
                            'Select payroll period\nto display data',
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
                            textAlign:
                                TextAlign.center,
                            style:
                                GoogleFonts.poppins(
                              color:
                                  colorError,
                            ),
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
                                .receipt_long_outlined,
                            size: 80,
                            color:
                                colorGrey,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'No payroll data found',
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