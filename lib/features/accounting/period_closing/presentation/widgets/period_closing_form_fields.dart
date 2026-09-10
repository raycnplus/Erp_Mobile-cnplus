import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/models/period_closing_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class PeriodClosingFormFields extends StatefulWidget {
  final PeriodClosingFormModel formData;
  final VoidCallback onSave;
  final bool isSaving;

  const PeriodClosingFormFields({
    super.key,
    required this.formData,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<PeriodClosingFormFields> createState() => _State();
}

class _State extends State<PeriodClosingFormFields> {
  final _yearCtrl = TextEditingController();

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _yearCtrl.text = widget.formData.year?.toString() ?? '';
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    final yearVal = int.tryParse(_yearCtrl.text.trim());
    widget.formData.year = yearVal;

    if (yearVal == null || _yearCtrl.text.trim().length != 4) {
      _snack('Please enter a valid 4-digit year');
      return false;
    }
    if (widget.formData.isMonthly && widget.formData.month == null) {
      _snack('Please select month');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _sectionLabel('Closing Type *'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _typeChip('MONTHLY', 'Monthly'),
                    const SizedBox(width: 10),
                    _typeChip('YEARLY', 'Yearly'),
                  ],
                ),
                const SizedBox(height: 16),

                if (widget.formData.isMonthly) ...[
                  _sectionLabel('Month *'),
                  const SizedBox(height: 6),
                  _monthPicker(),
                  const SizedBox(height: 16),
                ],

                CustomFormInput(
                  controller: _yearCtrl,
                  label: 'Year',
                  hintText: 'e.g. ${DateTime.now().year}',
                  required: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onChanged: (v) => widget.formData.year = int.tryParse(v),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _typeChip(String value, String label) {
    final isSelected = widget.formData.type == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          widget.formData.type = value;
          if (value == 'YEARLY') widget.formData.month = null;
          if (value == 'MONTHLY' && widget.formData.month == null) {
            widget.formData.month = DateTime.now().month;
          }
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colorPrimary : colorBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? colorPrimary : colorGreyLight),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? colorWhite : colorTextPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorGreyLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: widget.formData.month,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          icon: const Icon(Icons.keyboard_arrow_down, color: colorGrey),
          style: GoogleFonts.poppins(fontSize: 13, color: colorTextPrimary),
          items: List.generate(
            12,
            (i) => DropdownMenuItem(value: i + 1, child: Text(_months[i])),
          ),
          onChanged: (v) => setState(() => widget.formData.month = v),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: colorTextPrimary,
    ),
  );

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: BoxDecoration(
      color: colorCard,
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
      ],
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSave(); },
        icon: widget.isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
              )
            : const Icon(Icons.save_outlined, size: 18),
        label: Text(
          widget.formData.isEditMode ? 'Update Period Closing' : 'Save Period Closing',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: colorPrimary,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    ),
  );
}