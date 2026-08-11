import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/controllers/purchase_order_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/models/purchase_order_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_switch.dart';

class PurchaseOrderFormFields extends StatefulWidget {
  final PurchaseOrderFormModel formData;
  final PurchaseOrderFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const PurchaseOrderFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<PurchaseOrderFormFields> createState() => _State();
}

class _State extends State<PurchaseOrderFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _noteCtrl = TextEditingController();
  final _rfqCtrl  = TextEditingController();

  final Map<String, TextEditingController> _itemCtrls  = {};
  final Map<String, TextEditingController> _schedCtrls = {};

  TextEditingController _itemCtrl(int i, String field, double value) {
    final key = '${i}_$field';
    if (!_itemCtrls.containsKey(key)) {
      _itemCtrls[key] = TextEditingController(text: value > 0 ? value.toStringAsFixed(2) : '');
    }
    return _itemCtrls[key]!;
  }

  TextEditingController _schedCtrl(int i, String field, String value) {
    final key = 'sched_${i}_$field';
    if (!_schedCtrls.containsKey(key)) {
      _schedCtrls[key] = TextEditingController(text: value);
    }
    return _schedCtrls[key]!;
  }

  void _removeItemCtrls(int i) {
    final toRemove = _itemCtrls.keys.where((k) => k.startsWith('${i}_')).toList();
    for (final k in toRemove) {
      _itemCtrls[k]!.dispose();
      _itemCtrls.remove(k);
    }
    for (int j = i + 1; j <= widget.formData.items.length; j++) {
      for (final field in ['demandQty', 'unitPrice', 'discountRate', 'discountAmount']) {
        final oldKey = '${j}_$field';
        final newKey = '${j - 1}_$field';
        if (_itemCtrls.containsKey(oldKey)) _itemCtrls[newKey] = _itemCtrls.remove(oldKey)!;
      }
    }
  }

  void _removeSchedCtrls(int i) {
    final toRemove = _schedCtrls.keys.where((k) => k.startsWith('sched_${i}_')).toList();
    for (final k in toRemove) {
      _schedCtrls[k]!.dispose();
      _schedCtrls.remove(k);
    }
    for (int j = i + 1; j <= widget.formData.schedules.length; j++) {
      for (final field in ['termName', 'amount', 'percentage']) {
        final oldKey = 'sched_${j}_$field';
        final newKey = 'sched_${j - 1}_$field';
        if (_schedCtrls.containsKey(oldKey)) _schedCtrls[newKey] = _schedCtrls.remove(oldKey)!;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final tabCount = widget.formData.isMultiPayment ? 3 : 2;
    _tab            = TabController(length: tabCount, vsync: this);
    _noteCtrl.text  = widget.formData.note ?? '';
    _rfqCtrl.text   = widget.formData.rfqReference ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    _noteCtrl.dispose();
    _rfqCtrl.dispose();
    for (final c in _itemCtrls.values) c.dispose();
    for (final c in _schedCtrls.values) c.dispose();
    super.dispose();
  }

  PurchaseOrderFormOptions? get _opts => widget.formOptions;
  double get _taxRate => _opts?.defaultTaxRate ?? 11.0;

  void _recalcItem(int idx) {
    widget.formData.items[idx].recalculate(
      isTaxEnabled:   widget.formData.isTax,
      defaultTaxRate: _taxRate,
      discountType:   widget.formData.discountType,
    );
    setState(() {});
  }

  void _recalcAll() {
    for (int i = 0; i < widget.formData.items.length; i++) _recalcItem(i);
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.note         = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();
    widget.formData.rfqReference = _rfqCtrl.text.trim().isEmpty ? null : _rfqCtrl.text.trim();

    if (widget.formData.idVendor == null)              { _snack('Please select vendor');               return false; }
    if (widget.formData.destinationWarehouse == null)  { _snack('Please select destination warehouse'); return false; }
    if (widget.formData.destinationLocation == null)   { _snack('Please select destination location');  return false; }
    if (widget.formData.expectedArrival == null)       { _snack('Please select expected arrival date'); return false; }
    if (widget.formData.items.isEmpty)                 { _snack('Please add at least one product');    return false; }

    for (int i = 0; i < widget.formData.items.length; i++) {
      final item = widget.formData.items[i];
      if (item.idProduct == null) { _snack('Row ${i + 1}: Please select product');        return false; }
      if (item.uomId == null)     { _snack('Row ${i + 1}: Please select unit of measure'); return false; }
      if (item.demandQty <= 0)    { _snack('Row ${i + 1}: Quantity must be > 0');         return false; }
    }

    if (widget.formData.isMultiPayment) {
      if (widget.formData.schedules.isEmpty) {
        _snack('Please add at least one payment schedule');
        return false;
      }
      for (int i = 0; i < widget.formData.schedules.length; i++) {
        final s = widget.formData.schedules[i];
        if (s.termName.trim().isEmpty) { _snack('Schedule ${i + 1}: Term name is required');  return false; }
        if (s.dueDate == null)         { _snack('Schedule ${i + 1}: Due date is required');   return false; }
        if (s.percentage <= 0)         { _snack('Schedule ${i + 1}: Percentage must be > 0'); return false; }
        if (s.amount <= 0)             { _snack('Schedule ${i + 1}: Amount must be > 0');     return false; }
      }
      final totalPct = widget.formData.totalSchedulePercentage;
      if ((totalPct - 100).abs() > 0.01) {
        _snack('Total percentage must equal 100%. Current: ${totalPct.toStringAsFixed(1)}%');
        return false;
      }
    }
    return true;
  }

  Future<void> _addProduct() async {
    final ctrl = context.read<PurchaseOrderController>();
    final products = _opts?.products ?? [];
    if (products.isEmpty) {
      _snack('No available products');
      return;
    }

    POProductOption? selected;
    POUomOption? selectedUom;

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
                CustomSearchableDropdown<POProductOption>(
                  value: selected,
                  items: products,
                  itemLabel: (p) => p.productName,
                  onChanged: (v) => setSt(() {
                    selected    = v;
                    selectedUom = null;
                  }),
                  label: 'Product',
                  isRequired: true,
                  clearable: false,
                ),
                const SizedBox(height: 12),
                if (selected != null)
                  CustomSearchableDropdown<POUomOption>(
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
                if (selected == null)    { _snack('Please select product');          return; }
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
      final prod = result['product'] as POProductOption;
      final uom  = result['uom']    as POUomOption;

      double unitPrice = 0;
      double lastPurchasedPrice = 0;

      if (widget.formData.idPriceList != null) {
        unitPrice = await ctrl.fetchPriceFromList(prod.idProduct, widget.formData.idPriceList!) ?? 0;
      }
      if (widget.formData.idVendor != null) {
        lastPurchasedPrice = await ctrl.fetchLastPrice(widget.formData.idVendor!, prod.idProduct);
        if (unitPrice == 0) unitPrice = lastPurchasedPrice;
      }

      setState(() {
        widget.formData.items.add(PurchaseOrderFormItem(
          idProduct:          prod.idProduct,
          productName:        prod.productName,
          description:        prod.description,
          uomId:              uom.id,
          uomName:            uom.name,
          unitPrice:          unitPrice,
          lastPurchasedPrice: lastPurchasedPrice,
          taxRate:            widget.formData.isTax ? _taxRate : 0,
        ));
        _recalcItem(widget.formData.items.length - 1);
      });
    }
  }

  List<POLocationOption> _getFilteredLocations() {
    if (_opts == null || widget.formData.destinationWarehouse == null) return [];
    final filtered = _opts!.locations.where((l) => l.warehouseId == widget.formData.destinationWarehouse).toList();
    return filtered.isNotEmpty ? filtered : _opts!.locations;
  }

  @override
  Widget build(BuildContext context) {
    final tabCount = widget.formData.isMultiPayment ? 3 : 2;
    if (_tab.length != tabCount) {
      _tab.dispose();
      _tab = TabController(length: tabCount, vsync: this);
    }

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
                        style: GoogleFonts.poppins(fontSize: 10, color: colorWhite, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.formData.isMultiPayment)
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Flexible(child: Text('Schedules', overflow: TextOverflow.ellipsis)),
                    if (widget.formData.schedules.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: widget.formData.totalSchedulePercentage == 100 ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${widget.formData.schedules.length}',
                          style: GoogleFonts.poppins(fontSize: 10, color: colorWhite, fontWeight: FontWeight.w600),
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
              if (widget.formData.isMultiPayment) _buildSchedulesTab(),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildHeaderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchableDropdown<POVendorOption>(
            key: ValueKey('vendor_${widget.formData.idVendor}_${_opts?.vendors.length}'),
            value: _opts?.vendors.where((v) => v.id == widget.formData.idVendor).firstOrNull,
            items: _opts?.vendors ?? [],
            itemLabel: (v) => v.name,
            onChanged: (v) => setState(() => widget.formData.idVendor = v?.id),
            isRequired: true,
            label: 'Vendor',
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<POWarehouseOption>(
            key: ValueKey('wh_${widget.formData.destinationWarehouse}_${_opts?.warehouses.length}'),
            value: _opts?.warehouses.where((w) => w.id == widget.formData.destinationWarehouse).firstOrNull,
            items: _opts?.warehouses ?? [],
            itemLabel: (w) => w.name,
            onChanged: (v) => setState(() {
              widget.formData.destinationWarehouse = v?.id;
              widget.formData.destinationLocation  = null;
            }),
            isRequired: true,
            label: 'Destination Warehouse',
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<POLocationOption>(
            key: ValueKey('loc_${widget.formData.destinationLocation}_${widget.formData.destinationWarehouse}'),
            value: _opts?.locations.where((l) => l.id == widget.formData.destinationLocation).firstOrNull,
            items: _getFilteredLocations(),
            itemLabel: (l) => l.name,
            onChanged: (v) => setState(() => widget.formData.destinationLocation = v?.id),
            isRequired: true,
            label: 'Destination Location',
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<POPurchaseTeamOption>(
            key: ValueKey('team_${widget.formData.purchaseTeam}_${_opts?.purchaseTeams.length}'),
            value: _opts?.purchaseTeams.where((t) => t.id == widget.formData.purchaseTeam).firstOrNull,
            items: _opts?.purchaseTeams ?? [],
            itemLabel: (t) => t.name,
            onChanged: (v) => setState(() => widget.formData.purchaseTeam = v?.id),
            label: 'Purchase Team',
            clearable: true,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<POPurchasePersonOption>(
            key: ValueKey('person_${widget.formData.purchasePerson}_${_opts?.purchasePersons.length}'),
            value: _opts?.purchasePersons.where((p) => p.id == widget.formData.purchasePerson).firstOrNull,
            items: _opts?.purchasePersons ?? [],
            itemLabel: (p) => p.name,
            onChanged: (v) => setState(() => widget.formData.purchasePerson = v?.id),
            label: 'Purchase Person',
            clearable: true,
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _rfqCtrl,
            label: 'RFQ Reference',
            hintText: 'Reference from RFQ (optional)',
          ),
          const SizedBox(height: 14),

          _sectionLabel('Requested Date'),
          _datePicker(
            value: widget.formData.requestedDate,
            hint: 'Select requested date (optional)',
            onPicked: (d) => setState(() => widget.formData.requestedDate = d),
          ),
          const SizedBox(height: 14),

          _sectionLabel('Expected Arrival *'),
          _datePicker(
            value: widget.formData.expectedArrival,
            hint: 'Select expected arrival date',
            onPicked: (d) => setState(() => widget.formData.expectedArrival = d),
          ),
          const SizedBox(height: 14),

          _sectionLabel('Expiration Date'),
          _datePicker(
            value: widget.formData.expirationDate,
            hint: 'Select expiration date (optional)',
            onPicked: (d) => setState(() => widget.formData.expirationDate = d),
          ),
          const SizedBox(height: 14),

          _sectionLabel('Payment Type *'),
          const SizedBox(height: 6),
          Row(
            children: [
              _paymentTypeChip('Full',  'Full'),
              const SizedBox(width: 10),
              _paymentTypeChip('Multi', 'Multi (Termin)'),
            ],
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<POPaymentTermOption>(
            key: ValueKey('pt_${widget.formData.idPaymentTerm}_${_opts?.paymentTerms.length}'),
            value: _opts?.paymentTerms.where((p) => p.id == widget.formData.idPaymentTerm).firstOrNull,
            items: _opts?.paymentTerms ?? [],
            itemLabel: (p) => p.name,
            label: 'Payment Term',
            onChanged: (v) => setState(() => widget.formData.idPaymentTerm = v?.id),
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<POPriceListOption>(
            key: ValueKey('pl_${widget.formData.idPriceList}_${_opts?.priceLists.length}'),
            value: _opts?.priceLists.where((p) => p.id == widget.formData.idPriceList).firstOrNull,
            items: _opts?.priceLists ?? [],
            itemLabel: (p) => p.name,
            label: 'Price List',
            onChanged: (v) => setState(() => widget.formData.idPriceList = v?.id),
          ),
          const SizedBox(height: 14),

          _sectionLabel('Discount Type'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _discChip('No Discount', null),
              _discChip('Percentage (%)', 'Percentage'),
              _discChip('Nominal (Rp)', 'Nominal'),
            ],
          ),
          const SizedBox(height: 14),

          CustomFormSwitchHorizontal(
            label: 'PPN',
            subtitle: '${_taxRate.toStringAsFixed(0)}% dari subtotal',
            value: widget.formData.isTax,
            onChanged: (v) {
              setState(() => widget.formData.isTax = v);
              _recalcAll();
            },
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _noteCtrl,
            label: 'Note',
            hintText: 'Write note for this purchase order (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
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
                        'Add products to this purchase order',
                        style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addProduct,
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
                onPressed: _addProduct,
                icon: const Icon(Icons.add, size: 18),
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
            if (item.lastPurchasedPrice > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 12, color: colorGrey),
                    const SizedBox(width: 4),
                    Text(
                      'Last Price: Rp ${_fmtNum(item.lastPurchasedPrice)}',
                      style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                    ),
                  ],
                ),
              ),
            if (item.description?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  item.description!,
                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            CustomSearchableDropdown<POUomOption>(
              key: ValueKey('uom_${i}_${item.uomId}'),
              value: _opts?.uoms.where((u) => u.id == item.uomId).firstOrNull,
              items: _opts?.uoms ?? [],
              itemLabel: (u) => u.name,
              onChanged: (v) => setState(() {
                item.uomId   = v?.id;
                item.uomName = v?.name;
              }),
              label: 'Unit of Measure',
              isRequired: true,
              clearable: false,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _numFieldItem(
                    ctrl: _itemCtrl(i, 'demandQty', item.demandQty),
                    label: 'Demand Qty',
                    required: true,
                    onChanged: (v) => setState(() {
                      item.demandQty = v;
                      _recalcItem(i);
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _numFieldItem(
                    ctrl: _itemCtrl(i, 'unitPrice', item.unitPrice),
                    label: 'Unit Price',
                    required: true,
                    onChanged: (v) => setState(() {
                      item.unitPrice = v;
                      _recalcItem(i);
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (widget.formData.discountType == 'Percentage') ...[
              _numFieldItem(
                ctrl: _itemCtrl(i, 'discountRate', item.discountRate),
                label: 'Discount (%)',
                onChanged: (v) => setState(() {
                  item.discountRate = v.clamp(0, 100);
                  _recalcItem(i);
                }),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.remove_circle_outline, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'Discount Rp ${_fmtNum(item.discountAmount)}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.orange.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            if (widget.formData.discountType == 'Nominal') ...[
              _numFieldItem(
                ctrl: _itemCtrl(i, 'discountAmount', item.discountAmount),
                label: 'Discount (Rp)',
                onChanged: (v) => setState(() {
                  item.discountAmount = v.clamp(0, item.subtotalBeforeDiscount);
                  _recalcItem(i);
                }),
              ),
              const SizedBox(height: 4),
            ],
            if (widget.formData.isTax && item.taxAmount > 0) ...[
              Row(
                children: [
                  const Icon(Icons.receipt_outlined, size: 14, color: Colors.indigo),
                  const SizedBox(width: 4),
                  Text(
                    'PPN (${_taxRate.toStringAsFixed(0)}%): Rp ${_fmtNum(item.taxAmount)}',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.indigo),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            const Divider(height: 12, color: colorGreyLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                Text(
                  'Rp ${_fmtNum(item.taxedAmount)}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulesTab() {
    final grandTotal = widget.formData.grandTotal;
    final totalPct   = widget.formData.totalSchedulePercentage;
    final pctOk      = (totalPct - 100).abs() <= 0.01;

    return Column(
      children: [
        Container(
          color: colorCard,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grand Total: Rp ${_fmtNum(grandTotal)}',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                    ),
                    Row(
                      children: [
                        Text(
                          'Total %: ${totalPct.toStringAsFixed(1)}%',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: pctOk ? Colors.green : Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (!pctOk)
                          Text('(must equal 100%)', style: GoogleFonts.poppins(fontSize: 10, color: Colors.orange)),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: _addSchedule,
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  foregroundColor: colorPrimary,
                  side: const BorderSide(color: colorPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.formData.schedules.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 64, color: colorGrey),
                      const SizedBox(height: 12),
                      Text('No payment schedules', style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle)),
                      const SizedBox(height: 4),
                      Text(
                        'Add payment terms for Multi payment type',
                        style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                  itemCount: widget.formData.schedules.length,
                  itemBuilder: (_, i) => _buildScheduleCard(i),
                ),
        ),
      ],
    );
  }

  void _addSchedule() {
    setState(() {
      widget.formData.schedules.add(PurchaseOrderScheduleItem(
        termName:   'Term ${widget.formData.schedules.length + 1}',
        percentage: 0,
        amount:     0,
      ));
    });
  }

  Widget _buildScheduleCard(int i) {
    final s = widget.formData.schedules[i];

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
                    'Schedule ${i + 1}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorTextPrimary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: colorError, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() {
                    _removeSchedCtrls(i);
                    widget.formData.schedules.removeAt(i);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomFormInput(
              controller: _schedCtrl(i, 'termName', s.termName),
              label: 'Term Name',
              hintText: 'e.g. Down Payment, Final',
              required: true,
              onChanged: (v) => s.termName = v,
            ),
            const SizedBox(height: 8),
            _sectionLabel('Due Date *'),
            _datePicker(
              value: s.dueDate,
              hint: 'Select due date',
              onPicked: (d) => setState(() => s.dueDate = d),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _numFieldItem(
                    ctrl: _schedCtrl(i, 'percentage', s.percentage > 0 ? s.percentage.toStringAsFixed(2) : ''),
                    label: 'Percentage (%)',
                    required: true,
                    onChanged: (v) => setState(() {
                      s.percentage = v.clamp(0, 100);
                      s.amount     = widget.formData.untaxedAmount * (s.percentage / 100);
                      final amtKey = 'sched_${i}_amount';
                      _schedCtrls[amtKey]?.text = s.amount.toStringAsFixed(2);
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _numFieldItem(
                    ctrl: _schedCtrl(i, 'amount', s.amount > 0 ? s.amount.toStringAsFixed(2) : ''),
                    label: 'Amount (Rp)',
                    required: true,
                    onChanged: (v) => setState(() {
                      s.amount     = v;
                      final untaxed = widget.formData.untaxedAmount;
                      s.percentage = untaxed > 0 ? (v / untaxed * 100) : 0;
                      final pctKey = 'sched_${i}_percentage';
                      _schedCtrls[pctKey]?.text = s.percentage.toStringAsFixed(2);
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsFooter() => Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        color: colorCard,
        child: Column(
          children: [
            if (widget.formData.totalDiscount > 0)
              _footerRow('Total Discount', 'Rp ${_fmtNum(widget.formData.totalDiscount)}', color: Colors.orange.shade700),
            _footerRow('Untaxed Amount', 'Rp ${_fmtNum(widget.formData.untaxedAmount)}'),
            if (widget.formData.isTax)
              _footerRow('PPN (${_taxRate.toStringAsFixed(0)}%)', 'Rp ${_fmtNum(widget.formData.totalTaxes)}', color: Colors.indigo),
            const Divider(height: 14, color: colorGreyLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grand Total', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
                Text(
                  'Rp ${_fmtNum(widget.formData.grandTotal)}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: colorPrimary),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildBottomBar() => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colorCard,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSave(); },
            icon: widget.isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              widget.formData.isEditMode ? 'Update Purchase Order' : 'Save Purchase Order',
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
        child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary)),
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
          border: Border.all(color: value != null ? colorPrimary : colorGreyLight, width: value != null ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: value != null ? colorPrimary : colorGrey),
            const SizedBox(width: 8),
            Text(
              value != null ? DateFormat('d MMM yyyy').format(value) : hint,
              style: GoogleFonts.poppins(fontSize: 13, color: value != null ? colorTextPrimary : colorGrey),
            ),
            const Spacer(),
            if (value != null)
              GestureDetector(onTap: () => setState(() {}), child: const Icon(Icons.close, size: 16, color: colorGrey)),
          ],
        ),
      ),
    );
  }

  Widget _paymentTypeChip(String value, String label) {
    final isSelected = widget.formData.paymentType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => widget.formData.paymentType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorPrimary : colorBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? colorPrimary : colorGreyLight),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? colorWhite : colorTextPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _discChip(String label, String? value) {
    final isSelected = widget.formData.discountType == value;
    return GestureDetector(
      onTap: () => setState(() {
        widget.formData.discountType = value;
        _recalcAll();
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorPrimary : colorBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? colorPrimary : colorGreyLight),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isSelected ? colorWhite : colorTextPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
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

  Widget _footerRow(String label, String value, {Color? color}) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
            Text(value, style: GoogleFonts.poppins(fontSize: 12, color: color ?? colorTextPrimary)),
          ],
        ),
      );

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}