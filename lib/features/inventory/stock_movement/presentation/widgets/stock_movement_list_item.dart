import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/models/stock_movement_models.dart';

class StockMovementListItem extends StatelessWidget {
  final StockMovementModel item;
  const StockMovementListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isIn = item.movementType == 'in';
    final typeColor = isIn ? Colors.green : Colors.red;

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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isIn ? 'IN' : 'OUT',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: typeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.referenceNo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: colorTextSubtle,
                    ),
                  ),
                ),
                Text(
                  item.movementDate,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: colorTextSubtle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.productName,
              maxLines: 2,
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
              style: GoogleFonts.roboto(fontSize: 12, color: colorTextSubtle),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
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
                ),
                Text(
                  '${isIn ? '+' : '-'}${formatQty(item.qty)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: typeColor,
                  ),
                ),
              ],
            ),
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: colorGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
