import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/controllers/workstation_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/models/workstation_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/widgets/workstation_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class WorkstationFormScreen extends StatefulWidget {
  final String? encryption;

  const WorkstationFormScreen({super.key, this.encryption});

  @override
  State<WorkstationFormScreen> createState() => _WorkstationFormScreenState();
}

class _WorkstationFormScreenState extends State<WorkstationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late WorkstationFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = WorkstationFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<WorkstationController>();
      ctrl.resetDetailState();

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        if (ctrl.detail != null) {
          setState(() {
            _formData = WorkstationFormModel.fromDetail(ctrl.detail!);
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

    final ctrl = context.read<WorkstationController>();
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
          isEditMode ? 'Edit Workstation' : 'Create Workstation',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<WorkstationController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              WorkstationFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
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