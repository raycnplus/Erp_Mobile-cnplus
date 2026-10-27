import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/presentation/controllers/trial_balance_controller.dart';

class TrialBalanceFilterSheet extends StatelessWidget {
  const TrialBalanceFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<TrialBalanceController>();
    return DateRangeFilterSheet(
      title: 'Filter Trial Balance',
      initialDateFrom: ctrl.dateFrom,
      initialDateTo: ctrl.dateTo,
      onSetDateRange: ctrl.setDateRange,
      onApplyFilter: ctrl.applyFilter,
      onResetFilter: ctrl.resetFilter,
    );
  }
}