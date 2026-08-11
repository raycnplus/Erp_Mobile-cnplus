import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/models/sales_team_models.dart';

class SalesTeamDetailTabs extends StatefulWidget {
  final SalesTeamDetailModel teamDetail;
  const SalesTeamDetailTabs({super.key, required this.teamDetail});

  @override
  State<SalesTeamDetailTabs> createState() => _SalesTeamDetailTabsState();
}

class _SalesTeamDetailTabsState extends State<SalesTeamDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) { return d; }
  }

  String _safe(dynamic v) {
    if (v == null || v.toString().isEmpty) return '-';
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.teamDetail.team;
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: "General"), Tab(text: "Audit Trail")],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card("Team Info", Icons.groups_outlined, {
                      "Team Name": _safe(t.teamName),
                      "Team Leader": _safe(widget.teamDetail.teamLeaderName),
                      "Description": t.description?.isNotEmpty == true
                          ? t.description!
                          : '-',
                    }),
                    const SizedBox(height: 16),
                    _buildMembersCard(widget.teamDetail.members),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card("Creation", Icons.add_circle_outline, {
                      "Created By": _safe(widget.teamDetail.createdByName),
                      "Created On": _formatDate(t.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card("Last Update", Icons.update_outlined, {
                      "Updated By": _safe(widget.teamDetail.updatedByName),
                      "Updated On": _formatDate(t.updatedDate),
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

  Widget _buildMembersCard(List<SalesTeamMemberData> members) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.group_outlined, color: colorPrimary, size: 20),
              const SizedBox(width: 8),
              Text('Team Members (${members.length})',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorTextPrimary)),
            ]),
            const Divider(height: 24),
            if (members.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('No members yet',
                      style: GoogleFonts.poppins(color: colorGrey, fontSize: 14)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 44),
                itemBuilder: (_, i) {
                  final m = members[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: colorPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${i + 1}',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: colorPrimary,
                                  fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.namaKaryawan ?? '-',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: colorTextPrimary)),
                            if (m.email?.isNotEmpty == true)
                              Text(m.email!,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: colorTextSubtle)),
                          ],
                        ),
                      ),
                    ]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, IconData icon, Map<String, String> details) {
    final filtered = {
      for (final e in details.entries) if (e.value != '-') e.key: e.value
    };
    if (filtered.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: colorPrimary, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorTextPrimary)),
            ]),
            const Divider(height: 24),
            ...filtered.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.key,
                          style: GoogleFonts.poppins(
                              color: colorTextSubtle, fontSize: 14)),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(e.value,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: colorTextPrimary,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}