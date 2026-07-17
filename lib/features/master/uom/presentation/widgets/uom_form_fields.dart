import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/master/uom/data/models/uom_models.dart';

class UomFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final UomFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final List<UomRefOption> referenceUnits;

  const UomFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.referenceUnits,
  });

  @override
  State<UomFormFields> createState() => _UomFormFieldsState();
}

class _UomFormFieldsState extends State<UomFormFields> {
  late TextEditingController _nameCtrl;
  late TextEditingController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    final f = widget.formData;
    _nameCtrl = TextEditingController(text: f.uomName);
    _qtyCtrl = TextEditingController(
      text: f.quantity % 1 == 0
          ? f.quantity.toStringAsFixed(0)
          : f.quantity.toStringAsFixed(4),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.uomName = _nameCtrl.text.trim();
    widget.formData.quantity = double.tryParse(_qtyCtrl.text) ?? 1;
  }

  UomRefOption? _findRef(int? id) {
    if (id == null) return null;
    final m = widget.referenceUnits.where((r) => r.id == id);
    return m.isEmpty ? null : m.first;
  }

  String _fmtQty(double q) =>
      q % 1 == 0 ? q.toStringAsFixed(0) : q.toStringAsFixed(2);

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomFormInput(
                    controller: _nameCtrl,
                    label: 'UoM Name',
                    required: true,
                    hintText: 'e.g. Kilogram',
                    validator: (_) =>
                        _nameCtrl.text.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Quantity',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colorTextPrimary,
                            ),
                          ),
                          const Text(
                            ' *',
                            style: TextStyle(color: colorError, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _qtyCtrl,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val <= 0) return 'Quantity must be > 0';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '1.0',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: colorGrey,
                          ),
                          filled: true,
                          fillColor: colorBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: colorGreyLight),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: colorGreyLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: colorPrimary, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: colorError),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: colorError, width: 2),
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: colorTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.referenceUnits.isNotEmpty)
                    CustomSearchableDropdown<UomRefOption>(
                      key: ValueKey(
                          'ref_${widget.formData.referenceUnit}_${widget.referenceUnits.length}'),
                      value: _findRef(widget.formData.referenceUnit),
                      items: widget.referenceUnits,
                      itemLabel: (r) =>
                          '${r.name} (Qty: ${_fmtQty(r.quantity)})',
                      onChanged: (v) =>
                          setState(() => widget.formData.referenceUnit = v?.id),
                      label: 'Reference Unit',
                      clearable: true,
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorGreyLight),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.grey.shade500, size: 18),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'No other UoM available to set as reference.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _save();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? 'Update UoM' : 'Create UoM',
                  style: const TextStyle(
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