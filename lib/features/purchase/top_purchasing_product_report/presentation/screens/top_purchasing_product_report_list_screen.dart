import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/presentation/controllers/top_purchasing_product_report_controller.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/presentation/widgets/top_purchasing_product_report_list_item.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/presentation/widgets/top_purchasing_product_report_filter_sheet.dart';

import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class TopPurchasingProductReportListScreen
    extends StatefulWidget {
  const TopPurchasingProductReportListScreen({
    super.key,
  });

  @override
  State<TopPurchasingProductReportListScreen>
      createState() =>
          _TopPurchasingProductReportListScreenState();
}

class _TopPurchasingProductReportListScreenState
    extends State<
        TopPurchasingProductReportListScreen> {
  final TextEditingController
      _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      final ctrl =
          context.read<
              TopPurchasingProductReportController>();

      ctrl.fetchFormOptions();

      // Tidak fetch list otomatis.
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _onSearchChanged(
    String value,
  ) {
    context
        .read<
            TopPurchasingProductReportController>()
        .searchList(value);
  }

  void _clearSearch() {
    _searchController.clear();

    context
        .read<
            TopPurchasingProductReportController>()
        .clearSearch();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _handleRefresh() {
    return context
        .read<
            TopPurchasingProductReportController>()
        .fetchList();
  }

  // ============================================================
  // FILTER
  // ============================================================

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) =>
          ChangeNotifierProvider.value(
        value: context.read<
            TopPurchasingProductReportController>(),
        child:
            const TopPurchasingProductReportFilterSheet(),
      ),
    );
  }

  // ============================================================
  // FORMAT NUMBER
  // ============================================================

  String _formatNumber(
    String rawValue,
  ) {
    final parts =
        rawValue.split('.');

    final wholePart =
        parts[0];

    final decimalPart =
        parts.length > 1
            ? parts[1]
            : '';

    final buffer =
        StringBuffer();

    for (
      int i = 0;
      i < wholePart.length;
      i++
    ) {
      if (i > 0 &&
          (wholePart.length - i) %
                  3 ==
              0) {
        buffer.write('.');
      }

      buffer.write(
        wholePart[i],
      );
    }

    if (decimalPart.isEmpty) {
      return buffer.toString();
    }

    return '$buffer,$decimalPart';
  }

  String _formatRupiah(
    String rawValue,
  ) =>
      'Rp ${_formatNumber(rawValue)}';

  // ============================================================
  // BUILD
  // ============================================================

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
          'Top Purchasing Product',
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
              TopPurchasingProductReportController>(
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
                      right: 10,
                      top: 10,
                      child:
                          Container(
                        width: 8,
                        height: 8,
                        decoration:
                            const BoxDecoration(
                          color:
                              colorPrimary,
                          shape:
                              BoxShape
                                  .circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // ======================================================
          // SEARCH
          // ======================================================

          Container(
            color:
                colorCard,
            padding:
                const EdgeInsets
                    .fromLTRB(
              16,
              8,
              16,
              12,
            ),
            child:
                TextField(
              controller:
                  _searchController,
              onChanged:
                  _onSearchChanged,
              style:
                  GoogleFonts.poppins(
                fontSize:
                    14,
                color:
                    colorTextPrimary,
              ),
              decoration:
                  InputDecoration(
                hintText:
                    'Search product, vendor...',
                hintStyle:
                    GoogleFonts.poppins(
                  fontSize:
                      13,
                  color:
                      colorGrey,
                ),
                prefixIcon:
                    const Icon(
                  Icons.search,
                  color:
                      colorGrey,
                  size: 20,
                ),
                suffixIcon:
                    _searchController
                            .text
                            .isNotEmpty
                        ? IconButton(
                            icon:
                                const Icon(
                              Icons.close,
                              color:
                                  colorGrey,
                              size:
                                  18,
                            ),
                            onPressed:
                                _clearSearch,
                          )
                        : null,
                filled:
                    true,
                fillColor:
                    colorBackground,
                contentPadding:
                    const EdgeInsets
                        .symmetric(
                  horizontal:
                      16,
                  vertical:
                      10,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                  borderSide:
                      BorderSide.none,
                ),
                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                  borderSide:
                      const BorderSide(
                    color:
                        colorGreyLight,
                    width: 1,
                  ),
                ),
                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                  borderSide:
                      const BorderSide(
                    color:
                        colorPrimary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // ======================================================
          // LIST
          // ======================================================

          Expanded(
            child: Consumer<
                TopPurchasingProductReportController>(
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

                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal:
                            16,
                        vertical:
                            8,
                      ),
                      child:
                          Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} products',
                            style:
                                GoogleFonts
                                    .poppins(
                              fontSize:
                                  12,
                              color:
                                  colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Page ${ctrl.currentPage} of ${ctrl.lastPage}',
                            style:
                                GoogleFonts
                                    .poppins(
                              fontSize:
                                  12,
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
                            ListView
                                .builder(
                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            16,
                            0,
                            16,
                            8,
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
                                  TopPurchasingProductReportListItem(
                            item: ctrl
                                .list[index],
                          ),
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
  // INITIAL
  // ============================================================

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
            const Icon(
              Icons.search,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(
              height: 16,
            ),
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
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color:
                    colorPrimary,
              ),
              label: Text(
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
                  OutlinedButton
                      .styleFrom(
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
              color: colorError,
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
                  .inventory_2_outlined,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'No purchasing product data found',
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