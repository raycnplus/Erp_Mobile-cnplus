import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/presentation/controllers/top_customer_report_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/models/top_customer_report_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';

class TopCustomerReportFilterSheet extends StatefulWidget {
  const TopCustomerReportFilterSheet({super.key});

  @override
  State<TopCustomerReportFilterSheet> createState() =>
      _TopCustomerReportFilterSheetState();
}

class _TopCustomerReportFilterSheetState
    extends State<TopCustomerReportFilterSheet> {
  late int? _idStore;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<TopCustomerReportController>();
    _idStore = ctrl.selectedStoreId;
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

  @override
  Widget build(BuildContext context) {
    return Consumer<TopCustomerReportController>(
      builder: (context, ctrl, child) {
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
                  'Filter Top Customer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                CustomSearchableDropdown<StoreOption>(
                  value: ctrl.storeOptions.where((s) => s.idStore == _idStore).isEmpty
                      ? null
                      : ctrl.storeOptions.firstWhere((s) => s.idStore == _idStore),
                  items: ctrl.storeOptions,
                  itemLabel: (s) => s.storeName,
                  onChanged: (val) => setState(() => _idStore = val?.idStore),
                  label: 'Store',
                  hintText: 'All Stores',
                  clearable: true,
                ),

                const SizedBox(height: 16),

                FilterDateRangeRow(
                  fromLabel: 'From Date',
                  toLabel: 'To Date',
                  dateFrom: _dateFrom,
                  dateTo: _dateTo,
                  onTapFrom: () => _pickDate(isFrom: true),
                  onTapTo: () => _pickDate(isFrom: false),
                ),

                const SizedBox(height: 20),

                FilterActionButtons(
                  onReset: () {
                    ctrl.resetFilter();
                    Navigator.pop(context);
                  },
                  onApply: () {
                    ctrl.selectStore(_idStore);
                    ctrl.setDateRange(_dateFrom, _dateTo);
                    ctrl.applyFilter();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}