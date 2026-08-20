import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/utils/number_format_helper.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/models/history_stock_models.dart';

class HistoryStockListItem extends StatelessWidget {
  final HistoryStockModel item;
  const HistoryStockListItem({super.key, required this.item});

  String _formatDetail(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    return raw
        .split(', ')
        .map((part) {
          final match = RegExp(r'^(.+?)\s*\((.+?)\)$').firstMatch(part);
          if (match != null) {
            final type = humanizeEnum(match.group(1)!.replaceAll(' ', '_'));
            return '$type (${match.group(2)})';
          }
          return part;
        })
        .join(' • ');
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
              style: GoogleFonts.roboto(fontSize: 12, color: colorTextSubtle),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.warehouse_outlined,
                  size: 13,
                  color: colorTextSubtle,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${item.warehouseName} • ${item.locationName}',
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
              children: [
                _statItem('Opening', formatQty(item.stockOpening)),
                _statItem(
                  'In',
                  '+${formatQty(item.stockIn)}',
                  color: Colors.green,
                ),
                _statItem(
                  'Out',
                  '-${formatQty(item.stockOut)}',
                  color: Colors.red,
                ),
                _statItem('Closing', formatQty(item.stockClosing), bold: true),
              ],
            ),
            if (item.detailTransactions != null &&
                item.detailTransactions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _formatDetail(item.detailTransactions),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
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

  Widget _statItem(
    String label,
    String value, {
    Color? color,
    bool bold = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: color ?? colorTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
