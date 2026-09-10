import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/controllers/bill_payment_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/models/bill_payment_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/widgets/bill_payment_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BillPaymentFormScreen extends StatefulWidget {
  final String? encryption;
  const BillPaymentFormScreen({super.key, this.encryption});

  @override
  State<BillPaymentFormScreen> createState() => _State();
}

class _State extends State<BillPaymentFormScreen> {
  late BillPaymentFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = BillPaymentFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<BillPaymentController>();
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
          _form = BillPaymentFormModel.fromDetail(d);
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

  Future<void> _handleSave() async {
    final ctrl = context.read<BillPaymentController>();
    final success = await ctrl.save(_form);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Bill Payment' : 'Create Bill Payment', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1, backgroundColor: colorWhite, foregroundColor: colorTextPrimary,
      ),
      body: Consumer<BillPaymentController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(children: [
            BillPaymentFormFields(formData: _form, formOptions: ctrl.formOptions, onSave: _handleSave, isSaving: ctrl.isSaving),
            if (ctrl.isSaving) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
          ]);
        },
      ),
    );
  }
}