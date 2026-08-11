import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/controllers/bom_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/models/bom_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/widgets/bom_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BomFormScreen extends StatefulWidget {
  final String? encryption;

  const BomFormScreen({super.key, this.encryption});

  @override
  State<BomFormScreen> createState() => _BomFormScreenState();
}

class _BomFormScreenState extends State<BomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late BomFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = BomFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<BomController>();
      ctrl.resetDetailState();
      await Future.wait([
        ctrl.fetchFormOptions(),
        if (isEditMode) ctrl.fetchDetail(widget.encryption!),
      ]);
      if (!mounted) return;
      if (isEditMode && ctrl.detail != null) {
        setState(() {
          _formData = BomFormModel.fromDetail(ctrl.detail!);
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
        content: const Text(
          'BOM name, product, and at least 1 component with product selected are required',
        ),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }
    final ctrl = context.read<BomController>();
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
          isEditMode ? 'Edit BOM' : 'Create BOM',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<BomController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingFormOptions) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              BomFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                formOptions: ctrl.formOptions,
                isLoadingFormOptions: ctrl.isLoadingFormOptions,
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