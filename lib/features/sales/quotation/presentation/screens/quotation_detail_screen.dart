import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/data/models/quotation_models.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/controllers/quotation_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/widgets/quotation_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'quotation_form_screen.dart';

class QuotationDetailScreen extends StatefulWidget {
  final String encryption;

  const QuotationDetailScreen({super.key, required this.encryption});

  @override
  State<QuotationDetailScreen> createState() => _State();
}

class _State extends State<QuotationDetailScreen> {
  late String _enc;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final ctrl = context.read<QuotationController>();
    await ctrl.fetchDetail(_enc);
    final d = ctrl.detail;
    if (d?.isWaitingApproval == true) ctrl.loadSteps(d!.idQuotation);
  }

  void _snack(String msg, {bool success = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: success ? colorSuccess : colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  Future<void> _handleDelete() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this quotation draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok == true && mounted) {
      final success = await ctrl.remove(d.idQuotation);
      if (!mounted) return;
      _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
      if (success) Navigator.pop(context, true);
    }
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Confirm Quotation',
      'Confirm this quotation?',
      confirmLabel: 'Confirm',
    );
    if (ok == true && mounted) {
      final f = _formFromDetail(d);
      final success = await ctrl.save(f, status: 'confirm');
      if (!mounted) return;
      _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
      if (success && ctrl.savedEncryption?.isNotEmpty == true) {
        setState(() => _enc = ctrl.savedEncryption!);
      }
    }
  }

  Future<void> _handleValidate() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Validate Quotation',
      'Validate this quotation? Status will change to Done.',
      confirmLabel: 'Validate',
    );
    if (ok == true && mounted) {
      final f = _formFromDetail(d);
      final success = await ctrl.save(f, status: 'validate');
      if (!mounted) return;
      _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
      if (success && ctrl.savedEncryption?.isNotEmpty == true) {
        setState(() => _enc = ctrl.savedEncryption!);
      }
    }
  }

  Future<void> _handleCancel() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancel Quotation', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
            child: Text('Close', style: GoogleFonts.poppins(color: colorGreyDark)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorError,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Cancel Order', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      if (reasonCtrl.text.trim().isEmpty) {
        _snack('Cancel reason is required');
        return;
      }
      final success = await ctrl.cancel(d.idQuotation, reasonCtrl.text.trim());
      if (!mounted) return;
      _snack(success ? 'Cancelled' : ctrl.formError ?? 'Failed', success: success);
      if (success) setState(() => _enc = ctrl.detail?.encryption ?? _enc);
    }
  }

  Future<void> _handleCreateSO() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Create Sales Order',
      'Create a Sales Order from this quotation?',
      confirmLabel: 'Create SO',
    );
    if (ok == true && mounted) {
      final success = await ctrl.createSO(d.idQuotation);
      if (!mounted) return;
      _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    }
  }

  Future<void> _handleApprove() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Approve',
      'Approve this quotation?',
      confirmLabel: 'Approve',
      confirmColor: const Color(0xFF2E7D32),
    );
    if (ok == true && mounted) {
      final success = await ctrl.approve(d.idQuotation);
      if (!mounted) return;
      _snack(success ? 'Approved' : ctrl.formError ?? 'Failed', success: success);
    }
  }

  Future<void> _handleReject() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    final ok = await _confirmDialog(
      'Reject',
      'Reject this quotation?',
      confirmLabel: 'Reject',
      confirmColor: colorError,
    );
    if (ok == true && mounted) {
      final success = await ctrl.reject(d.idQuotation);
      if (!mounted) return;
      _snack(success ? 'Rejected' : ctrl.formError ?? 'Failed', success: success);
    }
  }

  Future<void> _handleViewSteps() async {
    final ctrl = context.read<QuotationController>();
    final d = ctrl.detail;
    if (d == null) return;
    await ctrl.loadSteps(d.idQuotation);
    if (!mounted) return;
    final steps = ctrl.approvalSteps;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Approval Steps', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: steps == null
            ? Text('Failed to load', style: GoogleFonts.poppins())
            : _buildStepsContent(steps),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: colorPrimary)),
          ),
        ],
      ),
    );
  }

  void _handleReturnFromForm(QuotationController ctrl) {
    if (!mounted) return;
    final ne = ctrl.savedEncryption;
    if (ne != null && ne.isNotEmpty && ne != _enc) {
      setState(() => _enc = ne);
    } else {
      ctrl.fetchDetail(_enc);
    }
  }

  Widget _buildStepsContent(Map<String, dynamic> steps) {
    final data = steps['data'] as Map<String, dynamic>?;
    if (data == null || data['has_rule'] != true) {
      return Text('No approval rule configured.', style: GoogleFonts.poppins());
    }
    final levels = (data['levels'] as List? ?? []);
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          children: levels.map<Widget>((lv) {
            final lvNo     = lv['level_no'];
            final min      = lv['min_approver'];
            final members  = (lv['members'] as List? ?? []);
            final approved = (lv['approved'] as List? ?? []).map((v) => v.toString()).toList();
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $lvNo — Min $min approver(s)',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    ...members.map((m) {
                      final id         = (m is Map) ? m['id']?.toString() : m.toString();
                      final name       = (m is Map) ? m['nama_lengkap']?.toString() ?? id : id;
                      final isApproved = approved.contains(id);
                      return Row(
                        children: [
                          Icon(
                            isApproved ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 16,
                            color: isApproved ? Colors.green : colorGrey,
                          ),
                          const SizedBox(width: 6),
                          Text(name ?? '-', style: GoogleFonts.poppins(fontSize: 12)),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  QuotationFormModel _formFromDetail(d) {
    final f = QuotationFormModel(
      idQuotation:     d.idQuotation,
      encryption:      d.encryption,
      reference:       d.reference,
      idCustomer:      d.idCustomer,
      sourceWarehouse: d.sourceWarehouse,
      sourceLocation:  d.sourceLocation,
      salesPerson:     d.salesPerson,
      idPaymentTerm:   d.idPaymentTerm,
      idPriceList:     d.idPriceList,
      validityDate:    d.validityDate != null ? DateTime.tryParse(d.validityDate!) : null,
      deliveryAddress: d.deliveryAddress ?? '',
      note:            d.note,
      isTax:           d.isTaxEnabled,
      discountType:    d.discountType,
    );
    for (final item in d.items) {
      f.items.add(QuotationFormItem(
        idProduct:      item.idProduct,
        productName:    item.productName,
        description:    item.description,
        uomId:          item.unitOfMeasure,
        uomName:        item.uomName,
        demandQty:      item.demandQty,
        unitPrice:      item.unitPrice,
        discountRate:   item.discountRate,
        discountAmount: item.discountAmount,
        taxRate:        item.taxRate,
        taxAmount:      item.taxAmount,
      ));
    }
    return f;
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
          'Quotation',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<QuotationController>(
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
                        MaterialPageRoute(builder: (_) => QuotationFormScreen(encryption: _enc)),
                      ).then((_) {
                        if (!mounted) return;
                        final ne = ctrl.savedEncryption;
                        if (ne != null && ne.isNotEmpty && ne != _enc) {
                          setState(() => _enc = ne);   
                        } else {
                          ctrl.fetchDetail(_enc);
                        }
                      }),
                    ),
                  if (d.canDelete)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: colorError),
                      onPressed: _handleDelete,
                    ),
                  if (d.isWaitingApproval)
                    IconButton(
                      icon: const Icon(Icons.account_tree_outlined),
                      onPressed: _handleViewSteps,
                    ),
                  const SizedBox(width: 4),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<QuotationController>(
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
                  Expanded(child: QuotationDetailTabs(detail: d)),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QuotationFormScreen(encryption: _enc)),
                      ).then((_) => _handleReturnFromForm(ctrl))),
                      _primaryBtn('Confirm', Icons.check_circle_outline, _handleConfirm),
                    ]),
                  if (d.isWaitingApproval)
                    _bottomBar([
                      _outlineBtn('View Steps', Icons.account_tree_outlined, _handleViewSteps),
                      if (_canApprove(ctrl.approvalSteps)) ...[
                        _dangerBtn('Reject', Icons.close, _handleReject),
                        _primaryBtn('Approve', Icons.check, _handleApprove, color: const Color(0xFF2E7D32)),
                      ],
                    ]),
                  if (d.isConfirmed)
                    _bottomBar([
                      _dangerBtn('Cancel', Icons.cancel_outlined, _handleCancel),
                      _primaryBtn('Validate', Icons.verified_outlined, _handleValidate),
                    ]),
                  if (d.isDone)
                    _bottomBar([
                      if (d.canCreateSO)
                        _primaryBtn('Create Sales Order', Icons.receipt_long_outlined, _handleCreateSO),
                      if (d.hasSalesOrder)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                                  'Sales Order Created',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
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

  bool _canApprove(Map<String, dynamic>? steps) {
    if (steps == null) return false;
    final data = steps['data'] as Map<String, dynamic>?;
    if (data == null) return false;

    if (data.containsKey('can_approve')) return data['can_approve'] == true;

    if (data['status'] != 'PENDING') return false;
    if (data['has_rule'] != true) return false;

    final levels = data['levels'] as List?;
    if (levels == null || levels.isEmpty) return false;

    final currentLevelRaw = data['current_level'];
    final currentLevel = currentLevelRaw is int
        ? currentLevelRaw
        : int.tryParse(currentLevelRaw.toString()) ?? 1;

    final curLvl = levels.firstWhere(
      (l) => l is Map &&
          ((l['level_no'] is int
                  ? l['level_no']
                  : int.tryParse(l['level_no'].toString()) ?? 0) ==
              currentLevel),
      orElse: () => null,
    ) as Map?;
    if (curLvl == null) return false;

    final approved  = (curLvl['approved'] as List? ?? []).length;
    final minNeeded = curLvl['min_approver'] is int
        ? curLvl['min_approver'] as int
        : int.tryParse(curLvl['min_approver'].toString()) ?? 1;

    if (approved >= minNeeded) return false;

    if (_currentUserId == null) return true;
    final members = (curLvl['members'] as List? ?? []);
    return members.any((m) {
      final memberId = m is Map
          ? (m['id'] is int ? m['id'] : int.tryParse(m['id'].toString()) ?? 0)
          : 0;
      return memberId == _currentUserId;
    });
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