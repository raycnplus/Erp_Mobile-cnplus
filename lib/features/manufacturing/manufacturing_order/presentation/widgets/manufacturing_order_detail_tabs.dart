import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/models/manufacturing_order_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class ManufacturingOrderDetailTabs extends StatefulWidget {
  final ManufacturingOrderDetailModel detail;
  final List<MOPlanMaterial> planMaterials;
  final Map<int, TextEditingController> usageCtrls;
  final bool showEditableUsage;
  final bool isEditingUsage;
  final ValueChanged<MOOperation> onOperationAction;
  final ValueChanged<MOOperation> onCompleteOperation;

  const ManufacturingOrderDetailTabs({
    super.key,
    required this.detail,
    required this.planMaterials,
    required this.usageCtrls,
    required this.showEditableUsage,
    required this.isEditingUsage,
    required this.onOperationAction,
    required this.onCompleteOperation,
  });

  @override
  State<ManufacturingOrderDetailTabs> createState() => _State();
}

class _State extends State<ManufacturingOrderDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;
  Timer? _ticker;
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 6, vsync: this);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _tick++);
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  int _liveActualSeconds(MOOperation op) {
    if (op.trackingStatus == 'in_progress' && op.startTime != null) {
      try {
        final start = DateTime.parse(op.startTime!);
        final elapsed = DateTime.now().difference(start).inSeconds;
        return op.actualDuration + elapsed;
      } catch (_) {
        return op.actualDuration;
      }
    }
    return op.actualDuration; 
  }

  String _fmtDuration(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Draft':            Color(0xFF757575),
    'Waiting Approval': Color(0xFFFFA500),
    'Confirmed':        Color(0xFF1565C0),
    'Done':             Color(0xFF2E7D32),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps = ['Draft', 'Waiting Approval', 'Confirmed', 'Done'];
    int activeIdx = steps.indexOf(status);
    if (activeIdx < 0) activeIdx = 0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final passed = (i ~/ 2) < activeIdx;
            return Expanded(child: Container(height: 2, color: passed ? colorPrimary : colorGreyLight));
          }
          final idx = i ~/ 2;
          final isDone = idx < activeIdx;
          final isCurrent = idx == activeIdx;
          final label = steps[idx];

          Color dot = colorGreyLight;
          if (isCurrent) dot = _statusColors[label] ?? colorPrimary;
          else if (isDone) dot = colorPrimary;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDone || isCurrent) ? dot : Colors.white,
                  border: Border.all(color: (isDone || isCurrent) ? dot : colorGreyLight, width: 2),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : isCurrent
                          ? const Icon(Icons.circle, size: 10, color: Colors.white)
                          : null,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 56,
                child: Text(
                  label == 'Waiting Approval' ? 'Waiting' : label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
                    color: isCurrent ? dot : isDone ? colorPrimary : colorGrey,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        _buildPipeline(),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [
            Tab(text: 'Materials'),
            Tab(text: 'Operations'),
            Tab(text: 'Info'),
            Tab(text: 'Locations'),
            Tab(text: 'Logs'),
            Tab(text: 'Others')
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildMaterialsTab(d),
              _buildOperationsTab(d),
              _buildInfoTab(d),
              _buildLocationsTab(d),
              AuditTrailList(
                items: d.auditTrails.map((a) => AuditTrailItem(
                      actionByName: a.actionByName,
                      actionById:   a.actionById,
                      date:         a.date,
                      description:  a.description,
                    )).toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _availabilityBadge(double required, double available) {
    Color color;
    String label;
    if (available >= required) {
      color = Colors.green;
      label = 'Available (${_fmtNum(available)})';
    } else if (available > 0) {
      color = Colors.orange;
      label = 'Partial ${_fmtNum(available)}/${_fmtNum(required)}';
    } else {
      color = colorError;
      label = 'Not Available';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildMaterialsTab(ManufacturingOrderDetailModel d) {
    if (widget.showEditableUsage) {
      if (widget.planMaterials.isEmpty) {
        return Center(child: Text('No materials found for this BoM', style: GoogleFonts.poppins(color: colorGrey)));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.planMaterials.length,
        itemBuilder: (_, i) {
          final m = widget.planMaterials[i];
          final ctrl = widget.usageCtrls[m.componentProductId];
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: colorCard,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          m.productName ?? '-',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorTextPrimary),
                        ),
                      ),
                      _availabilityBadge(m.requiredQty, m.availableStock),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Plan Qty: ${_fmtNum(m.requiredQty)} ${m.uomName ?? ''}',
                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ctrl,
                    enabled: widget.isEditingUsage,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Used Qty *',
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (d.usageMaterials.isEmpty) {
      return Center(child: Text('No material usage recorded', style: GoogleFonts.poppins(color: colorGrey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: d.usageMaterials.length,
      itemBuilder: (_, i) {
        final m = d.usageMaterials[i];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: colorCard,
          child: ListTile(
            title: Text(m.productName ?? '-', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
            subtitle: Text('Used Qty: ${_fmtNum(m.qtyUsed)} ${m.uomName ?? ''}', style: GoogleFonts.poppins(fontSize: 12)),
          ),
        );
      },
    );
  }

  Widget _buildOperationsTab(ManufacturingOrderDetailModel d) {
    final flat = d.allOperations.expand((g) => g.operations).toList();
    if (flat.isEmpty) {
      return Center(
        child: Text(
          d.isConfirmed || d.isDone ? 'No operations found for this BoM' : 'Operations available after Confirm',
          style: GoogleFonts.poppins(color: colorGrey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: flat.length,
      itemBuilder: (_, i) {
        final op = flat[i];
        final prevCompleted = i == 0 || flat[i - 1].isCompleted;
        final canStart = prevCompleted && op.isPending;
        final isDoneMo = d.isDone;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: colorCard,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${i + 1}. ${op.operationName ?? '-'}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorTextPrimary),
                      ),
                    ),
                    if (op.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('Completed', style: GoogleFonts.poppins(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
                      )
                    else if (op.isInProgress)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('In Progress', style: GoogleFonts.poppins(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w600)),
                      )
                    else if (op.isPaused)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text('Paused', style: GoogleFonts.poppins(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Workstation: ${op.workstationName ?? '-'}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                Text('Planned: ${op.durationFormatted ?? '00:00:00'}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                Text('Actual: ${_fmtDuration(_liveActualSeconds(op))}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: op.isInProgress ? colorPrimary : colorTextPrimary,
                  ),
        ),
                if (!isDoneMo) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (canStart)
                        _opBtn('Start', Icons.play_arrow, colorPrimary, () => widget.onOperationAction(op)),
                      if (op.isInProgress) ...[
                        _opBtn('Pause', Icons.pause, Colors.orange, () => widget.onOperationAction(op)),
                        const SizedBox(width: 8),
                        _opBtn('Complete', Icons.check_circle, Colors.green, () => widget.onCompleteOperation(op)),
                      ],
                      if (op.isPaused) ...[
                        _opBtn('Resume', Icons.play_arrow, colorPrimary, () => widget.onOperationAction(op)),
                        const SizedBox(width: 8),
                        _opBtn('Complete', Icons.check_circle, Colors.green, () => widget.onCompleteOperation(op)),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _opBtn(String label, IconData icon, Color color, VoidCallback onTap) => OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 14),
        label: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      );

  Widget _buildInfoTab(ManufacturingOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Manufacturing Order Info', Icons.precision_manufacturing_outlined, [
            _row('Reference', _safe(d.reference)),
            _row('Status', d.status),
            _row('Product', _safe(d.productName)),
            _row('Bill of Material', _safe(d.bomName)),
            _row('Planned Qty', '${_fmtNum(d.plannedQty)} ${d.uomName ?? ''}'),
            _row('Rejected Product', _safe(d.rejectedProductName)),
            _row('Source Warehouse', _safe(d.sourceWarehouseName)),
            _row('Source Location', _safe(d.sourceLocationName)),
            _row('Scheduled Date', _fmt(d.scheduledDate)),
            if (d.laborPersons.isNotEmpty)
              _row('Labor Persons', d.laborPersons.map((l) => l.name).join(', ')),
            if (d.notes?.isNotEmpty == true) _row('Notes', d.notes!),
          ]),
        ],
      ),
    );
  }

  Widget _buildLocationsTab(ManufacturingOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _infoCard('Locations', Icons.location_on_outlined, [
        _row('Finished Location', _safe(d.finishedLocationName)),
        _row('Byproduct Location', _safe(d.byproductLocationName)),
        _row('Rejected Location', _safe(d.rejectedLocationName)),
      ]),
    );
  }

  Widget _buildOthersTab(ManufacturingOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline, [
            _row('Created By', _safe(d.createdByName)),
            if (d.createdDate?.isNotEmpty == true) _row('Created On', _fmtDt(d.createdDate)),
          ]),
          if (d.updatedByName?.isNotEmpty == true || d.updatedDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Last Update', Icons.update_outlined, [
              if (d.updatedByName?.isNotEmpty == true) _row('Updated By', _safe(d.updatedByName)),
              if (d.updatedDate?.isNotEmpty == true) _row('Updated On', _fmtDt(d.updatedDate)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
            Expanded(
              child: Text(value, style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );

  Widget _infoCard(String title, IconData icon, List<Widget> rows) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorCard,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: colorPrimary, size: 18),
                  const SizedBox(width: 8),
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
                ],
              ),
              const Divider(height: 16),
              ...rows,
            ],
          ),
        ),
      );
}