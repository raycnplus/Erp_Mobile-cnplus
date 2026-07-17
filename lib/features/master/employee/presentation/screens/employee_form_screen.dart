import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/controllers/employee_controller.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/models/employee_models.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/widgets/employee_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class EmployeeFormScreen extends StatefulWidget {
  final String? encryption;

  const EmployeeFormScreen({super.key, this.encryption});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late EmployeeFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = EmployeeFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<EmployeeController>();
      ctrl.resetDetailState();

      await Future.wait([
        ctrl.fetchFormDropdownData(),
        if (isEditMode) ctrl.fetchDetail(widget.encryption!),
      ]);

      if (!mounted) return;

      if (isEditMode && ctrl.detail != null) {
        setState(() {
          _formData = EmployeeFormModel.fromDetail(ctrl.detail!);
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
        content: const Text('Employee name is required'),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }

    final ctrl = context.read<EmployeeController>();
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
          isEditMode ? 'Edit Employee' : 'Create Employee',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<EmployeeController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingDropdown) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (isEditMode && ctrl.detail == null && ctrl.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(ctrl.detailError!, style: GoogleFonts.poppins(color: colorError)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ctrl.fetchDetail(widget.encryption!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: colorWhite,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return Stack(
            children: [
              EmployeeFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                dropdownData: ctrl.dropdownData,
                isLoadingDropdown: ctrl.isLoadingDropdown,
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