import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/models/cash_bank_report_models.dart';

String _rp(double v) => 'Rp ${formatCurrencyDisplay(v)}';

class CBColumnWidths {
  static const double date = 90;
  static const double coa = 140;
  static const double description = 160;
  static const double debit = 130;
  static const double credit = 130;

  static const double horizontalPadding = 24;

  static const double minBalance = 150;
  static double get leftBlock => date + coa + description;
  static double get total => date + coa + description + debit + credit + minBalance + horizontalPadding;
}

class CashBankReportRowWidget extends StatelessWidget {
  final CashBankReportRow row;
  final double width;

  const CashBankReportRowWidget({super.key, required this.row, required this.width});

  @override
  Widget build(BuildContext context) {
    return switch (row.type) {
      CashBankReportRowType.header => Container(
          width: width,
          color: colorPrimary.withValues(alpha: 0.06),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            row.description,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: colorPrimary),
          ),
        ),

      CashBankReportRowType.saldoAwal => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: CBColumnWidths.leftBlock,
                child: Text(
                  row.description,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
              const SizedBox(width: CBColumnWidths.debit),
              const SizedBox(width: CBColumnWidths.credit),
              Expanded(
                child: Text(
                  _rp(row.saldo ?? 0),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
            ],
          ),
        ),

      CashBankReportRowType.transaction => Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: CBColumnWidths.date,
                child: Text(
                  row.transactionDate ?? '-',
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ),
              SizedBox(
                width: CBColumnWidths.coa,
                child: Text(
                  row.reference?.isNotEmpty == true ? row.reference! : '-',
                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: colorTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: CBColumnWidths.description,
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
                width: CBColumnWidths.debit,
                child: Text(
                  (row.debit ?? 0) > 0 ? _rp(row.debit!) : '-',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary),
                ),
              ),
              SizedBox(
                width: CBColumnWidths.credit,
                child: Text(
                  (row.credit ?? 0) > 0 ? _rp(row.credit!) : '-',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary),
                ),
              ),
              Expanded(
                child: Text(
                  _rp(row.saldo ?? 0),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ),
            ],
          ),
        ),

      CashBankReportRowType.coaLine => Container(
          width: width,
          color: colorBackground,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              const SizedBox(width: CBColumnWidths.date),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Text(
                    row.description,
                    style: GoogleFonts.poppins(fontSize: 10, fontStyle: FontStyle.italic, color: colorTextSubtle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(
                width: CBColumnWidths.debit,
                child: Text(
                  (row.debit ?? 0) > 0 ? _rp(row.debit!) : '-',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ),
              SizedBox(
                width: CBColumnWidths.credit,
                child: Text(
                  (row.credit ?? 0) > 0 ? _rp(row.credit!) : '-',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),

      CashBankReportRowType.total => Column(
          children: [
            SizedBox(width: width, child: const Divider(height: 1, color: colorGreyLight)),
            Container(
              width: width,
              color: const Color(0xFFF0F0F0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: CBColumnWidths.leftBlock,
                    child: Text(
                      row.description,
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: CBColumnWidths.debit,
                    child: Text(
                      _rp(row.debit ?? 0),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                    ),
                  ),
                  SizedBox(
                    width: CBColumnWidths.credit,
                    child: Text(
                      _rp(row.credit ?? 0),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _rp(row.saldo ?? 0),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      CashBankReportRowType.grandTotal => Container(
          width: width,
          color: const Color(0xFFE6E6E6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: colorTextPrimary, width: 1.5)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: CBColumnWidths.leftBlock,
                child: Text(
                  row.description,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
              SizedBox(
                width: CBColumnWidths.debit,
                child: Text(
                  _rp(row.debit ?? 0),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
              SizedBox(
                width: CBColumnWidths.credit,
                child: Text(
                  _rp(row.credit ?? 0),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
              Expanded(
                child: Text(
                  _rp(row.saldo ?? 0),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorPrimary),
                ),
              ),
            ],
          ),
        ),
    };
  }
}