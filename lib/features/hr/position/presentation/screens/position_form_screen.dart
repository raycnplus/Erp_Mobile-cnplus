import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/position/presentation/controllers/position_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/position/data/models/position_models.dart';
import 'package:erp_mobile_cnplus/features/hr/position/presentation/widgets/position_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class PositionFormScreen extends StatefulWidget {
  final String? encryption;

  const PositionFormScreen({super.key, this.encryption});

  @override
  State<PositionFormScreen> createState() => _PositionFormScreenState();
}

class _PositionFormScreenState extends State<PositionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late PositionFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = PositionFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<PositionController>();
      ctrl.resetDetailState();
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        if (ctrl.detail != null) {
          setState(() {
            _formData = PositionFormModel.fromDetail(ctrl.detail!);
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
    final ctrl = context.read<PositionController>();
    final success = isEditMode
        ? await ctrl.edit(widget.encryption!, _formData)
        : await ctrl.save(_formData);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? ctrl.successMessage! : ctrl.formError ?? 'Operation failed'),
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
          isEditMode ? 'Edit Position' : 'Create Position',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<PositionController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          return Stack(
            children: [
              PositionFormFields(
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