import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/ppn_report/data/models/ppn_report_models.dart';

class PPNReportListItem extends StatelessWidget {
  final PPNReportModel item;
  const PPNReportListItem({super.key, required this.item});

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
                    item.soReference,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary),
                  ),
                ),
                Text(item.date, style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: colorTextSubtle),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.taxWithholderName,
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
                Text('NPWP: ${item.npwp}', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
              ],
            ),
            if (item.eBupot != null && item.eBupot!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 14, color: colorTextSubtle),
                  const SizedBox(width: 4),
                  Text('e-Bupot: ${item.eBupot}', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                ],
              ),
            ],
            const SizedBox(height: 10),
            const Divider(height: 1, color: colorGreyLight),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gross Income', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(
                        _formatRupiah(item.grossIncomeRaw),
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colorTextPrimary),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PPN', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(
                        _formatRupiah(item.ppnRaw),
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: colorPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}