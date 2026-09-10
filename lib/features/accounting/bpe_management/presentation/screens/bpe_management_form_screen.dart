import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/controllers/bpe_management_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/models/bpe_management_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/widgets/bpe_management_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BpeManagementFormScreen extends StatefulWidget {
  final String? encryption;

  const BpeManagementFormScreen({super.key, this.encryption});

  @override
  State<BpeManagementFormScreen> createState() => _BpeManagementFormScreenState();
}

class _BpeManagementFormScreenState extends State<BpeManagementFormScreen> {
  late BpeFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = BpeFormModel(
      encryption: widget.encryption,
      periodMonth: DateTime.now().month,
      periodYear: DateTime.now().year,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;

    if (isEditMode) {
      final ctrl = context.read<BpeManagementController>();
      try {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _form = BpeFormModel.fromDetail(d);
        }
      } catch (_) {}
    }

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
    final ctrl = context.read<BpeManagementController>();
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
          isEditMode ? 'Edit BPE' : 'Create BPE',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<BpeManagementController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              BpeManagementFormFields(
                formData: _form,
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