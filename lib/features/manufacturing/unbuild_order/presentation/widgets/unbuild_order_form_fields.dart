import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/controllers/unbuild_order_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/models/unbuild_order_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class UnbuildOrderFormFields extends StatefulWidget {
  final UnbuildOrderFormModel formData;
  final UnbuildOrderFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const UnbuildOrderFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<UnbuildOrderFormFields> createState() => _State();
}

class _State extends State<UnbuildOrderFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _qtyCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  double _maxQty = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _qtyCtrl.text = widget.formData.unbuildQty > 0 ? widget.formData.unbuildQty.toStringAsFixed(2) : '';
    _notesCtrl.text = widget.formData.notes ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<UnbuildOrderController>();
      final moDetails = ctrl.selectedMoDetails;
      if (moDetails != null) {
        setState(() => _maxQty = moDetails.plannedQty);
      }
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    _qtyCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  UnbuildOrderFormOptions? get _opts => widget.formOptions;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();
    widget.formData.unbuildQty = double.tryParse(_qtyCtrl.text.replaceAll(',', '')) ?? 0;

    if (widget.formData.idManufacturingOrder == null) { _snack('Please select a Manufacturing Order'); return false; }
    if (widget.formData.idProduct == null || widget.formData.idBom == null) {
      _snack('Product / BoM data not loaded from Manufacturing Order'); return false;
    }
    if (widget.formData.unbuildQty <= 0) { _snack('Quantity must be greater than 0'); return false; }
    if (_maxQty > 0 && widget.formData.unbuildQty > _maxQty) {
      _snack('Quantity cannot exceed ${_maxQty.toStringAsFixed(2)}');
      return false;
    }
    return true;
  }

  Future<void> _onMoSelected(UOManufacturingOrderOption? mo) async {
    final ctrl = context.read<UnbuildOrderController>();
    setState(() {
      widget.formData.idManufacturingOrder = mo?.id;
      widget.formData.idProduct = null;
      widget.formData.idBom = null;
      widget.formData.unitOfMeasure = null;
      widget.formData.sourceWarehouse = null;
      widget.formData.sourceLocation = null;
      _maxQty = 0;
      _qtyCtrl.clear();
    });

    if (mo == null) return;

    await ctrl.fetchManufacturingOrderDetails(mo.id);
    final details = ctrl.selectedMoDetails;
    if (details == null || !mounted) return;

    setState(() {
      widget.formData.idProduct = details.idProduct;
      widget.formData.idBom = details.idBom;
      widget.formData.unitOfMeasure = details.idUnitOfMeasure;
      widget.formData.sourceWarehouse = details.sourceWarehouse;
      widget.formData.sourceLocation = details.sourceLocation;
      _maxQty = details.plannedQty;
    });

    _updatePreview();
  }

  void _updatePreview() {
    final ctrl = context.read<UnbuildOrderController>();
    final bomId = widget.formData.idBom;
    final qty = double.tryParse(_qtyCtrl.text.replaceAll(',', '')) ?? 0;
    if (bomId == null || qty <= 0) return;

    ctrl.fetchComponentsPreview([
      UOPreviewRequestItem(
        idBom: bomId,
        qty: qty,
        productName: ctrl.selectedMoDetails?.productName ?? 'Product',
      ),
    ]);
  }

  List<UOLocationOption> _locationsForWarehouse(int? warehouseId) {
    if (_opts == null || warehouseId == null) return [];
    return _opts!.locations.where((l) => l.warehouseId == warehouseId).toList();
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
            Tab(text: 'Components'),
            Tab(text: 'Destination'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildHeaderTab(),
              _buildComponentsPreviewTab(),
              _buildDestinationTab(),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildHeaderTab() {
    final ctrl = context.watch<UnbuildOrderController>();
    final moDetails = ctrl.selectedMoDetails;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchableDropdown<UOManufacturingOrderOption>(
            key: ValueKey('mo_${widget.formData.idManufacturingOrder}_${_opts?.manufacturingOrders.length}'),
            value: _opts?.manufacturingOrders.where((m) => m.id == widget.formData.idManufacturingOrder).firstOrNull,
            items: _opts?.manufacturingOrders ?? [],
            itemLabel: (m) => m.reference,
            onChanged: _onMoSelected,
            label: 'Manufacturing Order',
            isRequired: true,
            clearable: false,
          ),
          const SizedBox(height: 14),

          if (ctrl.isLoadingMoDetails)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator(color: colorPrimary)),
            ),

          if (!ctrl.isLoadingMoDetails && widget.formData.idManufacturingOrder != null) ...[
            _readOnlyField('Product', moDetails?.productName ?? '-'),
            const SizedBox(height: 14),
            _readOnlyField('Bill of Material', moDetails?.bomName ?? '-'),
            const SizedBox(height: 14),
            _readOnlyField('Unit of Measure', moDetails?.unitOfMeasureName ?? '-'),
            const SizedBox(height: 14),

            CustomFormInput(
              controller: _qtyCtrl,
              label: 'Quantity to Unbuild',
              hintText: _maxQty > 0 ? 'Max: ${_maxQty.toStringAsFixed(2)}' : '0.00',
              required: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                var qty = double.tryParse(v) ?? 0;
                if (_maxQty > 0 && qty > _maxQty) {
                  qty = _maxQty;
                  _qtyCtrl.text = qty.toStringAsFixed(2);
                  _qtyCtrl.selection = TextSelection.fromPosition(
                    TextPosition(offset: _qtyCtrl.text.length),
                  );
                  _snack('Quantity cannot exceed ${_maxQty.toStringAsFixed(2)}');
                }
                widget.formData.unbuildQty = qty;
                _updatePreview();
              },
            ),
            const SizedBox(height: 14),

            _readOnlyField('Source Warehouse', moDetails?.sourceWarehouseName ?? '-'),
            const SizedBox(height: 14),
            _readOnlyField('Source Location', moDetails?.sourceLocationName ?? '-'),
            const SizedBox(height: 14),
          ],

          _sectionLabel('Unbuild Date'),
          _datePicker(
            value: widget.formData.unbuildDate,
            hint: 'Select unbuild date (optional)',
            onPicked: (d) => setState(() => widget.formData.unbuildDate = d),
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _notesCtrl,
            label: 'Notes',
            hintText: 'Write note for this unbuild order (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildComponentsPreviewTab() {
    final ctrl = context.watch<UnbuildOrderController>();
    if (widget.formData.idBom == null || widget.formData.unbuildQty <= 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 48, color: colorGreyLight),
              const SizedBox(height: 12),
              Text(
                'Select Manufacturing Order and enter quantity first',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
              ),
            ],
          ),
        ),
      );
    }
    if (ctrl.isLoadingPreview) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    if (ctrl.previewComponents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No components to recover',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: ctrl.previewComponents.length,
      itemBuilder: (_, i) {
        final c = ctrl.previewComponents[i];
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

  Widget _buildDestinationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorPrimary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: colorPrimary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Destination is required when confirming or validating this order.',
                    style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary),
                  ),
                ),
              ],
            ),
          ),
          CustomSearchableDropdown<UOWarehouseOption>(
            key: ValueKey('dwh_${widget.formData.destinationWarehouse}_${_opts?.warehouses.length}'),
            value: _opts?.warehouses.where((w) => w.id == widget.formData.destinationWarehouse).firstOrNull,
            items: _opts?.warehouses ?? [],
            itemLabel: (w) => w.name,
            onChanged: (v) => setState(() {
              widget.formData.destinationWarehouse = v?.id;
              widget.formData.destinationLocation = null;
            }),
            label: 'Destination Warehouse',
            clearable: false,
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<UOLocationOption>(
            key: ValueKey('dloc_${widget.formData.destinationLocation}_${widget.formData.destinationWarehouse}'),
            value: _opts?.locations.where((l) => l.id == widget.formData.destinationLocation).firstOrNull,
            items: _locationsForWarehouse(widget.formData.destinationWarehouse),
            itemLabel: (l) => l.name,
            onChanged: (v) => setState(() => widget.formData.destinationLocation = v?.id),
            label: 'Destination Location',
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
              widget.formData.isEditMode ? 'Update Unbuild Order' : 'Save Unbuild Order',
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

  Widget _readOnlyField(String label, String value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorGreyLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.poppins(fontSize: 13, color: colorTextPrimary, fontWeight: FontWeight.w500)),
          ],
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