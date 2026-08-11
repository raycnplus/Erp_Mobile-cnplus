import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/models/store_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class StoreFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final StoreFormModel formData;
  final StoreFormOptions formOptions;
  final bool isEditMode;
  final VoidCallback onSubmit;

  const StoreFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.formOptions,
    required this.isEditMode,
    required this.onSubmit,
  });

  @override
  State<StoreFormFields> createState() =>
      _StoreFormFieldsState();
}

class _StoreFormFieldsState extends State<StoreFormFields> {
  late TextEditingController _nameCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(
      text: widget.formData.storeName,
    );

    _addressCtrl = TextEditingController(
      text: widget.formData.address,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();

    super.dispose();
  }

  void _save() {
    widget.formData.storeName =
        _nameCtrl.text.trim();

    widget.formData.address =
        _addressCtrl.text.trim();
  }

  StoreOptionItem? _findWarehouse(int? id) {
    if (id == null) {
      return null;
    }

    final matches = widget.formOptions.warehouses
        .where((warehouse) => warehouse.id == id);

    return matches.isEmpty ? null : matches.first;
  }

  StoreOptionItem? _findLocation(int? id) {
    if (id == null) {
      return null;
    }

    final matches = widget.formOptions.locations
        .where((location) => location.id == id);

    return matches.isEmpty ? null : matches.first;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  CustomFormInput(
                    controller: _nameCtrl,
                    label: 'Store Name',
                    required: true,
                    hintText: 'e.g. Main Store',
                    validator: (_) {
                      if (_nameCtrl.text.trim().isEmpty) {
                        return 'Store name is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: _addressCtrl,
                    label: 'Address',
                    required: true,
                    hintText: 'Enter store address',
                    maxLines: 3,
                    validator: (_) {
                      if (_addressCtrl.text
                          .trim()
                          .isEmpty) {
                        return 'Address is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<
                      StoreOptionItem>(
                    key: ValueKey(
                      'wh_'
                      '${widget.formData.warehouseId}_'
                      '${widget.formOptions.warehouses.length}',
                    ),
                    value: _findWarehouse(
                      widget.formData.warehouseId,
                    ),
                    items: widget.formOptions.warehouses,
                    itemLabel: (warehouse) =>
                        warehouse.name,
                    onChanged: (value) {
                      setState(() {
                        widget.formData.warehouseId =
                            value?.id;
                      });
                    },
                    label: 'Warehouse',
                    isRequired: true,
                    clearable: false,
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<
                      StoreOptionItem>(
                    key: ValueKey(
                      'loc_'
                      '${widget.formData.locationId}_'
                      '${widget.formOptions.locations.length}',
                    ),
                    value: _findLocation(
                      widget.formData.locationId,
                    ),
                    items: widget.formOptions.locations,
                    itemLabel: (location) =>
                        location.name,
                    onChanged: (value) {
                      setState(() {
                        widget.formData.locationId =
                            value?.id;
                      });
                    },
                    label: 'Location',
                    isRequired: true,
                    clearable: false,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorCard,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.08,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!widget.formKey.currentState!
                      .validate()) {
                    return;
                  }

                  if (widget.formData.warehouseId ==
                      null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select a warehouse',
                        ),
                        behavior:
                            SnackBarBehavior.floating,
                      ),
                    );

                    return;
                  }

                  if (widget.formData.locationId ==
                      null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select a location',
                        ),
                        behavior:
                            SnackBarBehavior.floating,
                      ),
                    );

                    return;
                  }

                  _save();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode
                      ? 'Update Store'
                      : 'Create Store',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}