import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/controllers/asset_disposal_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/models/asset_disposal_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/widgets/asset_disposal_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'asset_disposal_form_screen.dart';

class AssetDisposalDetailScreen extends StatefulWidget {
  final String encryption;

  const AssetDisposalDetailScreen({super.key, required this.encryption});

  @override
  State<AssetDisposalDetailScreen> createState() => _AssetDisposalDetailScreenState();
}

class _AssetDisposalDetailScreenState extends State<AssetDisposalDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<AssetDisposalController>().fetchDetail(_enc),
    );
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  void _syncEnc(AssetDisposalController ctrl) {
    final ne = ctrl.savedEncryption;
    if (ne != null && ne.isNotEmpty) setState(() => _enc = ne);
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
    final ctrl = context.read<AssetDisposalController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this asset disposal draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<AssetDisposalController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Confirm Disposal',
      'Confirm this disposal? A reference number is assigned and the current book value is locked.',
      confirmLabel: 'Confirm',
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.confirm(d.encryption);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) _syncEnc(ctrl);
  }

  Future<void> _handlePost() async {
    final ctrl = context.read<AssetDisposalController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Post Disposal',
      'Post this disposal? A journal entry is created and the asset is marked as disposed.',
      confirmLabel: 'Post',
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.post(d.encryption);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) _syncEnc(ctrl);
  }

  Future<void> _handleCancel() async {
    final ctrl = context.read<AssetDisposalController>();
    final d = ctrl.detail;
    if (d == null) return;

    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Disposal', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
              maxLength: 500,
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
            child: Text('Cancel Disposal', style: GoogleFonts.poppins()),
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
    if (success) _syncEnc(ctrl);
  }

  void _goEdit(AssetDisposalController ctrl) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AssetDisposalFormScreen(encryption: _enc)),
    ).then((_) {
      if (!mounted) return;
      final ne = ctrl.savedEncryption;
      if (ne != null && ne.isNotEmpty && ne != _enc) {
        setState(() => _enc = ne);
      } else {
        ctrl.fetchDetail(_enc);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Asset Disposal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<AssetDisposalController>(
            builder: (_, ctrl, __) {
              final d = ctrl.detail;
              if (d == null) return const SizedBox();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (d.canEdit)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _goEdit(ctrl),
                    ),
                  if (d.canDelete)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: colorError),
                      onPressed: _handleDelete,
                    ),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<AssetDisposalController>(
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
                  Expanded(child: AssetDisposalDetailTabs(detail: d)),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => _goEdit(ctrl)),
                      _primaryBtn('Confirm', Icons.check_circle_outline, _handleConfirm),
                    ]),
                  if (d.isConfirmed)
                    _bottomBar([
                      _dangerBtn('Cancel', Icons.cancel_outlined, _handleCancel),
                      _primaryBtn('Post', Icons.send_outlined, _handlePost),
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