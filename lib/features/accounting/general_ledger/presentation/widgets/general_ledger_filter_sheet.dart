import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/presentation/controllers/general_ledger_controller.dart';

const String _kAllCoa = 'All';

class GeneralLedgerFilterSheet extends StatefulWidget {
  const GeneralLedgerFilterSheet({super.key});

  @override
  State<GeneralLedgerFilterSheet> createState() =>
      _GeneralLedgerFilterSheetState();
}

class _GeneralLedgerFilterSheetState extends State<GeneralLedgerFilterSheet> {
  late String _coaFrom;
  late String _coaTo;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<GeneralLedgerController>();
    _coaFrom = ctrl.coaFrom;
    _coaTo = ctrl.coaTo;
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

  void _onCoaFromChanged(String? val) {
    final next = val ?? _kAllCoa;
    if (next != _kAllCoa && _coaTo != _kAllCoa && next.compareTo(_coaTo) > 0) {
      _warn('COA From cannot be greater than COA To!');
      setState(() => _coaFrom = _kAllCoa);
      return;
    }
    setState(() => _coaFrom = next);
  }

  void _onCoaToChanged(String? val) {
    final next = val ?? _kAllCoa;
    if (_coaFrom != _kAllCoa &&
        next != _kAllCoa &&
        _coaFrom.compareTo(next) > 0) {
      _warn('COA From cannot be greater than COA To!');
      setState(() => _coaTo = _kAllCoa);
      return;
    }
    setState(() => _coaTo = next);
  }

  void _onApply() {
    final ctrl = context.read<GeneralLedgerController>();

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
    if (_coaFrom != _kAllCoa &&
        _coaTo != _kAllCoa &&
        _coaFrom.compareTo(_coaTo) > 0) {
      _warn('COA From cannot be greater than COA To!');
      return;
    }

    ctrl.selectCoaFrom(_coaFrom);
    ctrl.selectCoaTo(_coaTo);
    ctrl.setDateRange(_dateFrom, _dateTo);
    ctrl.applyFilter();
    Navigator.pop(context);
  }

  void _onReset() {
    context.read<GeneralLedgerController>().resetFilter();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralLedgerController>(
      builder: (context, ctrl, child) {
        final coaOptions = ctrl.formOptions?.coaList ?? [];

        final coaValues = <String>[
          _kAllCoa,
          ...coaOptions.map((c) => c.coaNumber ?? ''),
        ];
        final coaLabels = <String, String>{
          _kAllCoa: 'All COA',
          for (final c in coaOptions) (c.coaNumber ?? ''): c.display,
        };
        String labelOf(String v) => coaLabels[v] ?? v;

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
                  'Filter General Ledger',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                CustomSearchableDropdown<String>(
                  value: _coaFrom,
                  items: coaValues,
                  itemLabel: labelOf,
                  onChanged: _onCoaFromChanged,
                  label: 'COA From',
                  hintText: 'All COA',
                  clearable: false,
                ),

                const SizedBox(height: 14),

                CustomSearchableDropdown<String>(
                  value: _coaTo,
                  items: coaValues,
                  itemLabel: labelOf,
                  onChanged: _onCoaToChanged,
                  label: 'COA To',
                  hintText: 'All COA',
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

                FilterActionButtons(
                  onReset: _onReset,
                  onApply: _onApply,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}