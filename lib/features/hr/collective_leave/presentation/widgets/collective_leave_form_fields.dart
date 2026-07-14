import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/models/collective_leave_models.dart';

class CollectiveLeaveFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final CollectiveLeaveFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const CollectiveLeaveFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<CollectiveLeaveFormFields> createState() =>
      _CollectiveLeaveFormFieldsState();
}

class _CollectiveLeaveFormFieldsState
    extends State<CollectiveLeaveFormFields> {
  late TextEditingController nameCtrl;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.formData.collectiveLeaveName);
    if (widget.formData.fromDate.isNotEmpty) {
      _fromDate = DateTime.tryParse(widget.formData.fromDate);
    }
    if (widget.formData.toDate.isNotEmpty) {
      _toDate = DateTime.tryParse(widget.formData.toDate);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  String _formatDisplay(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  String _formatApi(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  int? get _duration {
    if (_fromDate == null || _toDate == null) return null;
    return _toDate!.difference(_fromDate!).inDays + 1;
  }

  Future<void> _pickDate(bool isFrom) async {
    final initial =
        isFrom ? (_fromDate ?? DateTime.now()) : (_toDate ?? _fromDate ?? DateTime.now());
    final first = isFrom ? DateTime(2000) : (_fromDate ?? DateTime(2000));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: colorPrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          widget.formData.fromDate = _formatApi(picked);
          if (_toDate != null && _toDate!.isBefore(picked)) {
            _toDate = null;
            widget.formData.toDate = '';
          }
        } else {
          _toDate = picked;
          widget.formData.toDate = _formatApi(picked);
        }
      });
    }
  }

  Widget _dateField(String label, DateTime? date, bool isFrom) {
    final isEmpty = date == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary,
                ),
              ),
              const TextSpan(
                text: '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(isFrom),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isEmpty ? colorError.withOpacity(0.5) : colorGreyLight,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: colorPrimary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEmpty ? 'Select date' : _formatDisplay(date),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isEmpty ? colorGrey : colorTextPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: colorGrey),
              ],
            ),
          ),
        ),
        if (isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              '$label is required',
              style: GoogleFonts.poppins(fontSize: 12, color: colorError),
            ),
          ),
      ],
    );
  }

  void _save() {
    widget.formData.collectiveLeaveName = nameCtrl.text;
  }

  @override
  Widget build(BuildContext context) {
    final dur = _duration;
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
                    label: 'Leave Name',
                    required: true,
                    hintText: 'e.g. Idul Fitri 2025',
                    validator: (_) => nameCtrl.text.trim().isEmpty
                        ? 'Leave name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _dateField('From Date', _fromDate, true),
                  const SizedBox(height: 16),
                  _dateField('To Date', _toDate, false),
                  if (dur != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorPrimary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colorPrimary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: colorPrimary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Duration: $dur day${dur > 1 ? 's' : ''}',
                            style: GoogleFonts.poppins(
                              color: colorPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  if (_fromDate == null || _toDate == null) {
                    setState(() {});
                    return;
                  }
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
                  widget.isEditMode
                      ? 'Update Collective Leave'
                      : 'Create Collective Leave',
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