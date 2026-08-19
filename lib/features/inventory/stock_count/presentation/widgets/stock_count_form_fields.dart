import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class StockCountFormFields extends StatefulWidget {
  final StockCountFormOptions? formOptions;
  final SCWarehouseOption? warehouse;
  final SCLocationOption? location;
  final String selectBy;
  final TextEditingController noteCtrl;
  final ValueChanged<SCWarehouseOption?> onWarehouseChanged;
  final ValueChanged<SCLocationOption?> onLocationChanged;
  final ValueChanged<String> onSelectByChanged;
  final VoidCallback onSave;
  final bool isSaving;

  const StockCountFormFields({
    super.key,
    required this.formOptions,
    required this.warehouse,
    required this.location,
    required this.selectBy,
    required this.noteCtrl,
    required this.onWarehouseChanged,
    required this.onLocationChanged,
    required this.onSelectByChanged,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<StockCountFormFields> createState() => _State();
}

class _State extends State<StockCountFormFields> {
  StockCountFormOptions? get _opts => widget.formOptions;

  List<SCLocationOption> _getFilteredLocations() {
    if (_opts == null || widget.warehouse == null) return [];
    return _opts!.locationsForWarehouse(widget.warehouse!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSearchableDropdown<SCWarehouseOption>(
                  key: ValueKey('wh_${widget.warehouse?.id}_${_opts?.warehouses.length}'),
                  value: widget.warehouse,
                  items: _opts?.warehouses ?? [],
                  itemLabel: (w) => w.name,
                  onChanged: widget.onWarehouseChanged,
                  isRequired: true,
                  label: 'Warehouse',
                  clearable: false,
                ),
                const SizedBox(height: 14),

                CustomSearchableDropdown<SCLocationOption>(
                  key: ValueKey('loc_${widget.location?.id}_${widget.warehouse?.id}'),
                  value: _getFilteredLocations().where((l) => l.id == widget.location?.id).firstOrNull,
                  items: _getFilteredLocations(),
                  itemLabel: (l) => l.name,
                  onChanged: widget.onLocationChanged,
                  label: 'Location (optional — leave empty for all locations)',
                  clearable: true,
                ),
                const SizedBox(height: 14),

                Text('Select By', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'all',
                        groupValue: widget.selectBy,
                        onChanged: (v) => widget.onSelectByChanged(v!),
                        title: Text('All Products', style: GoogleFonts.poppins(fontSize: 13)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'product',
                        groupValue: widget.selectBy,
                        onChanged: (v) => widget.onSelectByChanged(v!),
                        title: Text('Specific Product', style: GoogleFonts.poppins(fontSize: 13)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                CustomFormInput(
                  controller: widget.noteCtrl,
                  label: 'Note',
                  hintText: 'Optional note',
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _buildBottomBar(),
      ],
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
            onPressed: widget.isSaving ? null : widget.onSave,
            icon: widget.isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
                : const Icon(Icons.save_outlined, size: 18),
            label: Text('Save Stock Count', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}