import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/controllers/overtime_type_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/models/overtime_type_models.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/widgets/overtime_type_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class OvertimeTypeFormScreen extends StatefulWidget {
  final String? encryption;

  const OvertimeTypeFormScreen({super.key, this.encryption});

  @override
  State<OvertimeTypeFormScreen> createState() => _OvertimeTypeFormScreenState();
}

class _OvertimeTypeFormScreenState extends State<OvertimeTypeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late OvertimeTypeFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = OvertimeTypeFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<OvertimeTypeController>();
      ctrl.resetDetailState();

      try {
        await ctrl.fetchFormOptions();
        if (isEditMode) {
          await ctrl.fetchDetail(widget.encryption!);
          if (!mounted) return;
          if (ctrl.detail != null) {
            _formData = OvertimeTypeFormModel.fromDetail(ctrl.detail!);
          }
        }
      } catch (_) {}

      if (!mounted) return;
      setState(() => _isInitialized = true);
    });
  }

  Future<void> _handleSubmit() async {
    final ctrl = context.read<OvertimeTypeController>();
    final success = isEditMode
        ? await ctrl.edit(widget.encryption!, _formData)
        : await ctrl.save(_formData);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed'),
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
          isEditMode ? 'Edit Overtime Type' : 'Create Overtime Type',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<OvertimeTypeController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized ||
              ctrl.isLoadingOptions ||
              (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(
                child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              OvertimeTypeFormFields(
                formKey: _formKey,
                formData: _formData,
                categories: ctrl.categories,
                isEditMode: isEditMode,
                onSubmit: _handleSubmit,
              ),
              if (ctrl.isSaving)
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