import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/presentation/controllers/top_customer_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/presentation/widgets/top_customer_report_list_item.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/presentation/widgets/top_customer_report_filter_sheet.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class TopCustomerReportListScreen extends StatefulWidget {
  const TopCustomerReportListScreen({super.key});

  @override
  State<TopCustomerReportListScreen> createState() => _TopCustomerReportListScreenState();
}

class _TopCustomerReportListScreenState extends State<TopCustomerReportListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<TopCustomerReportController>();
      ctrl.fetchFormOptions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) => context.read<TopCustomerReportController>().searchList(v);

  void _clearSearch() {
    _searchController.clear();
    context.read<TopCustomerReportController>().clearSearch();
  }

  Future<void> _handleRefresh() => context.read<TopCustomerReportController>().fetchList();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TopCustomerReportController>(),
        child: const TopCustomerReportFilterSheet(),
      ),
    );
  }

  String _formatRupiah(String rawValue) {
    final parts = rawValue.split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';
    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 && (wholePart.length - i) % 3 == 0) buffer.write('.');
      buffer.write(wholePart[i]);
    }
    if (decimalPart.isEmpty) return 'Rp $buffer';
    return 'Rp $buffer,$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Top Customer Report",
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
          Consumer<TopCustomerReportController>(
            builder: (context, ctrl, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _openFilterSheet,
                  ),
                  if (ctrl.hasActiveFilter)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
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
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
              decoration: InputDecoration(
                hintText: 'Search customer, warehouse, location...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: colorGrey, size: 18),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: colorBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorGreyLight, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          Consumer<TopCustomerReportController>(
            builder: (context, ctrl, child) {
              final summary = ctrl.summary;
              if (summary == null) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Amount', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                        const SizedBox(height: 2),
                        Text(
                          _formatRupiah(summary.totalAmountRaw),
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: colorPrimary),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Transactions', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                        const SizedBox(height: 2),
                        Text(
                          '${summary.totalTransaction}',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<TopCustomerReportController>(
              builder: (context, ctrl, child) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage,
                  lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrevPage,
                  hasNext: ctrl.hasNextPage,
                  onGoToPage: ctrl.goToPage,
                  onPrev: ctrl.prevPage,
                  onNext: ctrl.nextPage,
                );

                // ========================================================
                // BELUM APPLY FILTER
                // ========================================================

                if (!ctrl.hasFetchedOnce) {
                  return _buildInitialPromptState();
                }

                // ========================================================
                // LOADING
                // ========================================================

                if (ctrl.isLoadingList) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: colorPrimary,
                    ),
                  );
                }

                // ========================================================
                // ERROR
                // ========================================================

                if (ctrl.listError != null &&
                    ctrl.list.isEmpty) {
                  return _buildErrorState(
                    ctrl.listError!,
                    _handleRefresh,
                  );
                }

                // ========================================================
                // EMPTY
                // ========================================================

                if (ctrl.list.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: _buildEmptyState(),
                      ),
                      bar,
                    ],
                  );
                }

                // ========================================================
                // DATA
                // ========================================================

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} customers',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Page ${ctrl.currentPage} of ${ctrl.lastPage}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            8,
                          ),
                          itemCount: ctrl.list.length,
                          itemBuilder: (context, index) {
                            final rank =
                                (ctrl.currentPage - 1) * 15 +
                                    index +
                                    1;

                            return TopCustomerReportListItem(
                              item: ctrl.list[index],
                              rank: rank,
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

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(error, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInitialPromptState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                fontWeight: FontWeight.w500,
                color: colorTextSubtle,
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: _openFilterSheet,
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color: colorPrimary,
              ),
              label: Text(
                'Open Filter',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: colorPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: colorPrimary,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_outlined, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'No customer data found',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}