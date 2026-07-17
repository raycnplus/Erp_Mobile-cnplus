import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/controllers/product_type_controller.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/models/product_type_models.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/widgets/product_type_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ProductTypeFormScreen extends StatefulWidget {
  final String? encryption;
  const ProductTypeFormScreen({super.key, this.encryption});

  @override
  State<ProductTypeFormScreen> createState() => _ProductTypeFormScreenState();
}

class _ProductTypeFormScreenState extends State<ProductTypeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductTypeFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = ProductTypeFormModel.empty();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final controller = context.read<ProductTypeController>();
      controller.resetDetailState();

      if (isEditMode) {
        await controller.fetchTypeDetail(widget.encryption!);
        if (!mounted) return;
        if (controller.typeDetail != null) {
          setState(() {
            _formData = ProductTypeFormModel.fromDetail(controller.typeDetail!);
            _isInitialized = true;
          });
        }
      } else {
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (!_formData.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Product type name is required'),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }

    final controller = context.read<ProductTypeController>();
    final bool success = isEditMode
        ? await controller.editType(widget.encryption!, _formData)
        : await controller.saveType(_formData);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success
          ? controller.successMessage!
          : controller.formError ?? 'Operation failed'),
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
          isEditMode ? "Edit Product Type" : "Create Product Type",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<ProductTypeController>(
        builder: (context, controller, child) {
          if ((isEditMode && controller.isLoadingDetail) || !_isInitialized) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          if (isEditMode &&
              controller.typeDetail == null &&
              controller.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(controller.detailError!,
                      style: GoogleFonts.poppins(color: colorError)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        controller.fetchTypeDetail(widget.encryption!),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: colorWhite),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              ProductTypeFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
              ),
              if (controller.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                      child: CircularProgressIndicator(color: colorPrimary)),
                ),
            ],
          );
        },
      ),
    );
  }
}