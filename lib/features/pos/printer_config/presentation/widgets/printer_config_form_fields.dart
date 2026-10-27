import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_switch.dart';

class PrinterConfigFormFields extends StatefulWidget {
  final PrinterConfigFormModel formData;
  final VoidCallback onSave;
  final bool isSaving;

  const PrinterConfigFormFields({
    super.key,
    required this.formData,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<PrinterConfigFormFields> createState() => _State();
}

class _State extends State<PrinterConfigFormFields> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.formData.printerName;
    _descCtrl.text = widget.formData.description ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.printerName = _nameCtrl.text.trim();
    widget.formData.description = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();

    if (widget.formData.printerName.isEmpty) {
      _snack('Printer Name is required');
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
                CustomFormInput(
                  controller: _nameCtrl,
                  label: 'Printer Name',
                  hintText: 'Enter printer name',
                  required: true,
                  maxLength: 100,
                ),
                const SizedBox(height: 14),
                CustomFormInput(
                  controller: _descCtrl,
                  label: 'Description',
                  hintText: 'Enter description (optional)',
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                CustomFormSwitchHorizontal(
                  label: 'Set as Default',
                  subtitle: 'This printer will be used by default',
                  value: widget.formData.isDefault,
                  onChanged: (v) => setState(() => widget.formData.isDefault = v),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: BoxDecoration(
      color: colorCard,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSave(); },
        icon: widget.isSaving
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
            : const Icon(Icons.save_outlined, size: 18),
        label: Text(
          widget.formData.isEditMode ? 'Update Printer' : 'Save Printer',
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