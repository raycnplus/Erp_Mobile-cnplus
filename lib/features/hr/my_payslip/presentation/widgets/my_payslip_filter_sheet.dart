import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/controllers/my_payslip_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class MyPaySlipFilterSheet extends StatefulWidget {
  const MyPaySlipFilterSheet({
    super.key,
  });

  @override
  State<MyPaySlipFilterSheet> createState() =>
      _MyPaySlipFilterSheetState();
}

class _MyPaySlipFilterSheetState
    extends State<MyPaySlipFilterSheet> {
  late String? _status;
  late int? _year;

  @override
  void initState() {
    super.initState();

    final ctrl = context.read<MyPaySlipController>();

    _status = ctrl.selectedStatus;
    _year = ctrl.selectedYear;
  }

  // ============================================================
  // LABEL
  // ============================================================

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

  @override
  Widget build(BuildContext context) {
    return Consumer<MyPaySlipController>(
      builder: (
        context,
        ctrl,
        child,
      ) {
        final currentYear = DateTime.now().year;

        final years = List.generate(
          6,
          (index) => currentYear - index,
        );

        final statuses = const [
          'Approved',
          'Paid',
        ];

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom +
                16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  'Filter Payslip',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // ==================================================
                // STATUS
                // ==================================================

                CustomSearchableDropdown<String>(
                  value: statuses.contains(_status)
                      ? _status
                      : null,
                  items: statuses,
                  itemLabel: (status) =>
                      status.toString(),
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  label: 'Status',
                  hintText: 'All Statuses',
                  clearable: true,
                ),

                const SizedBox(height: 14),

                // ==================================================
                // YEAR
                // ==================================================

                CustomSearchableDropdown<int>(
                  value: years.contains(_year)
                      ? _year
                      : null,
                  items: years,
                  itemLabel: (year) =>
                      year.toString(),
                  onChanged: (value) {
                    setState(() {
                      _year = value;
                    });
                  },
                  label: 'Year',
                  hintText: 'All Years',
                  clearable: true,
                ),

                const SizedBox(height: 20),

                // ==================================================
                // BUTTON
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
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
                          ctrl.setStatus(_status);
                          ctrl.setYear(_year);
                          ctrl.applyFilter();

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              colorPrimary,
                          foregroundColor:
                              colorWhite,
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