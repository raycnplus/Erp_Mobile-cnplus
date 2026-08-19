import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/models/transfer_out_models.dart';

void showTransferOutTrackingDialog({
  required BuildContext context,
  required String productName,
  required double demandQty,
  required String? trackingMethod,
  required String uom,
  required List<TOLotSerial> lotSerials,
  required List<TOTrackingUsage> usages,
}) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tracking Detail', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(productName, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
              Text(
                'Demand: ${demandQty.toStringAsFixed(2)}   Method: ${_methodLabel(trackingMethod)}',
                style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: usages.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('No tracking data recorded.', style: GoogleFonts.poppins(color: colorGrey)),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: usages.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final u = usages[i];
                          final lot = lotSerials.where((l) => l.idProductLotSerial == u.idProductLotSerial).firstOrNull;
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(lot?.lotSerialNumber ?? 'Unknown', style: GoogleFonts.poppins(fontSize: 13)),
                            subtitle: (lot?.expirationDate != null || lot?.removalDate != null)
                                ? Text(
                                    'Exp: ${lot?.expirationDate ?? '-'}   Removal: ${lot?.removalDate ?? '-'}',
                                    style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                                  )
                                : null,
                            trailing: Text(
                              '${u.quantity.toStringAsFixed(2)} $uom',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close', style: GoogleFonts.poppins(color: colorGreyDark)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String _methodLabel(String? m) {
  if (m == 'serial_number') return 'By Serial Number';
  if (m == 'lots') return 'By Lots';
  return m ?? '-';
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}