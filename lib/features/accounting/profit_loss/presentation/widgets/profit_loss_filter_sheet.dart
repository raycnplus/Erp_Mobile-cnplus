import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/presentation/controllers/profit_loss_controller.dart';

class ProfitLossFilterSheet extends StatelessWidget {
  const ProfitLossFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ProfitLossController>();
    return PeriodFilterSheet(
      title: 'Filter Profit & Loss',
      filterTypes: kProfitLossFilterTypes,
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