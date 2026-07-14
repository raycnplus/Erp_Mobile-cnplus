import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/models/department_models.dart';

class DepartmentListItem extends StatelessWidget {
  final DepartmentModel department;
  final VoidCallback onTap;

  const DepartmentListItem({super.key, required this.department, required this.onTap});

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
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.apartment_outlined, color: colorPrimary, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(department.departmentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary)),
                if (department.departmentDescription?.isNotEmpty == true) ...[
                  const SizedBox(height: 3),
                  Text(department.departmentDescription!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
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