import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/models/leave_allocation_models.dart';

class LeaveAllocationFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final LeaveAllocationFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final LeaveAllocationFormOptions? formOptions;
  final bool isLoadingFormOptions;

  const LeaveAllocationFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.formOptions,
    required this.isLoadingFormOptions,
  });

  @override
  State<LeaveAllocationFormFields> createState() =>
      _LeaveAllocationFormFieldsState();
}

class _LeaveAllocationFormFieldsState
    extends State<LeaveAllocationFormFields> {
  late TextEditingController nameCtrl,
      quotaCtrl,
      yearCtrl;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(
      text: widget.formData.allocationName,
    );

    quotaCtrl = TextEditingController(
      text: widget.formData.quota.toStringAsFixed(0),
    );

    yearCtrl = TextEditingController(
      text: widget.formData.year?.toString() ??
          DateTime.now().year.toString(),
    );

    if (widget.formData.year == null) {
      widget.formData.year = DateTime.now().year;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    quotaCtrl.dispose();
    yearCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.allocationName = nameCtrl.text;
    widget.formData.quota =
        double.tryParse(quotaCtrl.text) ?? 0;
    widget.formData.year =
        int.tryParse(yearCtrl.text);
  }

  LtOption? _findLeaveType(int? id) {
    if (id == null || widget.formOptions == null) {
      return null;
    }

    final m = widget.formOptions!.leaveTypes.where(
      (t) => t.id == id,
    );

    return m.isEmpty ? null : m.first;
  }

  Widget _buildDetailPicker() {
    final alloc = widget.formData.allocationBy;

    if (alloc == 'ALL') {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorPrimary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.people_outline, color: colorPrimary, size: 20),
            const SizedBox(width: 8),
            Expanded(                          
              child: Text(
                'Quota will be allocated to ALL employees',
                style: GoogleFonts.poppins(color: colorPrimary, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    final List<MapEntry<int, String>> options;
    final String label;

    if (alloc == 'EMPLOYEE') {
      options = (widget.formOptions?.employees ?? [])
          .map((e) => MapEntry(e.id, e.name))
          .toList();

      label = 'Employee';
    } else if (alloc == 'DEPARTMENT') {
      options = (widget.formOptions?.departments ?? [])
          .map((e) => MapEntry(e.id, e.name))
          .toList();

      label = 'Department';
    } else {
      options = (widget.formOptions?.positions ?? [])
          .map((e) => MapEntry(e.id, e.name))
          .toList();

      label = 'Position';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select $label(s)',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(
            maxHeight: 200,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorGreyLight,
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (_, i) {
              final opt = options[i];
              final id = opt.key;
              final name = opt.value;

              final isSelected = widget
                  .formData.selectedDetails
                  .any((d) => d.id == id);

              return CheckboxListTile(
                title: Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                  ),
                ),
                value: isSelected,
                activeColor: colorPrimary,
                dense: true,
                controlAffinity:
                    ListTileControlAffinity.leading,
                onChanged: (val) => setState(() {
                  if (val == true) {
                    widget.formData.selectedDetails.add(
                      LeaveAllocationDetailItem(
                        id: id,
                        name: name,
                        quota: widget.formData.quota,
                      ),
                    );
                  } else {
                    widget.formData.selectedDetails
                        .removeWhere(
                      (d) => d.id == id,
                    );
                  }
                }),
              );
            },
          ),
        ),
        if (widget.formData.selectedDetails.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorPrimary.withOpacity(0.3),
              ),
            ),
            child: Text(
              '${widget.formData.selectedDetails.length} selected',
              style: GoogleFonts.poppins(
                color: colorPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingFormOptions) {
      return const Center(
        child: CircularProgressIndicator(
          color: colorPrimary,
        ),
      );
    }

    final opts = widget.formOptions;

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
                    controller: nameCtrl,
                    label: "Allocation Name",
                    required: true,
                    hintText: "e.g. Annual Leave 2025",
                    validator: (_) =>
                        nameCtrl.text.trim().isEmpty
                            ? "Allocation name is required"
                            : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormInput(
                          controller: yearCtrl,
                          label: "Year",
                          required: true,
                          hintText: "e.g. 2025",
                          keyboardType:
                              TextInputType.number,
                          validator: (_) =>
                              int.tryParse(
                                        yearCtrl.text,
                                      ) ==
                                      null
                                  ? "Valid year required"
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomFormInput(
                          controller: quotaCtrl,
                          label: "Quota (days)",
                          required: true,
                          hintText: "e.g. 12",
                          keyboardType:
                              TextInputType.number,
                          validator: (_) =>
                              (double.tryParse(
                                            quotaCtrl.text,
                                          ) ??
                                          0) <=
                                      0
                                  ? "Valid quota required"
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomSearchableDropdown<LtOption>(
                    key: ValueKey(
                      'lt_${widget.formData.idLeaveType}_${opts?.leaveTypes.length ?? 0}',
                    ),
                    value: _findLeaveType(
                      widget.formData.idLeaveType,
                    ),
                    items: opts?.leaveTypes ?? [],
                    itemLabel: (t) => t.name,
                    onChanged: (v) => setState(
                      () => widget.formData.idLeaveType =
                          v?.id,
                    ),
                    label: "Leave Type",
                    isRequired: true,
                    clearable: false,
                    validator: (_) =>
                        widget.formData.idLeaveType ==
                                null
                            ? "Leave type is required"
                            : null,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Allocation By",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: (opts
                                    ?.allocationByOptions ??
                                [
                                  'ALL',
                                  'EMPLOYEE',
                                  'DEPARTMENT',
                                  'POSITION',
                                ])
                            .map((opt) {
                          final isSelected =
                              widget.formData
                                      .allocationBy ==
                                  opt;

                          return ChoiceChip(
                            label: Text(
                              opt,
                              style:
                                  GoogleFonts.poppins(
                                fontSize: 13,
                                color: isSelected
                                    ? colorWhite
                                    : colorTextPrimary,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor:
                                colorPrimary,
                            backgroundColor:
                                colorBackground,
                            side: BorderSide(
                              color: isSelected
                                  ? colorPrimary
                                  : colorGreyLight,
                            ),
                            onSelected: (_) =>
                                setState(() {
                              widget.formData
                                  .allocationBy = opt;

                              widget.formData
                                  .selectedDetails
                                  .clear();
                            }),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailPicker(),
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
                  color:
                      Colors.black.withOpacity(0.08),
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
                  padding:
                      const EdgeInsets.symmetric(
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
                      ? "Update Allocation"
                      : "Create Allocation",
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