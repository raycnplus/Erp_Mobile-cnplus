import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/controllers/delivery_note_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/models/delivery_note_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class _DNLocationProduct {
  final int idProduct;
  final String productName;
  final double stockQty;

  _DNLocationProduct({required this.idProduct, required this.productName, this.stockQty = 0});

  factory _DNLocationProduct.fromMap(Map<String, dynamic> m) => _DNLocationProduct(
        idProduct: int.tryParse(m['id_product'].toString()) ?? 0,
        productName: m['product_name']?.toString() ?? '',
        stockQty: double.tryParse(m['stock_qty']?.toString() ?? '0') ?? 0,
      );

  @override
  bool operator ==(Object o) => o is _DNLocationProduct && o.idProduct == idProduct;
  @override
  int get hashCode => idProduct.hashCode;
}

class DeliveryNoteFormFields extends StatefulWidget {
  final DeliveryNoteFormModel formData;
  final DeliveryNoteFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const DeliveryNoteFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<DeliveryNoteFormFields> createState() => _State();
}

class _State extends State<DeliveryNoteFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _deliveryCtrl = TextEditingController();
  final _sourceDocCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final Map<String, TextEditingController> _itemCtrls = {};

  TextEditingController _itemCtrl(int i, String field, double value) {
    final key = '${i}_$field';
    if (!_itemCtrls.containsKey(key)) {
      _itemCtrls[key] = TextEditingController(text: value > 0 ? value.toStringAsFixed(2) : '');
    }
    return _itemCtrls[key]!;
  }

  void _removeItemCtrls(int i) {
    final toRemove = _itemCtrls.keys.where((k) => k.startsWith('${i}_')).toList();
    for (final k in toRemove) {
      _itemCtrls[k]!.dispose();
      _itemCtrls.remove(k);
    }
    for (int j = i + 1; j <= widget.formData.items.length; j++) {
      for (final field in ['demandQty']) {
        final oldKey = '${j}_$field';
        final newKey = '${j - 1}_$field';
        if (_itemCtrls.containsKey(oldKey)) _itemCtrls[newKey] = _itemCtrls.remove(oldKey)!;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _deliveryCtrl.text = widget.formData.deliveryAddress;
    _sourceDocCtrl.text = widget.formData.sourceDocument ?? '';
    _notesCtrl.text = widget.formData.notes ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    _deliveryCtrl.dispose();
    _sourceDocCtrl.dispose();
    _notesCtrl.dispose();
    for (final c in _itemCtrls.values) c.dispose();
    super.dispose();
  }

  DeliveryNoteFormOptions? get _opts => widget.formOptions;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.deliveryAddress = _deliveryCtrl.text.trim().isEmpty
        ? 'Customer Location'
        : _deliveryCtrl.text.trim();
    widget.formData.sourceDocument =
        _sourceDocCtrl.text.trim().isEmpty ? null : _sourceDocCtrl.text.trim();
    widget.formData.notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();

    if (widget.formData.idCustomer == null) { _snack('Please select customer'); return false; }
    if (widget.formData.sourceWarehouse == null) { _snack('Please select source warehouse'); return false; }
    if (widget.formData.sourceLocation == null) { _snack('Please select source location'); return false; }
    if (widget.formData.items.isEmpty) { _snack('Please add at least one product'); return false; }

    for (int i = 0; i < widget.formData.items.length; i++) {
      final item = widget.formData.items[i];
      if (item.idProduct == null) { _snack('Row ${i + 1}: Please select product'); return false; }
      if (item.uomId == null) { _snack('Row ${i + 1}: Please select unit of measure'); return false; }
      if (item.demandQty <= 0) { _snack('Row ${i + 1}: Quantity must be > 0'); return false; }
    }
    return true;
  }

  Future<void> _addProduct() async {
    final ctrl = context.read<DeliveryNoteController>();
    if (widget.formData.sourceLocation == null) {
      _snack('Please select source location first');
      return;
    }

    final rawProducts = await ctrl.fetchProductsByLocation(widget.formData.sourceLocation!);
    if (!mounted) return;

    final products = rawProducts.map(_DNLocationProduct.fromMap).toList();

    if (products.isEmpty) {
      _snack('No available products in this location');
      return;
    }

    _DNLocationProduct? selected;
    DNUomOption? selectedUom;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text('Add Product', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSearchableDropdown<_DNLocationProduct>(
                  value: selected,
                  items: products,
                  itemLabel: (p) => '${p.productName} (${p.stockQty.toStringAsFixed(0)} on hand)',
                  onChanged: (v) => setSt(() {
                    selected = v;
                    if (v != null) {
                      final defaultUomId = _opts?.defaultUomPerProduct[v.idProduct];
                      selectedUom = defaultUomId != null
                          ? _opts?.uoms.where((u) => u.id == defaultUomId).firstOrNull
                          : null;
                    } else {
                      selectedUom = null;
                    }
                  }),
                  label: 'Product',
                  isRequired: true,
                  clearable: false,
                ),
                const SizedBox(height: 12),
                if (selected != null)
                  CustomSearchableDropdown<DNUomOption>(
                    value: selectedUom,
                    items: _opts?.uoms ?? [],
                    itemLabel: (u) => u.name,
                    onChanged: (v) => setSt(() => selectedUom = v),
                    label: 'Unit of Measure',
                    isRequired: true,
                    clearable: false,
                  ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
            ElevatedButton(
              onPressed: () {
                if (selected == null) { _snack('Please select product'); return; }
                if (selectedUom == null) { _snack('Please select unit of measure'); return; }
                Navigator.pop(ctx, {'product': selected, 'uom': selectedUom});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Add', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      final prod = result['product'] as _DNLocationProduct;
      final uom = result['uom'] as DNUomOption;

      final alreadyAdded = widget.formData.items.any((i) => i.idProduct == prod.idProduct);
      if (alreadyAdded) {
        _snack('This product is already added');
        return;
      }

      setState(() {
        widget.formData.items.add(DeliveryNoteFormItem(
          idProduct: prod.idProduct,
          productName: prod.productName,
          uomId: uom.id,
          uomName: uom.name,
          onHand: prod.stockQty,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: [
            const Tab(text: 'Header'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(child: Text('Products', overflow: TextOverflow.ellipsis)),
                  if (widget.formData.items.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.formData.items.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: colorWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildHeaderTab(),
              _buildProductsTab(),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  List<DNLocationOption> _getFilteredLocations() {
    if (_opts == null || widget.formData.sourceWarehouse == null) return [];
    return _opts!.locationsForWarehouse(widget.formData.sourceWarehouse!);
  }

  Widget _buildHeaderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchableDropdown<DNCustomerOption>(
            key: ValueKey('cust_${widget.formData.idCustomer}_${_opts?.customers.length}'),
            value: _opts?.customers.where((c) => c.id == widget.formData.idCustomer).firstOrNull,
            items: _opts?.customers ?? [],
            itemLabel: (c) => c.name,
            onChanged: (v) => setState(() => widget.formData.idCustomer = v?.id),
            isRequired: true,
            label: 'Customer',
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<DNWarehouseOption>(
            key: ValueKey('wh_${widget.formData.sourceWarehouse}_${_opts?.warehouses.length}'),
            value: _opts?.warehouses.where((w) => w.id == widget.formData.sourceWarehouse).firstOrNull,
            items: _opts?.warehouses ?? [],
            itemLabel: (w) => w.name,
            onChanged: (v) => setState(() {
              widget.formData.sourceWarehouse = v?.id;
              widget.formData.sourceLocation = null;
              widget.formData.items.clear();
            }),
            isRequired: true,
            label: 'Source Warehouse',
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<DNLocationOption>(
            key: ValueKey('loc_${widget.formData.sourceLocation}_${widget.formData.sourceWarehouse}'),
            value: _getFilteredLocations()
                .where((l) => l.id == widget.formData.sourceLocation)
                .firstOrNull,
            items: _getFilteredLocations(),
            itemLabel: (l) => l.name,
            onChanged: (v) => setState(() {
              widget.formData.sourceLocation = v?.id;
              widget.formData.items.clear();
            }),
            isRequired: true,
            label: 'Source Location',
            clearable: false,
          ),
          const SizedBox(height: 14),

          _sectionLabel('Scheduled Date'),
          _datePicker(
            value: widget.formData.scheduledDate,
            hint: 'Select scheduled date (optional)',
            onPicked: (d) => setState(() => widget.formData.scheduledDate = d),
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _deliveryCtrl,
            label: 'Delivery Address',
            hintText: 'Enter delivery address',
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _sourceDocCtrl,
            label: 'Source Document',
            hintText: 'Reference document (optional)',
            maxLength: 20,
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _notesCtrl,
            label: 'Notes',
            hintText: 'Write note for this delivery note (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    final ctrl = context.read<DeliveryNoteController>();
    return Column(
      children: [
        Expanded(
          child: widget.formData.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 64, color: colorGrey),
                      const SizedBox(height: 12),
                      Text('No products added', style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle)),
                      const SizedBox(height: 4),
                      Text(
                        'Select source location first, then add products',
                        style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: widget.formData.sourceLocation != null ? _addProduct : null,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text('Add Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  itemCount: widget.formData.items.length,
                  itemBuilder: (_, i) => _buildItemCard(i),
                ),
        ),
        if (widget.formData.items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: ctrl.isLoadingProducts ? null : _addProduct,
                icon: ctrl.isLoadingProducts
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
                      )
                    : const Icon(Icons.add, size: 18),
                label: Text('Add Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: colorPrimary,
                  side: const BorderSide(color: colorPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        if (widget.formData.items.isNotEmpty) _buildTotalsFooter(),
      ],
    );
  }

  Widget _buildItemCard(int i) {
    final item = widget.formData.items[i];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.productName ?? 'Product ${i + 1}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: colorError, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() {
                    _removeItemCtrls(i);
                    widget.formData.items.removeAt(i);
                  }),
                ),
              ],
            ),
            if (item.onHand > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.warehouse_outlined, size: 12, color: colorGrey),
                    const SizedBox(width: 4),
                    Text(
                      'On Hand: ${_fmtNum(item.onHand)}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: item.onHand < item.demandQty && item.demandQty > 0 ? colorError : colorGrey,
                      ),
                    ),
                  ],
                ),
              ),
            CustomSearchableDropdown<DNUomOption>(
              key: ValueKey('uom_${i}_${item.uomId}'),
              value: _opts?.uoms.where((u) => u.id == item.uomId).firstOrNull,
              items: _opts?.uoms ?? [],
              itemLabel: (u) => u.name,
              onChanged: (v) => setState(() {
                item.uomId = v?.id;
                item.uomName = v?.name;
              }),
              label: 'Unit of Measure',
              isRequired: true,
              clearable: false,
            ),
            const SizedBox(height: 8),
            _numFieldItem(
              ctrl: _itemCtrl(i, 'demandQty', item.demandQty),
              label: 'Demand Qty',
              required: true,
              onChanged: (v) => setState(() => item.demandQty = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsFooter() {
    final totalItems = widget.formData.items.length;
    final totalQty = widget.formData.items.fold<double>(0, (s, i) => s + i.demandQty);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      color: colorCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$totalItems product(s)', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
          Text(
            'Total Qty: ${_fmtNum(totalQty)}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colorCard,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSave(); },
            icon: widget.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              widget.formData.isEditMode ? 'Update Delivery Note' : 'Save Delivery Note',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
      );

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
      );

  Widget _datePicker({
    required DateTime? value,
    required String hint,
    required ValueChanged<DateTime> onPicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 1),
          lastDate: DateTime(DateTime.now().year + 3),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)),
            child: child!,
          ),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: value != null ? colorPrimary : colorGreyLight,
            width: value != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: value != null ? colorPrimary : colorGrey),
            const SizedBox(width: 8),
            Text(
              value != null ? DateFormat('d MMM yyyy').format(value) : hint,
              style: GoogleFonts.poppins(fontSize: 13, color: value != null ? colorTextPrimary : colorGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numFieldItem({
    required TextEditingController ctrl,
    required String label,
    bool required = false,
    required Function(double) onChanged,
  }) =>
      CustomFormInput(
        controller: ctrl,
        label: label,
        required: required,
        hintText: '0',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
      );

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}