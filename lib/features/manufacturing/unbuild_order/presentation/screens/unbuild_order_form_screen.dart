import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/controllers/unbuild_order_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/models/unbuild_order_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/widgets/unbuild_order_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class UnbuildOrderFormScreen extends StatefulWidget {
  final String? encryption;

  const UnbuildOrderFormScreen({super.key, this.encryption});

  @override
  State<UnbuildOrderFormScreen> createState() => _State();
}

class _State extends State<UnbuildOrderFormScreen> {
  late UnbuildOrderFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = UnbuildOrderFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<UnbuildOrderController>();

    await ctrl.fetchFormOptions(forceRefresh: true);
    if (!mounted) return;

    if (ctrl.formOptionsError != null) {
      setState(() => _isInitialized = true);
      return;
    }

    try {
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _form = UnbuildOrderFormModel.fromDetail(d);
          if (d.idManufacturingOrder != null) {
            await ctrl.fetchManufacturingOrderDetails(d.idManufacturingOrder!);
          }
          if (_form.idBom != null && _form.unbuildQty > 0) {
            await ctrl.fetchComponentsPreview([
              UOPreviewRequestItem(
                idBom: _form.idBom!,
                qty: _form.unbuildQty,
                productName: ctrl.selectedMoDetails?.productName ?? 'Product',
              ),
            ]);
          }
        }
      } else {
        _form.reference = ctrl.formOptions?.reference;
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    context.read<UnbuildOrderController>().resetFormOptions();
    context.read<UnbuildOrderController>().resetDetailState();
    super.dispose();
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
    final ctrl = context.read<UnbuildOrderController>();
    final success = await ctrl.save(_form, status: 'save');
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _retryFetchOptions() async {
    setState(() => _isInitialized = false);
    await _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Unbuild Order' : 'Create Unbuild Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<UnbuildOrderController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }

          if (ctrl.formOptionsError != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: colorError),
                    const SizedBox(height: 12),
                    Text(
                      ctrl.formOptionsError!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 13, color: colorTextPrimary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retryFetchOptions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: colorWhite,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              UnbuildOrderFormFields(
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