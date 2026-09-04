import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/presentation/controllers/salespersons_report_controller.dart';

class SalespersonsReportFilterSheet extends StatefulWidget {
  const SalespersonsReportFilterSheet({super.key});

  @override
  State<SalespersonsReportFilterSheet> createState() =>
      _SalespersonsReportFilterSheetState();
}

class _SalespersonsReportFilterSheetState
    extends State<SalespersonsReportFilterSheet> {
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  // SEKARANG STRING, bukan int.
  late List<String> _selectedSalespersonNames;

  final TextEditingController _salespersonSearchController =
      TextEditingController();

  String _salespersonSearch = '';

  @override
  void initState() {
    super.initState();

    final ctrl = context.read<SalespersonsReportController>();

    _dateFrom = ctrl.dateFrom;
    _dateTo = ctrl.dateTo;

    _selectedSalespersonNames =
        List<String>.of(ctrl.selectedSalespersonNames);
  }

  @override
  void dispose() {
    _salespersonSearchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required bool isFrom,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _dateFrom : _dateTo) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: colorPrimary,
          ),
        ),
        child: child!,
      ),
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

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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

  Widget _datePickerBox({
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: colorCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: value != null ? colorPrimary : colorGreyLight,
            width: value != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: value != null ? colorPrimary : colorGrey,
            ),
            const SizedBox(width: 8),
            Text(
              _fmt(value),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: value != null
                    ? colorTextPrimary
                    : colorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalespersonsReportController>(
      builder: (context, ctrl, child) {
        final filteredOptions = _salespersonSearch.isEmpty
            ? ctrl.salespersonOptions
            : ctrl.salespersonOptions
                .where(
                  (o) => o.salespersonName
                      .toLowerCase()
                      .contains(
                        _salespersonSearch.toLowerCase(),
                      ),
                )
                .toList();

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filter Salespersons',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
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
                            CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('From Date'),
                          _datePickerBox(
                            value: _dateFrom,
                            onTap: () =>
                                _pickDate(isFrom: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('To Date'),
                          _datePickerBox(
                            value: _dateTo,
                            onTap: () =>
                                _pickDate(isFrom: false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ==================================================
                // SALESPERSON
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionLabel('Salesperson'),

                    if (_selectedSalespersonNames.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSalespersonNames = [];
                          });
                        },
                        child: Text(
                          'Clear (${_selectedSalespersonNames.length})',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                // SEARCH SALESPERSON
                TextField(
                  controller: _salespersonSearchController,
                  onChanged: (v) {
                    setState(() {
                      _salespersonSearch = v;
                    });
                  },
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Cari nama salesperson...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colorGrey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: colorGrey,
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: colorBackground,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // SALESPERSON LIST
                // ==================================================

                if (ctrl.isLoadingOptions)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                else if (filteredOptions.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Text(
                      'Tidak ada salesperson ditemukan',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorTextSubtle,
                      ),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(
                      maxHeight: 220,
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: filteredOptions.map((o) {
                          final salespersonName =
                              o.salespersonName.trim();

                          // PILIH BERDASARKAN NAMA
                          // BUKAN idUser.
                          final isSelected =
                              _selectedSalespersonNames.any(
                            (name) =>
                                name.toLowerCase() ==
                                salespersonName.toLowerCase(),
                          );

                          return FilterChip(
                            label: Text(
                              salespersonName,
                              style:
                                  GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w500,
                                color: isSelected
                                    ? colorWhite
                                    : colorTextPrimary,
                              ),
                            ),

                            selected: isSelected,

                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  final exists =
                                      _selectedSalespersonNames
                                          .any(
                                    (name) =>
                                        name
                                            .toLowerCase() ==
                                        salespersonName
                                            .toLowerCase(),
                                  );

                                  if (!exists) {
                                    _selectedSalespersonNames =
                                        List.of(
                                      _selectedSalespersonNames,
                                    )..add(
                                            salespersonName,
                                          );
                                  }
                                } else {
                                  _selectedSalespersonNames =
                                      List.of(
                                    _selectedSalespersonNames,
                                  )..removeWhere(
                                          (name) =>
                                              name
                                                  .toLowerCase() ==
                                              salespersonName
                                                  .toLowerCase(),
                                        );
                                }
                              });
                            },

                            selectedColor: colorPrimary,
                            backgroundColor:
                                colorBackground,
                            checkmarkColor: colorWhite,

                            side: BorderSide(
                              color: isSelected
                                  ? colorPrimary
                                  : colorGreyLight,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // ==================================================
                // BUTTONS
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _dateFrom = null;
                            _dateTo = null;
                            _selectedSalespersonNames =
                                [];
                          });

                          ctrl.resetFilter();

                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          side: const BorderSide(
                            color: colorGreyLight,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: GoogleFonts.poppins(
                            color: colorTextPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.setDateRange(
                            _dateFrom,
                            _dateTo,
                          );

                          ctrl.setSelectedSalespersons(
                            _selectedSalespersonNames,
                          );

                          ctrl.applyFilter();

                          Navigator.pop(context);
                        },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              colorPrimary,
                          foregroundColor: colorWhite,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        child: Text(
                          'Apply Filter',
                          style: GoogleFonts.poppins(
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