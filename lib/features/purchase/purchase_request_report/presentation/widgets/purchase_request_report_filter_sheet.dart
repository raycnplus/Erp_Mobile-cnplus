import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';

import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/presentation/controllers/purchase_request_report_controller.dart';

import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/models/purchase_request_report_models.dart';

import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class PurchaseRequestReportFilterSheet
    extends StatefulWidget {
  const PurchaseRequestReportFilterSheet({
    super.key,
  });

  @override
  State<PurchaseRequestReportFilterSheet>
      createState() =>
          _PurchaseRequestReportFilterSheetState();
}

class _PurchaseRequestReportFilterSheetState
    extends State<PurchaseRequestReportFilterSheet> {
  late int? _warehouseId;

  late int? _locationId;

  late DateTime? _dateFrom;

  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();

    final ctrl =
        context.read<
            PurchaseRequestReportController>();

    _warehouseId =
        ctrl.selectedWarehouseId;

    _locationId =
        ctrl.selectedLocationId;

    _dateFrom =
        ctrl.dateFrom;

    _dateTo =
        ctrl.dateTo;
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _pickDate({
    required bool isFrom,
  }) async {
    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          (isFrom
                  ? _dateFrom
                  : _dateTo) ??
              DateTime.now(),
      firstDate:
          DateTime(2020),
      lastDate:
          DateTime(2100),
      builder: (
        ctx,
        child,
      ) =>
          Theme(
        data:
            Theme.of(ctx)
                .copyWith(
          colorScheme:
              const ColorScheme.light(
            primary:
                colorPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom =
              picked;
        } else {
          _dateTo =
              picked;
        }
      });
    }
  }

  String _fmt(
    DateTime? d,
  ) =>
      d == null
          ? 'Select date'
          : '${d.year}-'
            '${d.month.toString().padLeft(2, '0')}-'
            '${d.day.toString().padLeft(2, '0')}';

  // ============================================================
  // SECTION LABEL
  // ============================================================

  Widget _sectionLabel(
    String label,
  ) =>
      Padding(
        padding:
            const EdgeInsets.only(
          bottom: 8,
        ),
        child: Text(
          label,
          style:
              const TextStyle(
            fontSize: 14,
            fontWeight:
                FontWeight.w500,
            color:
                Colors.black87,
          ),
        ),
      );

  // ============================================================
  // DATE PICKER BOX
  // ============================================================

  Widget _datePickerBox({
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration:
            BoxDecoration(
          color: colorCard,
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          border:
              Border.all(
            color: value != null
                ? colorPrimary
                : colorGreyLight,
            width: value != null
                ? 1.5
                : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons
                  .calendar_today_outlined,
              size: 16,
              color: value != null
                  ? colorPrimary
                  : colorGrey,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                _fmt(value),
                style:
                    GoogleFonts.poppins(
                  fontSize: 13,
                  color: value != null
                      ? colorTextPrimary
                      : colorGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<
        PurchaseRequestReportController>(
      builder: (
        context,
        ctrl,
        child,
      ) {
        return Padding(
          padding:
              EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom:
                MediaQuery.of(
                          context,
                        )
                        .viewInsets
                        .bottom +
                    16,
          ),
          child:
              SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                // ==================================================
                // TITLE
                // ==================================================

                Text(
                  'Filter Purchase Request',
                  style:
                      GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        colorTextPrimary,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // ==================================================
                // WAREHOUSE
                // ==================================================

                CustomSearchableDropdown<
                    PurchaseRequestWarehouseOption>(
                  value: ctrl
                          .warehouseOptions
                          .where(
                            (w) =>
                                w.idWarehouse ==
                                _warehouseId,
                          )
                          .isEmpty
                      ? null
                      : ctrl
                          .warehouseOptions
                          .firstWhere(
                            (w) =>
                                w.idWarehouse ==
                                _warehouseId,
                          ),
                  items:
                      ctrl.warehouseOptions,
                  itemLabel: (
                    w,
                  ) =>
                      w.warehouseName,
                  onChanged: (
                    val,
                  ) async {
                    setState(() {
                      _warehouseId =
                          val?.idWarehouse;

                      _locationId = null;
                    });

                    await ctrl
                        .selectWarehouse(
                      val?.idWarehouse,
                    );
                  },
                  label:
                      'Destination Warehouse',
                  hintText:
                      'All Warehouses',
                  clearable:
                      true,
                ),

                const SizedBox(
                  height: 14,
                ),

                // ==================================================
                // LOCATION
                // ==================================================

                ctrl.isLoadingLocations
                    ? const Padding(
                        padding:
                            EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child:
                            Center(
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
                          ),
                        ),
                      )
                    : CustomSearchableDropdown<
                        PurchaseRequestLocationOption>(
                        value: ctrl
                                .locationOptions
                                .where(
                                  (l) =>
                                      l.idLocation ==
                                      _locationId,
                                )
                                .isEmpty
                            ? null
                            : ctrl
                                .locationOptions
                                .firstWhere(
                                  (l) =>
                                      l.idLocation ==
                                      _locationId,
                                ),
                        items:
                            ctrl.locationOptions,
                        itemLabel: (
                          l,
                        ) =>
                            l.locationName,
                        onChanged: (
                          val,
                        ) {
                          setState(() {
                            _locationId =
                                val?.idLocation;
                          });
                        },
                        label:
                            'Destination Location',
                        hintText:
                            'All Locations',
                        clearable:
                            true,
                      ),

                const SizedBox(
                  height: 16,
                ),

                // ==================================================
                // DATE RANGE
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          _sectionLabel(
                            'From Date',
                          ),
                          _datePickerBox(
                            value:
                                _dateFrom,
                            onTap: () =>
                                _pickDate(
                              isFrom:
                                  true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          _sectionLabel(
                            'To Date',
                          ),
                          _datePickerBox(
                            value:
                                _dateTo,
                            onTap: () =>
                                _pickDate(
                              isFrom:
                                  false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // ==================================================
                // BUTTON
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child:
                          OutlinedButton(
                        onPressed:
                            () {
                          ctrl.resetFilter();

                          Navigator.pop(
                            context,
                          );
                        },
                        style:
                            OutlinedButton
                                .styleFrom(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 12,
                          ),
                          side:
                              const BorderSide(
                            color:
                                colorGreyLight,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                        ),
                        child:
                            Text(
                          'Reset',
                          style:
                              GoogleFonts
                                  .poppins(
                            color:
                                colorTextPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                          ElevatedButton(
                        onPressed:
                            () {
                          // Set warehouse kembali
                          // sebelum apply.
                          ctrl.selectWarehouse(
                            _warehouseId,
                          );

                          ctrl.selectLocation(
                            _locationId,
                          );

                          ctrl.setDateRange(
                            _dateFrom,
                            _dateTo,
                          );

                          ctrl.applyFilter();

                          Navigator.pop(
                            context,
                          );
                        },
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              colorPrimary,
                          foregroundColor:
                              colorWhite,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 12,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),
                        ),
                        child:
                            Text(
                          'Apply Filter',
                          style:
                              GoogleFonts
                                  .poppins(
                            fontWeight:
                                FontWeight
                                    .w600,
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