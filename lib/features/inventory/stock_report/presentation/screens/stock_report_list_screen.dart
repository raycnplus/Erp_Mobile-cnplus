import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/presentation/controllers/stock_report_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/presentation/widgets/stock_report_list_item.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/presentation/screens/stock_report_detail_screen.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class StockReportListScreen extends StatefulWidget {
  const StockReportListScreen({super.key});

  @override
  State<StockReportListScreen> createState() => _StockReportListScreenState();
}

class _StockReportListScreenState extends State<StockReportListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockReportController>().fetchReportList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) =>
      context.read<StockReportController>().searchReports(v);

  void _clearSearch() {
    _searchController.clear();
    context.read<StockReportController>().clearSearch();
  }

  Future<void> _handleRefresh() =>
      context.read<StockReportController>().fetchReportList();

  void _navigateToDetail(int idProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StockReportDetailScreen(idProduct: idProduct),
      ),
    );
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Stock Reports",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Stock levels & movement per product',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
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
                hintText: 'Search product name or code...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: colorGrey,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: colorGrey,
                          size: 18,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: colorBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
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
          Expanded(
            child: Consumer<StockReportController>(
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

                if (ctrl.isLoadingList) {
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }
                if (ctrl.listError != null && ctrl.reportList.isEmpty) {
                  return _buildErrorState(ctrl.listError!, _handleRefresh);
                }
                if (ctrl.reportList.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: _buildEmptyState(
                          isSearching: _searchController.text.isNotEmpty,
                          onClearSearch: _clearSearch,
                        ),
                      ),
                      bar,
                    ],
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} products',
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.reportList.length,
                          itemBuilder: (context, index) {
                            final report = ctrl.reportList[index];
                            return StockReportListItem(
                              report: report,
                              onTap: () => _navigateToDetail(report.idProduct),
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
            Text(
              error,
              style: GoogleFonts.poppins(color: colorError),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    bool isSearching = false,
    VoidCallback? onClearSearch,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.inventory_2_outlined,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'Product not found' : 'No stock data yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colorTextSubtle,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(Icons.close, size: 16, color: colorPrimary),
                label: Text(
                  'Clear search',
                  style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
