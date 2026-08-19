import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/controllers/stock_count_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/widgets/stock_count_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'stock_count_location_list_screen.dart';

class StockCountDetailScreen extends StatefulWidget {
  final String encryption;
  const StockCountDetailScreen({super.key, required this.encryption});

  @override
  State<StockCountDetailScreen> createState() => _State();
}

class _State extends State<StockCountDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final ctrl = context.read<StockCountController>();
    await ctrl.fetchDetail(widget.encryption);
    final d = ctrl.detail;
    if (d?.isWaitingApproval == true) ctrl.loadSteps(d!.idStockOpname);
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

  Future<void> _handleConfirm() async {
    final ctrl = context.read<StockCountController>();
    final d = ctrl.detail;
    if (d == null || d.idWarehouse == null) return;

    final ok = await _confirmDialog('Confirm Stock Count', 'Confirm this stock count?');
    if (ok != true || !mounted) return;

    final success = await ctrl.confirmHeader(
      idStockOpname: d.idStockOpname,
      idWarehouse: d.idWarehouse!,
      idLocation: d.idLocation,
      selectBy: d.selectBy,
      note: d.note,
    );
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) await ctrl.fetchDetail(widget.encryption);
  }

  Future<void> _handleValidate() async {
    final ctrl = context.read<StockCountController>();
    final d = ctrl.detail;
    if (d == null || d.idWarehouse == null) return;

    final ok = await _confirmDialog('Validate Stock Count', 'This will finalize stock quantities. Continue?', confirmColor: const Color(0xFF2E7D32));
    if (ok != true || !mounted) return;

    final success = await ctrl.validate(idStockOpname: d.idStockOpname, idWarehouse: d.idWarehouse!);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) await ctrl.fetchDetail(widget.encryption);
  }

  Future<void> _handleCancel() async {
    final ctrl = context.read<StockCountController>();
    final d = ctrl.detail;
    if (d == null) return;

    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Stock Count', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: InputDecoration(labelText: 'Cancel Reason *', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Close', style: GoogleFonts.poppins(color: colorGreyDark))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: colorError, foregroundColor: colorWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Cancel Count', style: GoogleFonts.poppins()),
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

  Future<void> _handleDelete() async {
    final ctrl = context.read<StockCountController>();
    final d = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog('Delete Draft', 'Delete this stock count draft?', confirmLabel: 'Delete', confirmColor: colorError);
    if (ok != true || !mounted) return;
    final success = await ctrl.remove(d.idStockOpname);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  void _goToLocationList() {
    final ctrl = context.read<StockCountController>();
    final d = ctrl.detail;
    if (d == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StockCountLocationListScreen(encryption: d.encryption)),
    ).then((_) => ctrl.fetchDetail(widget.encryption));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Stock Count', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<StockCountController>(
            builder: (_, ctrl, __) {
              final d = ctrl.detail;
              if (d == null) return const SizedBox();
              return Row(mainAxisSize: MainAxisSize.min, children: [
                if (d.canDelete)
                  IconButton(icon: const Icon(Icons.delete_outline, color: colorError), onPressed: _handleDelete),
                const SizedBox(width: 4),
              ]);
            },
          ),
        ],
      ),
      body: Consumer<StockCountController>(
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
                    onPressed: () => ctrl.fetchDetail(widget.encryption),
                    style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final d = ctrl.detail;
          if (d == null) return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: StockCountDetailTabs(
                      detail: d,
                      onOpenLocationList: _goToLocationList,
                    ),
                  ),
                  if (d.isDraft || d.canCancel || d.canValidate) _buildBottomBar(d),
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

  Widget _buildBottomBar(dynamic d) {
    final children = <Widget>[];
    if (d.isDraft) {
      children.add(_primaryBtn('Confirm', Icons.check_circle_outline, _handleConfirm));
    }
    if (d.canCancel) {
      children.add(_dangerBtn('Cancel', Icons.cancel_outlined, _handleCancel));
    }
    if (d.canValidate) {
      children.add(_primaryBtn('Validate', Icons.verified_outlined, _handleValidate));
    }

    final expanded = children.map((w) => Expanded(child: w)).toList();
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

  Widget _primaryBtn(String label, IconData icon, VoidCallback onTap) => ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          backgroundColor: colorPrimary,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      );

  Widget _dangerBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          foregroundColor: colorError,
          side: const BorderSide(color: colorError),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}