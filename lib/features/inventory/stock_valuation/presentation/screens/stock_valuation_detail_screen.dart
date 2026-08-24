import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/controllers/stock_valuation_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class StockValuationDetailScreen extends StatefulWidget {
  final int idWarehouse;
  const StockValuationDetailScreen({super.key, required this.idWarehouse});

  @override
  State<StockValuationDetailScreen> createState() => _StockValuationDetailScreenState();
}

class _StockValuationDetailScreenState extends State<StockValuationDetailScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockValuationController>().fetchWarehouseDetail(widget.idWarehouse);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    context.read<StockValuationController>().resetDetailState();
    super.dispose();
  }

  void _onSearchChanged(String v) =>
      context.read<StockValuationController>().searchDetailItems(widget.idWarehouse, v);

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
        title: Text("Stock Valuation", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<StockValuationController>(
        builder: (context, ctrl, child) {
          if (ctrl.isLoadingDetail && ctrl.detail == null) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.detailError != null && ctrl.detail == null) {
            return Center(child: Text(ctrl.detailError!, style: GoogleFonts.poppins(color: colorError)));
          }
          final detail = ctrl.detail;
          if (detail == null) return const SizedBox.shrink();

          final bar = PaginationBottomBar(
            currentPage: detail.itemsMeta.currentPage,
            lastPage: detail.itemsMeta.lastPage,
            hasPrev: ctrl.detailHasPrevPage,
            hasNext: ctrl.detailHasNextPage,
            onGoToPage: (page) => ctrl.detailGoToPage(widget.idWarehouse, page),
            onPrev: () => ctrl.detailPrevPage(widget.idWarehouse),
            onNext: () => ctrl.detailNextPage(widget.idWarehouse),
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Card(
                      color: colorCard,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.warehouseName,
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: colorTextPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Code: ${detail.warehouseCode} • Branch: ${detail.branch ?? '-'}',
                              style: GoogleFonts.roboto(fontSize: 12, color: colorTextSubtle),
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: colorGreyLight),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Stock', style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 13)),
                                Text(formatQty(double.tryParse(detail.totalStockRaw) ?? 0), style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Value', style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 13)),
                                Text(
                                  _formatRupiah(detail.totalValueRaw),
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorPrimary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search product or location...',
                        hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                        prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                        filled: true,
                        fillColor: colorCard,
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
                  ],
                ),
              ),
              Expanded(
                child: detail.items.isEmpty
                    ? Center(
                        child: Text('No products in this warehouse', style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 13)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        itemCount: detail.items.length,
                        itemBuilder: (context, index) {
                          final item = detail.items[index];
                          return Card(
                            color: colorCard,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: colorGreyLight, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text('${item.productCode} • ${item.locationName}', style: GoogleFonts.roboto(fontSize: 12, color: colorTextSubtle)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Stock: ${formatQty(double.tryParse(item.totalStockRaw) ?? 0)} ${item.baseUomName}',
                                        style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                                      ),
                                      Text(
                                        _formatRupiah(item.totalValueRaw),
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorPrimary),
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
    );
  }
}