import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/models/bom_models.dart';

class BomFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final BomFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final BomFormOptions? formOptions;
  final bool isLoadingFormOptions;

  const BomFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.formOptions,
    required this.isLoadingFormOptions,
  });

  @override
  State<BomFormFields> createState() => _BomFormFieldsState();
}

class _BomFormFieldsState extends State<BomFormFields>
    with SingleTickerProviderStateMixin {
  // 5 tabs: Info | Components | By-Products | Operations | Equipment
  late TabController _tab;

  late TextEditingController _bomNameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _productQtyCtrl;
  late TextEditingController _prepTimeCtrl;

  bool _showComponentError = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
    final f = widget.formData;
    _bomNameCtrl   = TextEditingController(text: f.bomName);
    _descCtrl      = TextEditingController(text: f.description ?? '');
    _productQtyCtrl = TextEditingController(text: f.productQty.toStringAsFixed(0));
    _prepTimeCtrl  = TextEditingController(text: f.preparationTime.toString());
  }

  @override
  void dispose() {
    _tab.dispose();
    _bomNameCtrl.dispose();
    _descCtrl.dispose();
    _productQtyCtrl.dispose();
    _prepTimeCtrl.dispose();
    super.dispose();
  }

  void _saveHeader() {
    final f = widget.formData;
    f.bomName        = _bomNameCtrl.text;
    f.description    = _descCtrl.text.isEmpty ? null : _descCtrl.text;
    f.productQty     = double.tryParse(_productQtyCtrl.text) ?? 1;
    f.preparationTime = int.tryParse(_prepTimeCtrl.text) ?? 0;
  }

  // ── finders ──
  BomProductOption?     _fp(int? id) { if (id == null || widget.formOptions == null) return null; final m = widget.formOptions!.products.where((p) => p.id == id); return m.isEmpty ? null : m.first; }
  BomProductOption?     _fs(int? id) { if (id == null || widget.formOptions == null) return null; final m = widget.formOptions!.storableProducts.where((p) => p.id == id); return m.isEmpty ? null : m.first; }
  BomUomOption?         _fu(int? id) { if (id == null || widget.formOptions == null) return null; final m = widget.formOptions!.uoms.where((u) => u.id == id); return m.isEmpty ? null : m.first; }
  BomWorkstationOption? _fw(int? id) { if (id == null || widget.formOptions == null) return null; final m = widget.formOptions!.workstations.where((w) => w.id == id); return m.isEmpty ? null : m.first; }
  BomProductOption?     _fe(int? id) { if (id == null || widget.formOptions == null) return null; final m = widget.formOptions!.equipmentProducts.where((e) => e.id == id); return m.isEmpty ? null : m.first; }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingFormOptions) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    final opts = widget.formOptions;

    return Form(
      key: widget.formKey,
      child: Column(children: [
        // ── TAB BAR (scrollable agar tidak sempit) ──
        Container(
          color: colorCard,
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: colorPrimary,
            unselectedLabelColor: colorGrey,
            indicatorColor: colorPrimary,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12),
            tabs: const [
              Tab(text: 'Info'),
              Tab(text: 'Components'),
              Tab(text: 'By-Products'),
              Tab(text: 'Operations'),
              Tab(text: 'Equipment'),
            ],
          ),
        ),

        // ── TAB CONTENT ──
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildInfo(opts),
              _buildComponents(opts),
              _buildByproducts(opts),
              _buildOperations(opts),
              _buildEquipment(opts),
            ],
          ),
        ),

        // ── SUBMIT BUTTON ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorCard,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
          ),
          child: SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              _saveHeader();
              setState(() => _showComponentError = true);
              widget.onSubmit();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: colorPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(
              widget.isEditMode ? 'Update BOM' : 'Create BOM',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          )),
        ),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB: INFO — semua header fields di sini
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildInfo(BomFormOptions? opts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        CustomFormInput(
          controller: _bomNameCtrl,
          label: 'BOM Name', required: true,
          hintText: 'e.g. Meja Kayu Standard',
          validator: (_) => _bomNameCtrl.text.trim().isEmpty ? 'BOM name is required' : null,
        ),
        const SizedBox(height: 14),

        Row(children: [
          Expanded(child: CustomSearchableDropdown<BomProductOption>(
            key: ValueKey('prod_${widget.formData.productId}_${opts?.products.length ?? 0}'),
            value: _fp(widget.formData.productId),
            items: opts?.products ?? [],
            itemLabel: (p) => p.name,
            onChanged: (v) => setState(() => widget.formData.productId = v?.id),
            label: 'Product', isRequired: true, clearable: false,
            validator: (_) => widget.formData.productId == null ? 'Product is required' : null,
          )),
          const SizedBox(width: 12),
          SizedBox(width: 76, child: CustomFormInput(
            controller: _productQtyCtrl, label: 'Qty', hintText: '1',
            keyboardType: TextInputType.number,
          )),
        ]),
        const SizedBox(height: 14),

        Row(children: [
          Expanded(child: CustomSearchableDropdown<BomProductOption>(
            key: ValueKey('rej_${widget.formData.rejectedProductId}_${opts?.storableProducts.length ?? 0}'),
            value: _fs(widget.formData.rejectedProductId),
            items: opts?.storableProducts ?? [],
            itemLabel: (p) => p.name,
            onChanged: (v) => setState(() => widget.formData.rejectedProductId = v?.id),
            label: 'Rejected Product', clearable: true,
          )),
          const SizedBox(width: 12),
          SizedBox(width: 96, child: CustomFormInput(
            controller: _prepTimeCtrl, label: 'Prep (min)', hintText: '0',
            keyboardType: TextInputType.number,
          )),
        ]),
        const SizedBox(height: 14),

        Text('Flexible Consumption',
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colorTextPrimary)),
        const SizedBox(height: 8),
        Row(
          children: (opts?.flexibleConsumptions ?? [
            BomFlexOption(value: 'allowed', label: 'Allowed'),
            BomFlexOption(value: 'warning', label: 'With Caution'),
            BomFlexOption(value: 'blocked', label: 'Blocked'),
          ]).asMap().entries.map((e) {
            final isSel = widget.formData.flexibleConsumption == e.value.value;
            return Expanded(child: Padding(
              padding: EdgeInsets.only(right: e.key < 2 ? 8 : 0),
              child: GestureDetector(
                onTap: () => setState(() => widget.formData.flexibleConsumption = e.value.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? colorPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSel ? colorPrimary : colorGreyLight, width: 1.5),
                  ),
                  child: Center(child: Text(e.value.label,
                    textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600,
                      color: isSel ? Colors.white : colorTextPrimary))),
                ),
              ),
            ));
          }).toList(),
        ),
        const SizedBox(height: 14),

        CustomFormInput(
          controller: _descCtrl, label: 'Description',
          hintText: 'Optional', maxLines: 3,
        ),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB: COMPONENTS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildComponents(BomFormOptions? opts) {
    final rows = widget.formData.components;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        if (_showComponentError && rows.isEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorError.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('At least 1 component is required',
              style: GoogleFonts.poppins(color: colorError, fontSize: 13)),
          ),

        if (rows.isEmpty && !_showComponentError) _emptyHint('No components yet. Tap + to add.'),

        ...List.generate(rows.length, (i) {
          final row = rows[i];
          return _card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(children: [
              _rowHeader(i + 1, colorPrimary, () => setState(() => rows.removeAt(i))),
              const SizedBox(height: 8),
              CustomSearchableDropdown<BomProductOption>(
                key: ValueKey('comp_${row.componentProductId}_${i}_${opts?.products.length ?? 0}'),
                value: row.componentProductId != null
                    ? opts?.products.where((p) => p.id == row.componentProductId).firstOrNull
                    : null,
                items: opts?.products ?? [],
                itemLabel: (p) => p.name,
                onChanged: (v) => setState(() {
                  row.componentProductId = v?.id;
                  row.componentProductName = v?.name ?? '';
                  if (v != null && opts?.purchasePriceMap.containsKey(v.id) == true)
                    row.estimatedCost = opts!.purchasePriceMap[v.id]!;
                }),
                label: 'Component Product', isRequired: true, clearable: false,
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: CustomSearchableDropdown<BomUomOption>(
                  key: ValueKey('uom_${row.unitOfMeasure}_${i}_${opts?.uoms.length ?? 0}'),
                  value: _fu(row.unitOfMeasure), items: opts?.uoms ?? [],
                  itemLabel: (u) => u.name,
                  onChanged: (v) => setState(() => row.unitOfMeasure = v?.id),
                  label: 'UOM', clearable: true,
                )),
                const SizedBox(width: 8),
                SizedBox(width: 72, child: _numField('Qty', row.quantity.toStringAsFixed(2),
                  (v) { final x = double.tryParse(v); if (x != null) row.quantity = x; })),
                const SizedBox(width: 8),
                SizedBox(width: 88, child: _numField('Est.Cost', row.estimatedCost.toStringAsFixed(0),
                  (v) { final x = double.tryParse(v); if (x != null) row.estimatedCost = x; })),
              ]),
            ]),
          );
        }),

        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => setState(() => rows.add(BomComponentRow())),
          icon: const Icon(Icons.add, size: 16),
          label: Text('Add Component', style: GoogleFonts.poppins(fontSize: 13)),
          style: OutlinedButton.styleFrom(
            foregroundColor: colorPrimary, side: const BorderSide(color: colorPrimary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )),
        const SizedBox(height: 8),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB: BY-PRODUCTS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildByproducts(BomFormOptions? opts) {
    final rows = widget.formData.byproducts;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (rows.isEmpty) _emptyHint('No by-products yet. Tap + to add.'),
        ...List.generate(rows.length, (i) {
          final row = rows[i];
          return _card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(children: [
              _labelHeader('By-Product ${i + 1}', () => setState(() => rows.removeAt(i))),
              const SizedBox(height: 8),
              CustomSearchableDropdown<BomProductOption>(
                key: ValueKey('bp_${row.productId}_${i}_${opts?.products.length ?? 0}'),
                value: row.productId != null
                    ? opts?.products.where((p) => p.id == row.productId).firstOrNull
                    : null,
                items: opts?.products ?? [],
                itemLabel: (p) => p.name,
                onChanged: (v) => setState(() { row.productId = v?.id; row.productName = v?.name ?? ''; }),
                label: 'Product', clearable: false,
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: CustomSearchableDropdown<BomUomOption>(
                  key: ValueKey('bpuom_${row.uomId}_${i}_${opts?.uoms.length ?? 0}'),
                  value: _fu(row.uomId), items: opts?.uoms ?? [],
                  itemLabel: (u) => u.name,
                  onChanged: (v) => setState(() => row.uomId = v?.id),
                  label: 'UOM', clearable: true,
                )),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: _numField('Qty', row.quantity.toStringAsFixed(2),
                  (v) { final x = double.tryParse(v); if (x != null) row.quantity = x; })),
              ]),
              const SizedBox(height: 8),
              _notesField(row.notes ?? '', (v) => row.notes = v),
            ]),
          );
        }),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => setState(() => rows.add(BomByproductRow())),
          icon: const Icon(Icons.add, size: 16),
          label: Text('Add By-Product', style: GoogleFonts.poppins(fontSize: 13)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange.shade700, side: BorderSide(color: Colors.orange.shade700),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )),
        const SizedBox(height: 8),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB: OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildOperations(BomFormOptions? opts) {
    final rows = widget.formData.operations;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (rows.isEmpty) _emptyHint('No operations yet. Tap + to add.'),
        ...List.generate(rows.length, (i) {
          final row = rows[i];
          return _card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(children: [
              _labelHeader('Operation ${row.sequence}', () => setState(() {
                rows.removeAt(i);
                for (int j = 0; j < rows.length; j++) rows[j].sequence = j + 1;
              }), labelColor: Colors.blue.shade700),
              const SizedBox(height: 8),
              _textField('Operation Name', row.operationName,
                (v) => row.operationName = v, hint: 'e.g. Cutting'),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: CustomSearchableDropdown<BomWorkstationOption>(
                  key: ValueKey('ws_${row.workstationId}_${i}_${opts?.workstations.length ?? 0}'),
                  value: _fw(row.workstationId), items: opts?.workstations ?? [],
                  itemLabel: (w) => w.name,
                  onChanged: (v) => setState(() => row.workstationId = v?.id),
                  label: 'Workstation', clearable: true,
                )),
                const SizedBox(width: 8),
                SizedBox(width: 90, child: _numField('Duration(min)', row.duration.toString(),
                  (v) { final x = int.tryParse(v); if (x != null) row.duration = x; })),
              ]),
              const SizedBox(height: 8),
              _notesField(row.notes ?? '', (v) => row.notes = v),
            ]),
          );
        }),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => setState(() => rows.add(BomOperationRow(sequence: rows.length + 1))),
          icon: const Icon(Icons.add, size: 16),
          label: Text('Add Operation', style: GoogleFonts.poppins(fontSize: 13)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue.shade700, side: BorderSide(color: Colors.blue.shade700),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )),
        const SizedBox(height: 8),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB: EQUIPMENT
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEquipment(BomFormOptions? opts) {
    final rows = widget.formData.equipments;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (rows.isEmpty) _emptyHint('No equipment yet. Tap + to add.'),
        ...List.generate(rows.length, (i) {
          final row = rows[i];
          return _card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(children: [
              _labelHeader('Equipment ${i + 1}', () => setState(() => rows.removeAt(i)),
                labelColor: Colors.purple.shade700),
              const SizedBox(height: 8),
              CustomSearchableDropdown<BomProductOption>(
                key: ValueKey('eq_${row.equipmentId}_${i}_${opts?.equipmentProducts.length ?? 0}'),
                value: _fe(row.equipmentId), items: opts?.equipmentProducts ?? [],
                itemLabel: (e) => e.name,
                onChanged: (v) => setState(() { row.equipmentId = v?.id; row.equipmentName = v?.name ?? ''; }),
                label: 'Equipment', clearable: false,
              ),
              const SizedBox(height: 8),
              _notesField(row.notes ?? '', (v) => row.notes = v),
            ]),
          );
        }),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(
          onPressed: () => setState(() => rows.add(BomEquipmentRow())),
          icon: const Icon(Icons.add, size: 16),
          label: Text('Add Equipment', style: GoogleFonts.poppins(fontSize: 13)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.purple.shade700, side: BorderSide(color: Colors.purple.shade700),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )),
        const SizedBox(height: 8),
      ]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────
  Widget _emptyHint(String msg) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Center(child: Column(children: [
      Icon(Icons.inbox_outlined, size: 48, color: colorGrey.withOpacity(0.5)),
      const SizedBox(height: 8),
      Text(msg, style: GoogleFonts.poppins(color: colorGrey, fontSize: 13)),
    ])),
  );

  Widget _card({required Widget child, EdgeInsetsGeometry margin = EdgeInsets.zero}) => Card(
    elevation: 1, margin: margin, color: colorCard,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), side: const BorderSide(color: colorGreyLight)),
    child: Padding(padding: const EdgeInsets.all(12), child: child),
  );

  Widget _rowHeader(int n, Color color, VoidCallback onDel) => Row(children: [
    Container(width: 24, height: 24,
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Center(child: Text('$n',
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: color)))),
    const Spacer(),
    _delBtn(onDel),
  ]);

  Widget _labelHeader(String label, VoidCallback onDel, {Color? labelColor}) => Row(children: [
    Text(label, style: GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 13, color: labelColor ?? colorTextPrimary)),
    const Spacer(),
    _delBtn(onDel),
  ]);

  Widget _delBtn(VoidCallback onTap) => IconButton(
    icon: const Icon(Icons.delete_outline, color: colorError, size: 20),
    padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: onTap,
  );

  Widget _numField(String label, String init, ValueChanged<String> onChange) {
    final c = TextEditingController(text: init);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w600, color: colorTextPrimary)),
      const SizedBox(height: 3),
      TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        onChanged: onChange,
        decoration: _dec(),
        style: GoogleFonts.poppins(fontSize: 12),
      ),
    ]);
  }

  Widget _textField(String label, String init, ValueChanged<String> onChange, {String? hint}) {
    final c = TextEditingController(text: init);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w600, color: colorTextPrimary)),
      const SizedBox(height: 3),
      TextField(
        controller: c, onChanged: onChange,
        decoration: _dec(hint: hint),
        style: GoogleFonts.poppins(fontSize: 13),
      ),
    ]);
  }

  Widget _notesField(String init, ValueChanged<String> onChange) =>
      _textField('Notes (optional)', init, onChange, hint: 'Optional notes');

  InputDecoration _dec({String? hint}) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
    filled: true, fillColor: colorBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: colorGreyLight)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: colorGreyLight)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: colorPrimary)),
  );
}