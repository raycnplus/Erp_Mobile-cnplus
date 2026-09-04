import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/models/attendance_overtime_report_models.dart';

class AttendanceOvertimeReportListItem
    extends StatelessWidget {
  final AttendanceOvertimeReportModel item;

  const AttendanceOvertimeReportListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.employeeName,
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
              height: 4,
            ),

            Text(
              item.department,
              style:
                  GoogleFonts.poppins(
                fontSize: 12,
                color:
                    colorTextSubtle,
              ),
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

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Clock In',
                    item.clockIn,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Clock Out',
                    item.clockOut,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Working Hours',
                    item.workHours,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Overtime',
                    item.overtime,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration:
                  BoxDecoration(
                color: colorPrimary
                    .withOpacity(
                  0.08,
                ),
                borderRadius:
                    BorderRadius.circular(
                  8,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.more_time_outlined,
                    size: 18,
                    color:
                        colorPrimary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Overtime ${item.overtime}',
                    style:
                        GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          colorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,
      children: [
        Text(
          title,
          style:
              GoogleFonts.poppins(
            fontSize: 11,
            color:
                colorTextSubtle,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style:
              GoogleFonts.poppins(
            fontSize: 13,
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