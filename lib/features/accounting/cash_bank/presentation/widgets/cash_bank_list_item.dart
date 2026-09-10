import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';

class CashBankListItem extends StatelessWidget {
  final CashBankModel cb;
  final VoidCallback onTap;
  final bool selectionMode;
  final bool isSelected;
  final ValueChanged<bool>? onSelectChanged;

  const CashBankListItem({
    super.key,
    required this.cb,
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
    final color = Color(cb.statusColor);
    final canSelect = cb.status == 'Draft';

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? colorPrimary : colorGreyLight, width: isSelected ? 1.5 : 1),
      ),
      child: InkWell(
        onTap: selectionMode && canSelect ? () => onSelectChanged?.call(!isSelected) : onTap,
        onLongPress: canSelect ? () => onSelectChanged?.call(!isSelected) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              if (selectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: canSelect
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (v) => onSelectChanged?.call(v ?? false),
                          activeColor: colorPrimary,
                        )
                      : const SizedBox(width: 24),
                ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.account_balance_wallet_outlined, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cb.reference?.isNotEmpty == true ? cb.reference! : 'Draft',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                    ),
                    Text(
                      cb.description?.isNotEmpty == true ? cb.description! : cb.noteTypeLabel,
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            _fmt(cb.transactionDate),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 3,
                          child: Text(
                            'Rp ${_fmtNum(cb.total)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600),
                          ),
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
                child: Text(cb.status, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}