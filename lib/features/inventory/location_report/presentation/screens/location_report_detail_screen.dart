import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/controllers/location_report_controller.dart';

class LocationReportDetailScreen extends StatefulWidget {
  final int idLocation;
  const LocationReportDetailScreen({super.key, required this.idLocation});

  @override
  State<LocationReportDetailScreen> createState() =>
      _LocationReportDetailScreenState();
}

class _LocationReportDetailScreenState
    extends State<LocationReportDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationReportController>().fetchReportDetail(
        widget.idLocation,
      );
    });
  }

  @override
  void dispose() {
    context.read<LocationReportController>().resetDetailState();
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
          "Location Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<LocationReportController>(
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
                        detail.locationName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail.locationCode,
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
                            'Warehouse',
                            style: GoogleFonts.poppins(
                              color: colorTextSubtle,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            detail.warehouseName ?? '-',
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
                            'Parent Location',
                            style: GoogleFonts.poppins(
                              color: colorTextSubtle,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            detail.parentName ?? '-',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                'Product Stock (${detail.stocks.length})',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...detail.stocks.map(
                (s) => Card(
                  color: colorCard,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: colorGreyLight, width: 1),
                  ),
                  child: ListTile(
                    title: Text(
                      s.productName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${s.productCode}${s.uomName != null ? ' • ${s.uomName}' : ''}',
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
                          'On Hand: ${s.onHand.toStringAsFixed(0)}',
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
              if (detail.stocks.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No stock in this location',
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
