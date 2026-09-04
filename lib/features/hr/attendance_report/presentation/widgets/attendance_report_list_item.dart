import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/models/attendance_report_models.dart';

class AttendanceReportListItem
    extends StatelessWidget {
  final AttendanceReportModel item;

  const AttendanceReportListItem({
    super.key,
    required this.item,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      case 'leave':
        return Colors.blue;
      case 'permission':
        return Colors.purple;
      default:
        return colorTextSubtle;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final statusColor =
        _statusColor(item.status);

    return Card(
      color: colorCard,
      elevation: 2,
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        side:
            const BorderSide(
          color:
              colorGreyLight,
          width: 1,
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            // ==================================================
            // EMPLOYEE + STATUS
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Text(
                    item.employeeName,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          colorTextPrimary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration:
                      BoxDecoration(
                    color: statusColor
                        .withOpacity(
                      0.10,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      8,
                    ),
                  ),
                  child: Text(
                    item.status,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 4,
            ),

            // ==================================================
            // DEPARTMENT + DATE
            // ==================================================

            Row(
              children: [
                const Icon(
                  Icons
                      .business_outlined,
                  size: 14,
                  color:
                      colorTextSubtle,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    item.department,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          colorTextSubtle,
                    ),
                  ),
                ),
                Text(
                  item.date,
                  style:
                      GoogleFonts.poppins(
                    fontSize: 11,
                    color:
                        colorTextSubtle,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            const Divider(
              height: 1,
              color:
                  colorGreyLight,
            ),

            const SizedBox(
              height: 12,
            ),

            // ==================================================
            // CLOCK
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Clock In',
                        style:
                            GoogleFonts
                                .poppins(
                          fontSize: 11,
                          color:
                              colorTextSubtle,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        item.clockIn,
                        style:
                            GoogleFonts
                                .poppins(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              colorTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'Clock Out',
                        style:
                            GoogleFonts
                                .poppins(
                          fontSize: 11,
                          color:
                              colorTextSubtle,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        item.clockOut,
                        style:
                            GoogleFonts
                                .poppins(
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              colorTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            // ==================================================
            // WORKING / LATE / OT
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Working Hours',
                    item.workingHours,
                    Icons
                        .schedule_outlined,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Late',
                    item.late,
                    Icons
                        .access_time_outlined,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Overtime',
                    item.ot,
                    Icons
                        .more_time_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 13,
              color:
                  colorTextSubtle,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              title,
              style:
                  GoogleFonts.poppins(
                fontSize: 10,
                color:
                    colorTextSubtle,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style:
              GoogleFonts.poppins(
            fontSize: 12,
            fontWeight:
                FontWeight.w600,
            color:
                colorTextPrimary,
          ),
        ),
      ],
    );
  }
}