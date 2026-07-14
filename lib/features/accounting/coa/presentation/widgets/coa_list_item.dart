import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';

class CoaListItem extends StatelessWidget {
  final CoaModel coa;
  final VoidCallback onTap;

  const CoaListItem({super.key, required this.coa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isHeader = coa.isHeaderAccount;
    final indent = coa.level * 16.0;
    final typeColor = coa.type == 'DEBIT'
        ? Colors.blue.shade700
        : Colors.purple.shade700;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: indent, bottom: 4),
        decoration: BoxDecoration(
          color: isHeader ? colorPrimary.withOpacity(0.05) : colorCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isHeader
                ? colorPrimary.withOpacity(0.2)
                : colorGreyLight,
            width: isHeader ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              if (coa.level > 0) ...[
                Container(
                  width: 3,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorPrimary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isHeader
                      ? colorPrimary.withOpacity(0.12)
                      : colorBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isHeader
                      ? Icons.account_tree_outlined
                      : Icons.receipt_long_outlined,
                  color: isHeader ? colorPrimary : colorGrey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          coa.coaNumber,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isHeader ? colorPrimary : colorTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            coa.type,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      coa.coaName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight:
                            isHeader ? FontWeight.w600 : FontWeight.normal,
                        color: colorTextPrimary,
                      ),
                    ),
                    Text(
                      coa.reportType,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: colorTextSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 13, color: colorGrey),
            ],
          ),
        ),
      ),
    );
  }
}