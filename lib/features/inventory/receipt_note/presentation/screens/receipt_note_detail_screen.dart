import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/controllers/receipt_note_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/models/receipt_note_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/widgets/receipt_note_detail_tabs.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/widgets/receipt_note_tracking_dialog.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'receipt_note_form_screen.dart';

int? _currentUserId(BuildContext context) => null;

class ReceiptNoteDetailScreen extends StatefulWidget {
  final String encryption;

  const ReceiptNoteDetailScreen({super.key, required this.encryption});

  @override
  State<ReceiptNoteDetailScreen> createState() => _ReceiptNoteDetailScreenState();
}

class _ReceiptNoteDetailScreenState extends State<ReceiptNoteDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final ctrl = context.read<ReceiptNoteController>();
    await ctrl.fetchDetail(_enc);
    final d = ctrl.detail;
    if (d?.isWaitingApproval == true) ctrl.loadSteps(d!.idReceiptNote);
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
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this receipt note draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.idReceiptNote);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Confirm Receipt Note', 'Confirm this receipt note?', confirmLabel: 'Confirm');
    if (ok != true || !mounted) return;

    final f = ReceiptNoteFormModel.fromDetail(d);
    final success = await ctrl.confirm(f);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleCancel() async {
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Receipt Note', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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

  Future<void> _handleValidate() async {
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    final missingTracking = d.items.where((i) => i.trackingRequired && i.trackingData.isEmpty).toList();
    if (missingTracking.isNotEmpty) {
      final names = missingTracking.map((i) => i.productName ?? 'Product').join(', ');
      _snack('Please fill Lot/Serial Number tracking first for: $names');
      return;
    }

    final f = ReceiptNoteFormModel.fromDetail(d);
    final qtyCtrls = <int, TextEditingController>{};
    for (final item in f.items) {
      final trackingItem = d.items.firstWhere((i) => i.idProduct == item.idProduct);
      final defaultQty = trackingItem.trackingRequired
          ? _trackingTotal(trackingItem)
          : (item.receivedQty ?? item.demandQty);
      qtyCtrls[item.idProduct!] = TextEditingController(text: defaultQty.toStringAsFixed(2));
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Validate Receipt Note', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the quantity actually received for each product.',
                  style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                ),
                const SizedBox(height: 12),
                ...f.items.map((item) {
                  final trackingItem = d.items.firstWhere((i) => i.idProduct == item.idProduct);
                  final isLocked = trackingItem.trackingRequired;
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
                              'Determined by tracking lines (${_trackingTotal(trackingItem).toStringAsFixed(2)})',
                              style: GoogleFonts.poppins(fontSize: 10, color: colorPrimary),
                            ),
                          ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: qtyCtrls[item.idProduct!],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.end,
                          readOnly: isLocked,
                          enabled: !isLocked,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Received Qty',
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

    for (final item in f.items) {
      item.receivedQty = double.tryParse(qtyCtrls[item.idProduct!]!.text.replaceAll(',', '')) ?? 0;
    }

    for (final item in f.items) {
      if ((item.receivedQty ?? 0) > item.demandQty) {
        _snack('${item.productName ?? 'Product'}: received qty cannot exceed demand (${item.demandQty.toStringAsFixed(2)})');
        return;
      }
    }

    await _submitValidate(f);
  }

  double _trackingTotal(ReceiptNoteItem item) =>
      item.trackingData.fold<double>(0, (sum, t) => sum + t.remainingQuantity);

  Future<void> _submitValidate(ReceiptNoteFormModel f, {bool? allowBackorder}) async {
    if (allowBackorder == null) {
      final shortItems = f.items.where((i) => (i.receivedQty ?? 0) < i.demandQty).toList();
      if (shortItems.isNotEmpty) {
        final wantsBackorder = await _confirmDialog(
          'Backorder',
          'The quantity received is less than requested. Create a backorder for the remaining quantity?',
          confirmLabel: 'Yes, Create Backorder',
        );
        if (!mounted) return;
        allowBackorder = wantsBackorder ?? false;
      } else {
        allowBackorder = false;
      }
    }

    final ctrl = context.read<ReceiptNoteController>();
    final success = await ctrl.validateReceipt(f, allowBackorder: allowBackorder);
    if (!mounted) return;

    if (!success) {
      _snack(ctrl.formError ?? 'Failed');
      return;
    }

    _snack(ctrl.successMessage ?? 'Validated', success: true);
  }

  Future<void> _handleOpenTracking(ReceiptNoteDetailModel d, int index) async {
    final item = d.items[index];
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ReceiptNoteTrackingDialog(
        item: item,
        status: d.status,
        isViewMode: d.isDone,
      ),
    );
    if (saved == true && mounted) {
      context.read<ReceiptNoteController>().fetchDetail(_enc);
    }
  }

  Future<void> _handleCreateReturn() async {
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Create Return',
      'Create a return receipt note from this document?',
      confirmLabel: 'Create Return',
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.createReturn(d.encryption);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleApprove() async {
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Approve',
      'Approve this receipt note?',
      confirmLabel: 'Approve',
      confirmColor: const Color(0xFF2E7D32),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.approve(d.idReceiptNote);
    if (!mounted) return;
    _snack(success ? 'Approved' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleReject() async {
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Reject',
      'Reject this receipt note?',
      confirmLabel: 'Reject',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.reject(d.idReceiptNote);
    if (!mounted) return;
    _snack(success ? 'Rejected' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleViewSteps() async {
    final ctrl = context.read<ReceiptNoteController>();
    final d = ctrl.detail;
    if (d == null) return;

    await ctrl.loadSteps(d.idReceiptNote);
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

  void _handleReturnFromForm(ReceiptNoteController ctrl) {
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
          'Receipt Note',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<ReceiptNoteController>(
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
                        MaterialPageRoute(builder: (_) => ReceiptNoteFormScreen(encryption: _enc)),
                      ).then((_) {
                        if (!mounted) return;
                        final ne = ctrl.savedEncryption;
                        if (ne != null && ne.isNotEmpty && ne != _enc) {
                          setState(() => _enc = ne);   
                        } else {
                          ctrl.fetchDetail(_enc);
                        }
                      }),
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
      body: Consumer<ReceiptNoteController>(
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
                  Expanded(child: ReceiptNoteDetailTabs(detail: d, onOpenTracking: (index) => _handleOpenTracking(d, index),)),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReceiptNoteFormScreen(encryption: _enc)),
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
                  if (d.isDone && !d.hasReturn)
                    _bottomBar([
                      _primaryBtn('Create Return', Icons.undo_outlined, _handleCreateReturn),
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