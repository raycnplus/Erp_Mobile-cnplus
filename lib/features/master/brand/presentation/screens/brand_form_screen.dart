import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/brand/presentation/controllers/brand_controller.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart'; // ← SATU file ini saja
import 'package:erp_mobile_cnplus/features/master/brand/presentation/widgets/brand_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BrandFormScreen extends StatefulWidget {
  final String? encryption; // ← String?, bukan int?

  const BrandFormScreen({super.key, this.encryption});

  @override
  State<BrandFormScreen> createState() => _BrandFormScreenState();
}

class _BrandFormScreenState extends State<BrandFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late BrandFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = BrandFormModel.empty();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = context.read<BrandController>();

      if (isEditMode) {
        await controller.fetchBrandDetail(widget.encryption!);
        if (controller.brandDetail != null) {
          setState(() {
            _formData = BrandFormModel.fromDetail(controller.brandDetail!);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final controller = context.read<BrandController>();
    final bool success;

    if (isEditMode) {
      success = await controller.editBrand(widget.encryption!, _formData);
    } else {
      success = await controller.saveBrand(_formData);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? controller.successMessage!
            : controller.formError ?? 'Operation failed'),
        backgroundColor: success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? "Edit Brand" : "Create Brand",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<BrandController>(
        builder: (context, controller, child) {
          if ((isEditMode && controller.isLoadingDetail) || !_isInitialized) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }

          if (isEditMode && controller.brandDetail == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(
                    controller.detailError ?? 'Failed to load brand data',
                    style: GoogleFonts.poppins(color: colorError),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        controller.fetchBrandDetail(widget.encryption!),
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
              BrandFormFields(
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