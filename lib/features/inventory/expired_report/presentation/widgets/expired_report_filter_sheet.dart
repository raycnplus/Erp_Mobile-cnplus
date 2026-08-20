import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/presentation/controllers/expired_report_controller.dart';

class ExpiredReportFilterSheet extends StatefulWidget {
  const ExpiredReportFilterSheet({super.key});

  @override
  State<ExpiredReportFilterSheet> createState() =>
      _ExpiredReportFilterSheetState();
}

class _ExpiredReportFilterSheetState extends State<ExpiredReportFilterSheet> {
  late int? _warehouseId;
  late int? _locationId;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<ExpiredReportController>();
    _warehouseId = ctrl.selectedWarehouseId;
    _locationId = ctrl.selectedLocationId;
    _dateFrom = ctrl.dateFrom;
    _dateTo = ctrl.dateTo;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _dateFrom : _dateTo) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
        } else {
          _dateTo = picked;
        }
      });
    }
  }

  String _fmt(DateTime? d) => d == null
      ? 'Select date'
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpiredReportController>(
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
                  'Filter Expired',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),

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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From Date',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: () => _pickDate(isFrom: true),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: colorGreyLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              _fmt(_dateFrom),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: colorTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To Date',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: () => _pickDate(isFrom: false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: colorGreyLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              _fmt(_dateTo),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: colorTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                          ctrl.setDateRange(_dateFrom, _dateTo);
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
