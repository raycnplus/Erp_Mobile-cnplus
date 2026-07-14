import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/controllers/bank_account_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/models/bank_account_models.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/widgets/bank_account_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BankAccountFormScreen extends StatefulWidget {
  final String? encryption;

  const BankAccountFormScreen({super.key, this.encryption});

  @override
  State<BankAccountFormScreen> createState() => _BankAccountFormScreenState();
}

class _BankAccountFormScreenState extends State<BankAccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late BankAccountFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = BankAccountFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ctrl = context.read<BankAccountController>();
      ctrl.resetDetailState();
      await Future.wait([
        ctrl.fetchFormOptions(),
        if (isEditMode) ctrl.fetchDetail(widget.encryption!),
      ]);
      if (!mounted) return;
      if (isEditMode && ctrl.detail != null) {
        setState(() {
          _formData = BankAccountFormModel.fromDetail(ctrl.detail!);
          _isInitialized = true;
        });
      } else if (!isEditMode) {
        setState(() => _isInitialized = true);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final ctrl = context.read<BankAccountController>();
    final success = isEditMode
        ? await ctrl.edit(widget.encryption!, _formData)
        : await ctrl.save(_formData);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? ctrl.successMessage! : ctrl.formError ?? 'Operation failed',
        ),
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
          isEditMode ? 'Edit Bank Account' : 'Create Bank Account',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<BankAccountController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingFormOptions) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          return Stack(
            children: [
              BankAccountFormFields(
                formKey: _formKey,
                formData: _formData,
                onSubmit: _handleSubmit,
                isEditMode: isEditMode,
                formOptions: ctrl.formOptions,
                isLoadingFormOptions: ctrl.isLoadingFormOptions,
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