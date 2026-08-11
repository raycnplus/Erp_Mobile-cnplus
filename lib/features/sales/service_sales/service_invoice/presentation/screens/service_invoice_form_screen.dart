import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/controllers/service_invoice_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/data/models/service_invoice_models.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/widgets/service_invoice_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ServiceInvoiceFormScreen extends StatefulWidget {
  final String? encryption;
  const ServiceInvoiceFormScreen({super.key, this.encryption});

  @override
  State<ServiceInvoiceFormScreen> createState() => _State();
}

class _State extends State<ServiceInvoiceFormScreen> {
  late ServiceInvoiceFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = ServiceInvoiceFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<ServiceInvoiceController>();
    try {
      await ctrl.fetchFormOptions();
      final opts = ctrl.formOptions;

      // Pre-fill salesperson dengan current user saat create
      if (!isEditMode && opts?.currentUserId != null) {
        _form.salesPerson = opts!.currentUserId;
      }

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) _form = ServiceInvoiceFormModel.fromDetail(d);
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  void _snack(String msg, {bool success = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  Future<void> _handleSave() async {
    final ctrl = context.read<ServiceInvoiceController>();
    final success = await ctrl.save(_form, status: 'save');
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Service Invoice' : 'Create Service Invoice',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<ServiceInvoiceController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              ServiceInvoiceFormFields(
                formData:    _form,
                formOptions: ctrl.formOptions,
                onSave:      _handleSave,
                isSaving:    ctrl.isSaving,
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