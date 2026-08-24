import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/presentation/controllers/invoice_report_controller.dart';

class InvoiceReportFilterSheet extends StatefulWidget {
  const InvoiceReportFilterSheet({super.key});

  @override
  State<InvoiceReportFilterSheet> createState() =>
      _InvoiceReportFilterSheetState();
}

class _InvoiceReportFilterSheetState extends State<InvoiceReportFilterSheet> {
  late String? _sourceType;
  late int? _salesPersonId;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;
  late String? _status;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<InvoiceReportController>();
    _sourceType = ctrl.selectedSourceType;
    _salesPersonId = ctrl.selectedSalesPersonId;
    _dateFrom = ctrl.dateFrom;
    _dateTo = ctrl.dateTo;
    _status = ctrl.selectedStatus;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _dateFrom : _dateTo) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
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

  String _fmt(DateTime? d) => d == null
      ? 'Select date'
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceReportController>(
      builder: (context, ctrl, child) {
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
                  'Filter Invoice',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Status',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String?>(
                  value: _status,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Statuses'),
                    ),
                    ...ctrl.statuses.map(
                      (s) =>
                          DropdownMenuItem<String?>(value: s, child: Text(s)),
                    ),
                  ],
                  onChanged: (val) => setState(() => _status = val),
                ),
                const SizedBox(height: 14),
                Text(
                  'Source Type',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String?>(
                  value: (_sourceType == null || _sourceType!.isEmpty)
                      ? null
                      : _sourceType,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ctrl.sourceTypeOptions
                      .map(
                        (s) => DropdownMenuItem<String?>(
                          value: s.value.isEmpty ? null : s.value,
                          child: Text(s.label),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _sourceType = val),
                ),
                const SizedBox(height: 14),
                Text(
                  'Sales Person',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int?>(
                  value: _salesPersonId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('All Sales Persons'),
                    ),
                    ...ctrl.salesPersonOptions.map(
                      (sp) => DropdownMenuItem<int?>(
                        value: sp.idUser,
                        child: Text(sp.namaLengkap),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => _salesPersonId = val),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From Date',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: () => _pickDate(isFrom: true),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: colorGreyLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              _fmt(_dateFrom),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: colorTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To Date',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: () => _pickDate(isFrom: false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: colorGreyLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              _fmt(_dateTo),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: colorTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ctrl.resetFilter();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: colorGreyLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: GoogleFonts.poppins(color: colorTextPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.selectSourceType(_sourceType);
                          ctrl.selectSalesPerson(_salesPersonId);
                          ctrl.setDateRange(_dateFrom, _dateTo);
                          ctrl.selectStatus(_status);
                          ctrl.applyFilter();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Apply Filter',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
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