import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/presentation/controllers/warehouse_report_controller.dart';

class WarehouseReportDetailScreen extends StatefulWidget {
  final int idWarehouse;
  const WarehouseReportDetailScreen({super.key, required this.idWarehouse});

  @override
  State<WarehouseReportDetailScreen> createState() =>
      _WarehouseReportDetailScreenState();
}

class _WarehouseReportDetailScreenState
    extends State<WarehouseReportDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WarehouseReportController>().fetchReportDetail(
        widget.idWarehouse,
      );
    });
  }

  @override
  void dispose() {
    context.read<WarehouseReportController>().resetDetailState();
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
          "Warehouse Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<WarehouseReportController>(
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
                        detail.warehouseName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail.warehouseCode,
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
                            'Total On Hand',
                            style: GoogleFonts.poppins(
                              color: colorTextSubtle,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            detail.totalOnHand.toStringAsFixed(0),
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
                'Locations (${detail.locations.length})',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...detail.locations.map(
                (loc) => Card(
                  color: colorCard,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: colorGreyLight, width: 1),
                  ),
                  child: ListTile(
                    title: Text(
                      loc.locationName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      loc.locationCode,
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
                          '${loc.totalProduct} products',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorTextSubtle,
                          ),
                        ),
                        Text(
                          loc.totalStock.toStringAsFixed(0),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
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
