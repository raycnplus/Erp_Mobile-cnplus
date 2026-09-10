import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/controllers/bill_payment_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/widgets/bill_payment_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'bill_payment_form_screen.dart';

class BillPaymentDetailScreen extends StatefulWidget {
  final String encryption;

  const BillPaymentDetailScreen({super.key, required this.encryption});

  @override
  State<BillPaymentDetailScreen> createState() => _BillPaymentDetailScreenState();
}

class _BillPaymentDetailScreenState extends State<BillPaymentDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<BillPaymentController>().fetchDetail(_enc));
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<bool?> _confirmDialog(String title, String content, {String confirmLabel = 'Confirm', Color? confirmColor}) =>
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(content, style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark))),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: confirmColor ?? colorPrimary, foregroundColor: colorWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text(confirmLabel, style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );

  Future<void> _handleDelete() async {
    final ctrl = context.read<BillPaymentController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Delete Draft', 'Delete this payment draft?', confirmLabel: 'Delete', confirmColor: colorError);
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<BillPaymentController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Confirm Payment', 'Confirm this payment? A payment number will be generated.', confirmLabel: 'Confirm');
    if (ok != true || !mounted) return;

    final success = await ctrl.confirm(d.encryption);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handlePost() async {
    final ctrl = context.read<BillPaymentController>();
    final d = ctrl.detail;
    if (d == null) return;

    String? journalDate;
    if (d.autoCreateJournal) {
      final picked = await showDatePicker(
        context: context, initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1), lastDate: DateTime.now(),
      );
      if (picked == null || !mounted) return;
      journalDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    } else {
      final ok = await _confirmDialog('Mark as Posted', 'Mark this payment as Posted?', confirmLabel: 'Post');
      if (ok != true || !mounted) return;
    }

    final success = await ctrl.post(d.encryption, journalTransactionDate: journalDate);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handleUnpost() async {
    final ctrl = context.read<BillPaymentController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Unpost Payment',
      'Unpost this payment and return it to Draft? The related journal entry will be removed.',
      confirmLabel: 'Unpost',
      confirmColor: Colors.green.shade700,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.unpost(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Unposted' : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handleCancel() async {
    final ctrl = context.read<BillPaymentController>();
    final d = ctrl.detail;
    if (d == null) return;

    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Payment', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
                const SizedBox(height: 8),
                Text('This action cannot be undone.', style: GoogleFonts.poppins(fontSize: 12, color: colorGrey), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonCtrl,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(labelText: 'Cancel Reason *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Close', style: GoogleFonts.poppins(color: colorGreyDark))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: colorError, foregroundColor: colorWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Cancel Payment', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;
    if (reasonCtrl.text.trim().isEmpty) { _snack('Cancel reason is required'); return; }

    final success = await ctrl.cancel(d.encryption, reasonCtrl.text.trim());
    if (!mounted) return;
    _snack(success ? 'Cancelled' : ctrl.formError ?? 'Failed', success: success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Bill Payment', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<BillPaymentController>(
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
                        MaterialPageRoute(builder: (_) => BillPaymentFormScreen(encryption: _enc)),
                      ).then((_) => ctrl.fetchDetail(_enc)),
                    ),
                  if (d.canDelete)
                    IconButton(icon: const Icon(Icons.delete_outline, color: colorError), onPressed: _handleDelete),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<BillPaymentController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoadingDetail) return const Center(child: CircularProgressIndicator(color: colorPrimary));
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
          if (ctrl.detail == null) return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));

          final d = ctrl.detail!;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(child: BillPaymentDetailTabs(detail: d)),
                  if (d.canConfirm)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BillPaymentFormScreen(encryption: _enc)),
                      ).then((_) => ctrl.fetchDetail(_enc))),
                      _primaryBtn('Confirm', Icons.check_circle_outline, _handleConfirm),
                    ]),
                  if (d.canPost)
                    _bottomBar([
                      _dangerBtn('Cancel', Icons.cancel_outlined, _handleCancel),
                      _primaryBtn('Mark as Posted', Icons.send_outlined, _handlePost),
                    ]),
                  if (d.canUnpost)
                    _bottomBar([
                      _outlineBtn('Unpost', Icons.undo_outlined, _handleUnpost),
                    ]),
                ],
              ),
              if (ctrl.isSaving)
                Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
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
      decoration: BoxDecoration(color: colorCard, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))]),
      child: Row(children: spaced),
    );
  }

  Widget _primaryBtn(String label, IconData icon, VoidCallback onTap) => ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          backgroundColor: colorPrimary, foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0,
        ),
      );

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
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
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          foregroundColor: colorError,
          side: const BorderSide(color: colorError),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}