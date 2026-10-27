import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';

class PrinterConfigListItem extends StatelessWidget {
  final PrinterConfigModel printer;
  final VoidCallback onTap;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const PrinterConfigListItem({
    super.key,
    required this.printer,
    required this.onTap,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.print_outlined, color: colorPrimary, size: 24),
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
                            printer.printerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                          ),
                        ),
                        if (printer.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: colorPrimary.withOpacity(0.3)),
                            ),
                            child: Text(
                              'Default',
                              style: GoogleFonts.poppins(fontSize: 10, color: colorPrimary, fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                    if (printer.description?.isNotEmpty == true)
                      Text(
                        printer.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: colorGrey, size: 20),
                onSelected: (v) {
                  if (v == 'default') onSetDefault();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  if (!printer.isDefault)
                    const PopupMenuItem(
                      value: 'default',
                      child: Row(
                        children: [
                          Icon(Icons.star_outline, size: 18, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Set as Default'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: colorError),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}