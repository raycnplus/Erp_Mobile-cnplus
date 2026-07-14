import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/models/national_holiday_models.dart';

class NationalHolidayFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final NationalHolidayFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const NationalHolidayFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<NationalHolidayFormFields> createState() => _NationalHolidayFormFieldsState();
}

class _NationalHolidayFormFieldsState extends State<NationalHolidayFormFields> {
  late TextEditingController _nameCtrl;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.formData.holidayName);
    if (widget.formData.holidayDate.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.formData.holidayDate);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _formatDisplay(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
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
        _selectedDate = picked;
        widget.formData.holidayDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _save() {
    widget.formData.holidayName = _nameCtrl.text;
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
                    controller: _nameCtrl,
                    label: 'Holiday Name',
                    required: true,
                    hintText: 'Enter holiday name',
                    validator: (_) => _nameCtrl.text.trim().isEmpty
                        ? 'Holiday name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Holiday Date ',
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
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: colorBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedDate == null
                                  ? colorError.withOpacity(0.5)
                                  : colorGreyLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  color: colorPrimary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDate != null
                                      ? _formatDisplay(_selectedDate!)
                                      : 'Select date',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: _selectedDate != null
                                        ? colorTextPrimary
                                        : colorGrey,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: colorGrey),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedDate == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6, left: 4),
                          child: Text(
                            'Holiday date is required',
                            style: GoogleFonts.poppins(fontSize: 12, color: colorError),
                          ),
                        ),
                    ],
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
                  if (_selectedDate == null) {
                    setState(() {});
                    return;
                  }
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? 'Update Holiday' : 'Create Holiday',
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