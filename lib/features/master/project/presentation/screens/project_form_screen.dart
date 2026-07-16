import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/project/presentation/controllers/project_controller.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';
import 'package:erp_mobile_cnplus/features/master/project/presentation/widgets/project_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ProjectFormScreen extends StatefulWidget {
  final String? encryption;
  const ProjectFormScreen({super.key, this.encryption});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProjectFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = ProjectFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<ProjectController>();
      ctrl.resetDetailState();
      await Future.wait([
        ctrl.fetchFormOptions(),
        if (isEditMode) ctrl.fetchDetail(widget.encryption!),
      ]);
      if (!mounted) return;
      if (isEditMode && ctrl.detail != null) {
        setState(() {
          _formData = ProjectFormModel.fromDetail(ctrl.detail!);
          _isInitialized = true;
        });
      } else if (!isEditMode) {
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_formData.startDate == null) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    final ctrl = context.read<ProjectController>();
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
          isEditMode ? "Edit Project" : "Create Project",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<ProjectController>(builder: (_, ctrl, __) {
        if (!_isInitialized || ctrl.isLoadingFormOptions) {
          return const Center(child: CircularProgressIndicator(color: colorPrimary));
        }
        return Stack(children: [
          ProjectFormFields(
            formKey: _formKey,
            formData: _formData,
            onSubmit: _handleSubmit,
            isEditMode: isEditMode,
            formOptions: ctrl.formOptions,
            isLoadingFormOptions: ctrl.isLoadingFormOptions,
            defaultCode: ctrl.formOptions?.defaultCode,
          ),
          if (ctrl.isSaving)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator(color: colorPrimary)),
            ),
        ]);
      }),
    );
  }
}