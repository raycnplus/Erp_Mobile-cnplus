import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/models/top_customer_report_models.dart';

class TopCustomerReportListItem extends StatelessWidget {
  final TopCustomerReportModel item;
  final int rank;

  const TopCustomerReportListItem({super.key, required this.item, required this.rank});

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

  Color _rankColor() {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return colorGreyLight;
  }

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank <= 3;
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isTopThree ? _rankColor().withOpacity(0.2) : colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$rank',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isTopThree ? _rankColor() : colorPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.customer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.warehouse_outlined, size: 12, color: colorTextSubtle),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${item.warehouse} • ${item.location}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.totalTransaction} transactions',
                        style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                      ),
                      Text(
                        _formatRupiah(item.totalAmountRaw),
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: colorPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}