import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/data/models/sales_product_report_models.dart';

class SalesProductReportListItem extends StatelessWidget {
  final SalesProductReportModel item;
  const SalesProductReportListItem({super.key, required this.item});

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(item.productCode, style: GoogleFonts.roboto(fontSize: 12, color: colorTextSubtle)),
                    ],
                  ),
                ),
                if (item.productCategory != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.productCategory!,
                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: colorPrimary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: colorGreyLight),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Qty Sold', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(formatQty(item.qtySold), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Avg Price', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(_formatRupiah(item.avgPriceRaw), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transactions', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text('${item.transactionCount}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contribution', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text('${item.salesContribution.toStringAsFixed(2)}%', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sales Value', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                Text(
                  _formatRupiah(item.salesValueRaw),
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: colorPrimary),
                ),
              ],
            ),
            if (item.lastSoldDate != null) ...[
              const SizedBox(height: 6),
              Text('Last sold: ${item.lastSoldDate}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
            ],
          ],
        ),
      ),
    );
  }
}