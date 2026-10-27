import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/models/cash_flow_models.dart';

String _rp(double v) => 'Rp ${formatCurrencyDisplay(v)}';

class CFColumnWidths {
  static const double label = 220;
  static const double amount = 130;

  static const double horizontalPadding = 24;

  static double totalFor(int columnCount) => label + (amount * columnCount) + horizontalPadding;
}

class CashFlowRowWidget extends StatelessWidget {
  final CashFlowRow row;
  final double width;
  final int columnCount;

  const CashFlowRowWidget({
    super.key,
    required this.row,
    required this.width,
    required this.columnCount,
  });

  List<double> get _paddedAmounts {
    if (row.amounts.length >= columnCount) return row.amounts;
    return [...row.amounts, ...List.filled(columnCount - row.amounts.length, 0)];
  }

  @override
  Widget build(BuildContext context) {
    return switch (row.rowType) {
      CashFlowRowType.header => Container(
          width: width,
          color: colorPrimary.withValues(alpha: 0.06),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            row.coaName,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorPrimary),
          ),
        ),

      CashFlowRowType.data => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: CFColumnWidths.label,
                child: Text(
                  row.coaName,
                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (final a in _paddedAmounts) _amountCell(a),
            ],
          ),
        ),

      CashFlowRowType.subtotal => Container(
          width: width,
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: CFColumnWidths.label,
                child: Text(
                  row.coaName,
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: colorTextPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (final a in _paddedAmounts) _amountCell(a, bold: true),
            ],
          ),
        ),

      CashFlowRowType.total => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: row.isMainTotal ? const Color(0xFFE6E6E6) : colorWhite,
            border: const Border(top: BorderSide(color: colorTextPrimary, width: 1.2)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: CFColumnWidths.label,
                child: Text(
                  row.coaName,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (final a in _paddedAmounts) _amountCell(a, bold: true, primary: true),
            ],
          ),
        ),
    };
  }

  Widget _amountCell(double value, {bool bold = false, bool primary = false}) {
    return SizedBox(
      width: CFColumnWidths.amount,
      child: Text(
        _rp(value),
        textAlign: TextAlign.right,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          color: primary ? colorPrimary : colorTextPrimary,
        ),
      ),
    );
  }
}