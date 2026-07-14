import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/controllers/coa_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/widgets/coa_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class CoaFormScreen extends StatefulWidget {
  final String? encryption;

  const CoaFormScreen({super.key, this.encryption});

  @override
  State<CoaFormScreen> createState() => _CoaFormScreenState();
}

class _CoaFormScreenState extends State<CoaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late CoaFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = CoaFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<CoaController>();
      ctrl.resetDetailState();
      await Future.wait([
        ctrl.fetchFormOptions(),
        if (isEditMode) ctrl.fetchDetail(widget.encryption!),
      ]);
      if (!mounted) return;
      if (isEditMode && ctrl.detail != null) {
        setState(() {
          _formData = CoaFormModel.fromDetail(ctrl.detail!);
          _isInitialized = true;
        });
      } else if (!isEditMode) {
        await ctrl.fetchAutonumber(isHeader: 'Y');
        if (!mounted) return;
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final ctrl = context.read<CoaController>();
    final success = isEditMode
        ? await ctrl.edit(widget.encryption!, _formData)
        : await ctrl.save(_formData);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? ctrl.successMessage! : ctrl.formError ?? 'Operation failed',
        ),
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
          isEditMode ? 'Edit COA' : 'Create COA',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<CoaController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingFormOptions) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          return Stack(
            children: [
              CoaFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                formOptions: ctrl.formOptions,
                isLoadingFormOptions: ctrl.isLoadingFormOptions,
                autonumber: ctrl.autonumber,
                isLoadingAutonumber: ctrl.isLoadingAutonumber,
                onParentOrHeaderChanged: (parentId, isHeader) {
                  ctrl.fetchAutonumber(
                    parentId: parentId,
                    isHeader: isHeader,
                  );
                },
              ),
              if (ctrl.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}