import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/models/overtime_type_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class OvertimeTypeFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final OvertimeTypeFormModel formData;
  final List<OvertimeCategoryOption> categories;
  final bool isEditMode;
  final VoidCallback onSubmit;

  const OvertimeTypeFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.categories,
    required this.isEditMode,
    required this.onSubmit,
  });

  @override
  State<OvertimeTypeFormFields> createState() => _OvertimeTypeFormFieldsState();
}

class _OvertimeTypeFormFieldsState extends State<OvertimeTypeFormFields> {
  late TextEditingController _nameCtrl;
  late TextEditingController _rateCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.formData.name);
    _rateCtrl = TextEditingController(text: widget.formData.rate.toString());
    _descCtrl = TextEditingController(text: widget.formData.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rateCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.name = _nameCtrl.text.trim();
    widget.formData.rate = double.tryParse(_rateCtrl.text) ?? 1.5;
    widget.formData.description =
        _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final cats = widget.categories.isNotEmpty
        ? widget.categories
        : [
            OvertimeCategoryOption(value: 'WEEKDAY', label: 'Weekday'),
            OvertimeCategoryOption(value: 'WEEKEND', label: 'Weekend'),
            OvertimeCategoryOption(value: 'HOLIDAY', label: 'Holiday'),
          ];

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
                    label: 'Overtime Type Name',
                    required: true,
                    hintText: 'e.g. Weekday Overtime',
                    validator: (_) => _nameCtrl.text.trim().isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Category',
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
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: cats.map((cat) {
                          final sel = widget.formData.category == cat.value;
                          Color c;
                          switch (cat.value) {
                            case 'WEEKDAY':
                              c = Colors.blue.shade700;
                              break;
                            case 'WEEKEND':
                              c = Colors.orange.shade700;
                              break;
                            default:
                              c = Colors.red.shade700;
                          }
                          return ChoiceChip(
                            label: Text(
                              cat.label,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: sel ? colorWhite : colorTextPrimary,
                              ),
                            ),
                            selected: sel,
                            selectedColor: c,
                            backgroundColor: colorBackground,
                            side: BorderSide(
                                color: sel ? c : colorGreyLight),
                            onSelected: (_) => setState(
                                () => widget.formData.category = cat.value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rate (x multiplier)',
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
                        controller: _rateCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]')),
                        ],
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val <= 0) {
                            return 'Rate must be > 0';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: '1.5',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 14, color: colorGrey),
                          filled: true,
                          fillColor: colorBackground,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: colorGreyLight),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: colorGreyLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: colorPrimary, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: colorError),
                          ),
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: colorTextPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: _descCtrl,
                    label: 'Description',
                    hintText: 'Optional description',
                    maxLines: 3,
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
                  if (!widget.formKey.currentState!.validate()) return;
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
                  widget.isEditMode
                      ? 'Update Overtime Type'
                      : 'Create Overtime Type',
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