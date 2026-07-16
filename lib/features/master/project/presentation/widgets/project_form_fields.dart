import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';

class ProjectFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ProjectFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final ProjectFormOptions? formOptions;
  final bool isLoadingFormOptions;
  final String? defaultCode;

  const ProjectFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.formOptions,
    required this.isLoadingFormOptions,
    this.defaultCode,
  });

  @override
  State<ProjectFormFields> createState() => _ProjectFormFieldsState();
}

class _ProjectFormFieldsState extends State<ProjectFormFields> {
  late TextEditingController nameCtrl, descCtrl;
  DateTime? _startDate, _endDate;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.formData.projectName);
    descCtrl = TextEditingController(text: widget.formData.description ?? '');
    if (widget.formData.startDate != null) _startDate = DateTime.tryParse(widget.formData.startDate!);
    if (widget.formData.endDate != null) _endDate = DateTime.tryParse(widget.formData.endDate!);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.projectName = nameCtrl.text;
    widget.formData.description = descCtrl.text.isEmpty ? null : descCtrl.text;
    widget.formData.startDate = _startDate != null
        ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
        : null;
    widget.formData.endDate = _endDate != null
        ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
        : null;
  }

  String _fmtDisplay(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Widget _dateField(String label, DateTime? date, bool isStart, {bool required = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(
        text: TextSpan(children: [
          TextSpan(
            text: '$label ',
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary),
          ),
          if (required) const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontSize: 14)),
        ]),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () async {
          final first = isStart ? DateTime(2000) : (_startDate ?? DateTime(2000));
          final initial = date ?? (isStart ? DateTime.now() : (_startDate ?? DateTime.now()));
          final p = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: first,
            lastDate: DateTime(2100),
            builder: (ctx, child) => Theme(
              data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)),
              child: child!,
            ),
          );
          if (p != null) {
            setState(() {
              if (isStart) {
                _startDate = p;
                if (_endDate != null && _endDate!.isBefore(p)) _endDate = null;
              } else {
                _endDate = p;
              }
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: required && date == null ? colorError.withOpacity(0.5) : colorGreyLight),
          ),
          child: Row(children: [
            const Icon(Icons.calendar_today_outlined, color: colorPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date != null ? _fmtDisplay(date) : 'Select date',
                style: GoogleFonts.poppins(fontSize: 14, color: date != null ? colorTextPrimary : colorGrey),
              ),
            ),
            if (date != null && !isStart)
              GestureDetector(
                onTap: () => setState(() => _endDate = null),
                child: const Icon(Icons.close, color: colorGrey, size: 18),
              ),
          ]),
        ),
      ),
      if (required && date == null)
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text('$label is required', style: GoogleFonts.poppins(fontSize: 12, color: colorError)),
        ),
    ]);
  }

  ProjectCustomerOption? _findCustomer(int? id) {
    if (id == null || widget.formOptions == null) return null;
    final m = widget.formOptions!.customers.where((c) => c.id == id);
    return m.isEmpty ? null : m.first;
  }

  ProjectUserOption? _findUser(int? id) {
    if (id == null || widget.formOptions == null) return null;
    final m = widget.formOptions!.users.where((u) => u.id == id);
    return m.isEmpty ? null : m.first;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingFormOptions) return const Center(child: CircularProgressIndicator(color: colorPrimary));
    final opts = widget.formOptions;
    return Form(
      key: widget.formKey,
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (!widget.isEditMode && widget.defaultCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorPrimary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorPrimary.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.tag, color: colorPrimary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Project Code: ${widget.defaultCode}',
                      style: GoogleFonts.poppins(color: colorPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ]),
                ),
              CustomFormInput(
                controller: nameCtrl,
                label: "Project Name",
                required: true,
                hintText: "Enter project name",
                validator: (_) => nameCtrl.text.trim().isEmpty ? "Project name is required" : null,
              ),
              const SizedBox(height: 16),
              CustomSearchableDropdown<ProjectUserOption>(
                key: ValueKey('mgr_${widget.formData.projectManagerId}_${opts?.users.length ?? 0}'),
                value: _findUser(widget.formData.projectManagerId),
                items: opts?.users ?? [],
                itemLabel: (u) => u.name,
                onChanged: (v) => setState(() => widget.formData.projectManagerId = v?.id),
                label: "Project Manager",
                isRequired: true,
                clearable: false,
                validator: (_) => widget.formData.projectManagerId == null ? "Project manager is required" : null,
              ),
              const SizedBox(height: 16),
              CustomSearchableDropdown<ProjectCustomerOption>(
                key: ValueKey('cust_${widget.formData.customerId}_${opts?.customers.length ?? 0}'),
                value: _findCustomer(widget.formData.customerId),
                items: opts?.customers ?? [],
                itemLabel: (c) => c.name,
                onChanged: (v) => setState(() => widget.formData.customerId = v?.id),
                label: "Customer (optional)",
                clearable: true,
              ),
              const SizedBox(height: 16),
              _dateField("Start Date", _startDate, true, required: true),
              const SizedBox(height: 16),
              _dateField("End Date", _endDate, false),
              const SizedBox(height: 16),
              CustomFormInput(
                controller: descCtrl,
                label: "Description",
                hintText: "Optional description",
                maxLines: 3,
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorCard,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
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
                widget.isEditMode ? "Update Project" : "Create Project",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}