import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';

class EmployeeListItem extends StatelessWidget {
  final EmployeeModel employee;
  final VoidCallback onTap;

  const EmployeeListItem({super.key, required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isM = employee.gender == 'M';
    final isF = employee.gender == 'F';
    final genderColor = isM ? Colors.blue : isF ? Colors.pink : colorPrimary;

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
              CircleAvatar(
                radius: 26,
                backgroundColor: genderColor.withOpacity(0.12),
                child: Icon(
                  isM ? Icons.male : isF ? Icons.female : Icons.person_outline,
                  color: genderColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (employee.positionName != '-')
                      Text(
                        employee.positionName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: colorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (employee.departmentName != '-') ...[
                          const Icon(Icons.apartment_outlined, size: 12, color: colorTextSubtle),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              employee.departmentName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (employee.employeeStatusName != '-')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: colorSuccess.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              employee.employeeStatusName,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colorSuccess,
                              ),
                            ),
                          ),
                      ],
                    ),
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