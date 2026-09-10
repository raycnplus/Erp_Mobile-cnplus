import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/models/bill_payment_models.dart';

class BillPaymentListItem extends StatelessWidget {
  final BillPaymentModel bp;
  final VoidCallback onTap;

  const BillPaymentListItem({super.key, required this.bp, required this.onTap});

  String _fmt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);

  @override
  Widget build(BuildContext context) {
    final color = Color(bp.statusColor);

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: colorGreyLight)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.payments_outlined, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bp.paymentNumber?.isNotEmpty == true ? bp.paymentNumber! : 'Draft',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                    ),
                    Text(
                      '${bp.vendorName ?? '-'} • ${bp.billNumber ?? '-'}',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(flex: 2, child: Text(_fmt(bp.paymentDate), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11, color: colorGrey))),
                        const SizedBox(width: 8),
                        Flexible(flex: 3, child: Text('Rp ${_fmtNum(bp.amountPaid)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
                child: Text(bp.status, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}