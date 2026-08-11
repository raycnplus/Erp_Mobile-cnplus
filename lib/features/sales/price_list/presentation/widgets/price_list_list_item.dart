import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';

class PriceListListItem extends StatelessWidget {
  final PriceListModel priceList;
  final VoidCallback onTap;

  const PriceListListItem({super.key, required this.priceList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = priceList.isActive == 'Y';
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
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.price_check_outlined, color: colorPrimary, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  priceList.priceListName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isActive ? colorSuccess : colorGrey).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isActive ? 'Active' : 'Inactive',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isActive ? colorSuccess : colorGrey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.inventory_2_outlined, size: 13, color: colorTextSubtle),
                  const SizedBox(width: 4),
                  Text('${priceList.itemCount} products', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                ]),
                if (priceList.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 3),
                  Text(
                    priceList.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                  ),
                ],
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, size: 15, color: colorGrey),
          ]),
        ),
      ),
    );
  }
}