import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/models/asset_movement_models.dart';

class AssetMovementListItem extends StatelessWidget {
  final AssetMovementModel movement;
  final VoidCallback onTap;

  const AssetMovementListItem({super.key, required this.movement, required this.onTap});

  String _fmt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _loc(String? v) => (v == null || v.isEmpty) ? '-' : v;

  @override
  Widget build(BuildContext context) {
    final asset = movement.assetCode?.isNotEmpty == true
        ? '${movement.assetCode} - ${movement.assetName ?? ''}'
        : (movement.assetName ?? '-');

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
                decoration: BoxDecoration(color: colorPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.swap_horiz_rounded, color: colorPrimary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movement.reference?.isNotEmpty == true ? movement.reference! : '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                    ),
                    Text(
                      asset,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_loc(movement.fromLocation)}  →  ${_loc(movement.toLocation)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(_fmt(movement.movementDate), style: GoogleFonts.poppins(fontSize: 11, color: colorGrey)),
            ],
          ),
        ),
      ),
    );
  }
}