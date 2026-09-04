import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/pph_report/presentation/controllers/pph_report_controller.dart';

class PPHReportFilterSheet extends StatefulWidget {
  const PPHReportFilterSheet({
    super.key,
  });

  @override
  State<PPHReportFilterSheet> createState() =>
      _PPHReportFilterSheetState();
}

class _PPHReportFilterSheetState
    extends State<PPHReportFilterSheet> {
  late TextEditingController _referenceCtrl;
  late TextEditingController _taxWithholderCtrl;

  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();

    final ctrl =
        context.read<PPHReportController>();

    _referenceCtrl = TextEditingController(
      text: ctrl.reference,
    );

    _taxWithholderCtrl = TextEditingController(
      text: ctrl.taxWithholder,
    );

    _dateFrom = ctrl.dateFrom;
    _dateTo = ctrl.dateTo;
  }

  @override
  void dispose() {
    _referenceCtrl.dispose();
    _taxWithholderCtrl.dispose();

    super.dispose();
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _pickDate({
    required bool isFrom,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          (isFrom ? _dateFrom : _dateTo) ??
              DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme:
                const ColorScheme.light(
              primary: colorPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  String _fmt(DateTime? d) {
    if (d == null) {
      return 'Select date';
    }

    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // SECTION LABEL
  // ============================================================

  Widget _sectionLabel(String label) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        TextField(
          controller: controller,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: colorTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: colorGrey,
            ),
            filled: true,
            fillColor: colorCard,
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),
              borderSide:
                  const BorderSide(
                color: colorGreyLight,
              ),
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),
              borderSide:
                  const BorderSide(
                color: colorGreyLight,
              ),
            ),
            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),
              borderSide:
                  const BorderSide(
                color: colorPrimary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DATE BOX
  // ============================================================

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
        decoration: BoxDecoration(
          color: colorCard,
          borderRadius:
              BorderRadius.circular(10),
          border: Border.all(
            color: value != null
                ? colorPrimary
                : colorGreyLight,
            width: value != null
                ? 1.5
                : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: value != null
                  ? colorPrimary
                  : colorGrey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _fmt(value),
                style: GoogleFonts.poppins(
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<PPHReportController>(
      builder: (
        context,
        ctrl,
        child,
      ) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  'Filter PPH Report',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // REFERENCE
                // ==================================================

                _textField(
                  controller: _referenceCtrl,
                  label: 'Reference',
                  hint:
                      'Search by reference number',
                ),

                const SizedBox(height: 14),

                // ==================================================
                // TAX WITHHOLDER
                // ==================================================

                _textField(
                  controller:
                      _taxWithholderCtrl,
                  label:
                      'Tax Withholder Name',
                  hint:
                      'Search by customer name',
                ),

                const SizedBox(height: 16),

                // ==================================================
                // DATE RANGE
                // ==================================================

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
                            value: _dateFrom,
                            onTap: () =>
                                _pickDate(
                              isFrom: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
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
                            value: _dateTo,
                            onTap: () =>
                                _pickDate(
                              isFrom: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ==================================================
                // BUTTON
                // ==================================================

                Row(
                  children: [
                    // RESET
                    Expanded(
                      child:
                          OutlinedButton(
                        onPressed: () {
                          _referenceCtrl
                              .clear();

                          _taxWithholderCtrl
                              .clear();

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
                        child: Text(
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

                    const SizedBox(width: 12),

                    // APPLY
                    Expanded(
                      child:
                          ElevatedButton(
                        onPressed: () {
                          ctrl.setReference(
                            _referenceCtrl
                                .text
                                .trim(),
                          );

                          ctrl.setTaxWithholder(
                            _taxWithholderCtrl
                                .text
                                .trim(),
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
                        child: Text(
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