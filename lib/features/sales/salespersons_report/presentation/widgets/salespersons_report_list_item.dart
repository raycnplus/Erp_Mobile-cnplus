import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/models/salespersons_report_models.dart';

class SalespersonsReportListItem extends StatelessWidget {
  final SalespersonsReportModel item;

  const SalespersonsReportListItem({super.key, required this.item});

  Color _conversionColor(String conversionRate) {
    if (conversionRate == '-') return Colors.grey;
    final numeric = double.tryParse(
      conversionRate.replaceAll('%', '').replaceAll(',', '.'),
    );
    if (numeric == null) return Colors.grey;
    if (numeric >= 75) return Colors.green;
    if (numeric >= 40) return Colors.orange;
    return Colors.red;
  }

  /// Memformat string mentah dari backend (mis. "1,234.56" hasil
  /// number_format PHP, atau "110000,00", atau angka polos) menjadi format
  /// Rupiah dengan pemisah ribuan titik dan SELALU 2 digit desimal.
  ///
  /// Separator yang muncul PALING TERAKHIR dianggap sebagai pemisah desimal,
  /// separator lainnya dianggap pemisah ribuan dan dibuang — jadi robust
  /// terhadap output PHP (koma ribuan, titik desimal) maupun locale ID.
  String _formatRupiah(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return 'Rp 0,00';
    }

    final value = rawValue.trim();
    final lastDot = value.lastIndexOf('.');
    final lastComma = value.lastIndexOf(',');

    String wholePart;
    String decimalPart;

    if (lastDot == -1 && lastComma == -1) {
      wholePart = value;
      decimalPart = '00';
    } else {
      final decimalSeparatorIndex = lastDot > lastComma ? lastDot : lastComma;
      wholePart = value
          .substring(0, decimalSeparatorIndex)
          .replaceAll('.', '')
          .replaceAll(',', '');
      decimalPart = value.substring(decimalSeparatorIndex + 1);
    }

    wholePart = wholePart.replaceAll(RegExp(r'[^0-9-]'), '');
    decimalPart = decimalPart.replaceAll(RegExp(r'[^0-9]'), '');

    if (wholePart.isEmpty || wholePart == '-') wholePart = '0';

    if (decimalPart.isEmpty) {
      decimalPart = '00';
    } else if (decimalPart.length == 1) {
      decimalPart = '${decimalPart}0';
    } else if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    final isNegative = wholePart.startsWith('-');
    final digitsOnly = isNegative ? wholePart.substring(1) : wholePart;

    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && (digitsOnly.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digitsOnly[i]);
    }

    final sign = isNegative ? '-' : '';
    return 'Rp $sign$buffer,$decimalPart';
  }

  Widget _statCell(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 10.5, color: colorTextSubtle),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: colorTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversionColor = _conversionColor(item.conversionRate);
    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.salespersonName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: colorTextPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: conversionColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Conv. ${item.conversionRate}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: conversionColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: colorGreyLight),
            const SizedBox(height: 12),
            Row(
              children: [
                _statCell('Quotation', '${item.totalQuotation}'),
                _statCell('Sales Order', '${item.totalSalesOrder}'),
                _statCell('Direct Sales', '${item.totalDirectSales}'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _statCell('Invoice', '${item.totalInvoice}'),
                _statCell('Customers', '${item.totalCustomers}'),
                _statCell('Handled', '${item.totalCustomerHandled}'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _statCell('Svc Invoice', '${item.totalServiceInvoice}'),
                _statCell('Svc Customers', '${item.totalServiceCustomers}'),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: colorGreyLight),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice Value',
                      style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatRupiah(item.totalInvoiceValueRaw),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colorPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Service Invoice Value',
                      style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatRupiah(item.totalServiceInvoiceValueRaw),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colorPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}