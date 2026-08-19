import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/presentation/controllers/transfer_out_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/models/transfer_out_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/presentation/widgets/transfer_out_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class TransferOutDetailScreen extends StatefulWidget {
  final String encryption;

  const TransferOutDetailScreen({super.key, required this.encryption});

  @override
  State<TransferOutDetailScreen> createState() => _TransferOutDetailScreenState();
}

class _TransferOutDetailScreenState extends State<TransferOutDetailScreen> {
  List<TransferOutFormItem> _formItems = [];
  final Map<int, TextEditingController> _qtyControllers = {};
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final ctrl = context.read<TransferOutController>();
    await ctrl.fetchDetail(widget.encryption);
    _rebuildFormItems();
  }

  void _rebuildFormItems() {
    final d = context.read<TransferOutController>().detail;
    if (d == null) return;
    setState(() {
      _formItems = d.items.map((i) => TransferOutFormItem.fromItem(i)).toList();
      for (final c in _qtyControllers.values) {
        c.dispose();
      }
      _qtyControllers.clear();
    });
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

  void _startEditing() {
    for (final item in _formItems) {
      _qtyControllers[item.mappingKey] =
          TextEditingController(text: item.transferredQty != null ? item.transferredQty!.toStringAsFixed(2) : '');
    }
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    _rebuildFormItems();
    setState(() => _isEditing = false);
  }

  bool _syncFromControllers() {
    for (final item in _formItems) {
      final raw = _qtyControllers[item.mappingKey]?.text.replaceAll(',', '') ?? '';
      if (raw.isEmpty) {
        _snack('Transferred quantity is required for all products.');
        return false;
      }
      final qty = double.tryParse(raw);
      if (qty == null || qty < 0) {
        _snack('Transferred quantity must be a valid number ≥ 0.');
        return false;
      }
      item.transferredQty = qty;
    }
    return true;
  }

  Future<void> _handleSave() async {
    if (!_syncFromControllers()) return;

    final ctrl = context.read<TransferOutController>();
    final f = TransferOutFormModel(items: _formItems);
    final success = await ctrl.save(widget.encryption, f);
    if (!mounted) return;

    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) {
      _rebuildFormItems();
      setState(() => _isEditing = false);
    }
  }

  Future<void> _handleValidate() async {
    if (_isEditing && !_syncFromControllers()) return;

    for (final item in _formItems) {
      if (item.transferredQty == null) {
        _snack('Please fill transferred quantity for all products (Save first if needed).');
        return;
      }
    }

    final hasBackorder = _formItems.any((i) => (i.transferredQty ?? 0) < i.demandQty);
    bool allowBackorder = false;

    if (hasBackorder) {
      final wantsBackorder = await _confirmDialog(
        'Backorder',
        'The quantity transferred is less than the quantity requested.\n\nWould you like to place a backorder for this product?',
        confirmLabel: 'Yes, Make a Backorder',
      );
      if (!mounted) return;
      allowBackorder = wantsBackorder ?? false;
    }

    final ctrl = context.read<TransferOutController>();
    final f = TransferOutFormModel(items: _formItems, allowBackorder: allowBackorder);
    final success = await ctrl.validate(widget.encryption, f);
    if (!mounted) return;

    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) {
      _rebuildFormItems();
      setState(() => _isEditing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Transfer Out', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
      ),
      body: Consumer<TransferOutController>(
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
                    onPressed: () => ctrl.fetchDetail(widget.encryption),
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

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: TransferOutDetailTabs(
                      detail: d,
                      formItems: _formItems,
                      isEditing: _isEditing,
                      qtyControllers: _qtyControllers,
                    ),
                  ),
                  if (d.canEdit)
                    _bottomBar([
                      if (!_isEditing) ...[
                        _outlineBtn('Edit', Icons.edit_outlined, _startEditing),
                        _primaryBtn('Validate', Icons.verified_outlined, _handleValidate),
                      ] else ...[
                        _outlineBtn('Cancel', Icons.close, _cancelEditing),
                        _primaryBtn('Save', Icons.save_outlined, _handleSave),
                      ],
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

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          foregroundColor: colorPrimary,
          side: const BorderSide(color: colorPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}