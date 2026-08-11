import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/controllers/service_sales_order_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/models/service_sales_order_models.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/widgets/service_sales_order_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ServiceSalesOrderFormScreen extends StatefulWidget {
  final String? encryption;
  const ServiceSalesOrderFormScreen({super.key, this.encryption});

  @override
  State<ServiceSalesOrderFormScreen> createState() => _State();
}

class _State extends State<ServiceSalesOrderFormScreen> {
  late ServiceSalesOrderFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = ServiceSalesOrderFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<ServiceSalesOrderController>();
    try {
      await ctrl.fetchFormOptions();
      final opts = ctrl.formOptions;

      if (!isEditMode && opts?.currentUserId != null) {
        _form.salesPerson = opts!.currentUserId;
      }

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _form = ServiceSalesOrderFormModel.fromDetail(d);
        }
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
    final ctrl = context.read<ServiceSalesOrderController>();
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
          isEditMode ? 'Edit Service Sales Order' : 'Create Service Sales Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<ServiceSalesOrderController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              ServiceSalesOrderFormFields(
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