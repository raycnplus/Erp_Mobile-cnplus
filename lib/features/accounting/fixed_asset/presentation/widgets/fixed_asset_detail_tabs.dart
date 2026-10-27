import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/models/fixed_asset_models.dart';

class FixedAssetDetailTabs extends StatefulWidget {
  final FixedAssetDetailModel detail;

  const FixedAssetDetailTabs({super.key, required this.detail});

  @override
  State<FixedAssetDetailTabs> createState() => _State();
}

class _State extends State<FixedAssetDetailTabs> with SingleTickerProviderStateMixin {
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

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
  String _rp(double v) => 'Rp ${_fmtNum(v)}';
  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  Widget _buildStatusBanner() {
    final d = widget.detail;
    final color = Color(d.statusColor);
    final icon = d.isActive
        ? Icons.check_circle
        : d.isInactive
            ? Icons.pause_circle_outline
            : Icons.block;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(d.statusLabel, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
          const Spacer(),
          Text(d.assetCode, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        _buildStatusBanner(),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [Tab(text: 'Info'), Tab(text: 'Depreciation'), Tab(text: 'Others')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [_buildInfoTab(d), _buildDepreciationTab(d), _buildOthersTab(d)],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(FixedAssetDetailModel d) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard('Asset Info', Icons.inventory_2_outlined, [
              _row('Asset Code', _safe(d.assetCode)),
              _row('Asset Name', _safe(d.assetName)),
              _row('Category', _safe(d.categoryName)),
              _row('Serial Number', _safe(d.serialNumber)),
              _row('Status', d.statusLabel),
            ]),
            const SizedBox(height: 12),
            _infoCard('Assignment', Icons.person_pin_circle_outlined, [
              _row('PIC', _safe(d.picName)),
              _row('Department', _safe(d.departmentName)),
              _row('Location', _safe(d.location)),
            ]),
            if (d.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              _infoCard('Notes', Icons.notes_outlined, [_row('Notes', d.notes!)]),
            ],
          ],
        ),
      );

  Widget _buildDepreciationTab(FixedAssetDetailModel d) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _infoCard('Acquisition', Icons.shopping_bag_outlined, [
          _row('Acquisition Date', _fmt(d.acquisitionDate)),
          _row('Acquisition Cost', _rp(d.acquisitionCost)),
        ]),
        const SizedBox(height: 12),
        _infoCard('Depreciation Setup', Icons.trending_down_outlined, [
          _row('Method', d.methodLabel),
          _row('Useful Life', '${d.usefulLifeMonths} months'),
          _row('Salvage Value', _rp(d.salvageValue)),
        ]),
        const SizedBox(height: 12),
        _infoCard('Current Value', Icons.account_balance_outlined, [
          _row('Accumulated Depreciation', _rp(d.accumulatedDepreciation)),
          _row('Book Value', _rp(d.bookValue)),
        ]),
      ],
    ),
  );

  Widget _buildOthersTab(FixedAssetDetailModel d) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _infoCard('Creation', Icons.add_circle_outline_outlined, [
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