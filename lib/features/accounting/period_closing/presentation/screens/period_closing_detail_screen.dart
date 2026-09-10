import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/controllers/period_closing_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/widgets/period_closing_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'period_closing_form_screen.dart';

class PeriodClosingDetailScreen extends StatefulWidget {
  final String encryption;

  const PeriodClosingDetailScreen({super.key, required this.encryption});

  @override
  State<PeriodClosingDetailScreen> createState() => _PeriodClosingDetailScreenState();
}

class _PeriodClosingDetailScreenState extends State<PeriodClosingDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final ctrl = context.read<PeriodClosingController>();
    await ctrl.fetchDetail(_enc);
    final d = ctrl.detail;
    if (d != null) {
      await ctrl.fetchBalanceDetail(year: d.year, type: d.type, month: d.month);
    }
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
    final ctrl = context.read<PeriodClosingController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this period closing draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handlePost() async {
    final ctrl = context.read<PeriodClosingController>();
    final d = ctrl.detail;
    if (d == null) return;

    final unresolvedCount = ctrl.balanceRows.length;
    final content = unresolvedCount > 0
        ? 'There are $unresolvedCount transaction(s) that are not posted or not balanced in this period. Posting may fail — check the Balance Check tab first.\n\nProceed anyway?'
        : 'Post and lock this period closing? This action cannot be undone.';

    final ok = await _confirmDialog(
      'Post Period Closing',
      content,
      confirmLabel: 'Post',
      confirmColor: unresolvedCount > 0 ? Colors.orange : const Color(0xFF2E7D32),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.post(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Period closing posted' : ctrl.formError ?? 'Failed to post', success: success);
    if (success) {
      await ctrl.fetchBalanceDetail(year: d.year, type: d.type, month: d.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Period Closing',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<PeriodClosingController>(
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
                        MaterialPageRoute(builder: (_) => PeriodClosingFormScreen(encryption: _enc)),
                      ).then((_) {
                        if (!mounted) return;
                        final ne = ctrl.savedEncryption;
                        if (ne != null && ne.isNotEmpty && ne != _enc) {
                          setState(() => _enc = ne);
                        } else {
                          _load();
                        }
                      }),
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
      body: Consumer<PeriodClosingController>(
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
                    onPressed: _load,
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
                    child: PeriodClosingDetailTabs(
                      detail: d,
                      balanceRows: ctrl.balanceRows,
                      isLoadingBalance: ctrl.isLoadingBalance,
                      balanceError: ctrl.balanceError,
                      onRetryBalance: () =>
                          ctrl.fetchBalanceDetail(year: d.year, type: d.type, month: d.month),
                    ),
                  ),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PeriodClosingFormScreen(encryption: _enc)),
                      ).then((_) => _load())),
                      _primaryBtn(
                        'Post',
                        Icons.lock_outline,
                        _handlePost,
                        color: const Color(0xFF2E7D32),
                      ),
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