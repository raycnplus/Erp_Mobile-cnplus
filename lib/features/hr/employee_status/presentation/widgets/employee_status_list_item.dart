import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';

class EmployeeStatusListItem extends StatelessWidget {
  final EmployeeStatusModel status;
  final VoidCallback onTap;

  const EmployeeStatusListItem({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status.isActive == 'Y';

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        side: const BorderSide(
          color: colorGreyLight,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          12,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      (isActive
                              ? colorSuccess
                              : colorGrey)
                          .withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                ),
                child: Icon(
                  Icons.badge_outlined,
                  size: 26,
                  color:
                      isActive
                          ? colorSuccess
                          : colorGrey,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.employeeStatusName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w700,
                            color:
                                colorTextPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                      decoration: BoxDecoration(
                        color:
                            (isActive
                                    ? colorSuccess
                                    : colorGrey)
                                .withOpacity(
                                  0.12,
                                ),
                        borderRadius:
                            BorderRadius.circular(
                              8,
                            ),
                      ),
                      child: Text(
                        isActive
                            ? 'Active'
                            : 'Inactive',
                        style:
                            GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  isActive
                                      ? colorSuccess
                                      : colorGrey,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: colorGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}