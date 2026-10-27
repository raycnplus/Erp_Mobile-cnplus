import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/presentation/controllers/cash_bank_report_controller.dart';

const String _kAll = 'All';

class CashBankReportFilterSheet extends StatefulWidget {
  const CashBankReportFilterSheet({super.key});

  @override
  State<CashBankReportFilterSheet> createState() =>
      _CashBankReportFilterSheetState();
}

class _CashBankReportFilterSheetState extends State<CashBankReportFilterSheet> {
  late String _accountId;
  late String _type;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<CashBankReportController>();
    _accountId = ctrl.accountId;
    _type = ctrl.type;
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
    final ctrl = context.read<CashBankReportController>();

    if (_dateFrom == null) {
      _warn('From Date is required!');
      return;
    }
    if (_dateTo == null) {
      _warn('To Date is required!');
      return;
    }
    if (_dateFrom!.isAfter(_dateTo!)) {
      _warn('From Date cannot be later than To Date!');
      return;
    }

    ctrl.selectAccount(_accountId);
    ctrl.selectType(_type);
    ctrl.setDateRange(_dateFrom, _dateTo);
    ctrl.applyFilter();
    Navigator.pop(context);
  }

  void _onReset() {
    context.read<CashBankReportController>().resetFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CashBankReportController>(
      builder: (context, ctrl, child) {
        final accountOptions = ctrl.formOptions?.accounts ?? [];
        final noteTypes = ctrl.formOptions?.noteTypes ?? const ['BANK', 'CASH'];

        final accountValues = <String>[
          _kAll,
          ...accountOptions.map((a) => a.idCoa.toString()),
        ];
        final accountLabels = <String, String>{
          _kAll: 'All Account',
          for (final a in accountOptions) a.idCoa.toString(): a.display,
        };

        final typeValues = <String>[_kAll, ...noteTypes];
        final typeLabels = <String, String>{
          _kAll: 'All',
          for (final t in noteTypes) t: t[0] + t.substring(1).toLowerCase(),
        };

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
                  'Filter Cash & Bank Report',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                CustomSearchableDropdown<String>(
                  value: _accountId,
                  items: accountValues,
                  itemLabel: (v) => accountLabels[v] ?? v,
                  onChanged: (val) =>
                      setState(() => _accountId = val ?? _kAll),
                  label: 'Account (Cash / Bank)',
                  hintText: 'All Account',
                  clearable: false,
                ),

                const SizedBox(height: 14),

                CustomSearchableDropdown<String>(
                  value: _type,
                  items: typeValues,
                  itemLabel: (v) => typeLabels[v] ?? v,
                  onChanged: (val) => setState(() => _type = val ?? _kAll),
                  label: 'Type',
                  hintText: 'All',
                  clearable: false,
                ),

                const SizedBox(height: 16),

                FilterDateRangeRow(
                  fromLabel: 'From Date *',
                  toLabel: 'To Date *',
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