import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/controllers/customer_category_controller.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/models/customer_category_models.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/widgets/customer_category_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class CustomerCategoryFormScreen extends StatefulWidget {
  final String? encryption;
  const CustomerCategoryFormScreen({super.key, this.encryption});

  @override
  State<CustomerCategoryFormScreen> createState() =>
      _CustomerCategoryFormScreenState();
}

class _CustomerCategoryFormScreenState
    extends State<CustomerCategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late CustomerCategoryFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = CustomerCategoryFormModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final controller = context.read<CustomerCategoryController>();
      controller.resetDetailState();

      if (isEditMode) {
        await controller.fetchCategoryDetail(widget.encryption!);
        if (!mounted) return;
        if (controller.categoryDetail != null) {
          setState(() {
            _formData = CustomerCategoryFormModel.fromDetail(
                controller.categoryDetail!);
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
        content: const Text('Please fill all required fields'),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }

    final controller = context.read<CustomerCategoryController>();
    final bool success = isEditMode
        ? await controller.editCategory(widget.encryption!, _formData)
        : await controller.saveCategory(_formData);

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
          isEditMode ? "Edit Customer Category" : "Create Customer Category",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<CustomerCategoryController>(
        builder: (context, controller, child) {
          if ((isEditMode && controller.isLoadingDetail) || !_isInitialized) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          if (isEditMode &&
              controller.categoryDetail == null &&
              controller.detailError != null) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.error_outline, size: 64, color: colorError),
                const SizedBox(height: 16),
                Text(controller.detailError!,
                    style: GoogleFonts.poppins(color: colorError)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      controller.fetchCategoryDetail(widget.encryption!),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary, foregroundColor: colorWhite),
                  child: const Text("Try Again"),
                ),
              ]),
            );
          }

          return Stack(
            children: [
              CustomerCategoryFormFields(
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