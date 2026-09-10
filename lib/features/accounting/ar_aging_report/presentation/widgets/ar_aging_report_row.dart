import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/models/ar_aging_report_models.dart';

String _rp(double v) => 'Rp ${formatCurrencyDisplay(v)}';

class ARAColumnWidths {
  static const double no = 36;
  static const double reference = 120;
  static const double customer = 150;
  static const double type = 80;
  static const double invoiceDate = 90;
  static const double dueDate = 90;
  static const double invoiceAmount = 140;
  static const double paid = 140;
  static const double outstanding = 150;
  static const double paymentNo = 130; 
  static const double paymentDate = 90;
  static const double daysOverdue = 90;
  static const double aging = 110; 
  static const double status = 86; 
  static const double columnGap = 12;

  static const double horizontalPadding = 24;

  static double get total =>
      no + reference + customer + type + invoiceDate + dueDate + invoiceAmount + paid +
      outstanding + paymentNo + paymentDate + daysOverdue + aging + status + horizontalPadding;
}

Widget _cell({required double width, required Widget child, bool isLast = false}) {
  return Container(
    width: width,
    padding: EdgeInsets.only(right: isLast ? 0 : ARAColumnWidths.columnGap),
    child: child,
  );
}

class ARAgingReportRowWidget extends StatelessWidget {
  final ARAgingRow row;
  final int index;
  final double width;

  const ARAgingReportRowWidget({super.key, required this.row, required this.index, required this.width});

  Color get _statusColor {
    switch (row.statusLabel) {
      case 'Paid':
        return colorSuccess;
      case 'Overdue':
        return colorError;
      case 'Outstanding':
        return colorWarning;
      default:
        return colorGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cell(
            width: ARAColumnWidths.no,
            child: Text('${index + 1}', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
          ),
          _cell(
            width: ARAColumnWidths.reference,
            child: Text(
              row.reference,
              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: colorTextPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _cell(
            width: ARAColumnWidths.customer,
            child: Text(
              row.customerName,
              style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _cell(
            width: ARAColumnWidths.type,
            child: Text(row.invoiceType, style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
          ),
          _cell(
            width: ARAColumnWidths.invoiceDate,
            child: Text(row.invoiceDate ?? '-', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
          ),
          _cell(
            width: ARAColumnWidths.dueDate,
            child: Text(row.dueDate ?? '-', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
          ),
          _cell(
            width: ARAColumnWidths.invoiceAmount,
            child: Text(_rp(row.invoiceAmount), textAlign: TextAlign.right, style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary)),
          ),
          _cell(
            width: ARAColumnWidths.paid,
            child: Text(_rp(row.paidAmount), textAlign: TextAlign.right, style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary)),
          ),
          _cell(
            width: ARAColumnWidths.outstanding,
            child: Text(
              _rp(row.outstanding),
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: row.outstanding > 0 ? colorError : colorTextPrimary),
            ),
          ),
          _cell(
            width: ARAColumnWidths.paymentNo,
            child: Text(row.paymentNumber ?? '-', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          _cell(
            width: ARAColumnWidths.paymentDate,
            child: Text(row.paymentDate ?? '-', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
          ),
          _cell(
            width: ARAColumnWidths.daysOverdue,
            child: Text(
              row.daysOverdue?.toString() ?? '-',
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
            ),
          ),
          _cell(
            width: ARAColumnWidths.aging,
            child: Text(
              row.agingBucket,
              style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _cell(
            width: ARAColumnWidths.status,
            isLast: true,
            child: Align(alignment: Alignment.centerLeft, child: _statusBadge()),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        row.statusLabel,
        style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: _statusColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}