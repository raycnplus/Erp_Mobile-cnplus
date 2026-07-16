import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/models/workstation_models.dart';

class WorkstationFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final WorkstationFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const WorkstationFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<WorkstationFormFields> createState() => _WorkstationFormFieldsState();
}

class _WorkstationFormFieldsState extends State<WorkstationFormFields> {
  late TextEditingController _nameCtrl, _codeCtrl, _branchCtrl, _addressCtrl, _descCtrl;
  late TextEditingController _heightCtrl, _lengthCtrl, _widthCtrl, _volumeCtrl;

  @override
  void initState() {
    super.initState();
    final f = widget.formData;
    _nameCtrl = TextEditingController(text: f.workstationName);
    _codeCtrl = TextEditingController(text: f.workstationCode);
    _branchCtrl = TextEditingController(text: f.branch ?? '');
    _addressCtrl = TextEditingController(text: f.address ?? '');
    _descCtrl = TextEditingController(text: f.description ?? '');
    _heightCtrl = TextEditingController(text: f.height?.toString() ?? '');
    _lengthCtrl = TextEditingController(text: f.length?.toString() ?? '');
    _widthCtrl = TextEditingController(text: f.width?.toString() ?? '');
    _volumeCtrl = TextEditingController(text: f.volume?.toString() ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _codeCtrl, _branchCtrl, _addressCtrl, _descCtrl,
      _heightCtrl, _lengthCtrl, _widthCtrl, _volumeCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final f = widget.formData;
    f.workstationName = _nameCtrl.text;
    f.workstationCode = _codeCtrl.text;
    f.branch = _branchCtrl.text.isEmpty ? null : _branchCtrl.text;
    f.address = _addressCtrl.text.isEmpty ? null : _addressCtrl.text;
    f.description = _descCtrl.text.isEmpty ? null : _descCtrl.text;
    f.height = double.tryParse(_heightCtrl.text);
    f.length = double.tryParse(_lengthCtrl.text);
    f.width = double.tryParse(_widthCtrl.text);
    f.volume = double.tryParse(_volumeCtrl.text);
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
                    controller: _codeCtrl,
                    label: 'Workstation Code',
                    required: true,
                    hintText: 'e.g. WS-001',
                    validator: (_) => _codeCtrl.text.trim().isEmpty ? 'Code is required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: _nameCtrl,
                    label: 'Workstation Name',
                    required: true,
                    hintText: 'e.g. Cutting Station',
                    validator: (_) => _nameCtrl.text.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: _branchCtrl,
                    label: 'Branch',
                    hintText: 'e.g. Main Factory',
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: _addressCtrl,
                    label: 'Address',
                    hintText: 'Enter address',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: CustomFormInput(
                        controller: _heightCtrl,
                        label: 'Height',
                        hintText: '0.00',
                        keyboardType: TextInputType.number,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: CustomFormInput(
                        controller: _lengthCtrl,
                        label: 'Length',
                        hintText: '0.00',
                        keyboardType: TextInputType.number,
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: CustomFormInput(
                        controller: _widthCtrl,
                        label: 'Width',
                        hintText: '0.00',
                        keyboardType: TextInputType.number,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: CustomFormInput(
                        controller: _volumeCtrl,
                        label: 'Volume',
                        hintText: '0.00',
                        keyboardType: TextInputType.number,
                      )),
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
                  _save();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? 'Update Workstation' : 'Create Workstation',
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