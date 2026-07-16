import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/controllers/warehouse_controller.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/widgets/warehouse_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class WarehouseFormScreen extends StatefulWidget {
  final String? encryption;

  const WarehouseFormScreen({super.key, this.encryption});

  @override
  State<WarehouseFormScreen> createState() => _WarehouseFormScreenState();
}

class _WarehouseFormScreenState extends State<WarehouseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late WarehouseFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = WarehouseFormModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final controller = context.read<WarehouseController>();
      controller.resetDetailState();

      if (isEditMode) {
        await controller.fetchWarehouseDetail(widget.encryption!);
        if (!mounted) return;
        if (controller.warehouseDetail != null) {
          setState(() {
            _formData = WarehouseFormModel.fromDetail(controller.warehouseDetail!);
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

    final controller = context.read<WarehouseController>();
    final bool success = isEditMode
        ? await controller.editWarehouse(widget.encryption!, _formData)
        : await controller.saveWarehouse(_formData);

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
          isEditMode ? "Edit Warehouse" : "Create Warehouse",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<WarehouseController>(
        builder: (context, controller, child) {
          if ((isEditMode && controller.isLoadingDetail) || !_isInitialized) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }

          if (isEditMode && controller.warehouseDetail == null &&
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
                        controller.fetchWarehouseDetail(widget.encryption!),
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
              WarehouseFormFields(
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