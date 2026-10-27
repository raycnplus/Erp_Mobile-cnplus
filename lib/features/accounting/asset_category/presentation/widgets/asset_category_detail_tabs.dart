import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/models/asset_category_models.dart';

class AssetCategoryDetailTabs extends StatefulWidget {
  final AssetCategoryDetailModel detail;
  final List<AssetCoaOption> coaList;

  const AssetCategoryDetailTabs({super.key, required this.detail, this.coaList = const []});

  @override
  State<AssetCategoryDetailTabs> createState() => _State();
}

class _State extends State<AssetCategoryDetailTabs> with SingleTickerProviderStateMixin {
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

  String _fmtDt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  String _coa(int? id) {
    if (id == null) return '-';
    for (final c in widget.coaList) {
      if (c.idCoa == id) return c.display;
    }
    return 'COA #$id';
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [Tab(text: 'Info'), Tab(text: 'COA Mapping'), Tab(text: 'Others')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [_buildInfoTab(d), _buildCoaTab(d), _buildOthersTab(d)],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(AssetCategoryDetailModel d) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: _infoCard('Category Info', Icons.category_outlined, [
      _row('Category Name', _safe(d.categoryName)),
      _row('Category Code', _safe(d.categoryCode)),
      _row('Useful Life', '${d.defaultUsefulLifeMonths} months'),
      _row('Depreciation Method', d.methodLabel),
    ]),
  );

  Widget _buildCoaTab(AssetCategoryDetailModel d) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: _infoCard('COA Mapping', Icons.account_tree_outlined, [
      _row('Asset', _coa(d.coaAsset)),
      _row('Accumulated Depreciation', _coa(d.coaAccumulatedDepreciation)),
      _row('Depreciation Expense', _coa(d.coaDepreciationExpense)),
      _row('Gain on Disposal', _coa(d.coaDisposalGain)),
      _row('Loss on Disposal', _coa(d.coaDisposalLoss)),
    ]),
  );

  Widget _buildOthersTab(AssetCategoryDetailModel d) => SingleChildScrollView(
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