import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/models/customer_category_models.dart';

class CustomerCategoryDetailTabs extends StatefulWidget {
  final CustomerCategoryDetailModel categoryDetail;
  const CustomerCategoryDetailTabs({super.key, required this.categoryDetail});

  @override
  State<CustomerCategoryDetailTabs> createState() =>
      _CustomerCategoryDetailTabsState();
}

class _CustomerCategoryDetailTabsState
    extends State<CustomerCategoryDetailTabs>
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
    final cat = widget.categoryDetail.category;

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
                    _buildCard("Category Info", Icons.category_outlined, {
                      "Name": _safe(cat.customerCategoryName),
                      "Code": _safe(cat.customerCategoryCode),
                    }),
                    if (cat.description != null &&
                        cat.description!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildCard("Description", Icons.notes_outlined, {
                        "Notes": cat.description!,
                      }),
                    ],
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCard("Creation", Icons.add_circle_outline, {
                      "Created By":
                          _safe(widget.categoryDetail.createdByName),
                      "Created On": _formatDate(cat.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _buildCard("Last Update", Icons.update_outlined, {
                      "Updated By":
                          _safe(widget.categoryDetail.updatedByName),
                      "Updated On": _formatDate(cat.updatedDate),
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

  Widget _buildCard(String title, IconData icon, Map<String, String> details) {
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
            ...details.entries.map((e) => Padding(
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