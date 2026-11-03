import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';

class StoreSessionReportFilterSheet extends StatefulWidget {
  const StoreSessionReportFilterSheet({super.key});

  @override
  State<StoreSessionReportFilterSheet> createState() =>
      _StoreSessionReportFilterSheetState();
}

class _StoreSessionReportFilterSheetState
    extends State<StoreSessionReportFilterSheet> {
  late int? _idStore;
  late String? _status;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<StoreSessionReportController>();
    _idStore = ctrl.selectedStoreId;
    _status = ctrl.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreSessionReportController>(
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
                  'Filter Store Session',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                CustomSearchableDropdown<SessionStoreOption>(
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

                const SizedBox(height: 14),

                CustomSearchableDropdown<String>(
                  value: ctrl.statusOptions.contains(_status) ? _status : null,
                  items: ctrl.statusOptions,
                  itemLabel: (s) => s,
                  onChanged: (val) => setState(() => _status = val),
                  label: 'Status',
                  hintText: 'All Statuses',
                  clearable: true,
                ),

                const SizedBox(height: 20),

                FilterActionButtons(
                  onReset: () {
                    ctrl.resetFilter();
                    Navigator.pop(context);
                  },
                  onApply: () {
                    ctrl.selectStore(_idStore);
                    ctrl.selectStatus(_status);
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