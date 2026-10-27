import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/presentation/controllers/asset_depreciation_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/models/asset_depreciation_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/presentation/widgets/asset_depreciation_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class AssetDepreciationFormScreen extends StatefulWidget {
  const AssetDepreciationFormScreen({super.key});

  @override
  State<AssetDepreciationFormScreen> createState() => _AssetDepreciationFormScreenState();
}

class _AssetDepreciationFormScreenState extends State<AssetDepreciationFormScreen> {
  final _form = AssetDepreciationFormModel();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    await context.read<AssetDepreciationController>().fetchFormOptions(forceRefresh: true);
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

  Future<void> _handleRun() async {
    final period = DateFormat('MMMM yyyy').format(DateTime(_form.year, _form.month, 1));

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Run Depreciation', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Run depreciation for $period?\n\nThis posts a journal entry and updates asset book values. It cannot be undone from the app.',
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Run', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final ctrl = context.read<AssetDepreciationController>();
    final success = await ctrl.run(_form);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Run Depreciation',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<AssetDepreciationController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              AssetDepreciationFormFields(
                formData: _form,
                formOptions: ctrl.formOptions,
                onSave: _handleRun,
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