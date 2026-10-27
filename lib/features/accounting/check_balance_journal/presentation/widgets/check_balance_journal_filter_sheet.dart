import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/presentation/controllers/check_balance_journal_controller.dart';

class CheckBalanceJournalFilterSheet extends StatelessWidget {
  const CheckBalanceJournalFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<CheckBalanceJournalController>();
    return DateRangeFilterSheet(
      title: 'Filter Check Balance Journal',
      initialDateFrom: ctrl.dateFrom,
      initialDateTo: ctrl.dateTo,
      onSetDateRange: ctrl.setDateRange,
      onApplyFilter: ctrl.applyFilter,
      onResetFilter: ctrl.resetFilter,
    );
  }
}