import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart'; // ← SATU file ini saja
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BrandListItem extends StatelessWidget {
  final BrandModel brand;
  final VoidCallback onTap;

  const BrandListItem({super.key, required this.brand, required this.onTap});

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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.workspace_premium_outlined,
                    color: colorPrimary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand.brandName,
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
                        Text(
                          brand.brandCode,
                          style: GoogleFonts.roboto(
                              color: colorTextSubtle,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
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