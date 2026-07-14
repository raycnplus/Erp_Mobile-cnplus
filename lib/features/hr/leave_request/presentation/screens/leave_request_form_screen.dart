import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/controllers/leave_request_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/models/leave_request_models.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/widgets/leave_request_form_fields.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class LeaveRequestFormScreen extends StatefulWidget {
  final String? encryption;

  const LeaveRequestFormScreen({super.key, this.encryption});

  @override
  State<LeaveRequestFormScreen> createState() =>
      _LeaveRequestFormScreenState();
}

class _LeaveRequestFormScreenState extends State<LeaveRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late LeaveRequestFormModel _formData;
  bool _isInitialized = false;

  bool get isEditMode => widget.encryption != null;

  @override
  void initState() {
    super.initState();
    _formData = LeaveRequestFormModel(encryption: widget.encryption);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final ctrl = context.read<LeaveRequestController>();
    try {
      await ctrl.fetchFormOptions();
      if (isEditMode) {
        await ctrl.fetchDetail(widget.encryption!);
        if (!mounted) return;
        final d = ctrl.detail;
        if (d != null) {
          _formData = LeaveRequestFormModel(
            idLeaveRequest: d.idLeaveRequest,
            encryption: d.encryption,
            idLeaveType: d.idLeaveType,
            startDate: d.startDatetime != null
                ? _parseDate(d.startDatetime!)
                : null,
            endDate: d.endDatetime != null
                ? _parseDate(d.endDatetime!)
                : null,
            durationType: d.durationType ?? 'FULL',
            halfSession: d.halfSession,
            description: d.description,
          );
        }
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() => _isInitialized = true);
  }

  DateTime? _parseDate(String s) {
    try {
      return DateTime.parse(s.length > 10 ? s.substring(0, 10) : s);
    } catch (_) {
      return null;
    }
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _handleSaveDraft() async {
    final ctrl = context.read<LeaveRequestController>();
    final bool success;
    if (isEditMode && _formData.idLeaveRequest != null) {
      success = await ctrl.updateDraft(_formData.idLeaveRequest!, _formData);
    } else {
      success = await ctrl.saveDraft(_formData);
    }
    if (!mounted) return;
    _snack(
      success ? ctrl.successMessage! : ctrl.formError ?? 'Failed',
      success: success,
    );
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleSubmit() async {
    final ctrl = context.read<LeaveRequestController>();
    final bool success;
    if (isEditMode && _formData.idLeaveRequest != null) {
      success = await ctrl.submitDraft(_formData.idLeaveRequest!, _formData);
    } else {
      success = await ctrl.createAndSubmit(_formData);
    }
    if (!mounted) return;
    _snack(
      success ? ctrl.successMessage ?? 'Submitted' : ctrl.formError ?? 'Failed',
      success: success,
    );
    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Leave Request' : 'Create Leave Request',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
        elevation: 1,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Consumer<LeaveRequestController>(
        builder: (_, ctrl, __) {
          if (!_isInitialized ||
              ctrl.isLoadingOptions ||
              (isEditMode && ctrl.isLoadingDetail)) {
            return const Center(
              child: CircularProgressIndicator(color: colorPrimary),
            );
          }
          return Stack(
            children: [
              LeaveRequestFormFields(
                formKey: _formKey,
                formData: _formData,
                formOptions: ctrl.formOptions,
                onSaveDraft: _handleSaveDraft,
                onSubmit: _handleSubmit,
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