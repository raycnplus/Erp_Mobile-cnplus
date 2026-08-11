import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/product/presentation/controllers/product_controller.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';
import 'package:erp_mobile_cnplus/features/master/product/presentation/widgets/product_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ProductFormScreen extends StatefulWidget {
  final String? encryption;
  const ProductFormScreen({super.key, this.encryption});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = ProductFormModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final controller = context.read<ProductController>();
      controller.resetDetailState();

      await Future.wait([
        controller.fetchFormDropdownData(),
        if (isEditMode) controller.fetchProductDetail(widget.encryption!),
      ]);

      if (!mounted) return;

      if (isEditMode && controller.productDetail != null) {
        setState(() {
          _formData = ProductFormModel.fromDetail(controller.productDetail!);
          _isInitialized = true;
        });
      } else if (!isEditMode) {
        if (controller.dropdownData?.defaultUomId != null) {
          _formData.unitOfMeasure = controller.dropdownData!.defaultUomId;
        }
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (!_formData.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill all required fields'),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }

    final controller = context.read<ProductController>();
    final bool success = isEditMode
        ? await controller.editProduct(widget.encryption!, _formData)
        : await controller.saveProduct(_formData);

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
          isEditMode ? "Edit Product" : "Create Product",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          if (!_isInitialized ||
              (isEditMode && controller.isLoadingDetail)) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }

          if (isEditMode &&
              controller.productDetail == null &&
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
                        controller.fetchProductDetail(widget.encryption!),
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
              ProductFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                dropdownData: controller.dropdownData,
                isLoadingDropdown: controller.isLoadingDropdown,
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