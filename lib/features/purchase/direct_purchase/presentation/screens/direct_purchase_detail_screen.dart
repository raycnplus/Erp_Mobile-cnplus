import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/controllers/direct_purchase_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/models/direct_purchase_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/widgets/direct_purchase_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'direct_purchase_form_screen.dart';

class DirectPurchaseDetailScreen extends StatefulWidget {
  final String encryption;

  const DirectPurchaseDetailScreen({super.key, required this.encryption});

  @override
  State<DirectPurchaseDetailScreen> createState() => _DirectPurchaseDetailScreenState();
}

class _DirectPurchaseDetailScreenState extends State<DirectPurchaseDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final ctrl = context.read<DirectPurchaseController>();
    await ctrl.fetchDetail(_enc);
    final d = ctrl.detail;
    if (d?.isWaitingApproval == true) ctrl.loadSteps(d!.idDirectPurchase);
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
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this direct purchase draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.idDirectPurchase);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Confirm Direct Purchase', 'Confirm this direct purchase?', confirmLabel: 'Confirm');
    if (ok != true || !mounted) return;

    final f = DirectPurchaseFormModel.fromDetail(d);
    final success = await ctrl.save(f, status: 'confirm');
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handleValidate() async {
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Validate Direct Purchase',
      'Validate this direct purchase? A Receipt Note will be created.',
      confirmLabel: 'Validate',
    );
    if (ok != true || !mounted) return;

    final f = DirectPurchaseFormModel.fromDetail(d);
    final success = await ctrl.save(f, status: 'validate');
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handleCancel() async {
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Direct Purchase', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
            const SizedBox(height: 8),
            Text('This action cannot be undone.', style: GoogleFonts.poppins(fontSize: 12, color: colorGrey)),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Cancel Reason *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
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

    final success = await ctrl.cancel(d.idDirectPurchase, reasonCtrl.text.trim());
    if (!mounted) return;
    _snack(success ? 'Cancelled' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleClose() async {
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Close Direct Purchase', 'Close this direct purchase?', confirmLabel: 'Close');
    if (ok != true || !mounted) return;

    final success = await ctrl.close(d.idDirectPurchase);
    if (!mounted) return;
    _snack(success ? 'Closed' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleApprove() async {
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Approve',
      'Approve this direct purchase?',
      confirmLabel: 'Approve',
      confirmColor: const Color(0xFF2E7D32),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.approve(d.idDirectPurchase);
    if (!mounted) return;
    _snack(success ? 'Approved' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleReject() async {
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Reject',
      'Reject this direct purchase?',
      confirmLabel: 'Reject',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.reject(d.idDirectPurchase);
    if (!mounted) return;
    _snack(success ? 'Rejected' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleViewSteps() async {
    final ctrl = context.read<DirectPurchaseController>();
    final d = ctrl.detail;
    if (d == null) return;

    await ctrl.loadSteps(d.idDirectPurchase);
    if (!mounted) return;

    final steps = ctrl.approvalSteps;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Approval Steps', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: steps == null
            ? Text('Failed to load', style: GoogleFonts.poppins())
            : _buildStepsContent(steps),
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

  void _handleReturnFromForm(DirectPurchaseController ctrl) {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isApproved ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 16,
                            color: isApproved ? Colors.green : colorGrey,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              name ?? '-',
                              softWrap: true,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
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

  bool _canApprove(Map<String, dynamic>? steps) {
    if (steps == null) return false;
    final data = steps['data'] as Map<String, dynamic>?;
    return data != null && data['can_approve'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Direct Purchase',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<DirectPurchaseController>(
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
                        MaterialPageRoute(builder: (_) => DirectPurchaseFormScreen(encryption: _enc)),
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
      body: Consumer<DirectPurchaseController>(
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
                  Text(
                    ctrl.detailError!,
                    style: GoogleFonts.poppins(color: colorError),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ctrl.fetchDetail(_enc),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: colorWhite,
                    ),
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
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: DirectPurchaseDetailTabs(detail: d),
                  ),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DirectPurchaseFormScreen(encryption: _enc)),
                      ).then((_) => _handleReturnFromForm(ctrl))),
                      _primaryBtn('Confirm', Icons.check_circle_outline, _handleConfirm),
                    ]),
                  if (d.isWaitingApproval)
                    _bottomBar([
                      _outlineBtn('View Steps', Icons.account_tree_outlined, _handleViewSteps),
                      if (_canApprove(ctrl.approvalSteps)) ...[
                        _dangerBtn('Reject', Icons.close, _handleReject),
                        _primaryBtn('Approve', Icons.check, _handleApprove, color: const Color(0xFF2E7D32)),
                      ],
                    ]),
                  if (d.isConfirmed)
                    _bottomBar([
                      _dangerBtn('Cancel', Icons.cancel_outlined, _handleCancel),
                      _primaryBtn('Validate', Icons.verified_outlined, _handleValidate),
                    ]),
                  if (d.isDone && d.canClose)
                    _bottomBar([
                      _primaryBtn('Close', Icons.lock_outline, _handleClose),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(children: spaced),
    );
  }

  Widget _primaryBtn(String label, IconData icon, VoidCallback onTap, {Color? color}) =>
      ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          backgroundColor: color ?? colorPrimary,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      );

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          foregroundColor: colorPrimary,
          side: const BorderSide(color: colorPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  Widget _dangerBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          foregroundColor: colorError,
          side: const BorderSide(color: colorError),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}