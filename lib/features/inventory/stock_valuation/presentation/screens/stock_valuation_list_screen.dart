import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/controllers/stock_valuation_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/widgets/stock_valuation_list_item.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/screens/stock_valuation_detail_screen.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';

class StockValuationListScreen extends StatefulWidget {
  const StockValuationListScreen({super.key});

  @override
  State<StockValuationListScreen> createState() =>
      _StockValuationListScreenState();
}

class _StockValuationListScreenState extends State<StockValuationListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<StockValuationController>();
      ctrl.fetchCostingMethods();
      ctrl.fetchList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) =>
      context.read<StockValuationController>().searchList(v);

  void _clearSearch() {
    _searchController.clear();
    context.read<StockValuationController>().clearSearch();
  }

  Future<void> _handleRefresh() =>
      context.read<StockValuationController>().fetchList();

  void _navigateToDetail(int idProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StockValuationDetailScreen(idProduct: idProduct),
      ),
    );
  }

  String _formatRupiah(double value) {
    final rounded = value.round();
    final str = rounded.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
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
          "Stock Valuation",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
            fontSize: 20,
          ),
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
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: colorTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search product name or code...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: colorGrey,
                    ),
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
                      borderSide: const BorderSide(
                        color: colorGreyLight,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: colorPrimary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<StockValuationController>(
                  builder: (context, ctrl, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String?>(
                        value: ctrl.selectedCostingMethod,
                        isExpanded: true,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: colorTextPrimary,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Costing method',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorTextSubtle,
                          ),
                          filled: true,
                          fillColor: colorBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: colorGreyLight,
                              width: 1,
                            ),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All Methods'),
                          ),
                          ...ctrl.costingMethods.map(
                            (m) => DropdownMenuItem<String?>(
                              value: m,
                              child: Text(humanizeEnum(m)),
                            ),
                          ),
                        ],
                        onChanged: (val) => ctrl.filterByCostingMethod(val),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer<StockValuationController>(
            builder: (context, ctrl, child) {
              final summary = ctrl.summary;
              if (summary == null) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                        Text(
                          'Grand Total Value',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorTextSubtle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatRupiah(summary.grandTotalValue),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<StockValuationController>(
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
                if (ctrl.listError != null && ctrl.list.isEmpty) {
                  return _buildErrorState(ctrl.listError!, _handleRefresh);
                }
                if (ctrl.list.isEmpty) {
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
                          itemCount: ctrl.list.length,
                          itemBuilder: (context, index) {
                            final item = ctrl.list[index];
                            return StockValuationListItem(
                              item: item,
                              onTap: () => _navigateToDetail(item.idProduct),
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
              isSearching ? Icons.search_off : Icons.assessment_outlined,
              size: 80,
              color: colorGrey,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'Product not found' : 'No valuation data yet',
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
