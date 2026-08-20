import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/presentation/controllers/stock_report_controller.dart';

class StockReportDetailScreen extends StatefulWidget {
  final int idProduct;
  const StockReportDetailScreen({super.key, required this.idProduct});

  @override
  State<StockReportDetailScreen> createState() =>
      _StockReportDetailScreenState();
}

class _StockReportDetailScreenState extends State<StockReportDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockReportController>().fetchReportDetail(widget.idProduct);
    });
  }

  @override
  void dispose() {
    context.read<StockReportController>().resetDetailState();
    super.dispose();
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
          "Stock Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<StockReportController>(
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
          final detail = ctrl.reportDetail;
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
                        '${detail.productCode}${detail.uomName != null ? ' • ${detail.uomName}' : ''}',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: colorTextSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Stock by Location (${detail.stockByLocation.length})',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...detail.stockByLocation.map(
                (s) => Card(
                  color: colorCard,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: colorGreyLight, width: 1),
                  ),
                  child: ListTile(
                    title: Text(
                      s.locationName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      s.warehouseName,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: colorTextSubtle,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Reserved: ${s.reservedQty.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: colorTextSubtle,
                          ),
                        ),
                        Text(
                          'Available: ${s.available.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (detail.stockByLocation.isEmpty)
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
