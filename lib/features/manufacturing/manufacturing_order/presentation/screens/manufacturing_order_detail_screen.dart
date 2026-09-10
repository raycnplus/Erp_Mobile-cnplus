import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/controllers/manufacturing_order_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/widgets/manufacturing_order_detail_tabs.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'manufacturing_order_form_screen.dart';

class ManufacturingOrderDetailScreen extends StatefulWidget {
  final String encryption;

  const ManufacturingOrderDetailScreen({super.key, required this.encryption});

  @override
  State<ManufacturingOrderDetailScreen> createState() => _State();
}

class _State extends State<ManufacturingOrderDetailScreen> {
  late String _enc;
  bool _isEditingUsage = false;

  final Map<int, TextEditingController> _usageCtrls = {};

  @override
  void initState() {
    super.initState();
    _enc = widget.encryption;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    for (final c in _usageCtrls.values) c.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ctrl = context.read<ManufacturingOrderController>();
    await ctrl.fetchDetail(_enc);
    final d = ctrl.detail;
    if (d == null) return;
    if (d.isWaitingApproval) ctrl.loadSteps(_enc);
    if (d.isConfirmed) await _loadPlanMaterialsForUsage(d);
  }

  Future<void> _loadPlanMaterialsForUsage(ManufacturingOrderDetailModel d) async {
    if (d.idBom == null || d.sourceWarehouse == null || d.sourceLocation == null) return;
    final ctrl = context.read<ManufacturingOrderController>();
    await ctrl.fetchPlanMaterials(
      bomId: d.idBom!,
      qty: d.plannedQty,
      warehouseId: d.sourceWarehouse!,
      locationId: d.sourceLocation!,
      manufacturingOrderId: d.idManufacturingOrder,
    );
    if (!mounted) return;
    for (final m in ctrl.planMaterials) {
      final key = m.componentProductId;
      final initial = m.realQty > 0 ? m.realQty : m.requiredQty;
      _usageCtrls[key] = TextEditingController(text: initial > 0 ? initial.toStringAsFixed(2) : '');
    }
    setState(() {});
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
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

  ManufacturingOrderFormModel _formFromDetail(ManufacturingOrderDetailModel d) =>
      ManufacturingOrderFormModel.fromDetail(d);

  Future<void> _handleDelete() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Delete Draft',
      'Delete this manufacturing order draft?',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Deleted' : ctrl.formError ?? 'Failed', success: success);
    if (success) Navigator.pop(context, true);
  }

  Future<void> _handleConfirm() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog('Confirm Manufacturing Order', 'Confirm this manufacturing order?', confirmLabel: 'Confirm');
    if (ok != true || !mounted) return;

    final f = _formFromDetail(d);
    final success = await ctrl.save(f, status: 'confirm');
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
    if (success && ctrl.savedEncryption?.isNotEmpty == true) {
      setState(() => _enc = ctrl.savedEncryption!);
      _usageCtrls.clear();
    }
  }

  Future<void> _handleSaveUsage() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    if (ctrl.planMaterials.isEmpty) {
      _snack('Material data not loaded yet');
      return;
    }

    final realMaterials = <MORealMaterialUsage>[];
    for (final m in ctrl.planMaterials) {
      final txt = _usageCtrls[m.componentProductId]?.text ?? '';
      final qty = double.tryParse(txt.replaceAll(',', '')) ?? 0;
      if (qty <= 0) {
        _snack('Used Qty for ${m.productName ?? 'material'} must be greater than 0');
        return;
      }
      realMaterials.add(MORealMaterialUsage(
        componentProductId: m.componentProductId,
        qtyUsed: qty,
        unitOfMeasure: m.uomId ?? m.unitOfMeasure,
      ));
    }

    final f = _formFromDetail(d);
    f.realMaterials = realMaterials;
    final success = await ctrl.save(f, status: 'save'); // status TETAP 'save', bukan 'validate'
    if (!mounted) return;
    _snack(success ? 'Used quantity updated' : ctrl.formError ?? 'Failed', success: success);
    if (success) setState(() => _isEditingUsage = false);
  }

  void _handleCancelEditUsage() {
    final ctrl = context.read<ManufacturingOrderController>();
    for (final m in ctrl.planMaterials) {
      final initial = m.realQty > 0 ? m.realQty : m.requiredQty;
      _usageCtrls[m.componentProductId]?.text = initial > 0 ? initial.toStringAsFixed(2) : '';
    }
    setState(() => _isEditingUsage = false);
  }

  Future<void> _handleValidate() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    if (ctrl.planMaterials.isEmpty) {
      _snack('Material data not loaded yet');
      return;
    }

    final realMaterials = <MORealMaterialUsage>[];
    for (final m in ctrl.planMaterials) {
      final txt = _usageCtrls[m.componentProductId]?.text ?? '';
      final qty = double.tryParse(txt.replaceAll(',', '')) ?? 0;
      if (qty <= 0) {
        _snack('Used Qty for ${m.productName ?? 'material'} must be greater than 0');
        return;
      }
      realMaterials.add(MORealMaterialUsage(
        componentProductId: m.componentProductId,
        qtyUsed: qty,
        unitOfMeasure: m.uomId ?? m.unitOfMeasure,
      ));
    }

    final ok = await _confirmDialog(
      'Validate Manufacturing Order',
      'Validate this manufacturing order? Status will change to Done and stock will be adjusted.',
      confirmLabel: 'Validate',
    );
    if (ok != true || !mounted) return;

    final f = _formFromDetail(d);
    f.realMaterials = realMaterials;
    final success = await ctrl.save(f, status: 'validate');
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleApprove() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Approve',
      'Approve this manufacturing order?',
      confirmLabel: 'Approve',
      confirmColor: const Color(0xFF2E7D32),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.approve(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Approved' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleReject() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Reject',
      'Reject this manufacturing order?',
      confirmLabel: 'Reject',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.reject(d.encryption);
    if (!mounted) return;
    _snack(success ? 'Rejected' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleViewSteps() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    await ctrl.loadSteps(d.encryption);
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
            final lvNo = lv['level_no'];
            final min = lv['min_approver'];
            final members = (lv['members'] as List? ?? []);
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
                      final id = (m is Map) ? m['id']?.toString() : m.toString();
                      final name = (m is Map) ? m['nama_lengkap']?.toString() ?? id : id;
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

  bool _canApprove(Map<String, dynamic>? steps) {
    if (steps == null) return false;
    final data = steps['data'] as Map<String, dynamic>?;
    return data != null && data['can_approve'] == true;
  }

  Future<void> _handleCreateUnbuild() async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    final ok = await _confirmDialog(
      'Create Unbuild Order',
      'This will create a new Unbuild Order based on this Manufacturing Order. Continue?',
      confirmLabel: 'Create Unbuild',
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.generateUnbuild(d.encryption);
    if (!mounted) return;
    _snack(success ? ctrl.successMessage! : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleOperationAction(MOOperation op) async {
    final ctrl = context.read<ManufacturingOrderController>();
    final d = ctrl.detail;
    if (d == null) return;

    bool success = false;
    if (op.isPending) {
      final ok = await _confirmDialog('Start Operation', 'Start "${op.operationName}"?', confirmLabel: 'Start');
      if (ok != true || !mounted) return;
      success = await ctrl.startMoOperation(d.idManufacturingOrder, op.idBomOperation);
    } else if (op.isInProgress) {
      success = await ctrl.pauseMoOperation(op.idMoOperationTracking!);
    } else if (op.isPaused) {
      success = await ctrl.resumeMoOperation(op.idMoOperationTracking!);
    } else {
      return;
    }
    if (!mounted) return;
    _snack(success ? 'Updated' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleCompleteOperation(MOOperation op) async {
    final ctrl = context.read<ManufacturingOrderController>();
    if (op.idMoOperationTracking == null) return;

    final ok = await _confirmDialog(
      'Complete Operation',
      'Mark "${op.operationName}" as completed?',
      confirmLabel: 'Complete',
      confirmColor: const Color(0xFF2E7D32),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.completeMoOperation(op.idMoOperationTracking!);
    if (!mounted) return;
    _snack(success ? 'Operation completed' : ctrl.formError ?? 'Failed', success: success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text(
          'Manufacturing Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
        actions: [
          Consumer<ManufacturingOrderController>(
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
                        MaterialPageRoute(builder: (_) => ManufacturingOrderFormScreen(encryption: _enc)),
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
      body: Consumer<ManufacturingOrderController>(
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
                    child: ManufacturingOrderDetailTabs(
                      detail: d,
                      planMaterials: ctrl.planMaterials,
                      usageCtrls: _usageCtrls,
                      showEditableUsage: d.isConfirmed,
                      isEditingUsage: _isEditingUsage,
                      onOperationAction: _handleOperationAction,
                      onCompleteOperation: _handleCompleteOperation,
                    ),
                  ),
                  if (d.isDraft)
                    _bottomBar([
                      _outlineBtn('Edit', Icons.edit_outlined, () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ManufacturingOrderFormScreen(encryption: _enc)),
                      ).then((_) => ctrl.fetchDetail(_enc))),
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
                    _bottomBar(_isEditingUsage
                        ? [
                            _outlineBtn('Cancel', Icons.close, _handleCancelEditUsage),
                            _primaryBtn('Save', Icons.save_outlined, _handleSaveUsage),
                          ]
                        : [
                            _outlineBtn('Edit Usage', Icons.edit_outlined, () => setState(() => _isEditingUsage = true)),
                            _primaryBtn('Validate', Icons.verified_outlined, _handleValidate),
                          ]),
                  if (d.isDone && d.canCreateUnbuild)
                    _bottomBar([
                      _outlineBtn('Create Unbuild', Icons.settings_backup_restore, _handleCreateUnbuild),
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
    final expanded = children.map((w) => w is Expanded ? w : Expanded(child: w)).toList();
    final spaced = <Widget>[];
    for (int i = 0; i < expanded.length; i++) {
      spaced.add(expanded[i]);
      if (i < expanded.length - 1) spaced.add(const SizedBox(width: 10));
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: colorCard,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(children: spaced),
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

  Widget _outlineBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
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

  Widget _dangerBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
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