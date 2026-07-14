import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/department/presentation/controllers/department_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/models/department_models.dart';
import 'package:erp_mobile_cnplus/features/hr/department/presentation/widgets/department_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class DepartmentFormScreen extends StatefulWidget {
  final String? encryption;
  const DepartmentFormScreen({super.key, this.encryption});
  @override
  State<DepartmentFormScreen> createState() => _DepartmentFormScreenState();
}

class _DepartmentFormScreenState extends State<DepartmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late DepartmentFormModel _formData;
  bool _isInitialized = false;
  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = DepartmentFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<DepartmentController>();
      ctrl.resetDetailState();
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        if (ctrl.detail != null) {
          setState(() {
            _formData = DepartmentFormModel.fromDetail(ctrl.detail!);
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
    final ctrl = context.read<DepartmentController>();
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
        title: Text(isEditMode ? "Edit Department" : "Create Department",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1, backgroundColor: colorWhite, foregroundColor: colorTextPrimary,
      ),
      body: Consumer<DepartmentController>(builder: (_, ctrl, __) {
        if (!_isInitialized || (isEditMode && ctrl.isLoadingDetail))
          return const Center(child: CircularProgressIndicator(color: colorPrimary));
        return Stack(children: [
          DepartmentFormFields(
            formKey: _formKey, formData: _formData,
            onSubmit: _handleSubmit, isEditMode: isEditMode,
          ),
          if (ctrl.isSaving)
            Container(color: Colors.black26,
                child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
        ]);
      }),
    );
  }
}