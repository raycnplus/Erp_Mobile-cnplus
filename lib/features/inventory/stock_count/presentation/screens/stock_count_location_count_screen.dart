import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/controllers/stock_count_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class StockCountLocationCountScreen extends StatefulWidget {
  final String encryption;
  final int idStockOpname;
  final int idWarehouse;
  final int idLocation;
  final String locationName;

  const StockCountLocationCountScreen({
    super.key,
    required this.encryption,
    required this.idStockOpname,
    required this.idWarehouse,
    required this.idLocation,
    required this.locationName,
  });

  @override
  State<StockCountLocationCountScreen> createState() => _State();
}

class _State extends State<StockCountLocationCountScreen> {
  List<SCFormItem> _items = [];
  final Map<int, TextEditingController> _qtyControllers = {};
  final Map<int, TextEditingController> _noteControllers = {};
  bool _isLoading = true;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    for (final c in _qtyControllers.values) c.dispose();
    for (final c in _noteControllers.values) c.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final ctrl = context.read<StockCountController>();
    try {
      final res = await ctrl.loadProducts(
        warehouseId: widget.idWarehouse,
        locationId: widget.idLocation,
        idStockOpname: widget.idStockOpname,
      );

      final products = (res['products'] as List? ?? []).map((e) => SCLocationProduct.fromJson(e)).toList();
      final existing = (res['existing_items'] as List? ?? []);

      final items = <SCFormItem>[];
      bool locked = false;

      if (existing.isNotEmpty) {
        for (final e in existing) {
          final idProduct = e['id_product'] as int? ?? int.tryParse('${e['id_product']}') ?? 0;
          final match = products.where((p) => p.idProduct == idProduct).toList();
          final productName = e['product_name']?.toString() ?? (match.isNotEmpty ? match.first.productName : 'Unknown');

          items.add(SCFormItem(
            idProduct: idProduct,
            productName: productName,
            idUom: e['id_uom'] == null ? null : int.tryParse('${e['id_uom']}'),
            uomName: e['default_uom_name']?.toString(),
            onHand: double.tryParse('${e['realtime_on_hand'] ?? e['qty_before'] ?? 0}') ?? 0,
            qtyAfter: e['qty_after'] == null ? null : double.tryParse('${e['qty_after']}'),
            notes: e['note']?.toString(),
            isExisting: true,
          ));
        }
        locked = existing.every((e) => e['status']?.toString() == 'Confirmed');
      } else {
        for (final p in products) {
          items.add(SCFormItem(
            idProduct: p.idProduct,
            productName: p.productName,
            idUom: p.defaultUom,
            uomName: p.defaultUomName,
            onHand: p.stockQty,
          ));
        }
      }

      if (!mounted) return;
      setState(() {
        _items = items;
        _isLocked = locked;
        for (final item in _items) {
          _qtyControllers[item.idProduct!] = TextEditingController(text: item.qtyAfter?.toStringAsFixed(2) ?? '');
          _noteControllers[item.idProduct!] = TextEditingController(text: item.notes ?? '');
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _snack('Failed to load products: $e');
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

  double _diff(SCFormItem item) {
    final raw = _qtyControllers[item.idProduct]?.text.replaceAll(',', '') ?? '';
    final qty = double.tryParse(raw);
    if (qty == null) return 0;
    return qty - item.onHand;
  }

  bool _syncItems() {
    for (final item in _items) {
      final raw = _qtyControllers[item.idProduct]?.text.replaceAll(',', '') ?? '';
      if (raw.isEmpty) {
        _snack('${item.productName ?? 'Product'}: counted quantity is required');
        return false;
      }
      final qty = double.tryParse(raw);
      if (qty == null) {
        _snack('${item.productName ?? 'Product'}: invalid quantity');
        return false;
      }
      item.qtyAfter = qty;
      item.notes = _noteControllers[item.idProduct]?.text.trim();
    }
    return true;
  }

  Future<void> _handleSubmit(String actionType) async {
    if (_items.isEmpty) {
      _snack('No products to count');
      return;
    }
    if (!_syncItems()) return;

    final ctrl = context.read<StockCountController>();
    final success = await ctrl.saveLocationCount(
      idStockOpname: widget.idStockOpname,
      idLocation: widget.idLocation,
      products: _items,
      actionType: actionType,
    );
    if (!mounted) return;

    final msg = actionType == 'confirm'
        ? (ctrl.successMessage ?? 'Product confirmed')
        : (ctrl.successMessage ?? 'Saved as draft');

    _snack(success ? msg : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Count - ${widget.locationName}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: colorPrimary))
          : Stack(
              children: [
                _items.isEmpty
                    ? Center(child: Text('No products found', style: GoogleFonts.poppins(color: colorGrey)))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                        itemCount: _items.length,
                        itemBuilder: (_, i) => _buildItemCard(_items[i]),
                      ),
                if (!_isLocked) _buildBottomBar(),
              ],
            ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: colorCard, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
        ]),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleSubmit('save'),
                icon: const Icon(Icons.save_outlined, size: 16),
                label: Text('Save Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorPrimary,
                  side: const BorderSide(color: colorPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _handleSubmit('confirm'),
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: Text('Confirm Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: colorWhite,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(SCFormItem item) {
    final diff = _diff(item);
    final symbol = diff > 0 ? '+' : (diff < 0 ? '-' : '=');
    final color = diff > 0 ? colorSuccess : (diff < 0 ? colorError : colorGrey);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.productName ?? '-', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('On Hand', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
                      Text('${item.onHand.toStringAsFixed(2)} ${item.uomName ?? ''}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Text(symbol, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 8),
            if (!_isLocked) ...[
              TextField(
                controller: _qtyControllers[item.idProduct],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Counted Qty',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteControllers[item.idProduct],
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ] else ...[
              Text('Counted: ${item.qtyAfter?.toStringAsFixed(2) ?? '-'}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colorPrimary)),
              if (item.notes?.isNotEmpty == true)
                Text('Note: ${item.notes}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
            ],
          ],
        ),
      ),
    );
  }
}