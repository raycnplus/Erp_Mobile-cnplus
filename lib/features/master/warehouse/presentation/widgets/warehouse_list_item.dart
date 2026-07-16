import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class WarehouseListItem extends StatelessWidget {
  final WarehouseModel warehouse;
  final VoidCallback onTap;

  const WarehouseListItem({super.key, required this.warehouse, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warehouse_outlined,
                    color: colorPrimary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warehouse.warehouseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: colorTextPrimary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.qr_code,
                            size: 14, color: colorTextSubtle),
                        const SizedBox(width: 4),
                        Text(warehouse.warehouseCode,
                            style: GoogleFonts.roboto(
                                color: colorTextSubtle,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    if (warehouse.branch != null &&
                        warehouse.branch!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.business,
                              size: 14, color: colorAccent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(warehouse.branch!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                    color: colorTextSubtle, fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: colorGrey),
            ],
          ),
        ),
      ),
    );
  }
}