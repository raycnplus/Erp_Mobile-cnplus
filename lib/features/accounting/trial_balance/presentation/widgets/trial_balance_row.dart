import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/models/trial_balance_models.dart';

String _rp(double v) => 'Rp ${formatCurrencyDisplay(v)}';

class TBColumnWidths {
  static const double coa = 180;
  static const double numeric = 120;

  static const double horizontalPadding = 24;

  static double get numericBlock => numeric * 6;
  static double get total => coa + numericBlock + horizontalPadding;
}

class TrialBalanceRowWidget extends StatelessWidget {
  final TrialBalanceRow row;
  final double width;

  const TrialBalanceRowWidget({super.key, required this.row, required this.width});

  @override
  Widget build(BuildContext context) {
    return switch (row.rowType) {
      TrialBalanceRowType.data => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: TBColumnWidths.coa,
                child: Text(
                  row.coaName,
                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _numCell(row.saldoAwalDebit),
              _numCell(row.saldoAwalKredit),
              _numCell(row.mutasiDebit),
              _numCell(row.mutasiKredit),
              _numCell(row.saldoAkhirDebit),
              _numCell(row.saldoAkhirKredit),
            ],
          ),
        ),

      TrialBalanceRowType.subtotal => Container(
          width: width,
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: TBColumnWidths.coa,
                child: Text(
                  row.coaName,
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: colorTextPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _numCell(row.saldoAwalDebit, bold: true),
              _numCell(row.saldoAwalKredit, bold: true),
              _numCell(row.mutasiDebit, bold: true),
              _numCell(row.mutasiKredit, bold: true),
              _numCell(row.saldoAkhirDebit, bold: true),
              _numCell(row.saldoAkhirKredit, bold: true),
            ],
          ),
        ),

        TrialBalanceRowType.grandTotal => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFE6E6E6),
            border: Border(top: BorderSide(color: colorTextPrimary, width: 1.5)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: TBColumnWidths.coa,
                child: Text(
                  'Total',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
              _numCell(row.saldoAwalDebit, bold: true, primary: true),
              _numCell(row.saldoAwalKredit, bold: true, primary: true),
              _numCell(row.mutasiDebit, bold: true, primary: true),
              _numCell(row.mutasiKredit, bold: true, primary: true),
              _numCell(row.saldoAkhirDebit, bold: true, primary: true),
              _numCell(row.saldoAkhirKredit, bold: true, primary: true),
            ],
          ),
        ),
    };
  }

  Widget _numCell(double value, {bool bold = false, bool primary = false}) {
    return SizedBox(
      width: TBColumnWidths.numeric,
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