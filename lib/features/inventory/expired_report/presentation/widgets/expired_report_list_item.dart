import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/data/models/expired_report_models.dart';

class ExpiredReportListItem extends StatelessWidget {
  final ExpiredReportModel item;
  const ExpiredReportListItem({super.key, required this.item});

  Color _statusColor(String status) {
    switch (status) {
      case 'Expired':
        return Colors.red;
      case 'Alert':
        return Colors.orange;
      case 'Removal':
        return Colors.deepOrange;
      case 'Best Before':
        return Colors.amber.shade800;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.expiryStatus);

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
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: colorTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.productCode,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: colorTextSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.expiryStatus,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.qr_code_2, size: 14, color: colorTextSubtle),
                const SizedBox(width: 4),
                Text(
                  item.lotSerialNumber,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.warehouse_outlined,
                  size: 14,
                  color: colorTextSubtle,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${item.warehouseName ?? '-'}${item.locationName != null ? ' • ${item.locationName}' : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colorTextSubtle,
                    ),
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
                    Text(
                      'Remaining Qty',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: colorTextSubtle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatQty(item.remainingQuantity)}${item.uomName != null ? ' ${item.uomName}' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorTextPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Expiration Date',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: colorTextSubtle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.expirationDate ?? '-',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    if (item.daysToExpiry != null)
                      Text(
                        item.daysToExpiry! < 0
                            ? '${item.daysToExpiry!.abs()} days ago'
                            : '${item.daysToExpiry} days left',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: colorTextSubtle,
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
