import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/presentation/controllers/balance_sheet_controller.dart';

class BalanceSheetFilterSheet extends StatelessWidget {
  const BalanceSheetFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<BalanceSheetController>();
    return PeriodFilterSheet(
      title: 'Filter Balance Sheet',
      filterTypes: kBalanceSheetFilterTypes,
      initialFilterType: ctrl.filterType,
      initialCustomDate: ctrl.customDate,
      initialMonth: ctrl.month,
      initialMonthYear: ctrl.monthYear,
      initialQuarter: ctrl.quarter,
      initialYear: ctrl.year,
      onSetFilterType: ctrl.setFilterType,
      onSetCustomDate: ctrl.setCustomDate,
      onSetMonth: ctrl.setMonth,
      onSetQuarter: ctrl.setQuarter,
      onSetYear: ctrl.setYear,
      onApplyFilter: ctrl.applyFilter,
      onResetFilter: ctrl.resetFilter,
    );
  }
}