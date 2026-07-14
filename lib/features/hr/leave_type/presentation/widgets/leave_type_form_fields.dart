import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/models/leave_type_models.dart';

class LeaveTypeFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final LeaveTypeFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final LeaveTypeFormOptions? formOptions;
  final bool isLoadingFormOptions;

  const LeaveTypeFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.formOptions,
    required this.isLoadingFormOptions,
  });

  @override
  State<LeaveTypeFormFields> createState() => _LeaveTypeFormFieldsState();
}

class _LeaveTypeFormFieldsState extends State<LeaveTypeFormFields> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.formData.leaveTypeName);
    _descCtrl = TextEditingController(text: widget.formData.leaveDescription ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.leaveTypeName = _nameCtrl.text;
    widget.formData.leaveDescription = _descCtrl.text.isEmpty ? null : _descCtrl.text;
  }

  Widget _switchRow(String label, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorGreyLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorTextPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: colorPrimary),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opts = widget.formOptions;
    if (widget.isLoadingFormOptions && opts == null) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
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
                    label: 'Leave Type Name',
                    required: true,
                    hintText: 'Enter leave type name',
                    validator: (_) => _nameCtrl.text.trim().isEmpty
                        ? 'Leave type name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<String>(
                    key: ValueKey('cat_${widget.formData.leaveCategory}_${opts?.categories.length ?? 0}'),
                    value: widget.formData.leaveCategory,
                    items: opts?.categories ?? ['LEAVE', 'PERMISSION', 'SICK'],
                    itemLabel: (v) => v,
                    onChanged: (v) => setState(() => widget.formData.leaveCategory = v),
                    label: 'Leave Category',
                    isRequired: true,
                    clearable: false,
                    validator: (_) => widget.formData.leaveCategory == null
                        ? 'Category is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<String>(
                    key: ValueKey('alloc_${widget.formData.allocationMethod}_${opts?.allocationMethods.length ?? 0}'),
                    value: widget.formData.allocationMethod,
                    items: opts?.allocationMethods ?? ['ANNUAL', 'MONTHLY', 'NONE'],
                    itemLabel: (v) => v,
                    onChanged: (v) => setState(() => widget.formData.allocationMethod = v),
                    label: 'Allocation Method',
                    isRequired: true,
                    clearable: false,
                    validator: (_) => widget.formData.allocationMethod == null
                        ? 'Allocation method is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<String>(
                    key: ValueKey('att_${widget.formData.requiredAttachment}_${opts?.attachmentOptions.length ?? 0}'),
                    value: widget.formData.requiredAttachment,
                    items: opts?.attachmentOptions ?? ['YES', 'OPTIONAL'],
                    itemLabel: (v) => v,
                    onChanged: (v) => setState(() => widget.formData.requiredAttachment = v),
                    label: 'Required Attachment',
                    isRequired: true,
                    clearable: false,
                    validator: (_) => widget.formData.requiredAttachment == null
                        ? 'Required attachment option is required'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _switchRow(
                    'Deduct Balance',
                    'Reduce employee leave balance when used',
                    widget.formData.deductBalance,
                    (v) => setState(() => widget.formData.deductBalance = v),
                  ),
                  const SizedBox(height: 10),
                  _switchRow(
                    'Carry Over',
                    'Allow unused leave to carry over to next period',
                    widget.formData.carryOver,
                    (v) => setState(() => widget.formData.carryOver = v),
                  ),
                  const SizedBox(height: 10),
                  _switchRow(
                    'Allow Half Day',
                    'Employees can apply for half-day leave',
                    widget.formData.allowHalfDay,
                    (v) => setState(() => widget.formData.allowHalfDay = v),
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: _descCtrl,
                    label: 'Description',
                    hintText: 'Enter description (optional)',
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
                  widget.isEditMode ? 'Update Leave Type' : 'Create Leave Type',
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