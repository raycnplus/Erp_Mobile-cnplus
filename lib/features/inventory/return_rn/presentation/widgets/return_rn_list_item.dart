import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/models/return_rn_models.dart';

class ReturnRNListItem extends StatelessWidget {
  final ReturnRNModel rrn;
  final VoidCallback onTap;

  const ReturnRNListItem({super.key, required this.rrn, required this.onTap});

  String _fmt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(rrn.statusColor);
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
                width: 48, height: 48,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.assignment_return_outlined, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rrn.documentCode ?? rrn.resolvedReference ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary)),
                    const SizedBox(height: 2),
                    if (rrn.resolvedReference?.isNotEmpty == true)
                      Text(
                        rrn.documentCode != null ? 'From: ${rrn.resolvedReference}' : 'RN: ${rrn.resolvedReference}',
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600),
                      ),
                    const SizedBox(height: 2),
                    Row(children: [
                      Flexible(child: Text(_fmt(rrn.scheduledDate), maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 11, color: colorGrey))),
                      if (rrn.poReference?.isNotEmpty == true) ...[
                        const SizedBox(width: 8),
                        Flexible(child: Text('PO: ${rrn.poReference}', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle))),
                      ],
                    ]),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
                child: Text(rrn.status, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}