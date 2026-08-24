import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/models/stock_valuation_models.dart';

class StockValuationWarehouseCard extends StatelessWidget {
  final StockValuationWarehouseModel warehouse;
  final VoidCallback onTap;

  const StockValuationWarehouseCard({super.key, required this.warehouse, required this.onTap});

  String _formatRupiah(String rawValue) {
    final parts = rawValue.split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';
    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 && (wholePart.length - i) % 3 == 0) buffer.write('.');
      buffer.write(wholePart[i]);
    }
    if (decimalPart.isEmpty) return 'Rp $buffer';
    return 'Rp $buffer,$decimalPart';
  }

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.warehouse_outlined, color: colorPrimary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warehouse.warehouseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Code: ${warehouse.warehouseCode} • Branch: ${warehouse.branch ?? '-'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatRupiah(warehouse.totalValuationRaw),
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: colorPrimary),
                    ),
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