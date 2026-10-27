import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/presentation/controllers/work_order_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/models/work_order_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/presentation/widgets/work_order_list_item.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/screens/manufacturing_order_detail_screen.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class WorkOrderListScreen extends StatefulWidget {
  const WorkOrderListScreen({super.key});

  @override
  State<WorkOrderListScreen> createState() => _State();
}

class _State extends State<WorkOrderListScreen> {
  final _moRefCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<WorkOrderController>();
      ctrl.fetchFormOptions();
      ctrl.fetchList();
    });
  }

  @override
  void dispose() {
    _moRefCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<bool?> _confirmDialog(
    String title,
    String content, {
    String confirmLabel = 'Confirm',
    Color? confirmColor,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(content, style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(confirmLabel, style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );

  Future<void> _handleStart(WorkOrderModel wo) async {
    final ctrl = context.read<WorkOrderController>();
    final ok = await _confirmDialog('Start Work Order', 'Start "${wo.operationName}"? Timer will start immediately.', confirmLabel: 'Start');
    if (ok != true || !mounted) return;

    final success = await ctrl.start(wo.idMoOperationTracking);
    if (!mounted) return;
    _snack(success ? 'Work Order started' : ctrl.actionError ?? 'Failed', success: success);
  }

  Future<void> _handlePause(WorkOrderModel wo) async {
    final ctrl = context.read<WorkOrderController>();
    final success = await ctrl.pause(wo.idMoOperationTracking);
    if (!mounted) return;
    _snack(success ? 'Work Order paused' : ctrl.actionError ?? 'Failed', success: success);
  }

  Future<void> _handleResume(WorkOrderModel wo) async {
    final ctrl = context.read<WorkOrderController>();
    final success = await ctrl.resume(wo.idMoOperationTracking);
    if (!mounted) return;
    _snack(success ? 'Work Order resumed' : ctrl.actionError ?? 'Failed', success: success);
  }

  Future<void> _handleComplete(WorkOrderModel wo) async {
    final ctrl = context.read<WorkOrderController>();
    final ok = await _confirmDialog(
      'Complete Work Order',
      'Mark "${wo.operationName}" as completed?',
      confirmLabel: 'Complete',
      confirmColor: const Color(0xFF2E7D32),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.complete(wo.idMoOperationTracking);
    if (!mounted) return;
    _snack(success ? 'Work Order completed' : ctrl.actionError ?? 'Failed', success: success);
  }

  void _openMo(WorkOrderModel wo) {
    if (wo.moEncryption == null || wo.moEncryption!.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ManufacturingOrderDetailScreen(encryption: wo.moEncryption!)),
    );
  }

  Future<void> _openFilterSheet() async {
    final ctrl = context.read<WorkOrderController>();
    _moRefCtrl.text = ctrl.filter.moReference ?? '';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Filter Work Orders', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),

                CustomSearchableDropdown<WOWorkstationOption>(
                  value: (ctrl.formOptions?.workstations ?? []).where((w) => w.id == ctrl.filter.workstationId).firstOrNull,
                  items: ctrl.formOptions?.workstations ?? [],
                  itemLabel: (w) => w.name,
                  onChanged: (v) => setSt(() => ctrl.filter.workstationId = v?.id),
                  label: 'Workstation',
                  clearable: true,
                ),
                const SizedBox(height: 12),

                _sectionLabel('Status'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _statusChip(ctrl, null, 'All'),
                    _statusChip(ctrl, 'pending', 'Pending'),
                    _statusChip(ctrl, 'in_progress', 'In Progress'),
                    _statusChip(ctrl, 'paused', 'Paused'),
                    _statusChip(ctrl, 'completed', 'Completed'),
                  ],
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _moRefCtrl,
                  onChanged: (v) => ctrl.filter.moReference = v,
                  decoration: InputDecoration(
                    labelText: 'MO Reference',
                    hintText: 'Search MO reference...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),

                CustomSearchableDropdown<WOProductOption>(
                  value: (ctrl.formOptions?.products ?? []).where((p) => p.id == ctrl.filter.productId).firstOrNull,
                  items: ctrl.formOptions?.products ?? [],
                  itemLabel: (p) => p.name,
                  onChanged: (v) => setSt(() => ctrl.filter.productId = v?.id),
                  label: 'Product',
                  clearable: true,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _datePickerField(ctx, setSt, 'From Date', ctrl.filter.dateFrom, (d) => ctrl.filter.dateFrom = d)),
                    const SizedBox(width: 10),
                    Expanded(child: _datePickerField(ctx, setSt, 'To Date', ctrl.filter.dateTo, (d) => ctrl.filter.dateTo = d)),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ctrl.filter.clear();
                          _moRefCtrl.clear();
                          setSt(() {});
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          foregroundColor: colorError,
                          side: const BorderSide(color: colorError),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Reset', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ctrl.applyFilter();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Apply Filter', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusChip(WorkOrderController ctrl, String? value, String label) {
    final isSelected = ctrl.filter.status == value || (value == null && (ctrl.filter.status == null || ctrl.filter.status!.isEmpty));
    return StatefulBuilder(
      builder: (ctx, setSt) => GestureDetector(
        onTap: () {
          ctrl.filter.status = value;
          (context as Element).markNeedsBuild();
          setSt(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorPrimary : colorBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? colorPrimary : colorGreyLight),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? colorWhite : colorTextPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _datePickerField(BuildContext ctx, StateSetter setSt, String label, DateTime? value, ValueChanged<DateTime?> onPicked) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: ctx,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 2),
          lastDate: DateTime(DateTime.now().year + 2),
          builder: (c, child) => Theme(
            data: Theme.of(c).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)),
            child: child!,
          ),
        );
        if (picked != null) {
          onPicked(picked);
          setSt(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: value != null ? colorPrimary : colorGreyLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
            const SizedBox(height: 2),
            Text(
              value != null ? '${value.day}/${value.month}/${value.year}' : '-',
              style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
        label,
        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colorTextPrimary),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Work Orders',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 20),
            ),
            Text(
              'Operation tracking & timers',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<WorkOrderController>(
            builder: (_, ctrl, __) => IconButton(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list, size: 20),
                  if (ctrl.filter.isActive) ...[
                    const SizedBox(width: 2),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: colorPrimary, shape: BoxShape.circle),
                    ),
                  ],
                ],
              ),
              onPressed: _openFilterSheet,
            ),
          ),
        ],
      ),
      body: Consumer<WorkOrderController>(
        builder: (_, ctrl, __) {
          final bar = PaginationBottomBar(
            currentPage: ctrl.currentPage,
            lastPage: ctrl.lastPage,
            hasPrev: ctrl.hasPrev,
            hasNext: ctrl.hasNext,
            onGoToPage: ctrl.goToPage,
            onPrev: ctrl.prevPage,
            onNext: ctrl.nextPage,
          );

          if (ctrl.isLoadingList && ctrl.items.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }

          if (ctrl.listError != null && ctrl.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: colorError),
                    const SizedBox(height: 16),
                    Text(ctrl.listError!, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ctrl.fetchList(page: ctrl.currentPage),
                      style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (ctrl.items.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.engineering_outlined, size: 80, color: colorGrey),
                        const SizedBox(height: 16),
                        Text('No work orders found', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle)),
                      ],
                    ),
                  ),
                ),
                bar,
              ],
            );
          }

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${ctrl.total} work orders', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                        Text('Pages ${ctrl.currentPage} of ${ctrl.lastPage}', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => ctrl.fetchList(page: ctrl.currentPage),
                      color: colorPrimary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        itemCount: ctrl.items.length,
                        itemBuilder: (_, i) {
                          final wo = ctrl.items[i];
                          return WorkOrderListItem(
                            wo: wo,
                            onTapCard: () => _openMo(wo),
                            onStart: () => _handleStart(wo),
                            onPause: () => _handlePause(wo),
                            onResume: () => _handleResume(wo),
                            onComplete: () => _handleComplete(wo),
                          );
                        },
                      ),
                    ),
                  ),
                  bar,
                ],
              ),
              if (ctrl.isActing)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator(color: colorPrimary)),
                ),
            ],
          );
        },
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}