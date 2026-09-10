import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/models/unbuild_order_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class UnbuildOrderDetailTabs extends StatefulWidget {
  final UnbuildOrderDetailModel detail;

  const UnbuildOrderDetailTabs({super.key, required this.detail});

  @override
  State<UnbuildOrderDetailTabs> createState() => _State();
}

class _State extends State<UnbuildOrderDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
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
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [
            Tab(text: 'Components'),
            Tab(text: 'Info'),
            Tab(text: 'Logs'),
            Tab(text: 'Others'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildComponentsTab(d),
              _buildInfoTab(d),
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

  Widget _buildComponentsTab(UnbuildOrderDetailModel d) {
    if (d.items.isEmpty) {
      return Center(child: Text('No items', style: GoogleFonts.poppins(color: colorGrey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: d.items.length,
      itemBuilder: (_, i) {
        final item = d.items[i];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 10),
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
                        item.productName ?? '-',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                      ),
                    ),
                    Text(
                      '${_fmtNum(item.unbuildQty)} ${item.uomName ?? ''}',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                    ),
                  ],
                ),
                if (item.bomName?.isNotEmpty == true)
                  Text(
                    'BoM: ${item.bomName}',
                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                  ),
                if (item.components.isNotEmpty) ...[
                  const Divider(height: 16, color: colorGreyLight),
                  Text(
                    'Components to Recover',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: colorTextPrimary),
                  ),
                  const SizedBox(height: 6),
                  ...item.components.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                c.productName ?? '-',
                                style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary),
                              ),
                            ),
                            Text(
                              '${_fmtNum(c.componentQty)} ${c.uomName ?? ''}',
                              style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTab(UnbuildOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Unbuild Order Info', Icons.settings_backup_restore_outlined, [
            _row('Reference', _safe(d.reference)),
            _row('Status', d.status),
            _row('Manufacturing Order', _safe(d.moReference)),
            _row('Unbuild Date', _fmt(d.unbuildDate)),
            if (d.notes?.isNotEmpty == true) _row('Notes', d.notes!),
          ]),
          const SizedBox(height: 12),
          _infoCard('Source', Icons.warehouse_outlined, [
            _row('Source Warehouse', _safe(d.sourceWarehouseName)),
            _row('Source Location', _safe(d.sourceLocationName)),
          ]),
          const SizedBox(height: 12),
          _infoCard('Destination', Icons.inventory_2_outlined, [
            _row('Destination Warehouse', _safe(d.destinationWarehouseName)),
            _row('Destination Location', _safe(d.destinationLocationName)),
          ]),
        ],
      ),
    );
  }

  Widget _buildOthersTab(UnbuildOrderDetailModel d) {
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
        SizedBox(width: 150, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
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