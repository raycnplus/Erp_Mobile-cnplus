import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';

class ProjectDetailTabs extends StatefulWidget {
  final ProjectDetailModel detail;

  const ProjectDetailTabs({super.key, required this.detail});

  @override
  State<ProjectDetailTabs> createState() => _ProjectDetailTabsState();
}

class _ProjectDetailTabsState extends State<ProjectDetailTabs> with SingleTickerProviderStateMixin {
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
      return DateFormat('d MMMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  @override
  Widget build(BuildContext context) {
    final p = widget.detail.project;
    return Column(children: [
      TabBar(
        controller: _tab,
        labelColor: colorPrimary,
        unselectedLabelColor: colorTextSubtle,
        indicatorColor: colorPrimary,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        tabs: const [Tab(text: "Info"), Tab(text: "Audit Trail")],
      ),
      Expanded(
        child: TabBarView(controller: _tab, children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _card("Project Info", Icons.folder_outlined, {
                "Project Code": _safe(p.projectCode),
                "Project Name": _safe(p.projectName),
                "Start Date": _fmt(p.startDate),
                "End Date": _fmt(p.endDate),
                "Description": p.description?.isNotEmpty == true ? p.description! : '-',
              }),
            ]),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _card("Creation", Icons.add_circle_outline, {
                "Created By": _safe(widget.detail.createdByName),
                "Created On": _fmtDt(p.createdDate),
              }),
              const SizedBox(height: 16),
              _card("Last Update", Icons.update_outlined, {
                "Updated By": _safe(widget.detail.updatedByName),
                "Updated On": _fmtDt(p.updatedDate),
              }),
            ]),
          ),
        ]),
      ),
    ]);
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: colorPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: colorTextPrimary),
            ),
          ]),
          const Divider(height: 24),
          ...visible.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.key, style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 14)),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    e.value,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: colorTextPrimary, fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
        ]),
      ),
    );
  }
}