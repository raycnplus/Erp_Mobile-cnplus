import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/presentation/controllers/transaction_history_controller.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/filter_sheet_widgets.dart';

class TransactionHistoryFilterSheet extends StatefulWidget {
  const TransactionHistoryFilterSheet({super.key});

  @override
  State<TransactionHistoryFilterSheet> createState() =>
      _TransactionHistoryFilterSheetState();
}

class _TransactionHistoryFilterSheetState
    extends State<TransactionHistoryFilterSheet> {
  late DateTime? _dateFrom;
  late DateTime? _dateTo;
  late String? _payment;
  late String? _status;
  late Set<int> _storeIds;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<TransactionHistoryController>();
    _dateFrom = ctrl.dateFrom;
    _dateTo = ctrl.dateTo;
    _payment = ctrl.selectedPayment;
    _status = ctrl.selectedStatus;
    _storeIds = {...ctrl.selectedStoreIds};
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

  void _apply(TransactionHistoryController ctrl) {
    if ((_dateFrom == null) != (_dateTo == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select both From Date and To Date')),
      );
      return;
    }
    if (_dateFrom != null && _dateTo != null && _dateFrom!.isAfter(_dateTo!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('From Date cannot be later than To Date')),
      );
      return;
    }

    ctrl.applyFilters(
      dateFrom: _dateFrom,
      dateTo: _dateTo,
      paymentMethod: _payment,
      status: _status,
      storeIds: _storeIds,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionHistoryController>(
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
                  'Filter Transaction History',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                CustomSearchableDropdown<String>(
                  value: ctrl.paymentMethodOptions.contains(_payment)
                      ? _payment
                      : null,
                  items: ctrl.paymentMethodOptions,
                  itemLabel: (s) => s,
                  onChanged: (val) => setState(() => _payment = val),
                  label: 'Payment Method',
                  hintText: 'All Payment Methods',
                  clearable: true,
                ),

                if (ctrl.statusOptions.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  CustomSearchableDropdown<String>(
                    value:
                        ctrl.statusOptions.contains(_status) ? _status : null,
                    items: ctrl.statusOptions,
                    itemLabel: (s) => s,
                    onChanged: (val) => setState(() => _status = val),
                    label: 'Status',
                    hintText: 'All Statuses',
                    clearable: true,
                  ),
                ],

                if (ctrl.storeOptions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const FilterSectionLabel('Stores'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in ctrl.storeOptions)
                        FilterChip(
                          label: Text(s.storeName),
                          selected: _storeIds.contains(s.idStore),
                          onSelected: (sel) => setState(() {
                            if (sel) {
                              _storeIds.add(s.idStore);
                            } else {
                              _storeIds.remove(s.idStore);
                            }
                          }),
                          selectedColor: colorPrimary.withOpacity(0.15),
                          checkmarkColor: colorPrimary,
                          backgroundColor: colorCard,
                          side: BorderSide(
                            color: _storeIds.contains(s.idStore)
                                ? colorPrimary
                                : colorGreyLight,
                          ),
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _storeIds.contains(s.idStore)
                                ? colorPrimary
                                : colorTextSubtle,
                          ),
                        ),
                    ],
                  ),
                ],

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
                  onApply: () => _apply(ctrl),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}