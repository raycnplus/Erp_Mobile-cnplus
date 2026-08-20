import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/controllers/history_stock_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/widgets/history_stock_list_item.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/widgets/history_stock_filter_sheet.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/screens/history_stock_transactions_screen.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class HistoryStockListScreen extends StatefulWidget {
  const HistoryStockListScreen({super.key});

  @override
  State<HistoryStockListScreen> createState() => _HistoryStockListScreenState();
}

class _HistoryStockListScreenState extends State<HistoryStockListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctrl = context.read<HistoryStockController>();
      await ctrl.fetchFormOptions();
      ctrl.fetchList();
    });
  }

  Future<void> _handleRefresh() =>
      context.read<HistoryStockController>().fetchList();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<HistoryStockController>(),
        child: const HistoryStockFilterSheet(),
      ),
    );
  }

  void _navigateToTransactions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<HistoryStockController>(),
          child: const HistoryStockTransactionsScreen(),
        ),
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
        title: Text(
          "Stock History",
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
          Consumer<HistoryStockController>(
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
      body: Consumer<HistoryStockController>(
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

          return Column(
            children: [
              if (ctrl.summary != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          'Total In',
                          '+${formatQty(ctrl.summary!.totalIn)}',
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          'Total Out',
                          '-${formatQty(ctrl.summary!.totalOut)}',
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              if (ctrl.summary != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          'Net Movement',
                          formatQty(ctrl.summary!.netMovement),
                          colorPrimary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: _navigateToTransactions,
                          borderRadius: BorderRadius.circular(12),
                          child: _summaryCard(
                            'Transactions',
                            '${ctrl.summary!.totalRows}',
                            colorTextPrimary,
                            tappable: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Builder(
                  builder: (context) {
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
                          Expanded(child: _buildEmptyState()),
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
                                '${ctrl.total} records',
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
                              itemBuilder: (context, index) =>
                                  HistoryStockListItem(item: ctrl.list[index]),
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
          );
        },
      ),
    );
  }

  Widget _summaryCard(
    String label,
    String value,
    Color color, {
    bool tappable = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorGreyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: colorTextSubtle,
                  ),
                ),
              ),
              if (tappable)
                const Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: colorTextSubtle,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'No stock history for this date',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
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
