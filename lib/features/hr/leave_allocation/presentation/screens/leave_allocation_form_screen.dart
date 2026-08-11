import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/models/leave_allocation_models.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/controllers/leave_allocation_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/widgets/leave_allocation_form_fields.dart';

class LeaveAllocationFormScreen extends StatefulWidget {
  final String? encryption;

  const LeaveAllocationFormScreen({
    super.key,
    this.encryption,
  });

  @override
  State<LeaveAllocationFormScreen> createState() =>
      _LeaveAllocationFormScreenState();
}

class _LeaveAllocationFormScreenState
    extends State<LeaveAllocationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late LeaveAllocationFormModel _formData;

  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();

    _formData = LeaveAllocationFormModel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    if (!mounted) {
      return;
    }

    final controller =
        context.read<LeaveAllocationController>();

    controller.resetDetailState();

    try {
      await controller.fetchFormOptions();

      if (isEditMode) {
        await controller.fetchDetail(
          widget.encryption!,
        );

        if (!mounted) {
          return;
        }

        if (controller.detail != null) {
          final detail = controller.detail!;

          final selected =
              detail.details.map((row) {
            final id =
                row.idEmployee ??
                row.idPosition ??
                row.idDepartment ??
                0;

            return LeaveAllocationDetailItem(
              id: id,
              name: row.nama,
              quota: row.quota,
            );
          }).toList();

          _formData = LeaveAllocationFormModel(
            encryption: detail.encryption,
            allocationName:
                detail.allocationName,
            year: detail.year,
            idLeaveType: detail.idLeaveType,
            quota: detail.quota,
            allocationBy:
                detail.allocationBy,
            selectedDetails: selected,
          );
        }
      }
    } catch (_) {}

    if (!mounted) {
      return;
    }

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    _formKey.currentState!.save();

    final controller =
        context.read<LeaveAllocationController>();

    final success = isEditMode
        ? await controller.edit(
            widget.encryption!,
            _formData,
          )
        : await controller.save(
            _formData,
          );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          success
              ? controller.successMessage!
              : controller.formError ??
                    'Operation failed',
        ),
        backgroundColor:
            success
                ? colorSuccess
                : colorError,
        behavior:
            SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8),
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
        title: Text(
          isEditMode
              ? 'Edit Leave Allocation'
              : 'Create Leave Allocation',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<
          LeaveAllocationController>(
        builder: (
          context,
          controller,
          _,
        ) {
          if (!_isInitialized ||
              controller
                  .isLoadingFormOptions) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color: colorPrimary,
              ),
            );
          }

          return Stack(
            children: [
              LeaveAllocationFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                formOptions:
                    controller.formOptions,
                isLoadingFormOptions:
                    false,
              ),
              if (controller.isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child:
                        CircularProgressIndicator(
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