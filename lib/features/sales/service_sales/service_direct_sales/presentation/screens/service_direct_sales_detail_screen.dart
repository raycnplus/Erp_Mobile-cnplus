import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/models/service_direct_sales_models.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/controllers/service_direct_sales_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/widgets/service_direct_sales_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'service_direct_sales_form_screen.dart';

class ServiceDirectSalesDetailScreen extends StatefulWidget {
  final String encryption;

  const ServiceDirectSalesDetailScreen({super.key, required this.encryption});

  @override
  State<ServiceDirectSalesDetailScreen> createState() => _State();
}

class _State extends State<ServiceDirectSalesDetailScreen> {
  late String _enc;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        context.read<ServiceDirectSalesController>().fetchDetail(_enc));
  }

  void _snack(String msg, {bool success = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  Future<void> _handleDelete() async {
    final ctrl = context.read<ServiceDirectSalesController>();
    final d    = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this service direct sales draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok == true && mounted) {
      final success = await ctrl.remove(d.idServiceDirectSales);
      if (!mounted) return;
      _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
      if (success) Navigator.pop(context, true);
    }
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<ServiceDirectSalesController>();
    final d    = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Confirm',
      'Confirm this service direct sales?',
      confirmLabel: 'Confirm',
    );
    if (ok == true && mounted) {
      final f       = ServiceDirectSalesFormModel.fromDetail(d);
      final success = await ctrl.save(f, status: 'confirm');
      if (!mounted) return;
      _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
      if (success && ctrl.savedEncryption?.isNotEmpty == true) {
        setState(() => _enc = ctrl.savedEncryption!);
      }
    }
  }

  Future<void> _handleValidate() async {
    final ctrl = context.read<ServiceDirectSalesController>();
    final d    = ctrl.detail;
    if (d == null) return;

    final msg = d.isMultiPayment
        ? 'Validate this SDS? Status will change to Done.'
        : 'Validate this SDS? Status will change to Done and a Service Invoice will be auto-created.';

    final ok = await _confirmDialog('Validate', msg, confirmLabel: 'Validate');
    if (ok == true && mounted) {
      final f       = ServiceDirectSalesFormModel.fromDetail(d);
      final success = await ctrl.save(f, status: 'validate');
      if (!mounted) return;
      _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
      if (success && ctrl.savedEncryption?.isNotEmpty == true) {
        setState(() => _enc = ctrl.savedEncryption!);
      }
    }
  }

  Future<void> _handleCancel() async {
    final ctrl      = context.read<ServiceDirectSalesController>();
    final d         = ctrl.detail;
    if (d == null) return;
    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Cancel Service Direct Sales',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Cancel Reason *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Close', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      if (reasonCtrl.text.trim().isEmpty) {
        _snack('Cancel reason is required');
        return;
      }
      final success = await ctrl.cancel(d.idServiceDirectSales, reasonCtrl.text.trim());
      if (!mounted) return;
      _snack(success ? 'Cancelled' : ctrl.formError ?? 'Failed', success: success);
    }
  }

  Future<void> _handleCreateInvoiceFromTerm(ServiceDirectSalesPaymentSchedule schedule) async {
    final ctrl = context.read<ServiceDirectSalesController>();
    final d    = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Create Invoice',
      'Create invoice for term "${schedule.termName}"?',
      confirmLabel: 'Create',
    );
    if (ok == true && mounted) {
      final success = await ctrl.createInvoiceFromSchedule(
        d.idServiceDirectSales,
        schedule.idPaymentSchedule,
      );
      if (!mounted) return;
      _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    }
  }

  Future<void> _handleCreateInvoiceFromTermDialog() async {
    final ctrl = context.read<ServiceDirectSalesController>();
    final d = ctrl.detail;
    if (d == null) return;

    final pendingSchedules = d.paymentSchedules.where((s) => s.canInvoice).toList();
    if (pendingSchedules.isEmpty) {
      _snack('No pending payment schedules');
      return;
    }

    ServiceDirectSalesPaymentSchedule? selected = pendingSchedules.first;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text(
            'Create Invoice from Term',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: pendingSchedules.map((s) {
              return RadioListTile<ServiceDirectSalesPaymentSchedule>(
                value: s,
                groupValue: selected,
                onChanged: (v) => setSt(() => selected = v),
                title: Text(s.termName, style: GoogleFonts.poppins(fontSize: 13)),
                subtitle: Text(
                  'Rp ${s.totalAmount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(fontSize: 11),
                ),
              );
            }).toList(),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Create', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );

    if (ok != true || selected == null || !mounted) return;

    final success = await ctrl.createInvoiceFromSchedule(
      d.idServiceDirectSales,
      selected!.idPaymentSchedule,
    );
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
  }

  Future<bool?> _confirmDialog(
    String title,
    String content, {
    String confirmLabel = 'Confirm',
    Color? confirmColor,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(content, style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(confirmLabel, style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Service Direct Sales',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<ServiceDirectSalesController>(
            builder: (_, ctrl, __) {
              final d = ctrl.detail;
              if (d == null) return const SizedBox();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (d.canEdit)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDirectSalesFormScreen(encryption: _enc),
                        ),
                      ).then((_) {
                        if (mounted) {
                          final ne = ctrl.savedEncryption;
                          if (ne != null && ne.isNotEmpty && ne != _enc) {
                            setState(() => _enc = ne);
                          } else {
                            ctrl.fetchDetail(_enc);
                          }
                        }
                      }),
                    ),
                  if (d.canDelete)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: colorError),
                      onPressed: _handleDelete,
                    ),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<ServiceDirectSalesController>(
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
                    child: const Text('Retry'),
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
                    child: ServiceDirectSalesDetailTabs(
                      detail: d,
                      onCreateInvoiceFromTerm: d.isDone && d.isMultiPayment
                          ? _handleCreateInvoiceFromTerm
                          : null,
                    ),
                  ),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceDirectSalesFormScreen(encryption: _enc),
                        ),
                      ).then((_) => ctrl.fetchDetail(_enc))),
                      _primaryBtn('Confirm', Icons.check_circle_outline, _handleConfirm),
                    ]),
                  if (d.isConfirmed)
                    _bottomBar([
                      _dangerBtn('Cancel',   Icons.cancel_outlined,   _handleCancel),
                      _primaryBtn('Validate', Icons.verified_outlined, _handleValidate),
                    ]),
                  if (d.isDone)
                    _bottomBar([
                      if (d.isMultiPayment)
                        _primaryBtn(
                          'Invoice from Term',
                          Icons.payment_outlined,
                          _handleCreateInvoiceFromTermDialog,
                        )
                      else
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Done — Service Invoice auto-created',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ]),
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

  Widget _bottomBar(List<Widget> children) {
    final items = children
        .map((w) => w is Expanded ? w : Expanded(child: w))
        .toList()
        .asMap()
        .entries
        .expand((e) => e.key < children.length - 1 ? [e.value, const SizedBox(width: 10)] : [e.value])
        .toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: colorCard,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(children: items),
    );
  }

  Widget _primaryBtn(String label, IconData icon, VoidCallback onTap, {Color? color}) =>
      ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          backgroundColor: color ?? colorPrimary,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      );

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) =>
      OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          foregroundColor: colorPrimary,
          side: const BorderSide(color: colorPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  Widget _dangerBtn(String label, IconData icon, VoidCallback onTap) =>
      OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          foregroundColor: colorError,
          side: const BorderSide(color: colorError),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
}