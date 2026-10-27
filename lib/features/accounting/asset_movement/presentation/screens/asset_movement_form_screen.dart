import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/controllers/asset_movement_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/models/asset_movement_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/widgets/asset_movement_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class AssetMovementFormScreen extends StatefulWidget {
  const AssetMovementFormScreen({super.key});

  @override
  State<AssetMovementFormScreen> createState() => _State();
}

class _State extends State<AssetMovementFormScreen> {
  late AssetMovementFormModel _form;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _form = AssetMovementFormModel(movementDate: DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    await context.read<AssetMovementController>().fetchFormOptions();
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
    final ctrl = context.read<AssetMovementController>();
    final success = await ctrl.save(_form);
    if (!mounted) return;

    if (success) {
      _snack(ctrl.successMessage!, success: true);
      Navigator.pop(context, true);
      return;
    }
    _snack(ctrl.formError ?? 'Failed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Move Asset', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1, backgroundColor: colorWhite, foregroundColor: colorTextPrimary,
      ),
      body: Consumer<AssetMovementController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.formOptions == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text('Failed to load form options', style: GoogleFonts.poppins(color: colorError)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: ctrl.fetchFormOptions,
                    style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Stack(children: [
            AssetMovementFormFields(formData: _form, formOptions: ctrl.formOptions, onSubmit: _handleSubmit, isSaving: ctrl.isSaving),
            if (ctrl.isSaving) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
          ]);
        },
      ),
    );
  }
}