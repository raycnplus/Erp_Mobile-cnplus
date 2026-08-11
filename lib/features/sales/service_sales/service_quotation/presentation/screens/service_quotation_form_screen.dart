import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/models/service_quotation_models.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/controllers/service_quotation_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/widgets/service_quotation_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ServiceQuotationFormScreen extends StatefulWidget {
  final String? encryption;

  const ServiceQuotationFormScreen({super.key, this.encryption});

  @override
  State<ServiceQuotationFormScreen> createState() => _State();
}

class _State extends State<ServiceQuotationFormScreen> {
  late ServiceQuotationFormModel _formData;
  bool _isInitialized = false;

  bool get _isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = ServiceQuotationFormModel();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final ctrl = context.read<ServiceQuotationController>();
    await ctrl.fetchFormOptions();

    final opts = ctrl.formOptions;
    if (!_isEditMode && opts?.currentUserId != null) {
      _formData.salesPerson = opts!.currentUserId;
    }

    if (_isEditMode) {
      await ctrl.fetchDetail(widget.encryption!);
      final d = ctrl.detail;
      if (d != null && mounted) {
        setState(() {
          _formData = ServiceQuotationFormModel.fromDetail(d);
        });
      }
    }

    if (mounted) setState(() => _isInitialized = true);
  }

  Future<void> _handleSave() async {
    final ctrl = context.read<ServiceQuotationController>();
    final success = await ctrl.save(_formData, status: 'save');
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.successMessage ?? 'Saved'),
          backgroundColor: colorSuccess,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.formError ?? 'Failed to save'),
          backgroundColor: colorError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Quotation' : 'New Quotation',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
      ),
      body: Consumer<ServiceQuotationController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          return ServiceQuotationFormFields(
            formData: _formData,
            formOptions: ctrl.formOptions,
            onSave: _handleSave,
            isSaving: ctrl.isSaving,
          );
        },
      ),
    );
  }
}