import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/data/models/leave_report_models.dart';

class LeaveReportListItem
    extends StatelessWidget {
  final LeaveReportModel item;

  const LeaveReportListItem({
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
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 5,
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
                  child: Text(
                    item.leaveTypeName,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          colorPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 4,
            ),

            Row(
              children: [
                const Icon(
                  Icons.business_outlined,
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
                        TextOverflow.ellipsis,
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      color:
                          colorTextSubtle,
                    ),
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

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    'Total Request',
                    item.totalRequest
                        .toString(),
                    Icons
                        .description_outlined,
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    'Total Days',
                    _formatDays(
                      item.totalDays,
                    ),
                    Icons
                        .calendar_month_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDays(
    double value,
  ) {
    if (value == value.truncateToDouble()) {
      return value
          .toInt()
          .toString();
    }

    return value
        .toStringAsFixed(2);
  }

  Widget _infoItem(
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color:
                  colorTextSubtle,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
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
          height: 3,
        ),
        Text(
          value,
          style:
              GoogleFonts.poppins(
            fontSize: 15,
            fontWeight:
                FontWeight.w700,
            color:
                colorTextPrimary,
          ),
        ),
      ],
    );
  }
}