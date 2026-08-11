import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/controllers/direct_sales_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/models/direct_sales_models.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/widgets/direct_sales_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class DirectSalesFormScreen extends StatefulWidget {
  final String? encryption;

  const DirectSalesFormScreen({super.key, this.encryption});

  @override
  State<DirectSalesFormScreen> createState() => _DirectSalesFormScreenState();
}

class _DirectSalesFormScreenState extends State<DirectSalesFormScreen> {
  late DirectSalesFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = DirectSalesFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<DirectSalesController>();

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
          _form = DirectSalesFormModel(
            idDirectSales: d.idDirectSales,
            encryption: d.encryption,
            reference: d.reference,
            idCustomer: d.idCustomer,
            sourceWarehouse: d.sourceWarehouse,
            sourceLocation: d.sourceLocation,
            salesPerson: d.salesPerson,
            idPaymentTerm: d.idPaymentTerm,
            idPriceList: d.idPriceList,
            validityDate: d.validityDate != null ? DateTime.tryParse(d.validityDate!) : null,
            deliveryAddress: d.deliveryAddress ?? '',
            note: d.note,
            isTax: d.isTaxEnabled,
            discountType: d.discountType?.isEmpty == true ? null : d.discountType,
            paymentType: d.paymentType,
          );

          for (final item in d.items) {
            _form.items.add(DirectSalesFormItem(
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
              onHand: item.onHand,
            ));
          }

          for (final s in d.paymentSchedules) {
            _form.schedules.add(DirectSalesScheduleItem(
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
    final ctrl = context.read<DirectSalesController>();
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
          isEditMode ? 'Edit Direct Sales' : 'Create Direct Sales',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<DirectSalesController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              DirectSalesFormFields(
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