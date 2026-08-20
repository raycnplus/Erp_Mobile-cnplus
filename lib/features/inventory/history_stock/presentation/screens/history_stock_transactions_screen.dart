import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/controllers/history_stock_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class HistoryStockTransactionsScreen extends StatefulWidget {
  const HistoryStockTransactionsScreen({super.key});

  @override
  State<HistoryStockTransactionsScreen> createState() => _HistoryStockTransactionsScreenState();
}

class _HistoryStockTransactionsScreenState extends State<HistoryStockTransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryStockController>().fetchTransactions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    context.read<HistoryStockController>().resetTransactionsState();
    super.dispose();
  }

  void _onSearchChanged(String v) => context.read<HistoryStockController>().searchTransactions(v);

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
          "Transaction List",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 18),
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
                hintText: 'Search product, warehouse, location...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
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
          Expanded(
            child: Consumer<HistoryStockController>(
              builder: (context, ctrl, child) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.txCurrentPage,
                  lastPage: ctrl.txLastPage,
                  hasPrev: ctrl.txHasPrevPage,
                  hasNext: ctrl.txHasNextPage,
                  onGoToPage: ctrl.txGoToPage,
                  onPrev: ctrl.txPrevPage,
                  onNext: ctrl.txNextPage,
                );

                if (ctrl.isLoadingTransactions) {
                  return const Center(child: CircularProgressIndicator(color: colorPrimary));
                }
                if (ctrl.transactionsError != null && ctrl.transactions.isEmpty) {
                  return Center(child: Text(ctrl.transactionsError!, style: GoogleFonts.poppins(color: colorError)));
                }
                if (ctrl.transactions.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('No transactions found', style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 14)),
                        ),
                      ),
                      bar,
                    ],
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('${ctrl.txTotal} transactions', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        itemCount: ctrl.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = ctrl.transactions[index];
                          final isIn = tx.movementType == 'in';
                          final color = isIn ? Colors.green : Colors.red;
                          return Card(
                            color: colorCard,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: colorGreyLight, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isIn ? 'IN' : 'OUT',
                                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          tx.reference,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.roboto(fontSize: 11, color: colorTextSubtle),
                                        ),
                                      ),
                                      Text(tx.movementDate, style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tx.productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: colorTextPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${tx.warehouseName} • ${tx.locationName}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                                        ),
                                      ),
                                      Text(
                                        '${isIn ? '+' : '-'}${formatQty(tx.qty)}',
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: color),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
}