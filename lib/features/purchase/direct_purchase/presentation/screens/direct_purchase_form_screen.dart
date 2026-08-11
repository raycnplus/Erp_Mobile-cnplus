import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/controllers/direct_purchase_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/models/direct_purchase_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/widgets/direct_purchase_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class DirectPurchaseFormScreen extends StatefulWidget {
  final String? encryption;

  const DirectPurchaseFormScreen({super.key, this.encryption});

  @override
  State<DirectPurchaseFormScreen> createState() => _DirectPurchaseFormScreenState();
}

class _DirectPurchaseFormScreenState extends State<DirectPurchaseFormScreen> {
  late DirectPurchaseFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = DirectPurchaseFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<DirectPurchaseController>();

    try {
      await ctrl.fetchFormOptions();

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _form = DirectPurchaseFormModel(
            idDirectPurchase: d.idDirectPurchase,
            encryption: d.encryption,
            reference: d.reference,
            prReference: d.prReference,
            requestedDate: d.requestedDate != null ? DateTime.tryParse(d.requestedDate!) : null,
            idVendor: d.idVendor,
            destinationWarehouse: d.destinationWarehouse,
            destinationLocation: d.destinationLocation,
            expectedArrival: d.expectedArrival != null ? DateTime.tryParse(d.expectedArrival!) : null,
            idPriceList: d.idPriceList,
            discountType: d.discountType?.isEmpty == true ? null : d.discountType,
            isTax: d.isTaxEnabled,
            note: d.note,
          );

          for (final item in d.items) {
            _form.items.add(DirectPurchaseFormItem(
              idProduct: item.idProduct,
              productName: item.productName,
              description: item.description,
              uomId: item.unitOfMeasure,
              uomName: item.uomName,
              demandQty: item.demandQty,
              unitPrice: item.unitPrice,
              discountRate: item.discountRate,
              discountAmount: item.discountAmount,
              taxRate: item.taxRate,
              taxAmount: item.taxAmount,
              lastPurchasedPrice: item.lastPurchasedPrice,
              vendorLastPrice: item.vendorLastPrice,
            ));
          }
        }
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
    final ctrl = context.read<DirectPurchaseController>();
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
          isEditMode ? 'Edit Direct Purchase' : 'Create Direct Purchase',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<DirectPurchaseController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              DirectPurchaseFormFields(
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