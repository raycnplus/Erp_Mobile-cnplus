import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/controllers/purchase_order_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/models/purchase_order_models.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/widgets/purchase_order_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class PurchaseOrderFormScreen extends StatefulWidget {
  final String? encryption;

  const PurchaseOrderFormScreen({super.key, this.encryption});

  @override
  State<PurchaseOrderFormScreen> createState() => _PurchaseOrderFormScreenState();
}

class _PurchaseOrderFormScreenState extends State<PurchaseOrderFormScreen> {
  late PurchaseOrderFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = PurchaseOrderFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<PurchaseOrderController>();

    try {
      await ctrl.fetchFormOptions();

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _form = PurchaseOrderFormModel(
            idPurchaseOrder: d.idPurchaseOrder,
            encryption: d.encryption,
            reference: d.reference,
            rfqReference: d.rfqReference,
            idVendor: d.idVendor,
            purchaseTeam: d.purchaseTeam,
            purchasePerson: d.purchasePerson,
            destinationWarehouse: d.destinationWarehouse,
            destinationLocation: d.destinationLocation,
            idPaymentTerm: d.idPaymentTerm,
            idPriceList: d.idPriceList,
            requestedDate: d.requestedDate != null ? DateTime.tryParse(d.requestedDate!) : null,
            expectedArrival: d.expectedArrival != null ? DateTime.tryParse(d.expectedArrival!) : null,
            expirationDate: d.expirationDate != null ? DateTime.tryParse(d.expirationDate!) : null,
            note: d.note,
            isTax: d.isTaxEnabled,
            discountType: d.discountType?.isEmpty == true ? null : d.discountType,
            paymentType: d.paymentType,
          );

          for (final item in d.items) {
            _form.items.add(PurchaseOrderFormItem(
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

          for (final s in d.paymentSchedules) {
            _form.schedules.add(PurchaseOrderScheduleItem(
              termName: s.termName,
              dueDate: s.dueDate != null ? DateTime.tryParse(s.dueDate!) : null,
              amount: s.amount,
              percentage: s.percentage,
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
    final ctrl = context.read<PurchaseOrderController>();
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
          isEditMode ? 'Edit Purchase Order' : 'Create Purchase Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<PurchaseOrderController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              PurchaseOrderFormFields(
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