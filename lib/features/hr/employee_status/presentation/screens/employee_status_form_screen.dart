import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/controllers/employee_status_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/widgets/employee_status_form_fields.dart';

class EmployeeStatusFormScreen extends StatefulWidget {
  final String? encryption;

  const EmployeeStatusFormScreen({
    super.key,
    this.encryption,
  });

  @override
  State<EmployeeStatusFormScreen> createState() =>
      _EmployeeStatusFormScreenState();
}

class _EmployeeStatusFormScreenState
    extends State<EmployeeStatusFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late EmployeeStatusFormModel _formData;

  bool _isInitialized = false;

  bool get isEditMode {
    return widget.encryption != null;
  }

  @override
  void initState() {
    super.initState();

    _formData = EmployeeStatusFormModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      final controller =
          context.read<EmployeeStatusController>();

      controller.resetDetail();

      if (isEditMode) {
        await controller.fetchDetail(
          widget.encryption!,
        );

        if (!mounted) {
          return;
        }

        if (controller.detail != null) {
          setState(() {
            _formData =
                EmployeeStatusFormModel.fromDetail(
                  controller.detail!,
                );

            _isInitialized = true;
          });
        }
      } else {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final controller =
        context.read<EmployeeStatusController>();

    final success =
        isEditMode
            ? await controller.edit(
              widget.encryption!,
              _formData,
            )
            : await controller.save(_formData);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? controller.successMessage!
              : controller.formError ??
                    'Operation failed',
        ),
        backgroundColor:
            success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        title: Text(
          isEditMode
              ? 'Edit Employee Status'
              : 'Create Employee Status',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
      ),
      body: Consumer<EmployeeStatusController>(
        builder: (_, controller, __) {
          if (!_isInitialized ||
              (isEditMode &&
                  controller.isLoadingDetail)) {
            return const Center(
              child: CircularProgressIndicator(
                color: colorPrimary,
              ),
            );
          }

          return Stack(
            children: [
              EmployeeStatusFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
              ),
              if (controller.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: colorPrimary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}