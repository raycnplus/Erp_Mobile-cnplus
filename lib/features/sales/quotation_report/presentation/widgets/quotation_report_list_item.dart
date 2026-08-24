import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation_report/data/models/quotation_report_models.dart';

class QuotationReportListItem extends StatelessWidget {
  final QuotationReportModel item;
  const QuotationReportListItem({super.key, required this.item});

  Color _statusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'Confirmed':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      case 'Waiting Approval':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

String _formatRupiah(String rawValue) {
  // Samakan pemisah desimal dari backend (ubah koma jadi titik jika ada)
  final normalizedValue = rawValue.replaceAll(',', '.');
  final parts = normalizedValue.split('.');
  final wholePart = parts[0];

  // PAKSA selalu ada 2 digit desimal
  String decimalPart = parts.length > 1 ? parts[1] : '00';
  if (decimalPart.length == 1) decimalPart += '0'; // misal "5" jadi "50"
  if (decimalPart.length > 2) decimalPart = decimalPart.substring(0, 2); // potong jika lebih dari 2

  final buffer = StringBuffer();
  for (int i = 0; i < wholePart.length; i++) {
    if (i > 0 && (wholePart.length - i) % 3 == 0) buffer.write('.');
    buffer.write(wholePart[i]);
  }

  // Karena kita sudah memaksa decimalPart ada, kita bisa langsung return dengan koma
  return 'Rp $buffer,$decimalPart'; 
}

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);

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
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.status,
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor),
                  ),
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
              item.product,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colorTextPrimary),
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
                    Text(formatQty(item.demandQty), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Amount', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                    const SizedBox(height: 2),
                    Text(
                      _formatRupiah(item.amountRaw),
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: colorPrimary),
                    ),
                  ],
                ),
              ],
            ),
            if (item.createdDate != null) ...[
              const SizedBox(height: 6),
              Text(item.createdDate!, style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
            ],
          ],
        ),
      ),
    );
  }
}