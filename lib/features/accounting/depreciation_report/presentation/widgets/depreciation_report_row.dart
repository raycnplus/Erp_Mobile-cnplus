import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/models/depreciation_report_models.dart';

class DRColumnWidths {
  static const double no = 40;
  static const double date = 90;
  static const double reference = 140;
  static const double description = 200;
  static const double numeric = 110;

  static const double horizontalPadding = 24;

  static double get total =>
      no + date + reference + description + (numeric * 3) + horizontalPadding;
}

class DepreciationReportRowWidget extends StatelessWidget {
  final DepreciationReportRow row;
  final double width;

  const DepreciationReportRowWidget({super.key, required this.row, required this.width});

  @override
  Widget build(BuildContext context) {
    return switch (row.rowType) {
      DepreciationRowType.header => Container(
          width: width,
          color: const Color(0xFFEAEAEA),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            row.journalDescription,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
          ),
        ),

      DepreciationRowType.saldoAwal => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
          ),
          child: Row(
            children: [
              const SizedBox(width: DRColumnWidths.no + DRColumnWidths.date + DRColumnWidths.reference),
              _textCell(row.journalDescription, DRColumnWidths.description, italic: true),
              _numCell(''),
              _numCell(''),
              _numCell(row.saldo, bold: true),
            ],
          ),
        ),

      DepreciationRowType.data => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
          ),
          child: Row(
            children: [
              _textCell(row.no, DRColumnWidths.no),
              _textCell(row.journalDate, DRColumnWidths.date),
              _textCell(row.reference, DRColumnWidths.reference),
              _textCell(row.journalDescription, DRColumnWidths.description),
              _numCell(row.debit),
              _numCell(row.credit),
              _numCell(row.saldo),
            ],
          ),
        ),

      DepreciationRowType.total => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            border: Border(top: BorderSide(color: colorTextPrimary, width: 1)),
          ),
          child: Row(
            children: [
              const SizedBox(width: DRColumnWidths.no + DRColumnWidths.date + DRColumnWidths.reference),
              _textCell('Total', DRColumnWidths.description, bold: true),
              _numCell(row.debit, bold: true, primary: true),
              _numCell(row.credit, bold: true, primary: true),
              _numCell(row.saldo, bold: true, primary: true),
            ],
          ),
        ),
    };
  }

  Widget _textCell(String text, double w, {bool bold = false, bool italic = false}) {
    return SizedBox(
      width: w,
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          color: colorTextPrimary,
        ),
      ),
    );
  }

  Widget _numCell(String value, {bool bold = false, bool primary = false}) {
    return SizedBox(
      width: DRColumnWidths.numeric,
      child: Text(
        value.isEmpty ? '' : 'Rp $value',
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