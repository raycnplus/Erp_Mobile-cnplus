import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/models/attendance_late_report_models.dart';

class AttendanceLateReportListItem
    extends StatelessWidget {
  final AttendanceLateReportModel item;

  const AttendanceLateReportListItem({
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
            // EMPLOYEE

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

            // SCHEDULED + CLOCK IN

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Scheduled In',
                    item.scheduledIn,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Clock In',
                    item.clockIn,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            // LATE

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
                    Icons
                        .access_time_outlined,
                    size: 18,
                    color:
                        colorPrimary,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Late ${item.late}',
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