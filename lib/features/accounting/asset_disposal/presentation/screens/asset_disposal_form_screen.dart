import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/controllers/asset_disposal_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/models/asset_disposal_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/widgets/asset_disposal_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class AssetDisposalFormScreen extends StatefulWidget {
  final String? encryption;

  const AssetDisposalFormScreen({super.key, this.encryption});

  @override
  State<AssetDisposalFormScreen> createState() => _AssetDisposalFormScreenState();
}

class _AssetDisposalFormScreenState extends State<AssetDisposalFormScreen> {
  late AssetDisposalFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = AssetDisposalFormModel(encryption: widget.encryption, disposalDate: DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<AssetDisposalController>();

    try {
      await ctrl.fetchFormOptions(forceRefresh: true);

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          if (!d.canEdit) {
            Navigator.pop(context);
            return;
          }
          _form = AssetDisposalFormModel.fromDetail(d);
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _handleSave() async {
    final ctrl = context.read<AssetDisposalController>();
    final success = await ctrl.save(_form);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Asset Disposal' : 'Create Asset Disposal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<AssetDisposalController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              AssetDisposalFormFields(
                formData: _form,
                formOptions: ctrl.formOptions,
                onSave: _handleSave,
                isSaving: ctrl.isSaving,
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