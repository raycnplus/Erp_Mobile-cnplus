import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/controllers/overtime_request_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/models/overtime_request_models.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/widgets/overtime_request_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class OvertimeRequestFormScreen extends StatefulWidget {
  final String? encryption;

  const OvertimeRequestFormScreen({super.key, this.encryption});

  @override
  State<OvertimeRequestFormScreen> createState() => _OvertimeRequestFormScreenState();
}

class _OvertimeRequestFormScreenState extends State<OvertimeRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late OvertimeRequestFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = OvertimeRequestFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<OvertimeRequestController>();

    try {
      await ctrl.fetchFormOptions();
      final opts = ctrl.formOptions;
      _formData.idEmployee = opts?.currentEmployeeId;

      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _formData = OvertimeRequestFormModel(
            idOvertimeRequest: d.idOvertimeRequest,
            encryption: d.encryption,
            idOvertimeType: d.idOvertimeType,
            idEmployee: d.idEmployee ?? opts?.currentEmployeeId,
            requestDate: _parseDate(d.requestDate),
            startTime: _parseTime(d.startDatetime),
            endTime: _parseTime(d.endDatetime),
            requestedHours: d.requestedHours,
            reason: d.reason,
          );
        }
      }
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  DateTime? _parseDate(String? s) {
    if (s == null) return null;
    try {
      return DateTime.parse(s.length > 10 ? s.substring(0, 10) : s);
    } catch (_) {
      return null;
    }
  }

  TimeOfDay? _parseTime(String? s) {
    if (s == null || s.length < 16) return null;
    try {
      final p = s.substring(11, 16).split(':');
      return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
    } catch (_) {
      return null;
    }
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _handleSaveDraft() async {
    final ctrl = context.read<OvertimeRequestController>();
    final success = await ctrl.saveDraft(_formData);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleSubmit() async {
    final ctrl = context.read<OvertimeRequestController>();
    final success = await ctrl.saveAndSubmit(_formData);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Overtime Request' : 'Create Overtime Request',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<OvertimeRequestController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized || ctrl.isLoadingOptions || (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          return Stack(
            children: [
              OvertimeRequestFormFields(
                formKey: _formKey,
                formData: _formData,
                formOptions: ctrl.formOptions,
                onSaveDraft: _handleSaveDraft,
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