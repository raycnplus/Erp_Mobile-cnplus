import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/hr/position/data/models/position_models.dart';

class PositionFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final PositionFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const PositionFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<PositionFormFields> createState() => _PositionFormFieldsState();
}

class _PositionFormFieldsState extends State<PositionFormFields> {
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.formData.positionName);
    descCtrl = TextEditingController(text: widget.formData.positionDescription);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.positionName = nameCtrl.text;
    widget.formData.positionDescription = descCtrl.text;
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomFormInput(
                    controller: nameCtrl,
                    label: 'Position Name',
                    required: true,
                    hintText: 'Enter position name',
                    validator: (_) => nameCtrl.text.trim().isEmpty
                        ? 'Position name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: descCtrl,
                    label: 'Description',
                    hintText: 'Enter description (optional)',
                    maxLines: 4,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? 'Update Position' : 'Create Position',
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