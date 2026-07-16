import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/controllers/vendor_controller.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/models/vendor_models.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/widgets/vendor_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class VendorFormScreen extends StatefulWidget {
  final String? encryption;
  const VendorFormScreen({super.key, this.encryption});

  @override
  State<VendorFormScreen> createState() => _VendorFormScreenState();
}

class _VendorFormScreenState extends State<VendorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late VendorFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = VendorFormModel.empty();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final controller = context.read<VendorController>();
      controller.resetDetailState();

      await Future.wait([
        controller.fetchFormDropdownData(),
        if (isEditMode) controller.fetchVendorDetail(widget.encryption!),
      ]);

      if (!mounted) return;

      if (isEditMode && controller.vendorDetail != null) {
        setState(() {
          _formData = VendorFormModel.fromDetail(controller.vendorDetail!);
          _isInitialized = true;
        });
      } else if (!isEditMode) {
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

    final controller = context.read<VendorController>();
    final bool success = isEditMode
        ? await controller.editVendor(widget.encryption!, _formData)
        : await controller.saveVendor(_formData);

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
          isEditMode ? "Edit Vendor" : "Create Vendor",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<VendorController>(
        builder: (context, controller, _) {
          if (!_isInitialized || (isEditMode && controller.isLoadingDetail)) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }

          if (isEditMode && controller.vendorDetail == null &&
              controller.detailError != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: colorError),
                    const SizedBox(height: 16),
                    Text(controller.detailError!,
                        style: GoogleFonts.poppins(color: colorError),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          controller.fetchVendorDetail(widget.encryption!),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite),
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              VendorFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                countries: controller.countries,   
                currencies: controller.currencies, 
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