import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/controllers/location_controller.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/models/location_models.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/widgets/location_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class LocationFormScreen extends StatefulWidget {
  final String? encryption;
  const LocationFormScreen({super.key, this.encryption});

  @override
  State<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends State<LocationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late LocationFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = LocationFormModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final controller = context.read<LocationController>();
      controller.resetDetailState();

      await Future.wait([
        controller.fetchFormDropdownData(),
        if (isEditMode) controller.fetchLocationDetail(widget.encryption!),
      ]);

      if (!mounted) return;
      if (isEditMode && controller.locationDetail != null) {
        setState(() {
          _formData = LocationFormModel.fromDetail(controller.locationDetail!);
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

    final controller = context.read<LocationController>();
    final bool success = isEditMode
        ? await controller.editLocation(widget.encryption!, _formData)
        : await controller.saveLocation(_formData);

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
          isEditMode ? "Edit Location" : "Create Location",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<LocationController>(
        builder: (context, controller, child) {
          if (!_isInitialized ||
              (isEditMode && controller.isLoadingDetail)) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }

          if (isEditMode &&
              controller.locationDetail == null &&
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
                        controller.fetchLocationDetail(widget.encryption!),
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
              LocationFormFields(
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