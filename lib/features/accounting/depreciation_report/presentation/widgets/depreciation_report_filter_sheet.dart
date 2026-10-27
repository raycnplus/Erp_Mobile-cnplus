import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/presentation/controllers/depreciation_report_controller.dart';

class DepreciationReportFilterSheet extends StatelessWidget {
  const DepreciationReportFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<DepreciationReportController>();
    return DateRangeFilterSheet(
      title: 'Filter Depreciation Report',
      initialDateFrom: ctrl.dateFrom,
      initialDateTo: ctrl.dateTo,
      onSetDateRange: ctrl.setDateRange,
      onApplyFilter: ctrl.applyFilter,
      onResetFilter: ctrl.resetFilter,
    );
  }
}