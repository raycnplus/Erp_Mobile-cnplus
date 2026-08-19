import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/controllers/internal_transfer_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/models/internal_transfer_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/widgets/internal_transfer_detail_tabs.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/widgets/internal_transfer_tracking_dialog.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'internal_transfer_form_screen.dart';

int? _currentUserId(BuildContext context) => null;

class InternalTransferDetailScreen extends StatefulWidget {
  final String encryption;

  const InternalTransferDetailScreen({super.key, required this.encryption});

  @override
  State<InternalTransferDetailScreen> createState() => _InternalTransferDetailScreenState();
}

class _InternalTransferDetailScreenState extends State<InternalTransferDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final ctrl = context.read<InternalTransferController>();
    await ctrl.fetchDetail(_enc);
    final d = ctrl.detail;
    if (d?.isWaitingApproval == true) ctrl.loadSteps(d!.idInternalTransfer);
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

  Future<void> _handleDelete() async {
    final ctrl = context.read<InternalTransferController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this internal transfer draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.idInternalTransfer);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<InternalTransferController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Confirm Internal Transfer', 'Confirm this internal transfer?', confirmLabel: 'Confirm');
    if (ok != true || !mounted) return;

    final f = InternalTransferFormModel.fromDetail(d);
    final success = await ctrl.confirm(f);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handleCancel() async {
    final ctrl = context.read<InternalTransferController>();
    final d = ctrl.detail;
    if (d == null) return;

    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Internal Transfer', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
                const SizedBox(height: 8),
                Text(
                  'This will release reserved stock and cannot be undone.',
                  style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Cancel Reason *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Close', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Cancel Order', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;
    if (reasonCtrl.text.trim().isEmpty) {
      _snack('Cancel reason is required');
      return;
    }

    final success = await ctrl.cancel(d.encryption, reasonCtrl.text.trim());
    if (!mounted) return;
    _snack(success ? 'Cancelled' : ctrl.formError ?? 'Failed', success: success);
  }

  double _trackingTotal(InternalTransferItem item) =>
      item.trackingData.fold<double>(0, (sum, t) => sum + t.quantity);

  Future<void> _handleValidate() async {
    final ctrl = context.read<InternalTransferController>();
    final d = ctrl.detail;
    if (d == null) return;

    final missingTracking = d.items.where((i) => i.trackingRequired && i.trackingData.isEmpty).toList();
    if (missingTracking.isNotEmpty) {
      final names = missingTracking.map((i) => i.productName ?? 'Product').join(', ');
      _snack('Please fill Lot/Serial Number tracking first for: $names');
      return;
    }

    final qtyCtrls = <int, TextEditingController>{};
    for (final item in d.items) {
      final hasTracking = item.trackingData.isNotEmpty;
      final defaultQty = hasTracking ? _trackingTotal(item) : (item.transferredQty ?? item.demandQty);
      qtyCtrls[item.idInternalTransferItem] = TextEditingController(text: defaultQty.toStringAsFixed(2));
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Validate Internal Transfer', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the quantity actually transferred for each product.',
                  style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                ),
                const SizedBox(height: 12),
                ...d.items.map((item) {
                  final isLocked = item.trackingData.isNotEmpty;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? 'Product',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Demand: ${item.demandQty.toStringAsFixed(2)} ${item.uomName ?? ''}',
                          style: GoogleFonts.poppins(fontSize: 10, color: colorGrey),
                        ),
                        if (isLocked)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'Determined by tracking lines (${_trackingTotal(item).toStringAsFixed(2)})',
                              style: GoogleFonts.poppins(fontSize: 10, color: colorPrimary),
                            ),
                          ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: qtyCtrls[item.idInternalTransferItem],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.end,
                          readOnly: isLocked,
                          enabled: !isLocked,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Transferred Qty',
                            filled: isLocked,
                            fillColor: isLocked ? colorGreyLight.withOpacity(0.3) : null,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Validate', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final items = <InternalTransferFormItem>[];
    for (final item in d.items) {
      final raw = qtyCtrls[item.idInternalTransferItem]!.text.replaceAll(',', '');
      final transferred = double.tryParse(raw) ?? 0;

      if (transferred > item.demandQty) {
        _snack('${item.productName ?? 'Product'}: transferred qty cannot exceed demand (${item.demandQty.toStringAsFixed(2)})');
        return;
      }

      items.add(InternalTransferFormItem(
        idProduct: item.idProduct,
        uomId: item.unitOfMeasure,
        demandQty: item.demandQty, 
        transferredQty: transferred,
      ));
    }

    await _submitValidate(d, items);
  }

  Future<void> _submitValidate(
    InternalTransferDetailModel d,
    List<InternalTransferFormItem> items, {
    bool? allowBackorder,
  }) async {
    if (allowBackorder == null) {
      final shortItems = <String>[];
      for (int i = 0; i < items.length; i++) {
        if ((items[i].transferredQty) < d.items[i].demandQty) {
          shortItems.add(d.items[i].productName ?? 'Product ${d.items[i].idProduct}');
        }
      }
      if (shortItems.isNotEmpty) {
        final wantsBackorder = await _confirmDialog(
          'Backorder',
          'Transferred quantity is less than demand for:\n${shortItems.join(', ')}\n\n'
              'Would you like to create a backorder for the remaining quantity?',
          confirmLabel: 'Yes, Create Backorder',
        );
        if (!mounted) return;
        allowBackorder = wantsBackorder ?? false;
      } else {
        allowBackorder = false;
      }
    }

    final ctrl = context.read<InternalTransferController>();
    final f = InternalTransferFormModel(
      idInternalTransfer: d.idInternalTransfer,
      encryption: d.encryption,
      allowBackorder: allowBackorder,
      items: items,
    );

    final success = await ctrl.validate(f);
    if (!mounted) return;

    if (!success) {
      _snack(ctrl.formError ?? 'Failed');
      return;
    }
    _snack(ctrl.successMessage ?? 'Validated', success: true);
  }

  Future<void> _handleOpenTracking(InternalTransferDetailModel d, int index) async {
    final ctrl = context.read<InternalTransferController>();
    final item = d.items[index];
    final current = item.trackingData
        .map((t) => {
              'id_product_lot_serial': t.idProductLotSerial,
              'lot_number': t.lotNumber,
              'quantity': t.quantity,
            })
        .toList();

    final result = await showInternalTransferTrackingDialog(
      context: context,
      item: item,
      sourceLocation: d.sourceLocation,
      initialTracking: current,
      readOnly: !d.isConfirmed,
    );
    if (result == null || !mounted) return;

    final ok = await ctrl.saveTracking(
      idInternalTransferItem: item.idInternalTransferItem,
      trackingData: result,
    );
    if (!mounted) return;

    if (ok) {
      _snack(ctrl.successMessage ?? 'Tracking saved', success: true);
    } else {
      _snack(ctrl.formError ?? 'Failed to save tracking');
    }
  }

  Future<void> _handleApprove() async {
    final ctrl = context.read<InternalTransferController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Approve',
      'Approve this internal transfer?',
      confirmLabel: 'Approve',
      confirmColor: const Color(0xFF2E7D32),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.approve(d.idInternalTransfer);
    if (!mounted) return;
    _snack(success ? 'Approved' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleReject() async {
    final ctrl = context.read<InternalTransferController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Reject',
      'Reject this internal transfer?',
      confirmLabel: 'Reject',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.reject(d.idInternalTransfer);
    if (!mounted) return;
    _snack(success ? 'Rejected' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleViewSteps() async {
    final ctrl = context.read<InternalTransferController>();
    final d = ctrl.detail;
    if (d == null) return;

    await ctrl.loadSteps(d.idInternalTransfer);
    if (!mounted) return;

    final steps = ctrl.approvalSteps;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Approval Steps', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: steps == null ? Text('Failed to load', style: GoogleFonts.poppins()) : _buildStepsContent(steps),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: colorPrimary)),
          ),
        ],
      ),
    );
  }

  void _handleReturnFromForm(InternalTransferController ctrl) {
    if (!mounted) return;
    final ne = ctrl.savedEncryption;
    if (ne != null && ne.isNotEmpty && ne != _enc) {
      setState(() => _enc = ne);
    } else {
      ctrl.fetchDetail(_enc);
    }
  }

  Widget _buildStepsContent(Map<String, dynamic> steps) {
    final data = steps['data'] as Map<String, dynamic>?;
    if (data == null || data['has_rule'] != true) {
      return Text('No approval rule configured.', style: GoogleFonts.poppins());
    }
    final levels = (data['levels'] as List? ?? []);
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          children: levels.map<Widget>((lv) {
            final lvNo = lv['level_no'];
            final min = lv['min_approver'];
            final members = (lv['members'] as List? ?? []);
            final approved = (lv['approved'] as List? ?? []).map((v) => v.toString()).toList();
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $lvNo — Min $min approver(s)',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    ...members.map((m) {
                      final id = (m is Map) ? m['id']?.toString() : m.toString();
                      final name = (m is Map) ? m['nama_lengkap']?.toString() ?? id : id;
                      final isApproved = approved.contains(id);
                      return Row(
                        children: [
                          Icon(
                            isApproved ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 16,
                            color: isApproved ? Colors.green : colorGrey,
                          ),
                          const SizedBox(width: 6),
                          Text(name ?? '-', style: GoogleFonts.poppins(fontSize: 12)),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _canActOnCurrentLevel(Map<String, dynamic>? steps, int? me) {
    if (steps == null || me == null) return false;
    final data = steps['data'] as Map<String, dynamic>?;
    if (data == null || data['has_rule'] != true || data['status'] != 'PENDING') return false;

    final currentLevel = data['current_level'];
    final levels = (data['levels'] as List? ?? []);
    final lv = levels.cast<Map<String, dynamic>?>().firstWhere(
          (l) => l != null && l['level_no'] == currentLevel,
          orElse: () => null,
        );
    if (lv == null) return false;

    final members = (lv['members'] as List? ?? [])
        .map((m) => (m is Map) ? m['id']?.toString() : m.toString())
        .toSet();
    final approved = (lv['approved'] as List? ?? []).map((v) => v.toString()).toSet();
    final rejected = (lv['rejected'] as List? ?? []).map((v) => v.toString()).toSet();
    final minApprover = (lv['min_approver'] as int?) ?? 1;

    final meStr = me.toString();
    final levelPassed = approved.length >= minApprover;

    return members.contains(meStr) && !approved.contains(meStr) && !rejected.contains(meStr) && !levelPassed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Internal Transfer',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<InternalTransferController>(
            builder: (_, ctrl, __) {
              final d = ctrl.detail;
              if (d == null) return const SizedBox();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (d.canEdit)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => InternalTransferFormScreen(encryption: _enc)),
                      ).then((_) => _handleReturnFromForm(ctrl)),
                    ),
                  if (d.canDelete)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: colorError),
                      onPressed: _handleDelete,
                    ),
                  if (d.isWaitingApproval)
                    IconButton(
                      icon: const Icon(Icons.account_tree_outlined),
                      onPressed: _handleViewSteps,
                    ),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<InternalTransferController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(ctrl.detailError!, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ctrl.fetchDetail(_enc),
                    style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (ctrl.detail == null) {
            return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));
          }

          final d = ctrl.detail!;
          final canApprove = _canActOnCurrentLevel(ctrl.approvalSteps, _currentUserId(context));

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: InternalTransferDetailTabs(
                      detail: d,
                      onOpenTracking: (index) => _handleOpenTracking(d, index),
                    ),
                  ),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => InternalTransferFormScreen(encryption: _enc)),
                      ).then((_) => _handleReturnFromForm(ctrl))),
                      _primaryBtn('Confirm', Icons.check_circle_outline, _handleConfirm),
                    ]),
                  if (d.isWaitingApproval)
                    _bottomBar([
                      _outlineBtn('View Steps', Icons.account_tree_outlined, _handleViewSteps),
                      if (canApprove) ...[
                        _dangerBtn('Reject', Icons.close, _handleReject),
                        _primaryBtn('Approve', Icons.check, _handleApprove, color: const Color(0xFF2E7D32)),
                      ],
                    ]),
                  if (d.isConfirmed)
                    _bottomBar([
                      _dangerBtn('Cancel', Icons.cancel_outlined, _handleCancel),
                      _primaryBtn('Validate', Icons.verified_outlined, _handleValidate),
                    ]),
                ],
              ),
              if (ctrl.isSaving)
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

  Widget _bottomBar(List<Widget> children) {
    final expanded = children.map((w) => w is Expanded ? w : Expanded(child: w)).toList();
    final spaced = <Widget>[];
    for (int i = 0; i < expanded.length; i++) {
      spaced.add(expanded[i]);
      if (i < expanded.length - 1) spaced.add(const SizedBox(width: 10));
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: colorCard,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(children: spaced),
    );
  }

  Widget _primaryBtn(String label, IconData icon, VoidCallback onTap, {Color? color}) => ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    label: Text(
      label,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    ),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      backgroundColor: color ?? colorPrimary,
      foregroundColor: colorWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
    ),
  );

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    label: Text(
      label,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    ),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      foregroundColor: colorPrimary,
      side: const BorderSide(color: colorPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  Widget _dangerBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16),
    label: Text(
      label,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    ),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      foregroundColor: colorError,
      side: const BorderSide(color: colorError),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}