import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/controllers/history_stock_controller.dart';

class HistoryStockFilterSheet extends StatefulWidget {
  const HistoryStockFilterSheet({super.key});

  @override
  State<HistoryStockFilterSheet> createState() =>
      _HistoryStockFilterSheetState();
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
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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

                Text(
                  'Date',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: _pickDate,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: colorGreyLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _fmt(_date),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: colorTextPrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                Text(
                  'Warehouse',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int?>(
                  value: _warehouseId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('All Warehouses'),
                    ),
                    ...ctrl.warehouseOptions.map(
                      (w) => DropdownMenuItem<int?>(
                        value: w.idWarehouse,
                        child: Text(w.warehouseName),
                      ),
                    ),
                  ],
                  onChanged: (val) async {
                    setState(() {
                      _warehouseId = val;
                      _locationId = null;
                    });
                    await ctrl.selectWarehouse(val);
                  },
                ),

                const SizedBox(height: 14),
                Text(
                  'Location',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                ctrl.isLoadingLocations
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : DropdownButtonFormField<int?>(
                        value: _locationId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('All Locations'),
                          ),
                          ...ctrl.locationOptions.map(
                            (l) => DropdownMenuItem<int?>(
                              value: l.idLocation,
                              child: Text(l.locationName),
                            ),
                          ),
                        ],
                        onChanged: (val) => setState(() => _locationId = val),
                      ),

                const SizedBox(height: 14),
                Text(
                  'Product',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorTextSubtle,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int?>(
                  value: _productId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('All Products'),
                    ),
                    ...ctrl.productOptions.map(
                      (p) => DropdownMenuItem<int?>(
                        value: p.idProduct,
                        child: Text(
                          '${p.productCode} - ${p.productName}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => _productId = val),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: GoogleFonts.poppins(color: colorTextPrimary),
                        ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Apply Filter',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
