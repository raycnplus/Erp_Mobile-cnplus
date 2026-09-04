import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/models/payroll_summary_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/presentation/controllers/payroll_summary_report_controller.dart';

import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class PayrollSummaryReportFilterSheet
    extends StatefulWidget {
  const PayrollSummaryReportFilterSheet({
    super.key,
  });

  @override
  State<PayrollSummaryReportFilterSheet>
      createState() =>
          _PayrollSummaryReportFilterSheetState();
}

class _PayrollSummaryReportFilterSheetState
    extends State<
        PayrollSummaryReportFilterSheet> {
  late int? _payrollPeriodId;
  late int? _departmentId;

  @override
  void initState() {
    super.initState();

    final ctrl =
        context.read<
            PayrollSummaryReportController>();

    _payrollPeriodId =
        ctrl.selectedPayrollPeriodId;

    _departmentId =
        ctrl.selectedDepartmentId;
  }

  Widget _sectionLabel(
    String label,
  ) =>
      Padding(
        padding:
            const EdgeInsets.only(
          bottom: 8,
        ),
        child: Text(
          label,
          style:
              const TextStyle(
            fontSize: 14,
            fontWeight:
                FontWeight.w500,
            color:
                Colors.black87,
          ),
        ),
      );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<
        PayrollSummaryReportController>(
      builder: (
        context,
        ctrl,
        child,
      ) {
        return Padding(
          padding:
              EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    16,
          ),
          child:
              SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  'Filter Payroll Summary Report',
                  style:
                      GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        colorTextPrimary,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                CustomSearchableDropdown<
                    PayrollSummaryReportPayrollPeriodOption>(
                  value: ctrl
                          .payrollPeriodOptions
                          .where(
                            (p) =>
                                p.idPayrollPeriod ==
                                _payrollPeriodId,
                          )
                          .isEmpty
                      ? null
                      : ctrl
                          .payrollPeriodOptions
                          .firstWhere(
                            (p) =>
                                p.idPayrollPeriod ==
                                _payrollPeriodId,
                          ),
                  items:
                      ctrl.payrollPeriodOptions,
                  itemLabel:
                      (period) =>
                          period.name,
                  onChanged: (
                    value,
                  ) {
                    setState(() {
                      _payrollPeriodId =
                          value
                              ?.idPayrollPeriod;
                    });
                  },
                  label:
                      'Payroll Period',
                  hintText:
                      'Select Payroll Period',
                  clearable: true,
                ),

                const SizedBox(
                  height: 14,
                ),

                CustomSearchableDropdown<
                    PayrollSummaryReportDepartmentOption>(
                  value: ctrl
                          .departmentOptions
                          .where(
                            (d) =>
                                d.idDepartment ==
                                _departmentId,
                          )
                          .isEmpty
                      ? null
                      : ctrl
                          .departmentOptions
                          .firstWhere(
                            (d) =>
                                d.idDepartment ==
                                _departmentId,
                          ),
                  items:
                      ctrl.departmentOptions,
                  itemLabel:
                      (department) =>
                          department
                              .departmentName,
                  onChanged: (
                    value,
                  ) {
                    setState(() {
                      _departmentId =
                          value
                              ?.idDepartment;
                    });
                  },
                  label:
                      'Department',
                  hintText:
                      'All Departments',
                  clearable: true,
                ),

                const SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          OutlinedButton(
                        onPressed: () {
                          ctrl.resetFilter();

                          Navigator.pop(
                            context,
                          );
                        },
                        style:
                            OutlinedButton
                                .styleFrom(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical:
                                12,
                          ),
                          side:
                              const BorderSide(
                            color:
                                colorGreyLight,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        child:
                            Text(
                          'Reset',
                          style:
                              GoogleFonts
                                  .poppins(
                            color:
                                colorTextPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                          ElevatedButton(
                        onPressed: () {
                          if (_payrollPeriodId ==
                              null) {
                            ScaffoldMessenger
                                .of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select Payroll Period.',
                                ),
                              ),
                            );

                            return;
                          }

                          ctrl
                              .selectPayrollPeriod(
                            _payrollPeriodId,
                          );

                          ctrl
                              .selectDepartment(
                            _departmentId,
                          );

                          ctrl.applyFilter();

                          Navigator.pop(
                            context,
                          );
                        },
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              colorPrimary,
                          foregroundColor:
                              colorWhite,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical:
                                12,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        child:
                            Text(
                          'Apply Filter',
                          style:
                              GoogleFonts
                                  .poppins(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}