import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/controllers/cash_bank_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/widgets/cash_bank_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class CashBankFormScreen extends StatefulWidget {
  final String? encryption;
  const CashBankFormScreen({super.key, this.encryption});

  @override
  State<CashBankFormScreen> createState() => _State();
}

class _State extends State<CashBankFormScreen> {
  late CashBankFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = CashBankFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<CashBankController>();
    try {
      await ctrl.fetchFormOptions();
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          if (!d.canEdit) {
            if (mounted) Navigator.pop(context);
            return;
          }
          _form = CashBankFormModel.fromDetail(d);
        }
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _handleSubmit(String action) async {
    final ctrl = context.read<CashBankController>();
    final success = action == 'post' ? await ctrl.post(_form) : await ctrl.save(_form);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Cash & Bank' : 'Create Cash & Bank', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1, backgroundColor: colorWhite, foregroundColor: colorTextPrimary,
      ),
      body: Consumer<CashBankController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(children: [
            CashBankFormFields(formData: _form, formOptions: ctrl.formOptions, onSubmit: _handleSubmit, isSaving: ctrl.isSaving),
            if (ctrl.isSaving) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
          ]);
        },
      ),
    );
  }
}