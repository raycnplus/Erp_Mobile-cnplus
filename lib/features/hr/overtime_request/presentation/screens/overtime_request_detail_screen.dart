import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/controllers/overtime_request_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/models/overtime_request_models.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/widgets/overtime_request_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'overtime_request_form_screen.dart';

class OvertimeRequestDetailScreen extends StatefulWidget {
  final String encryption;

  const OvertimeRequestDetailScreen({super.key, required this.encryption});

  @override
  State<OvertimeRequestDetailScreen> createState() => _OvertimeRequestDetailScreenState();
}

class _OvertimeRequestDetailScreenState extends State<OvertimeRequestDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<OvertimeRequestController>().fetchDetail(_enc),
    );
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _handleDelete() async {
    final ctrl = context.read<OvertimeRequestController>();
    if (ctrl.detail?.canDelete != true) {
      _snack('Only draft requests can be deleted');
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Draft', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Delete this overtime request draft?', style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    final success = await ctrl.remove(_enc);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleSubmit() async {
    final ctrl = context.read<OvertimeRequestController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Submit Request', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Submit this overtime request for approval?', style: GoogleFonts.poppins()),
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
            child: Text('Submit', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    final f = _buildFormFromDetail(d);
    final success = await ctrl.saveAndSubmit(f);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage ?? 'Submitted' : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
    }
  }

  Future<void> _handleApprove() async {
    final d = context.read<OvertimeRequestController>().detail;
    if (d == null) return;

    final hoursCtrl = TextEditingController(text: d.requestedHours.toStringAsFixed(2));
    final notesCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Approve Overtime', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Approve overtime for ${d.employeeName ?? "this employee"}?', style: GoogleFonts.poppins()),
            const SizedBox(height: 12),
            TextField(
              controller: hoursCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Approved Hours',
                suffixText: 'hours',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notesCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Notes (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
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
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Approve', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    final ctrl = context.read<OvertimeRequestController>();
    final approvedHours = double.tryParse(hoursCtrl.text) ?? d.requestedHours;
    final notes = notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim();
    final success = await ctrl.approve(d.idOvertimeRequest, approvedHours: approvedHours, notes: notes);
    if (!mounted) return;
    _snack(success ? 'Approved' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleReject() async {
    final d = context.read<OvertimeRequestController>().detail;
    if (d == null) return;

    final notesCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reject Overtime', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reject overtime from ${d.employeeName ?? "this employee"}?', style: GoogleFonts.poppins()),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                hintStyle: GoogleFonts.poppins(color: colorGrey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
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
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Reject', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    final ctrl = context.read<OvertimeRequestController>();
    final notes = notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim();
    final success = await ctrl.reject(d.idOvertimeRequest, notes: notes);
    if (!mounted) return;
    _snack(success ? 'Rejected' : ctrl.formError ?? 'Failed', success: success);
  }

  OvertimeRequestFormModel _buildFormFromDetail(OvertimeRequestDetailModel d) {
    DateTime? parseDate(String? s) {
      if (s == null) return null;
      try {
        return DateTime.parse(s.length > 10 ? s.substring(0, 10) : s);
      } catch (_) {
        return null;
      }
    }

    TimeOfDay? parseTime(String? s) {
      if (s == null || s.length < 16) return null;
      try {
        final p = s.substring(11, 16).split(':');
        return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
      } catch (_) {
        return null;
      }
    }

    return OvertimeRequestFormModel(
      idOvertimeRequest: d.idOvertimeRequest,
      encryption: d.encryption,
      idOvertimeType: d.idOvertimeType,
      idEmployee: d.idEmployee,
      requestDate: parseDate(d.requestDate),
      startTime: parseTime(d.startDatetime),
      endTime: parseTime(d.endDatetime),
      requestedHours: d.requestedHours,
      reason: d.reason,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Overtime Request', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<OvertimeRequestController>(
            builder: (_, ctrl, __) {
              final d = ctrl.detail;
              if (d == null) return const SizedBox();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (d.canDelete)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: colorError),
                      onPressed: _handleDelete,
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<OvertimeRequestController>(
        builder: (_, ctrl, __) {
          if (ctrl.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: colorError),
                  const SizedBox(height: 16),
                  Text(
                    ctrl.detailError!,
                    style: GoogleFonts.poppins(color: colorError),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ctrl.fetchDetail(_enc),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      foregroundColor: colorWhite,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          if (ctrl.detail == null) {
            return Center(child: Text('No data', style: GoogleFonts.poppins(color: colorGrey)));
          }

          final d = ctrl.detail!;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: OvertimeRequestDetailTabs(
                      detail: d,
                      canApprove: d.approvalInfo?['can_approve'] == true,
                      onApprove: _handleApprove,
                      onReject: _handleReject,
                    ),
                  ),
                  if (d.canSubmit)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      decoration: BoxDecoration(
                        color: colorCard,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => OvertimeRequestFormScreen(encryption: _enc)),
                              ).then((_) {
                                if (!mounted) return;
                                final ne = ctrl.savedEncryption;
                                if (ne != null && ne != _enc) {
                                  setState(() => _enc = ne);
                                } else {
                                  ctrl.fetchDetail(_enc);
                                }
                              }),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: Text('Edit', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                foregroundColor: colorPrimary,
                                side: const BorderSide(color: colorPrimary),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _handleSubmit,
                              icon: const Icon(Icons.send_outlined, size: 18),
                              label: Text('Submit', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                backgroundColor: colorPrimary,
                                foregroundColor: colorWhite,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (d.canEdit && !d.canSubmit)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      decoration: BoxDecoration(
                        color: colorCard,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OvertimeRequestFormScreen(encryption: _enc)),
                          ).then((_) {
                            if (mounted) ctrl.fetchDetail(_enc);
                          }),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: Text('Edit & Resubmit', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            backgroundColor: colorPrimary,
                            foregroundColor: colorWhite,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                ],
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