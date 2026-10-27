import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/models/billing_tax_report_models.dart';

String _rp(double v) => 'Rp ${formatCurrencyDisplay(v)}';
String _dash(String? v) => (v == null || v.isEmpty) ? '-' : v;

const double kBTColumnGap = 12;

class BTColumn {
  final String label;
  final double width;
  final String Function(BillingTaxRow row, int index) getValue;
  final TextAlign align;

  const BTColumn({
    required this.label,
    required this.width,
    required this.getValue,
    this.align = TextAlign.left,
  });
}

final List<BTColumn> billingTaxColumns = [
  BTColumn(label: 'No', width: 40, align: TextAlign.center, getValue: (r, i) => '${i + 1}'),
  BTColumn(label: 'Year', width: 60, align: TextAlign.center, getValue: (r, i) => _dash(r.year)),
  BTColumn(label: 'Customer', width: 150, getValue: (r, i) => r.customer),
  BTColumn(label: 'Address', width: 180, getValue: (r, i) => r.address),
  BTColumn(label: 'NPWP', width: 130, getValue: (r, i) => r.npwp),
  BTColumn(label: 'Project', width: 130, getValue: (r, i) => r.project),
  BTColumn(label: 'PO/SPK No.', width: 110, getValue: (r, i) => r.poNumber),
  BTColumn(label: 'PO Date', width: 90, align: TextAlign.center, getValue: (r, i) => _dash(r.poDate)),
  BTColumn(label: 'Payment Term', width: 120, getValue: (r, i) => r.termName),
  BTColumn(label: 'Subtotal', width: 130, align: TextAlign.right, getValue: (r, i) => _rp(r.untaxedAmount)),
  BTColumn(label: 'PPN', width: 130, align: TextAlign.right, getValue: (r, i) => _rp(r.totalTaxes)),
  BTColumn(label: 'Grand Total', width: 140, align: TextAlign.right, getValue: (r, i) => _rp(r.grandTotal)),
  BTColumn(label: 'Invoice No.', width: 120, getValue: (r, i) => r.reference),
  BTColumn(label: 'Invoice Date', width: 90, align: TextAlign.center, getValue: (r, i) => _dash(r.invoiceDate)),
  BTColumn(label: 'Tax Invoice No.', width: 140, getValue: (r, i) => r.fakturPajak),
  BTColumn(label: 'Tax Invoice Date', width: 100, align: TextAlign.center, getValue: (r, i) => _dash(r.tanggalFakturPajak)),
  BTColumn(label: 'E-Billing No.', width: 130, getValue: (r, i) => r.taxBillingNumber),
  BTColumn(label: 'E-Billing Date', width: 100, align: TextAlign.center, getValue: (r, i) => _dash(r.taxBillingPaymentDate)),
  BTColumn(label: 'E-Billing Signer', width: 130, getValue: (r, i) => r.taxBillingSignerName),
  BTColumn(label: 'E-Billing Status', width: 100, align: TextAlign.center, getValue: (r, i) => r.taxPaymentStatus),
  BTColumn(label: 'PPN Payment Date', width: 110, align: TextAlign.center, getValue: (r, i) => _dash(r.vatPaymentDate)),
  BTColumn(label: 'PPH 23 Amount', width: 130, align: TextAlign.right, getValue: (r, i) => _rp(r.totalPph23)),
  BTColumn(label: 'E-Bupot No.', width: 120, getValue: (r, i) => r.eBupot),
  BTColumn(label: 'E-Bupot Date', width: 90, align: TextAlign.center, getValue: (r, i) => _dash(r.eBupotDate)),
  BTColumn(label: 'Withholder Name', width: 140, getValue: (r, i) => r.eBupotCutterName),
  BTColumn(label: 'Withholder Address', width: 160, getValue: (r, i) => r.eBupotCutterAddress),
  BTColumn(label: 'Signer Name', width: 130, getValue: (r, i) => r.eBupotSignerName),
  BTColumn(label: 'Amount Paid', width: 130, align: TextAlign.right, getValue: (r, i) => _rp(r.amountPaid)),
  BTColumn(label: 'Payment Date', width: 100, align: TextAlign.center, getValue: (r, i) => _dash(r.paymentDate)),
  BTColumn(label: 'BPE No.', width: 110, align: TextAlign.center, getValue: (r, i) => r.bpeNumber),
  BTColumn(label: 'BPE Date', width: 90, align: TextAlign.center, getValue: (r, i) => _dash(r.bpeDate)),
  BTColumn(label: 'Status', width: 80, align: TextAlign.center, getValue: (r, i) => r.status),
];

double get billingTaxTableWidth =>
    billingTaxColumns.fold<double>(0, (sum, c) => sum + c.width) +
    24 +
    (billingTaxColumns.length * kBTColumnGap);

class BillingTaxReportHeaderWidget extends StatelessWidget {
  final double width;
  const BillingTaxReportHeaderWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: colorTextPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: billingTaxColumns
            .map((c) => SizedBox(
                  width: c.width,
                  child: Padding(
                    padding: const EdgeInsets.only(right: kBTColumnGap),
                    child: Text(
                      c.label,
                      textAlign: c.align,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: colorWhite),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class BillingTaxReportRowWidget extends StatelessWidget {
  final BillingTaxRow row;
  final int index;
  final double width;

  const BillingTaxReportRowWidget({super.key, required this.row, required this.index, required this.width});

  Color get _statusColor {
    switch (row.status) {
      case 'Posted':
        return colorSuccess;
      case 'Confirmed':
        return colorPrimary;
      case 'Cancelled':
        return colorError;
      case 'Closed':
        return colorGrey;
      default:
        return colorTextSubtle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: index.isEven ? colorWhite : const Color(0xFFFAFAFA),
        border: const Border(bottom: BorderSide(color: colorGreyLight, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: billingTaxColumns.map((c) {
          final isStatus = c.label == 'Status';
          return SizedBox(
            width: c.width,
            child: Padding(
              padding: const EdgeInsets.only(right: kBTColumnGap),
              child: isStatus
                  ? Center(child: _statusBadge())
                  : Text(
                      c.getValue(row, index),
                      textAlign: c.align,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 10, color: colorTextPrimary),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        row.status,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w600, color: _statusColor),
      ),
    );
  }
}