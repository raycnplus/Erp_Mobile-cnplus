import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/presentation/controllers/cash_flow_controller.dart';

class CashFlowFilterSheet extends StatelessWidget {
  const CashFlowFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<CashFlowController>();
    return PeriodFilterSheet(
      title: 'Filter Cash Flow',
      filterTypes: kCashFlowFilterTypes,
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