import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/controllers/cash_bank_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/widgets/cash_bank_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'cash_bank_form_screen.dart';

class CashBankDetailScreen extends StatefulWidget {
  final String encryption;

  const CashBankDetailScreen({super.key, required this.encryption});

  @override
  State<CashBankDetailScreen> createState() => _CashBankDetailScreenState();
}

class _CashBankDetailScreenState extends State<CashBankDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<CashBankController>().fetchDetail(_enc));
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
    final ctrl = context.read<CashBankController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Delete Draft', 'Delete this cash & bank draft?', confirmLabel: 'Delete', confirmColor: colorError);
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handlePost() async {
    final ctrl = context.read<CashBankController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Post Transaction', 'Post this cash & bank transaction? This will finalize the entry.', confirmLabel: 'Post');
    if (ok != true || !mounted) return;

    final f = CashBankFormModel.fromDetail(d);
    final success = await ctrl.post(f);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handleUnpost() async {
    final ctrl = context.read<CashBankController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Unpost Transaction',
      'Unpost this transaction and return it to Draft?',
      confirmLabel: 'Unpost',
      confirmColor: Colors.green.shade700,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.unpost(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Unposted' : ctrl.formError ?? 'Failed', success: success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Cash & Bank', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<CashBankController>(
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
                        MaterialPageRoute(builder: (_) => CashBankFormScreen(encryption: _enc)),
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
                    IconButton(icon: const Icon(Icons.delete_outline, color: colorError), onPressed: _handleDelete),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<CashBankController>(
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
                  Expanded(child: CashBankDetailTabs(detail: d)),
                  if (d.canPost)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CashBankFormScreen(encryption: _enc)),
                      ).then((_) => ctrl.fetchDetail(_enc))),
                      _primaryBtn('Post', Icons.send_outlined, _handlePost),
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
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          backgroundColor: colorPrimary, foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0,
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
}