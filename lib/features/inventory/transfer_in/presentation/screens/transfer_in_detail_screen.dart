import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/controllers/transfer_in_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/models/transfer_in_models.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/widgets/transfer_in_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class TransferInDetailScreen extends StatefulWidget {
  final String encryption;

  const TransferInDetailScreen({super.key, required this.encryption});

  @override
  State<TransferInDetailScreen> createState() => _TransferInDetailScreenState();
}

class _TransferInDetailScreenState extends State<TransferInDetailScreen> {
  List<TransferInFormItem> _formItems = [];
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
    final ctrl = context.read<TransferInController>();
    await ctrl.fetchDetail(widget.encryption);
    _rebuildFormItems();
  }

  void _rebuildFormItems() {
    final d = context.read<TransferInController>().detail;
    if (d == null) return;
    setState(() {
      _formItems = d.items.map((i) => TransferInFormItem.fromItem(i)).toList();
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

  void _startEditing() {
    for (final item in _formItems) {
      _qtyControllers[item.mappingKey] =
          TextEditingController(text: item.receivedQty != null ? item.receivedQty!.toStringAsFixed(2) : '');
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
        _snack('Received quantity is required for all products.');
        return false;
      }
      final qty = double.tryParse(raw);
      if (qty == null || qty < 0) {
        _snack('Received quantity must be a valid number ≥ 0.');
        return false;
      }
      if (item.transferredQty != null && qty > item.transferredQty!) {
        _snack('${item.productName ?? 'Product'}: received qty cannot exceed transferred qty (${item.transferredQty!.toStringAsFixed(2)}).');
        return false;
      }
      item.receivedQty = qty;
    }
    return true;
  }

  Future<void> _handleSave() async {
    if (!_syncFromControllers()) return;

    final ctrl = context.read<TransferInController>();
    final f = TransferInFormModel(items: _formItems);
    final success = await ctrl.save(widget.encryption, f);
    if (!mounted) return;

    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) {
      _rebuildFormItems();
      setState(() => _isEditing = false);
    }
  }

  Future<String?> _promptScrapReason() {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Discrepancy Reason', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Received quantity is less than transferred quantity for one or more products. Please provide a reason — a scrap document will be created for the missing quantity.',
              style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Reason for discrepancy',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context, ctrl.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Continue', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Future<void> _handleValidate() async {
    if (_isEditing && !_syncFromControllers()) return;

    for (final item in _formItems) {
      if (item.receivedQty == null) {
        _snack('Please fill received quantity for all products (Save first if needed).');
        return;
      }
    }

    final hasDiscrepancy = _formItems.any(
      (i) => i.transferredQty != null && (i.receivedQty ?? 0) < i.transferredQty!,
    );

    String? scrapReason;
    if (hasDiscrepancy) {
      scrapReason = await _promptScrapReason();
      if (scrapReason == null) return;
    }

    final ctrl = context.read<TransferInController>();
    final f = TransferInFormModel(items: _formItems, scrapReason: scrapReason);
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
        title: Text('Transfer In', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
      ),
      body: Consumer<TransferInController>(
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
                    child: TransferInDetailTabs(
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