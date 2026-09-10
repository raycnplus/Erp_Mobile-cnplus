import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/models/invoice_payment_models.dart';

class InvoicePaymentListItem extends StatelessWidget {
  final InvoicePaymentModel ip;
  final VoidCallback onTap;
  final bool selectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectChanged;

  const InvoicePaymentListItem({
    super.key,
    required this.ip,
    required this.onTap,
    this.selectionMode = false,
    this.isSelected = false,
    this.onSelectChanged,
  });

  String _fmt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);

  @override
  Widget build(BuildContext context) {
    final color = Color(ip.statusColor);

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? colorPrimary : colorGreyLight, width: isSelected ? 1.5 : 1),
      ),
      child: InkWell(
        onTap: selectionMode ? () => onSelectChanged?.call(!isSelected) : onTap,
        onLongPress: onSelectChanged != null ? () => onSelectChanged?.call(!isSelected) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              if (selectionMode) ...[
                Checkbox(
                  value: isSelected,
                  activeColor: colorPrimary,
                  onChanged: onSelectChanged,
                ),
                const SizedBox(width: 4),
              ] else
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.request_quote_outlined, color: color, size: 24),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ip.paymentNumber?.isNotEmpty == true ? ip.paymentNumber! : 'Draft',
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: colorGreyLight.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                          child: Text(ip.invoiceType, style: GoogleFonts.poppins(fontSize: 9, color: colorTextSubtle, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    Text(
                      '${ip.customerName ?? '-'} • ${ip.invoiceNumber ?? '-'}',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(flex: 2, child: Text(_fmt(ip.paymentDate), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11, color: colorGrey))),
                        const SizedBox(width: 8),
                        Flexible(flex: 3, child: Text('Rp ${_fmtNum(ip.amountPaid)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ],
                ),
              ),
              if (!selectionMode)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
                  child: Text(ip.status, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}