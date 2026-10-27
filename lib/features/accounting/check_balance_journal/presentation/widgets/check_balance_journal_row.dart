import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/models/check_balance_journal_models.dart';

String _rp(double v) => 'Rp ${formatCurrencyDisplay(v)}';

class CBJColumnWidths {
  static const double date = 90;
  static const double reference = 130;
  static const double description = 180;
  static const double debit = 130;
  static const double credit = 130;
  static const double source = 130;
  static const double status = 100;

  static const double horizontalPadding = 24;

  static double get total =>
      date + reference + description + debit + credit + source + status + horizontalPadding;
}

class CheckBalanceJournalRowWidget extends StatelessWidget {
  final CheckBalanceJournalRow row;
  final double width;

  const CheckBalanceJournalRowWidget({super.key, required this.row, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: row.isBalanced ? null : colorError.withValues(alpha: 0.04),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: CBJColumnWidths.date,
            child: Text(
              row.transactionDate ?? '-',
              style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
            ),
          ),
          SizedBox(
            width: CBJColumnWidths.reference,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                row.reference,
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: colorTextPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: CBJColumnWidths.description,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                row.description,
                style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: CBJColumnWidths.debit,
            child: Text(
              _rp(row.debit),
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary),
            ),
          ),
          SizedBox(
            width: CBJColumnWidths.credit,
            child: Text(
              _rp(row.credit),
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary),
            ),
          ),
          SizedBox(
            width: CBJColumnWidths.source,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                row.sourceType,
                style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: CBJColumnWidths.status,
            child: Align(
              alignment: Alignment.center,
              child: _statusBadge(row.isBalanced),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isBalanced) {
    final color = isBalanced ? colorSuccess : colorError;
    final label = isBalanced ? 'Balance' : 'Mismatch';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBalanced ? Icons.check_circle : Icons.error,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}