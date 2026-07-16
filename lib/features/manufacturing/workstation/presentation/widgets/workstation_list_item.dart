import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/models/workstation_models.dart';

class WorkstationListItem extends StatelessWidget {
  final WorkstationModel workstation;
  final VoidCallback onTap;

  const WorkstationListItem({super.key, required this.workstation, required this.onTap});

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
                child: const Icon(
                  Icons.precision_manufacturing_outlined,
                  color: colorPrimary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workstation.workstationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      workstation.workstationCode,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (workstation.branch?.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: colorTextSubtle),
                          const SizedBox(width: 3),
                          Text(
                            workstation.branch!,
                            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 15, color: colorGrey),
            ],
          ),
        ),
      ),
    );
  }
}