import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/models/overtime_request_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class OvertimeRequestFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final OvertimeRequestFormModel formData;
  final OvertimeRequestFormOptions? formOptions;
  final VoidCallback onSaveDraft;
  final VoidCallback onSubmit;

  const OvertimeRequestFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.formOptions,
    required this.onSaveDraft,
    required this.onSubmit,
  });

  @override
  State<OvertimeRequestFormFields> createState() => _OvertimeRequestFormFieldsState();
}

class _OvertimeRequestFormFieldsState extends State<OvertimeRequestFormFields> {
  final _reasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reasonCtrl.text = widget.formData.reason ?? '';
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) => DateFormat('d MMM yyyy').format(d);

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _recalcHours() {
    final s = widget.formData.startTime;
    final e = widget.formData.endTime;
    if (s == null || e == null) return;

    double mins = e.hour * 60.0 + e.minute - (s.hour * 60.0 + s.minute);
    if (mins <= 0) mins += 24 * 60;

    setState(() {
      widget.formData.requestedHours = double.parse((mins / 60).toStringAsFixed(2));
    });
  }

  bool _validate() {
    if (widget.formData.idOvertimeType == null) {
      _snack('Please select overtime type');
      return false;
    }
    if (widget.formData.requestDate == null) {
      _snack('Please select request date');
      return false;
    }
    if (widget.formData.startTime == null) {
      _snack('Please select start time');
      return false;
    }
    if (widget.formData.endTime == null) {
      _snack('Please select end time');
      return false;
    }
    if (widget.formData.requestedHours < 3) {
      _snack('Minimum overtime duration is 3 hours');
      return false;
    }
    widget.formData.reason = _reasonCtrl.text.trim().isEmpty ? null : _reasonCtrl.text.trim();
    return true;
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  OvertimeTypeOption? get _selectedOTType {
    if (widget.formData.idOvertimeType == null) return null;
    final m = widget.formOptions?.overtimeTypes.where((t) => t.id == widget.formData.idOvertimeType);
    return (m?.isEmpty == true) ? null : m?.first;
  }

  @override
  Widget build(BuildContext context) {
    final opts = widget.formOptions;

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
                  if (opts?.currentEmployeeName != null) ...[
                    Text(
                      'Employee Name',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: colorGreyLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorGreyLight),
                      ),
                      child: Text(
                        opts!.currentEmployeeName!,
                        style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  CustomSearchableDropdown<OvertimeTypeOption>(
                    key: ValueKey(
                        'ot_${widget.formData.idOvertimeType}_${opts?.overtimeTypes.length ?? 0}'),
                    value: _selectedOTType,
                    items: opts?.overtimeTypes ?? [],
                    itemLabel: (t) => t.name,
                    onChanged: (v) => setState(() => widget.formData.idOvertimeType = v?.id),
                    label: 'Overtime Type',
                    isRequired: true,
                    clearable: false,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Request Date *',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _datePicker(),
                  const SizedBox(height: 16),
                  Text(
                    'Time *',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _timePicker('Start Time', widget.formData.startTime, (t) {
                          setState(() {
                            widget.formData.startTime = t;
                            _recalcHours();
                          });
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _timePicker('End Time', widget.formData.endTime, (t) {
                          setState(() {
                            widget.formData.endTime = t;
                            _recalcHours();
                          });
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Overtime Hours',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: colorBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorGreyLight),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: widget.formData.requestedHours > 0 ? colorPrimary : colorGrey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.formData.requestedHours > 0
                              ? '${widget.formData.requestedHours.toStringAsFixed(2)} hours'
                              : 'Calculated from Start & End Time',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: widget.formData.requestedHours > 0
                                ? colorTextPrimary
                                : colorGrey,
                            fontWeight: widget.formData.requestedHours > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        if (widget.formData.requestedHours > 0 && widget.formData.requestedHours < 3)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '(min. 3h)',
                              style: GoogleFonts.poppins(fontSize: 11, color: colorError),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Task Reason',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _reasonCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Optional',
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
                        borderSide: const BorderSide(color: colorPrimary, width: 2),
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
                      widget.formData.isEditMode ? 'Update Draft' : 'Save Draft',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: colorPrimary,
                      side: const BorderSide(color: colorPrimary, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    label: Text('Submit', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: colorPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _datePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: widget.formData.requestDate ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 1),
          lastDate: DateTime(DateTime.now().year + 1),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: colorPrimary),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => widget.formData.requestDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.formData.requestDate != null ? colorPrimary : colorGreyLight,
            width: widget.formData.requestDate != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: widget.formData.requestDate != null ? colorPrimary : colorGrey,
            ),
            const SizedBox(width: 8),
            Text(
              widget.formData.requestDate != null
                  ? _fmtDate(widget.formData.requestDate!)
                  : 'Select date',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: widget.formData.requestDate != null ? colorTextPrimary : colorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timePicker(String label, TimeOfDay? time, Function(TimeOfDay) onPicked) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: colorPrimary),
            ),
            child: child!,
          ),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: time != null ? colorPrimary : colorGreyLight,
            width: time != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 16, color: time != null ? colorPrimary : colorGrey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                time != null ? _fmtTime(time) : label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: time != null ? colorTextPrimary : colorGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}