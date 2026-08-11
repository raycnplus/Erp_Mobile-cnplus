import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/controllers/store_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/models/store_models.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/widgets/store_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class StoreFormScreen extends StatefulWidget {
  final String? encryption;

  const StoreFormScreen({super.key, this.encryption});

  @override
  State<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends State<StoreFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late StoreFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = StoreFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<StoreController>();
      ctrl.resetDetailState();

      await ctrl.fetchFormOptions();

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        if (ctrl.detail != null) {
          _formData = StoreFormModel.fromDetail(ctrl.detail!);
        }
      }

      setState(() => _isInitialized = true);
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final ctrl = context.read<StoreController>();
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
          isEditMode ? 'Edit Store' : 'Create Store',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<StoreController>(
        builder: (_, ctrl, __) {
          final loading = !_isInitialized ||
              ctrl.isLoadingOptions ||
              (isEditMode && ctrl.isLoadingDetail);

          if (loading) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }

          return Stack(
            children: [
              StoreFormFields(
                formKey: _formKey,
                formData: _formData,
                formOptions: ctrl.formOptions,
                isEditMode: isEditMode,
                onSubmit: _handleSubmit,
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