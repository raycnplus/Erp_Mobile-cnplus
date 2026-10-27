import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/models/general_ledger_models.dart';

String _rp(double v) => 'Rp ${formatCurrencyDisplay(v)}';

class GLColumnWidths {
  static const double date = 90;
  static const double refDesc = 200;
  static const double debit = 130;
  static const double credit = 130;

  static const double horizontalPadding = 24;

  static const double minBalance = 150;
  static double get total => date + refDesc + debit + credit + minBalance + horizontalPadding;
}

class GeneralLedgerRowWidget extends StatelessWidget {
  final GeneralLedgerRow row;
  final double width;

  const GeneralLedgerRowWidget({super.key, required this.row, required this.width});

  @override
  Widget build(BuildContext context) {
    switch (row.type) {
      case GeneralLedgerRowType.header:
        return Container(
          width: width,
          color: colorPrimary.withOpacity(0.06),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            row.description,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: colorPrimary),
          ),
        );

      case GeneralLedgerRowType.saldoAwal:
        return Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: GLColumnWidths.date + GLColumnWidths.refDesc,
                child: Text(
                  row.description,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
              const SizedBox(width: GLColumnWidths.debit),
              const SizedBox(width: GLColumnWidths.credit),
              Expanded(
                child: Text(
                  _rp(row.saldo ?? 0),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
              ),
            ],
          ),
        );

      case GeneralLedgerRowType.total:
        return Column(
          children: [
            SizedBox(width: width, child: const Divider(height: 1, color: colorGreyLight)),
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: GLColumnWidths.date + GLColumnWidths.refDesc,
                    child: Text(
                      'Total',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                    ),
                  ),
                  SizedBox(
                    width: GLColumnWidths.debit,
                    child: Text(
                      _rp(row.debit ?? 0),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: colorTextPrimary),
                    ),
                  ),
                  SizedBox(
                    width: GLColumnWidths.credit,
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
        );

      case GeneralLedgerRowType.transaction:
        return Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: GLColumnWidths.date,
                child: Text(
                  row.journalDate ?? '-',
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ),
              SizedBox(
                width: GLColumnWidths.refDesc,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.reference?.isNotEmpty == true ? row.reference! : '-',
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: colorTextPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        row.description,
                        style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: GLColumnWidths.debit,
                child: Text(
                  (row.debit ?? 0) > 0 ? _rp(row.debit!) : '-',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary),
                ),
              ),
              SizedBox(
                width: GLColumnWidths.credit,
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
        );
    }
  }
}