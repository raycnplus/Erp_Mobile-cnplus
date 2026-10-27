import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/controllers/ar_aging_report_controller.dart';

const Map<String, String> _kViewTypeLabels = {
  'receivable': 'Receivables (Outstanding Only)',
  'all': 'All (All Invoices)',
};

class ARAgingReportFilterSheet extends StatefulWidget {
  const ARAgingReportFilterSheet({super.key});

  @override
  State<ARAgingReportFilterSheet> createState() =>
      _ARAgingReportFilterSheetState();
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
    final picked = await pickFilterDate(
      context,
      initial: isFrom ? _dateFrom : _dateTo,
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
        final customerValues = <String>[
          kARAgingAllCustomer,
          ...customers.map((c) => c.idCustomer.toString()),
        ];
        final customerLabels = <String, String>{
          kARAgingAllCustomer: 'All Customer',
          for (final c in customers) c.idCustomer.toString(): c.customerName,
        };

        final viewTypes =
            ctrl.formOptions?.viewTypes ?? const ['receivable', 'all'];

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
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                CustomSearchableDropdown<String>(
                  value: _customerId,
                  items: customerValues,
                  itemLabel: (v) => customerLabels[v] ?? v,
                  onChanged: (val) =>
                      setState(() => _customerId = val ?? kARAgingAllCustomer),
                  label: 'Customer',
                  hintText: 'All Customer',
                  clearable: false,
                ),

                const SizedBox(height: 14),

                CustomSearchableDropdown<String>(
                  value: _viewType,
                  items: viewTypes,
                  itemLabel: (v) => _kViewTypeLabels[v] ?? v,
                  onChanged: (val) =>
                      setState(() => _viewType = val ?? 'receivable'),
                  label: 'View Type',
                  hintText: 'Select view type',
                  clearable: false,
                ),

                const SizedBox(height: 16),

                FilterDateRangeRow(
                  fromLabel: 'From Date',
                  toLabel: 'To Date',
                  placeholder: 'Any',
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                  onTapFrom: () => _pickDate(isFrom: true),
                  onTapTo: () => _pickDate(isFrom: false),
                ),

                const SizedBox(height: 20),

                FilterActionButtons(onReset: _onReset, onApply: _onApply),
              ],
            ),
          ),
        );
      },
    );
  }
}