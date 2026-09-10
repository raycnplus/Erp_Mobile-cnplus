import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/controllers/manufacturing_order_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class ManufacturingOrderFormFields extends StatefulWidget {
  final ManufacturingOrderFormModel formData;
  final ManufacturingOrderFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const ManufacturingOrderFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<ManufacturingOrderFormFields> createState() => _State();
}

class _State extends State<ManufacturingOrderFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _qtyCtrl.text = widget.formData.plannedQty > 0 ? widget.formData.plannedQty.toStringAsFixed(2) : '1.00';
    _notesCtrl.text = widget.formData.notes ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  ManufacturingOrderFormOptions? get _opts => widget.formOptions;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();
    widget.formData.plannedQty = double.tryParse(_qtyCtrl.text.replaceAll(',', '')) ?? 0;

    if (widget.formData.idBom == null)              { _snack('Please select a Bill of Material'); return false; }
    if (widget.formData.idProduct == null)          { _snack('Please select a product');           return false; }
    if (widget.formData.plannedQty <= 0)            { _snack('Quantity must be greater than 0');    return false; }
    if (widget.formData.unitOfMeasure == null)      { _snack('Please select unit of measure');      return false; }
    if (widget.formData.rejectedProductId == null)  { _snack('Please select rejected product');     return false; }
    if (widget.formData.sourceWarehouse == null)    { _snack('Please select source warehouse');     return false; }
    if (widget.formData.sourceLocation == null)     { _snack('Please select source location');      return false; }
    if (widget.formData.finishedLocation == null)   { _snack('Please select finished location');    return false; }
    if (widget.formData.byproductLocation == null)  { _snack('Please select byproduct location');   return false; }
    if (widget.formData.rejectedLocation == null)   { _snack('Please select rejected location');    return false; }

    return true;
  }

  Future<void> _onBomSelected(MOBomOption? bom) async {
    final ctrl = context.read<ManufacturingOrderController>();
    setState(() {
      widget.formData.idBom = bom?.id;
    });
    if (bom == null) return;

    await ctrl.fetchBomDetails(bom.id);
    final detail = ctrl.selectedBomDetail;
    if (detail == null || !mounted) return;

    setState(() {
      widget.formData.idProduct = detail.productId;
      widget.formData.unitOfMeasure = detail.unitOfMeasure;
      widget.formData.rejectedProductId = detail.rejectedProductId;
      if (detail.productQty > 0) {
        widget.formData.plannedQty = detail.productQty;
        _qtyCtrl.text = detail.productQty.toStringAsFixed(2);
      }
    });

    await ctrl.fetchBomComponents(bom.id, qty: widget.formData.plannedQty);
  }

  Future<void> _pickLaborPersons() async {
    final all = _opts?.labors ?? [];
    final selected = Set<int>.from(widget.formData.laborPerson);

    final result = await showDialog<Set<int>>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text('Select Labor Persons', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: all.map((l) {
                final isChecked = selected.contains(l.id);
                return CheckboxListTile(
                  value: isChecked,
                  onChanged: (v) => setSt(() {
                    if (v == true) selected.add(l.id); else selected.remove(l.id);
                  }),
                  title: Text(l.name, style: GoogleFonts.poppins(fontSize: 13)),
                );
              }).toList(),
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Done', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() => widget.formData.laborPerson = result.toList());
    }
  }

  List<MOLocationOption> _getFilteredLocations() {
    if (_opts == null || widget.formData.sourceWarehouse == null) return [];
    final filtered = _opts!.locations.where((l) => l.warehouseId == widget.formData.sourceWarehouse).toList();
    return filtered;
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
          tabs: const [
            Tab(text: 'Header'),
            Tab(text: 'Materials'),
            Tab(text: 'Locations'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildHeaderTab(),
              _buildMaterialsPreviewTab(),
              _buildLocationsTab(),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildHeaderTab() {
    final ctrl = context.watch<ManufacturingOrderController>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchableDropdown<MOBomOption>(
            key: ValueKey('bom_${widget.formData.idBom}_${_opts?.boms.length}'),
            value: _opts?.boms.where((b) => b.id == widget.formData.idBom).firstOrNull,
            items: _opts?.boms ?? [],
            itemLabel: (b) => b.productName != null ? '${b.name} (${b.productName})' : b.name,
            onChanged: _onBomSelected,
            label: 'Bill of Material',
            isRequired: true,
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<MOProductOption>(
            key: ValueKey('prod_${widget.formData.idProduct}_${_opts?.products.length}'),
            value: _opts?.products.where((p) => p.id == widget.formData.idProduct).firstOrNull,
            items: _opts?.products ?? [],
            itemLabel: (p) => p.name,
            onChanged: (v) => setState(() => widget.formData.idProduct = v?.id),
            isRequired: true,
            label: 'Product',
            clearable: false,
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: CustomFormInput(
                  controller: _qtyCtrl,
                  label: 'Planned Qty',
                  hintText: '1.00',
                  required: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) {
                    widget.formData.plannedQty = double.tryParse(v) ?? 0;
                    if (widget.formData.idBom != null) {
                      context.read<ManufacturingOrderController>().fetchBomComponents(
                        widget.formData.idBom!,
                        qty: widget.formData.plannedQty,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomSearchableDropdown<MOUomOption>(
                  key: ValueKey('uom_${widget.formData.unitOfMeasure}_${_opts?.uoms.length}'),
                  value: _opts?.uoms.where((u) => u.id == widget.formData.unitOfMeasure).firstOrNull,
                  items: _opts?.uoms ?? [],
                  itemLabel: (u) => u.name,
                  onChanged: (v) => setState(() => widget.formData.unitOfMeasure = v?.id),
                  label: 'Unit of Measure',
                  isRequired: true,
                  clearable: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<MOProductOption>(
            key: ValueKey('rej_${widget.formData.rejectedProductId}_${_opts?.products.length}'),
            value: _opts?.products.where((p) => p.id == widget.formData.rejectedProductId).firstOrNull,
            items: _opts?.products ?? [],
            itemLabel: (p) => p.name,
            onChanged: (v) => setState(() => widget.formData.rejectedProductId = v?.id),
            isRequired: true,
            label: 'Rejected Product',
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<MOWarehouseOption>(
            key: ValueKey('wh_${widget.formData.sourceWarehouse}_${_opts?.warehouses.length}'),
            value: _opts?.warehouses.where((w) => w.id == widget.formData.sourceWarehouse).firstOrNull,
            items: _opts?.warehouses ?? [],
            itemLabel: (w) => w.name,
            onChanged: (v) {
              setState(() {
                widget.formData.sourceWarehouse = v?.id;
                widget.formData.sourceLocation = null;
              });
            },
            isRequired: true,
            label: 'Source Warehouse',
            clearable: false,
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<MOLocationOption>(
            key: ValueKey('loc_${widget.formData.sourceLocation}_${widget.formData.sourceWarehouse}'),
            value: _opts?.locations.where((l) => l.id == widget.formData.sourceLocation).firstOrNull,
            items: _getFilteredLocations(),
            itemLabel: (l) => l.name,
            onChanged: (v) => setState(() => widget.formData.sourceLocation = v?.id),
            isRequired: true,
            label: 'Source Location',
            clearable: false,
          ),
          const SizedBox(height: 14),

          _sectionLabel('Schedule Date'),
          _datePicker(
            value: widget.formData.scheduleDate,
            hint: 'Select schedule date (optional)',
            onPicked: (d) => setState(() => widget.formData.scheduleDate = d),
          ),
          const SizedBox(height: 14),

          _sectionLabel('Labor Persons'),
          GestureDetector(
            onTap: _pickLaborPersons,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorGreyLight),
              ),
              child: Text(
                widget.formData.laborPerson.isEmpty
                    ? 'Select labor persons (optional)'
                    : (_opts?.labors ?? [])
                        .where((l) => widget.formData.laborPerson.contains(l.id))
                        .map((l) => l.name)
                        .join(', '),
                style: GoogleFonts.poppins(fontSize: 13, color: colorTextPrimary),
              ),
            ),
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _notesCtrl,
            label: 'Notes',
            hintText: 'Write note for this manufacturing order (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMaterialsPreviewTab() {
    final ctrl = context.watch<ManufacturingOrderController>();
    if (widget.formData.idBom == null) {
      return Center(
        child: Text('Select a Bill of Material first', style: GoogleFonts.poppins(color: colorGrey)),
      );
    }
    if (ctrl.isLoadingBom) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    if (ctrl.bomComponents.isEmpty) {
      return Center(child: Text('No components in this BoM', style: GoogleFonts.poppins(color: colorGrey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: ctrl.bomComponents.length,
      itemBuilder: (_, i) {
        final c = ctrl.bomComponents[i];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: colorCard,
          child: ListTile(
            title: Text(c.productName ?? '-', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
            trailing: Text(
              '${NumberFormat('#,##0.00', 'id_ID').format(c.quantity)} ${c.uomName ?? ''}',
              style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchableDropdown<MOLocationOption>(
            key: ValueKey('finished_${widget.formData.finishedLocation}_${_opts?.locations.length}'),
            value: _opts?.locations.where((l) => l.id == widget.formData.finishedLocation).firstOrNull,
            items: _opts?.locations ?? [],
            itemLabel: (l) => l.name,
            onChanged: (v) => setState(() => widget.formData.finishedLocation = v?.id),
            isRequired: true,
            label: 'Finished Location',
            clearable: false,
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<MOLocationOption>(
            key: ValueKey('byproduct_${widget.formData.byproductLocation}_${_opts?.locations.length}'),
            value: _opts?.locations.where((l) => l.id == widget.formData.byproductLocation).firstOrNull,
            items: _opts?.locations ?? [],
            itemLabel: (l) => l.name,
            onChanged: (v) => setState(() => widget.formData.byproductLocation = v?.id),
            isRequired: true,
            label: 'Byproduct Location',
            clearable: false,
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<MOLocationOption>(
            key: ValueKey('rejloc_${widget.formData.rejectedLocation}_${_opts?.locations.length}'),
            value: _opts?.locations.where((l) => l.id == widget.formData.rejectedLocation).firstOrNull,
            items: _opts?.locations ?? [],
            itemLabel: (l) => l.name,
            onChanged: (v) => setState(() => widget.formData.rejectedLocation = v?.id),
            isRequired: true,
            label: 'Rejected Location',
            clearable: false,
          ),
        ],
      ),
    );
  }

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
              widget.formData.isEditMode ? 'Update Manufacturing Order' : 'Save Manufacturing Order',
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
          ],
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}