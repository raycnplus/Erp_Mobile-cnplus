import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/models/leave_request_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class LeaveRequestFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final LeaveRequestFormModel formData;
  final LeaveRequestFormOptions? formOptions;
  final VoidCallback onSaveDraft;
  final VoidCallback onSubmit;

  const LeaveRequestFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.formOptions,
    required this.onSaveDraft,
    required this.onSubmit,
  });

  @override
  State<LeaveRequestFormFields> createState() =>
      _LeaveRequestFormFieldsState();
}

class _LeaveRequestFormFieldsState extends State<LeaveRequestFormFields> {
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descCtrl.text = widget.formData.description ?? '';
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) => DateFormat('d MMM yyyy').format(d);

  bool _validate() {
    if (widget.formData.idLeaveType == null) {
      _snack('Please select a leave type');
      return false;
    }
    if (widget.formData.startDate == null) {
      _snack('Please select start date');
      return false;
    }
    if (widget.formData.durationType == 'FULL' &&
        widget.formData.endDate == null) {
      _snack('Please select end date');
      return false;
    }
    if (widget.formData.durationType == 'HALF' &&
        widget.formData.halfSession == null) {
      _snack('Please select Morning or Afternoon session');
      return false;
    }
    widget.formData.description = _descCtrl.text.trim().isEmpty
        ? null
        : _descCtrl.text.trim();
    return true;
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (widget.formData.startDate ?? now)
        : (widget.formData.endDate ?? widget.formData.startDate ?? now);
    final firstDate = isStart ? now : (widget.formData.startDate ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: colorPrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          widget.formData.startDate = picked;
          if (widget.formData.endDate != null &&
              widget.formData.endDate!.isBefore(picked)) {
            widget.formData.endDate = picked;
          }
        } else {
          widget.formData.endDate = picked;
        }
      });
    }
  }

  LeaveTypeOption? get _selectedLeaveType {
    if (widget.formData.idLeaveType == null) return null;
    final m = widget.formOptions?.leaveTypes
        .where((t) => t.id == widget.formData.idLeaveType);
    return (m?.isEmpty == true) ? null : m?.first;
  }

  LeaveQuotaInfo? get _selectedQuota {
    if (widget.formData.idLeaveType == null) return null;
    final m = widget.formOptions?.leaveQuotas
        .where((q) => q.idLeaveType == widget.formData.idLeaveType);
    return (m?.isEmpty == true) ? null : m?.first;
  }

  @override
  Widget build(BuildContext context) {
    final quota = _selectedQuota;
    final leaveType = _selectedLeaveType;

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
                  CustomSearchableDropdown<LeaveTypeOption>(
                    key: ValueKey(
                      'lt_${widget.formData.idLeaveType}_${widget.formOptions?.leaveTypes.length ?? 0}',
                    ),
                    value: leaveType,
                    items: widget.formOptions?.leaveTypes ?? [],
                    itemLabel: (t) => t.name,
                    onChanged: (v) => setState(() {
                      widget.formData.idLeaveType = v?.id;
                      widget.formData.durationType = 'FULL';
                      widget.formData.halfSession = null;
                    }),
                    label: 'Leave Type',
                    isRequired: true,
                    clearable: false,
                  ),
                  const SizedBox(height: 8),
                  if (quota != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorPrimary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorPrimary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _quotaChip('Quota', quota.totalQuota),
                          Container(
                            height: 36,
                            width: 1,
                            color: colorGreyLight,
                          ),
                          _quotaChip('Used', quota.totalUsed),
                          Container(
                            height: 36,
                            width: 1,
                            color: colorGreyLight,
                          ),
                          _quotaChip(
                            'Remaining',
                            quota.totalRemaining,
                            highlight: true,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (leaveType?.allowHalfDay == true) ...[
                    Text(
                      'Duration Type',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _durationBtn('FULL', 'Full Day')),
                        const SizedBox(width: 10),
                        Expanded(child: _durationBtn('HALF', 'Half Day')),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (widget.formData.durationType == 'HALF') ...[
                    Text(
                      'Session',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _sessionBtn(
                            'MORNING',
                            'Morning (First Half)',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _sessionBtn(
                            'AFTERNOON',
                            'Afternoon (Second Half)',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Date Range *',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _dateBtn(
                          'Start Date',
                          widget.formData.startDate,
                          () => _pickDate(isStart: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: widget.formData.durationType == 'FULL'
                            ? _dateBtn(
                                'End Date',
                                widget.formData.endDate,
                                () => _pickDate(isStart: false),
                              )
                            : _dateBtn(
                                'End Date',
                                widget.formData.startDate,
                                null,
                                disabled: true,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    onChanged: (v) => widget.formData.description =
                        v.trim().isEmpty ? null : v.trim(),
                    decoration: InputDecoration(
                      hintText: 'Optional reason',
                      hintStyle: GoogleFonts.poppins(color: colorGrey),
                      filled: true,
                      fillColor: colorBackground,
                      contentPadding: const EdgeInsets.all(14),
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
                        borderSide: const BorderSide(
                          color: colorPrimary,
                          width: 2,
                        ),
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (!_validate()) return;
                      widget.onSaveDraft();
                    },
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: Text(
                      widget.formData.isEditMode
                          ? 'Update Draft'
                          : 'Save Draft',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: colorPrimary,
                      side: const BorderSide(color: colorPrimary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!_validate()) return;
                      widget.onSubmit();
                    },
                    icon: const Icon(Icons.send_outlined, size: 18),
                    label: Text(
                      'Submit',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: colorPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quotaChip(String label, double value, {bool highlight = false}) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(0),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: highlight ? colorPrimary : colorTextPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
        ),
      ],
    );
  }

  Widget _durationBtn(String value, String label) {
    final isSelected = widget.formData.durationType == value;
    return GestureDetector(
      onTap: () => setState(() {
        widget.formData.durationType = value;
        if (value == 'FULL') {
          widget.formData.halfSession = null;
        } else {
          widget.formData.endDate = widget.formData.startDate;
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colorPrimary : colorBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorPrimary : colorGreyLight,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? colorWhite : colorTextPrimary,
          ),
        ),
      ),
    );
  }

  Widget _sessionBtn(String value, String label) {
    final isSelected = widget.formData.halfSession == value;
    return GestureDetector(
      onTap: () => setState(() => widget.formData.halfSession = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade600 : colorBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.orange.shade600 : colorGreyLight,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? colorWhite : colorTextPrimary,
          ),
        ),
      ),
    );
  }

  Widget _dateBtn(
    String label,
    DateTime? date,
    VoidCallback? onTap, {
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: disabled ? colorGreyLight : colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: date != null ? colorPrimary : colorGreyLight,
            width: date != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: date != null ? colorPrimary : colorGrey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null ? _fmt(date) : label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: date != null ? colorTextPrimary : colorGrey,
                  fontWeight:
                      date != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}