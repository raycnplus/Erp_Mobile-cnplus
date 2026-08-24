import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/controllers/history_stock_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/models/history_stock_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class HistoryStockFilterSheet extends StatefulWidget {
  const HistoryStockFilterSheet({super.key});

  @override
  State<HistoryStockFilterSheet> createState() => _HistoryStockFilterSheetState();
}

class _HistoryStockFilterSheetState extends State<HistoryStockFilterSheet> {
  late int? _warehouseId;
  late int? _locationId;
  late int? _productId;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<HistoryStockController>();
    _warehouseId = ctrl.selectedWarehouseId;
    _locationId = ctrl.selectedLocationId;
    _productId = ctrl.selectedProductId;
    _date = ctrl.selectedDate;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      );

  Widget _datePickerBox({
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorCard,
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
              value != null ? _fmt(value) : 'Select date',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: value != null ? colorTextPrimary : colorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryStockController>(
      builder: (context, ctrl, child) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filter History',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                _sectionLabel('Date'),
                _datePickerBox(value: _date, onTap: _pickDate),

                const SizedBox(height: 14),
                CustomSearchableDropdown<HistoryWarehouseOption>(
                  value: ctrl.warehouseOptions.where((w) => w.idWarehouse == _warehouseId).isEmpty
                      ? null
                      : ctrl.warehouseOptions.firstWhere((w) => w.idWarehouse == _warehouseId),
                  items: ctrl.warehouseOptions,
                  itemLabel: (w) => w.warehouseName,
                  onChanged: (val) async {
                    setState(() {
                      _warehouseId = val?.idWarehouse;
                      _locationId = null;
                    });
                    await ctrl.selectWarehouse(val?.idWarehouse);
                  },
                  label: 'Warehouse',
                  hintText: 'All Warehouses',
                  clearable: true,
                ),

                const SizedBox(height: 14),
                ctrl.isLoadingLocations
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : CustomSearchableDropdown<HistoryLocationOption>(
                        value: ctrl.locationOptions.where((l) => l.idLocation == _locationId).isEmpty
                            ? null
                            : ctrl.locationOptions.firstWhere((l) => l.idLocation == _locationId),
                        items: ctrl.locationOptions,
                        itemLabel: (l) => l.locationName,
                        onChanged: (val) => setState(() => _locationId = val?.idLocation),
                        label: 'Location',
                        hintText: 'All Locations',
                        clearable: true,
                      ),

                const SizedBox(height: 14),
                CustomSearchableDropdown<HistoryProductOption>(
                  value: ctrl.productOptions.where((p) => p.idProduct == _productId).isEmpty
                      ? null
                      : ctrl.productOptions.firstWhere((p) => p.idProduct == _productId),
                  items: ctrl.productOptions,
                  itemLabel: (p) => '${p.productCode} - ${p.productName}',
                  onChanged: (val) => setState(() => _productId = val?.idProduct),
                  label: 'Product',
                  hintText: 'All Products',
                  clearable: true,
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ctrl.resetFilter();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: colorGreyLight),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Reset', style: GoogleFonts.poppins(color: colorTextPrimary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ctrl.selectLocation(_locationId);
                          ctrl.selectProduct(_productId);
                          ctrl.setDate(_date);
                          ctrl.applyFilter();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Apply Filter', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}