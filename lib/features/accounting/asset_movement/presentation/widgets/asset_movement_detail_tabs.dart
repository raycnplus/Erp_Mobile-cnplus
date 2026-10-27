import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/models/asset_movement_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class AssetMovementDetailTabs extends StatefulWidget {
  final AssetMovementDetailModel detail;

  const AssetMovementDetailTabs({super.key, required this.detail});

  @override
  State<AssetMovementDetailTabs> createState() => _State();
}

class _State extends State<AssetMovementDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _fmtDt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  Widget _buildBanner() {
    final d = widget.detail;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz_rounded, color: colorPrimary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${_safe(d.assetCode)} - ${_safe(d.assetName)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
            ),
          ),
          Text(_safe(d.reference), style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        _buildBanner(),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [Tab(text: 'Info'), Tab(text: 'Logs'), Tab(text: 'Others')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildInfoTab(d),
              AuditTrailList(
                items: d.auditTrails.map((a) => AuditTrailItem(
                      actionByName: a.actionByName, actionById: a.actionById,
                      date: a.date, description: a.description,
                    )).toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(AssetMovementDetailModel d) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _infoCard('Movement Info', Icons.swap_horiz_rounded, [
          _row('Reference', _safe(d.reference)),
          _row('Movement Date', _fmt(d.movementDate)),
          _row('Asset', '${_safe(d.assetCode)} - ${_safe(d.assetName)}'),
        ]),
        const SizedBox(height: 12),
        _infoCard('From', Icons.logout_outlined, [
          _row('PIC', _safe(d.fromPicName)),
          _row('Location', _safe(d.fromLocation)),
        ]),
        const SizedBox(height: 12),
        _infoCard('To', Icons.login_outlined, [
          _row('PIC', _safe(d.toPicName)),
          _row('Location', _safe(d.toLocation)),
        ]),
        if (d.reason?.isNotEmpty == true) ...[
          const SizedBox(height: 12),
          _infoCard('Reason', Icons.notes_outlined, [_row('Reason', d.reason!)]),
        ],
      ],
    ),
  );

  Widget _buildOthersTab(AssetMovementDetailModel d) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: _infoCard('Creation', Icons.add_circle_outline_outlined, [
      _row('Created By', _safe(d.createdByName)),
      if (d.createdDate?.isNotEmpty == true) _row('Created On', _fmtDt(d.createdDate)),
    ]),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 140, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
        Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w500))),
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
          Row(children: [
            Icon(icon, color: colorPrimary, size: 18),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
          ]),
          const Divider(height: 16),
          ...rows,
        ],
      ),
    ),
  );
}