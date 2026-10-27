import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/controllers/fixed_asset_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/models/fixed_asset_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/widgets/fixed_asset_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class FixedAssetFormScreen extends StatefulWidget {
  final String? encryption;
  const FixedAssetFormScreen({super.key, this.encryption});

  @override
  State<FixedAssetFormScreen> createState() => _State();
}

class _State extends State<FixedAssetFormScreen> {
  late FixedAssetFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = FixedAssetFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<FixedAssetController>();
    try {
      await ctrl.fetchFormOptions();
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          if (!d.canEdit) {
            if (mounted) Navigator.pop(context);
            return;
          }
          _form = FixedAssetFormModel.fromDetail(d);
        }
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _handleSubmit() async {
    final ctrl = context.read<FixedAssetController>();
    final success = await ctrl.save(_form);
    if (!mounted) return;

    if (success) {
      _snack(ctrl.successMessage!, success: true);
      Navigator.pop(context, true);
      return;
    }

    final err = ctrl.formError ?? 'Failed';
    final isStale = err.toLowerCase().contains('no query results') || err.toLowerCase().contains('not found');

    if (isStale && isEditMode) {
      _snack('This asset may have changed elsewhere. Reloading latest data...');
      await ctrl.fetchDetail(widget.encryption!);
      if (!mounted) return;
      final d = ctrl.detail;
      if (d != null) {
        setState(() => _form = FixedAssetFormModel.fromDetail(d));
      } else {
        Navigator.pop(context);
      }
      return;
    }

    _snack(err);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Fixed Asset' : 'Create Fixed Asset', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1, backgroundColor: colorWhite, foregroundColor: colorTextPrimary,
      ),
      body: Consumer<FixedAssetController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(children: [
            FixedAssetFormFields(formData: _form, formOptions: ctrl.formOptions, onSubmit: _handleSubmit, isSaving: ctrl.isSaving),
            if (ctrl.isSaving) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
          ]);
        },
      ),
    );
  }
}