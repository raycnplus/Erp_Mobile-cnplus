import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/models/overtime_type_models.dart';
import 'package:intl/intl.dart';

class OvertimeTypeDetailTabs extends StatefulWidget {
  final OvertimeTypeDetailModel detail;

  const OvertimeTypeDetailTabs({super.key, required this.detail});

  @override
  State<OvertimeTypeDetailTabs> createState() => _OvertimeTypeDetailTabsState();
}

class _OvertimeTypeDetailTabsState extends State<OvertimeTypeDetailTabs>
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

  String _fmtDt(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? '-' : v.toString();

  Color get _catColor {
    switch (widget.detail.data.category) {
      case 'WEEKDAY': return Colors.blue.shade700;
      case 'WEEKEND': return Colors.orange.shade700;
      case 'HOLIDAY': return Colors.red.shade700;
      default: return colorPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
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
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: colorCard,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.more_time,
                                color: colorPrimary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Overtime Info',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: colorTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _row('Name', _safe(d.data.name)),
                        _row('Category', d.data.category,
                            badge: true, badgeColor: _catColor),
                        _row('Rate', '${d.data.rate}x per hour'),
                        if (d.data.description?.isNotEmpty == true)
                          _row('Description', d.data.description!),
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Creation', Icons.add_circle_outline, {
                      'Created By': _safe(d.createdByName),
                      'Created Date': _fmtDt(d.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card('Last Update', Icons.update_outlined, {
                      'Updated By': _safe(d.updatedByName),
                      'Updated On': _fmtDt(d.updatedDate),
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

  Widget _row(String label, String value,
      {bool badge = false, Color? badgeColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 14)),
          const SizedBox(width: 16),
          badge
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? colorPrimary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: badgeColor ?? colorPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Flexible(
                  child: Text(
                    value,
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
            ...visible.entries.map((e) => _row(e.key, e.value)),
          ],
        ),
      ),
    );
  }
}