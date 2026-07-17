import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/uom/presentation/controllers/uom_controller.dart';
import 'package:erp_mobile_cnplus/features/master/uom/data/models/uom_models.dart';
import 'package:erp_mobile_cnplus/features/master/uom/presentation/widgets/uom_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class UomFormScreen extends StatefulWidget {
  final String? encryption;

  const UomFormScreen({super.key, this.encryption});

  @override
  State<UomFormScreen> createState() => _UomFormScreenState();
}

class _UomFormScreenState extends State<UomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late UomFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = UomFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<UomController>();
      ctrl.resetDetailState();

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        if (ctrl.detail != null) _formData = UomFormModel.fromDetail(ctrl.detail!);
      } else {
        await ctrl.fetchFormOptions();
      }

      setState(() => _isInitialized = true);
    });
  }

  Future<void> _handleSubmit() async {
    final ctrl = context.read<UomController>();
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
          isEditMode ? 'Edit UoM' : 'Create UoM',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<UomController>(
        builder: (_, ctrl, __) {
          final loading = !_isInitialized ||
              (isEditMode && ctrl.isLoadingDetail) ||
              (!isEditMode && ctrl.isLoadingFormOptions);

          if (loading) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }

          final refOptions = isEditMode
              ? (ctrl.detail?.referenceUnits ?? [])
              : ctrl.allUoms;

          return Stack(
            children: [
              UomFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                referenceUnits: refOptions,
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