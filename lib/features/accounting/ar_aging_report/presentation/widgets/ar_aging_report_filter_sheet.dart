import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/controllers/ar_aging_report_controller.dart';

const Map<String, String> _kViewTypeLabels = {
  'receivable': 'Receivables (Outstanding Only)',
  'all': 'All (All Invoices)',
};

class ARAgingReportFilterSheet extends StatefulWidget {
  const ARAgingReportFilterSheet({super.key});

  @override
  State<ARAgingReportFilterSheet> createState() => _ARAgingReportFilterSheetState();
}

class _ARAgingReportFilterSheetState extends State<ARAgingReportFilterSheet> {
  late String _customerId;
  late String _viewType;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<ARAgingReportController>();
    _customerId = ctrl.customerId;
    _viewType = ctrl.viewType;
    _dateFrom = ctrl.dateFrom;
    _dateTo = ctrl.dateTo;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _dateFrom : _dateTo) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => isFrom ? _dateFrom = picked : _dateTo = picked);
    }
  }

  String _fmtDate(DateTime? d) => d == null
      ? 'Any'
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _warn(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: colorError),
    );
  }

  void _onApply() {
    final ctrl = context.read<ARAgingReportController>();

    if (_dateFrom != null && _dateTo != null && _dateFrom!.isAfter(_dateTo!)) {
      _warn('From Date cannot be later than To Date!');
      return;
    }

    ctrl.selectCustomer(_customerId);
    ctrl.selectViewType(_viewType);
    ctrl.setDateRange(_dateFrom, _dateTo);
    ctrl.applyFilter();
    Navigator.pop(context);
  }

  void _onReset() {
    context.read<ARAgingReportController>().resetFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ARAgingReportController>(
      builder: (context, ctrl, child) {
        final customers = ctrl.formOptions?.customers ?? [];
        final customerValues = <String>[kARAgingAllCustomer, ...customers.map((c) => c.idCustomer.toString())];
        final customerLabels = <String, String>{
          kARAgingAllCustomer: 'All Customer',
          for (final c in customers) c.idCustomer.toString(): c.customerName,
        };

        final viewTypes = ctrl.formOptions?.viewTypes ?? const ['receivable', 'all'];

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
                  'Filter AR Aging Report',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: colorTextPrimary),
                ),
                const SizedBox(height: 16),
                CustomSearchableDropdown<String>(
                  value: _customerId,
                  items: customerValues,
                  itemLabel: (v) => customerLabels[v] ?? v,
                  onChanged: (val) => setState(() => _customerId = val ?? kARAgingAllCustomer),
                  label: 'Customer',
                  hintText: 'Select customer',
                  clearable: false,
                ),
                const SizedBox(height: 14),
                CustomSearchableDropdown<String>(
                  value: _viewType,
                  items: viewTypes,
                  itemLabel: (v) => _kViewTypeLabels[v] ?? v,
                  onChanged: (val) => setState(() => _viewType = val ?? 'receivable'),
                  label: 'View Type',
                  hintText: 'Select view type',
                  clearable: false,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From Date', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: () => _pickDate(isFrom: true),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: colorGreyLight),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(_fmtDate(_dateFrom), style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('To Date', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: () => _pickDate(isFrom: false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: colorGreyLight),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(_fmtDate(_dateTo), style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
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
                        onPressed: _onReset,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: colorGreyLight),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Reset', style: GoogleFonts.poppins(color: colorTextPrimary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onApply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Apply Filter', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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