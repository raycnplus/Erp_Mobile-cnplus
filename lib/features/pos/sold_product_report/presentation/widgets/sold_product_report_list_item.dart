import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/models/sold_product_report_models.dart';

class SoldProductReportListItem extends StatelessWidget {
  final SoldProductReportItem item;

  const SoldProductReportListItem({super.key, required this.item});

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
                const Icon(Icons.inventory_2_outlined, size: 16, color: colorTextSubtle),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: colorTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.qr_code_2_outlined, size: 14, color: colorTextSubtle),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.productCode,
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
                const Icon(Icons.store_outlined, size: 14, color: colorTextSubtle),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.store,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                  ),
                ),
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
                    Text('Qty Sold', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                    const SizedBox(height: 2),
                    Text(
                      formatPrice(item.totalQty),
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total Amount', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                    const SizedBox(height: 2),
                    Text(
                      'Rp ${formatPrice(item.totalAmount)}',
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
          ],
        ),
      ),
    );
  }
}