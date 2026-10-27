import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/controllers/printer_config_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_switch.dart';

class PrinterConfigFormScreen extends StatefulWidget {
  final int? id;

  const PrinterConfigFormScreen({super.key, this.id});

  @override
  State<PrinterConfigFormScreen> createState() => _State();
}

class _State extends State<PrinterConfigFormScreen> {
  late PrinterConfigFormModel _form;
  bool _isInitialized = false;

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  bool get isEditMode => widget.id != null;

  @override
  void initState() {
    super.initState();
    _form = PrinterConfigFormModel(id: widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    if (!mounted) return;

    if (isEditMode) {
      final ctrl = context.read<PrinterConfigController>();
      await ctrl.fetchDetail(widget.id!);
      if (!mounted) return;
      final p = ctrl.detail;
      if (p != null) {
        _form = PrinterConfigFormModel.fromModel(p);
        _nameCtrl.text = p.printerName;
        _descCtrl.text = p.description ?? '';
      }
    }

    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _handleSave() async {
    if (_nameCtrl.text.trim().isEmpty) {
      _snack('Printer Name is required');
      return;
    }
    _form.printerName = _nameCtrl.text.trim();
    _form.description = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();

    final ctrl = context.read<PrinterConfigController>();
    final success = await ctrl.save(_form);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Printer' : 'Create Printer',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<PrinterConfigController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }

          return Stack(
            children: [
              Column(
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
                            value: _form.isDefault,
                            onChanged: (v) => setState(() => _form.isDefault = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    decoration: BoxDecoration(
                      color: colorCard,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: ctrl.isSaving ? null : _handleSave,
                        icon: ctrl.isSaving
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
                            : const Icon(Icons.save_outlined, size: 18),
                        label: Text(
                          isEditMode ? 'Update Printer' : 'Save Printer',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (ctrl.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator(color: colorPrimary)),
                ),
            ],
          );
        },
      ),
    );
  }
}
