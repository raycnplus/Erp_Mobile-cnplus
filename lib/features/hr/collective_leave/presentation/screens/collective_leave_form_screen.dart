import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/controllers/collective_leave_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/models/collective_leave_models.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/widgets/collective_leave_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class CollectiveLeaveFormScreen extends StatefulWidget {
  final String? encryption;

  const CollectiveLeaveFormScreen({super.key, this.encryption});

  @override
  State<CollectiveLeaveFormScreen> createState() =>
      _CollectiveLeaveFormScreenState();
}

class _CollectiveLeaveFormScreenState
    extends State<CollectiveLeaveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late CollectiveLeaveFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = CollectiveLeaveFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<CollectiveLeaveController>();
      ctrl.resetDetailState();
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        if (ctrl.detail != null) {
          setState(() {
            _formData = CollectiveLeaveFormModel.fromDetail(ctrl.detail!);
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
    final ctrl = context.read<CollectiveLeaveController>();
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
          isEditMode ? 'Edit Collective Leave' : 'Create Collective Leave',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<CollectiveLeaveController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          return Stack(
            children: [
              CollectiveLeaveFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
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