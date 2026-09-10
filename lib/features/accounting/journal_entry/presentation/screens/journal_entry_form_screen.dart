import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/presentation/controllers/journal_entry_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/models/journal_entry_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/presentation/widgets/journal_entry_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class JournalEntryFormScreen extends StatefulWidget {
  final String? encryption;
  const JournalEntryFormScreen({super.key, this.encryption});

  @override
  State<JournalEntryFormScreen> createState() => _State();
}

class _State extends State<JournalEntryFormScreen> {
  late JournalEntryFormModel _form;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _form = JournalEntryFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<JournalEntryController>();
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
          _form = JournalEntryFormModel.fromDetail(d);
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

  Future<void> _handleSubmit(String action) async {
    final ctrl = context.read<JournalEntryController>();
    final success = action == 'post' ? await ctrl.post(_form) : await ctrl.save(_form);
    if (!mounted) return;

    if (success) {
      _snack(ctrl.successMessage!, success: true);
      Navigator.pop(context, true);
      return;
    }

    final err = ctrl.formError ?? 'Failed';
    final isStale = err.toLowerCase().contains('no query results') || err.toLowerCase().contains('not found');

    if (isStale && isEditMode) {
      _snack('This entry may have changed elsewhere. Reloading latest data...', success: false);
      await ctrl.fetchDetail(widget.encryption!);
      if (!mounted) return;
      final d = ctrl.detail;
      if (d != null) {
        setState(() => _form = JournalEntryFormModel.fromDetail(d));
      } else {
        Navigator.pop(context); 
      }
      return;
    }

    _snack(err, success: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Journal Entry' : 'Create Journal Entry', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        elevation: 1, backgroundColor: colorWhite, foregroundColor: colorTextPrimary,
      ),
      body: Consumer<JournalEntryController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(children: [
            JournalEntryFormFields(formData: _form, formOptions: ctrl.formOptions, onSubmit: _handleSubmit, isSaving: ctrl.isSaving),
            if (ctrl.isSaving) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: colorPrimary))),
          ]);
        },
      ),
    );
  }
}