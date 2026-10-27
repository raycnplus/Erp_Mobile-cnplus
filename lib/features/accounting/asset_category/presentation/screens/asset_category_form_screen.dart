import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/presentation/controllers/asset_category_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/models/asset_category_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/presentation/widgets/asset_category_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class AssetCategoryFormScreen extends StatefulWidget {
  final String? encryption;
  const AssetCategoryFormScreen({super.key, this.encryption});

  @override
  State<AssetCategoryFormScreen> createState() => _State();
}

class _State extends State<AssetCategoryFormScreen> {
  late AssetCategoryFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = AssetCategoryFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<AssetCategoryController>();
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
          _form = AssetCategoryFormModel.fromDetail(d);
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

  Future<void> _showWarnings(List<String> warnings) => showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Row(children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Text('COA Warning', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ]),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: warnings
                  .map((w) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• $w', style: GoogleFonts.poppins(fontSize: 13)),
                      ))
                  .toList(),
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );

  Future<void> _handleSubmit() async {
    final ctrl = context.read<AssetCategoryController>();
    final success = await ctrl.save(_form);
    if (!mounted) return;

    if (success) {
      _snack(ctrl.successMessage!, success: true);
      if (ctrl.warnings.isNotEmpty) await _showWarnings(ctrl.warnings);
      if (!mounted) return;
      Navigator.pop(context, true);
      return;
    }

    final err = ctrl.formError ?? 'Failed';
    final isStale = err.toLowerCase().contains('no query results') || err.toLowerCase().contains('not found');

    if (isStale && isEditMode) {
      _snack('This category may have changed elsewhere. Reloading latest data...');
      await ctrl.fetchDetail(widget.encryption!);
      if (!mounted) return;
      final d = ctrl.detail;
      if (d != null) {
        setState(() => _form = AssetCategoryFormModel.fromDetail(d));
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
        title: Text(isEditMode ? 'Edit Asset Category' : 'Create Asset Category', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1, backgroundColor: colorWhite, foregroundColor: colorTextPrimary,
      ),
      body: Consumer<AssetCategoryController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(children: [
            AssetCategoryFormFields(formData: _form, formOptions: ctrl.formOptions, onSubmit: _handleSubmit, isSaving: ctrl.isSaving),
            if (ctrl.isSaving) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
          ]);
        },
      ),
    );
  }
}