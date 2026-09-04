import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/models/attendance_late_report_models.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/presentation/controllers/attendance_late_report_controller.dart';

import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class AttendanceLateReportFilterSheet
    extends StatefulWidget {
  const AttendanceLateReportFilterSheet({
    super.key,
  });

  @override
  State<AttendanceLateReportFilterSheet>
      createState() =>
          _AttendanceLateReportFilterSheetState();
}

class _AttendanceLateReportFilterSheetState
    extends State<
        AttendanceLateReportFilterSheet> {
  late int? _employeeId;
  late int? _departmentId;

  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();

    final ctrl =
        context.read<
            AttendanceLateReportController>();

    _employeeId =
        ctrl.selectedEmployeeId;

    _departmentId =
        ctrl.selectedDepartmentId;

    _dateFrom =
        ctrl.dateFrom;

    _dateTo =
        ctrl.dateTo;
  }

  Future<void> _pickDate({
    required bool isFrom,
  }) async {
    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          (isFrom
                  ? _dateFrom
                  : _dateTo) ??
              DateTime.now(),
      firstDate:
          DateTime(2020),
      lastDate:
          DateTime(2100),
      builder: (
        ctx,
        child,
      ) =>
          Theme(
        data:
            Theme.of(ctx)
                .copyWith(
          colorScheme:
              const ColorScheme.light(
            primary:
                colorPrimary,
          ),
        ),
        child:
            child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom =
              picked;
        } else {
          _dateTo =
              picked;
        }
      });
    }
  }

  String _fmt(
    DateTime? d,
  ) =>
      d == null
          ? 'Select date'
          : '${d.year}-'
            '${d.month.toString().padLeft(2, '0')}-'
            '${d.day.toString().padLeft(2, '0')}';

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

  Widget _datePickerBox({
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration:
            BoxDecoration(
          color: colorCard,
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          border:
              Border.all(
            color: value != null
                ? colorPrimary
                : colorGreyLight,
            width:
                value != null
                    ? 1.5
                    : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons
                  .calendar_today_outlined,
              size: 16,
              color: value != null
                  ? colorPrimary
                  : colorGrey,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                _fmt(value),
                style:
                    GoogleFonts.poppins(
                  fontSize: 13,
                  color: value != null
                      ? colorTextPrimary
                      : colorGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<
        AttendanceLateReportController>(
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
                MediaQuery.of(
                          context,
                        )
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
                  'Filter Attendance Late Report',
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

                // EMPLOYEE

                CustomSearchableDropdown<
                    AttendanceLateReportEmployeeOption>(
                  value: ctrl
                          .employeeOptions
                          .where(
                            (e) =>
                                e.idEmployee ==
                                _employeeId,
                          )
                          .isEmpty
                      ? null
                      : ctrl
                          .employeeOptions
                          .firstWhere(
                            (e) =>
                                e.idEmployee ==
                                _employeeId,
                          ),
                  items:
                      ctrl.employeeOptions,
                  itemLabel:
                      (employee) =>
                          employee.employeeName,
                  onChanged: (
                    value,
                  ) {
                    setState(() {
                      _employeeId =
                          value?.idEmployee;
                    });
                  },
                  label: 'Employee',
                  hintText:
                      'All Employees',
                  clearable: true,
                ),

                const SizedBox(
                  height: 14,
                ),

                // DEPARTMENT

                CustomSearchableDropdown<
                    AttendanceLateReportDepartmentOption>(
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
                  label: 'Department',
                  hintText:
                      'All Departments',
                  clearable: true,
                ),

                const SizedBox(
                  height: 16,
                ),

                // DATE RANGE

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          _sectionLabel(
                            'From Date',
                          ),
                          _datePickerBox(
                            value:
                                _dateFrom,
                            onTap: () =>
                                _pickDate(
                              isFrom:
                                  true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          _sectionLabel(
                            'To Date',
                          ),
                          _datePickerBox(
                            value:
                                _dateTo,
                            onTap: () =>
                                _pickDate(
                              isFrom:
                                  false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            vertical: 12,
                          ),
                          side:
                              const BorderSide(
                            color:
                                colorGreyLight,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
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
                          if (_dateFrom ==
                                  null ||
                              _dateTo ==
                                  null) {
                            ScaffoldMessenger
                                .of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select From Date and To Date.',
                                ),
                              ),
                            );

                            return;
                          }

                          ctrl.selectEmployee(
                            _employeeId,
                          );

                          ctrl.selectDepartment(
                            _departmentId,
                          );

                          ctrl.setDateRange(
                            _dateFrom,
                            _dateTo,
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
                            vertical: 12,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
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
                                FontWeight.w600,
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