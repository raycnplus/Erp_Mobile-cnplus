import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/controllers/manufacturing_order_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/widgets/manufacturing_order_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ManufacturingOrderFormScreen extends StatefulWidget {
  final String? encryption;

  const ManufacturingOrderFormScreen({super.key, this.encryption});

  @override
  State<ManufacturingOrderFormScreen> createState() => _State();
}

class _State extends State<ManufacturingOrderFormScreen> {
  late ManufacturingOrderFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = ManufacturingOrderFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<ManufacturingOrderController>();

    try {
      await ctrl.fetchFormOptions();

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _form = ManufacturingOrderFormModel.fromDetail(d);
          if (d.idBom != null) {
            await ctrl.fetchBomComponents(d.idBom!, qty: d.plannedQty);
          }
        }
      } else {
        _form.reference = ctrl.formOptions?.reference;
      }
    } catch (_) {}

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
    final ctrl = context.read<ManufacturingOrderController>();
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
          isEditMode ? 'Edit Manufacturing Order' : 'Create Manufacturing Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<ManufacturingOrderController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              ManufacturingOrderFormFields(
                formData: _form,
                formOptions: ctrl.formOptions,
                onSave: _handleSave,
                isSaving: ctrl.isSaving,
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