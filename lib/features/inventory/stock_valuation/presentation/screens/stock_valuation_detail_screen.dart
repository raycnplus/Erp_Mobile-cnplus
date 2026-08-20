import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/controllers/stock_valuation_controller.dart';

class StockValuationDetailScreen extends StatefulWidget {
  final int idProduct;
  const StockValuationDetailScreen({super.key, required this.idProduct});

  @override
  State<StockValuationDetailScreen> createState() =>
      _StockValuationDetailScreenState();
}

class _StockValuationDetailScreenState
    extends State<StockValuationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockValuationController>().fetchDetail(widget.idProduct);
    });
  }

  @override
  void dispose() {
    context.read<StockValuationController>().resetDetailState();
    super.dispose();
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
          "Valuation Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<StockValuationController>(
        builder: (context, ctrl, child) {
          if (ctrl.isLoadingDetail) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          if (ctrl.detailError != null) {
            return Center(
              child: Text(
                ctrl.detailError!,
                style: GoogleFonts.poppins(color: colorError),
              ),
            );
          }
          final detail = ctrl.detail;
          if (detail == null) return const SizedBox.shrink();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: colorCard,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.productName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail.productCode,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: colorTextSubtle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: colorGreyLight),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Qty',
                            style: GoogleFonts.poppins(
                              color: colorTextSubtle,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            formatQty(detail.totalQty),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Value',
                            style: GoogleFonts.poppins(
                              color: colorTextSubtle,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            _formatRupiah(detail.totalValue),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: colorPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By Location (${detail.byLocation.length})',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...detail.byLocation.map(
                (s) => Card(
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
                        Text(
                          s.locationName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.warehouseName,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: colorTextSubtle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${formatQty(s.stockQty)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: colorTextSubtle,
                              ),
                            ),
                            Text(
                              _formatRupiah(s.locationValue),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: colorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (detail.byLocation.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No stock recorded for this product',
                      style: GoogleFonts.poppins(
                        color: colorTextSubtle,
                        fontSize: 13,
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
}
