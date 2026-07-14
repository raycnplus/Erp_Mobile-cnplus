import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';

class CoaDetailTabs extends StatefulWidget {
  final CoaDetailModel detail;

  const CoaDetailTabs({super.key, required this.detail});

  @override
  State<CoaDetailTabs> createState() => _CoaDetailTabsState();
}

class _CoaDetailTabsState extends State<CoaDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? '-' : v.toString();

  @override
  Widget build(BuildContext context) {
    final d = widget.detail.coa;
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Info'), Tab(text: 'Audit Trail')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('COA Info', Icons.account_tree_outlined, {
                      'COA Number': _safe(d.coaNumber),
                      'COA Name': _safe(d.coaName),
                      'Type': _safe(d.type),
                      'Report Type': _safe(d.reportType),
                      'Is Header': d.isHeader == 'Y' ? 'Yes' : 'No',
                      'Tax Adjustment': _safe(d.taxAdjustment),
                      'Description': d.description?.isNotEmpty == true
                          ? d.description!
                          : '-',
                    }),
                    if (widget.detail.parentCoa != null) ...[
                      const SizedBox(height: 16),
                      _card(
                        'Parent Account',
                        Icons.subdirectory_arrow_right_outlined,
                        {
                          'Number': _safe(widget.detail.parentCoa!.coaNumber),
                          'Name': _safe(widget.detail.parentCoa!.coaName),
                        },
                      ),
                    ],
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Creation', Icons.add_circle_outline, {
                      'Created By': _safe(widget.detail.createdByName),
                      'Created On': _fmt(d.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card('Last Update', Icons.update_outlined, {
                      'Updated By': _safe(widget.detail.updatedByName),
                      'Updated On': _fmt(d.updatedDate),
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(String title, IconData icon, Map<String, String> fields) {
    final visible = {
      for (final e in fields.entries)
        if (e.value != '-') e.key: e.value,
    };
    if (visible.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorTextPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...visible.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.key,
                      style: GoogleFonts.poppins(
                        color: colorTextSubtle,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        e.value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: colorTextPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}