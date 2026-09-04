import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/sales/pph_report/presentation/controllers/pph_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/pph_report/presentation/widgets/pph_report_list_item.dart';

import 'package:erp_mobile_cnplus/features/sales/pph_report/presentation/widgets/pph_report_filter_sheet.dart';

import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class PPHReportListScreen extends StatefulWidget {
  const PPHReportListScreen({super.key});

  @override
  State<PPHReportListScreen> createState() =>
      _PPHReportListScreenState();
}

class _PPHReportListScreenState
    extends State<PPHReportListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Tidak fetchFormOptions()
      // Tidak fetchList()
      //
      // User wajib melakukan search atau Apply Filter
      // terlebih dahulu untuk menampilkan data.
    });
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _handleRefresh() {
    return context
        .read<PPHReportController>()
        .fetchList();
  }

  // ============================================================
  // FILTER SHEET
  // ============================================================

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<PPHReportController>(),
        child: const PPHReportFilterSheet(),
      ),
    );
  }

  // ============================================================
  // FORMAT RUPIAH
  // ============================================================

  String _formatRupiah(String rawValue) {
    final parts = rawValue.split('.');

    final wholePart = parts[0];

    final decimalPart =
        parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();

    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 &&
          (wholePart.length - i) % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(wholePart[i]);
    }

    if (decimalPart.isEmpty) {
      return 'Rp $buffer';
    }

    return 'Rp $buffer,$decimalPart';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () =>
              Navigator.of(context).pop(),
        ),
        title: Text(
          'PPH Report',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
            fontSize: 20,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<PPHReportController>(
            builder: (
              context,
              ctrl,
              child,
            ) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                    ),
                    onPressed:
                        _openFilterSheet,
                  ),

                  if (ctrl.hasActiveFilter)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration:
                            const BoxDecoration(
                          color: colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // ======================================================
          // CONTENT
          // ======================================================

          Expanded(
            child: Consumer<PPHReportController>(
              builder: (
                context,
                ctrl,
                child,
              ) {
                final bar =
                    PaginationBottomBar(
                  currentPage:
                      ctrl.currentPage,
                  lastPage:
                      ctrl.lastPage,
                  hasPrev:
                      ctrl.hasPrevPage,
                  hasNext:
                      ctrl.hasNextPage,
                  onGoToPage:
                      ctrl.goToPage,
                  onPrev:
                      ctrl.prevPage,
                  onNext:
                      ctrl.nextPage,
                );

                // =================================================
                // INITIAL STATE
                // =================================================

                if (!ctrl.hasFetchedOnce) {
                  return _buildInitialPromptState();
                }

                // =================================================
                // LOADING
                // =================================================

                if (ctrl.isLoadingList) {
                  return const Center(
                    child:
                        CircularProgressIndicator(
                      color: colorPrimary,
                    ),
                  );
                }

                // =================================================
                // ERROR
                // =================================================

                if (ctrl.listError != null &&
                    ctrl.list.isEmpty) {
                  return _buildErrorState(
                    ctrl.listError!,
                    _handleRefresh,
                  );
                }

                // =================================================
                // EMPTY
                // =================================================

                if (ctrl.list.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child:
                            _buildEmptyState(),
                      ),
                      bar,
                    ],
                  );
                }

                // =================================================
                // DATA
                // =================================================

                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} records',
                            style:
                                GoogleFonts.poppins(
                              fontSize: 12,
                              color:
                                  colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Page ${ctrl.currentPage} of ${ctrl.lastPage}',
                            style:
                                GoogleFonts.poppins(
                              fontSize: 12,
                              color:
                                  colorTextSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child:
                          RefreshIndicator(
                        onRefresh:
                            _handleRefresh,
                        color:
                            colorPrimary,
                        child:
                            ListView.builder(
                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            16,
                            0,
                            16,
                            8,
                          ),
                          itemCount:
                              ctrl.list.length,
                          itemBuilder:
                              (
                            context,
                            index,
                          ) {
                            return PPHReportListItem(
                              item: ctrl.list[index],
                            );
                          },
                        ),
                      ),
                    ),

                    bar,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INITIAL PROMPT
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
              'Pilih filter\n'
              'untuk menampilkan data',
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
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(
    String error,
    VoidCallback onRetry,
  ) {
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
              Icons.error_outline,
              size: 64,
              color: colorError,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: GoogleFonts.poppins(
                color: colorError,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    colorPrimary,
                foregroundColor:
                    colorWhite,
              ),
              child:
                  const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
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
              Icons.receipt_long_outlined,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'No PPH data found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight:
                    FontWeight.w500,
                color: colorTextSubtle,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}