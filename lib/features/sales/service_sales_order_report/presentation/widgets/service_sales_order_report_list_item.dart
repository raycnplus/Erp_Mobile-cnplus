import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/models/service_sales_order_report_models.dart';

class ServiceSalesOrderReportListItem extends StatelessWidget {
  final ServiceSalesOrderReportModel item;

  const ServiceSalesOrderReportListItem({super.key, required this.item});

  Color _statusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'Confirmed':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _paymentStatusColor(String paymentStatus) {
    switch (paymentStatus) {
      case 'Paid':
        return Colors.green;
      case 'Partial':
        return Colors.orange;
      case 'Unpaid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Memformat string mentah dari backend (mis. "110000.5", "110000,5",
  /// "1.110.000,00", atau angka polos "110000") menjadi format Rupiah
  /// dengan pemisah ribuan titik dan SELALU 2 digit desimal (mis. "Rp 110.000,50").
  ///
  /// Backend bisa mengirim titik ATAU koma sebagai pemisah desimal, jadi
  /// kita deteksi separator desimal yang sebenarnya terlebih dahulu
  /// (pemisah yang muncul PALING TERAKHIR dianggap sebagai pemisah desimal),
  /// baru kemudian buang sisa pemisah ribuan sebelum diformat ulang.
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
      // Tidak ada pemisah sama sekali, murni angka bulat.
      wholePart = value;
      decimalPart = '00';
    } else {
      // Separator yang posisinya paling akhir dianggap sebagai pemisah desimal,
      // separator lainnya (jika ada) dianggap pemisah ribuan dan dibuang.
      final decimalSeparatorIndex = lastDot > lastComma ? lastDot : lastComma;

      wholePart = value
          .substring(0, decimalSeparatorIndex)
          .replaceAll('.', '')
          .replaceAll(',', '');
      decimalPart = value.substring(decimalSeparatorIndex + 1);
    }

    // Bersihkan karakter non-digit yang mungkin nyelip (mis. "Rp", spasi).
    wholePart = wholePart.replaceAll(RegExp(r'[^0-9-]'), '');
    decimalPart = decimalPart.replaceAll(RegExp(r'[^0-9]'), '');

    if (wholePart.isEmpty || wholePart == '-') wholePart = '0';

    // PAKSA selalu tepat 2 digit desimal.
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

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);
    final paymentStatusColor = _paymentStatusColor(item.paymentStatus);
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
                    item.reference,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: colorTextPrimary,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: [
                    _badge(item.status, statusColor),
                    _badge(item.paymentStatus, paymentStatusColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: colorTextSubtle),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.customer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.badge_outlined, size: 14, color: colorTextSubtle),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.salesPerson,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.service,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
              ),
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
                    Text('Qty', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                    const SizedBox(height: 2),
                    Text(
                      formatQty(item.qty),
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Amount', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                    const SizedBox(height: 2),
                    Text(
                      _formatRupiah(item.amountRaw),
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colorPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (item.createdDate != null) ...[
              const SizedBox(height: 6),
              Text(
                item.createdDate!,
                style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}