import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/models/purchase_request_models.dart';

class PurchaseRequestListItem extends StatelessWidget {
  final PurchaseRequestModel pr;
  final VoidCallback onTap;

  const PurchaseRequestListItem({
    super.key,
    required this.pr,
    required this.onTap,
  });

  String _fmt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(pr.statusColor);
    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight),
      ),
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
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.shopping_cart_outlined, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pr.reference ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: colorTextPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        if (pr.requestedByName?.isNotEmpty == true) ...[
                          const Icon(Icons.person_outline, size: 12, color: colorGrey),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              pr.requestedByName!,
                              style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (pr.warehouseName?.isNotEmpty == true) ...[
                          const Icon(Icons.warehouse_outlined, size: 11, color: colorGrey),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              pr.warehouseName!,
                              style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today_outlined, size: 11, color: colorGrey),
                        const SizedBox(width: 3),
                        Text(
                          _fmt(pr.requestDate),
                          style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  pr.status,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}