import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/models/payroll_summary_report_models.dart';

class PayrollSummaryReportListItem
    extends StatelessWidget {
  final PayrollSummaryReportModel item;

  const PayrollSummaryReportListItem({
    super.key,
    required this.item,
  });

  String _formatRupiah(
    double value,
  ) {
    final whole =
        value.round().toString();

    final buffer =
        StringBuffer();

    for (int i = 0;
        i < whole.length;
        i++) {
      if (i > 0 &&
          (whole.length - i) % 3 ==
              0) {
        buffer.write('.');
      }

      buffer.write(whole[i]);
    }

    return 'Rp $buffer';
  }

  Widget _moneyItem(
    String title,
    double value,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(
              fontSize: 10,
              color:
                  colorTextSubtle,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            _formatRupiah(
              value,
            ),
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style:
                GoogleFonts.poppins(
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
              color:
                  colorTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

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
                    item.department,
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
                    color:
                        colorPrimary
                            .withOpacity(
                      0.08,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: Text(
                    '${item.totalEmployee} Employees',
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
                _moneyItem(
                  'Basic Salary',
                  item.totalBasic,
                ),
                _moneyItem(
                  'Allowance',
                  item.totalAllowance,
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [
                _moneyItem(
                  'Overtime',
                  item.totalOvertime,
                ),
                _moneyItem(
                  'Deductions',
                  item.totalDeductions,
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
                color:
                    colorPrimary
                        .withOpacity(
                  0.08,
                ),
                borderRadius:
                    BorderRadius.circular(
                  8,
                ),
              ),
              child:
                  Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Text(
                    'Net Salary',
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          colorTextPrimary,
                    ),
                  ),
                  Text(
                    _formatRupiah(
                      item.totalNet,
                    ),
                    style:
                        GoogleFonts.poppins(
                      fontSize: 14,
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
}