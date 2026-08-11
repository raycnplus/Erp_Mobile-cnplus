import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/controllers/price_list_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/widgets/price_list_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class PriceListFormScreen extends StatefulWidget {
  final String? encryption;

  const PriceListFormScreen({super.key, this.encryption});

  @override
  State<PriceListFormScreen> createState() => _PriceListFormScreenState();
}

class _PriceListFormScreenState extends State<PriceListFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late PriceListFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = PriceListFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<PriceListController>();
      ctrl.resetDetailState();
      await Future.wait([
        ctrl.fetchProducts(),
        if (isEditMode) ctrl.fetchDetail(widget.encryption!),
      ]);
      if (!mounted) return;
      if (isEditMode && ctrl.detail != null) {
        setState(() {
          _formData = PriceListFormModel.fromDetail(ctrl.detail!);
          _isInitialized = true;
        });
      } else if (!isEditMode) {
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_formData.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('At least 1 product required'),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }
    _formKey.currentState!.save();
    final ctrl = context.read<PriceListController>();
    final success = isEditMode
        ? await ctrl.edit(widget.encryption!, _formData)
        : await ctrl.save(_formData);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? ctrl.successMessage! : ctrl.formError ?? 'Operation failed'),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? "Edit Price List" : "Create Price List",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<PriceListController>(builder: (_, ctrl, __) {
        if (!_isInitialized || ctrl.isLoadingProducts) {
          return const Center(child: CircularProgressIndicator(color: colorPrimary));
        }
        return Stack(children: [
          PriceListFormFields(
            formKey: _formKey,
            formData: _formData,
            onSubmit: _handleSubmit,
            isEditMode: isEditMode,
            products: ctrl.products,
            isLoadingProducts: ctrl.isLoadingProducts,
          ),
          if (ctrl.isSaving)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator(color: colorPrimary)),
            ),
        ]);
      }),
    );
  }
}