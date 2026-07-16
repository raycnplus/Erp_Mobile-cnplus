import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/models/warehouse_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class WarehouseDetailTabs extends StatefulWidget {
  final WarehouseDetailModel warehouseDetail;

  const WarehouseDetailTabs({super.key, required this.warehouseDetail});

  @override
  State<WarehouseDetailTabs> createState() => _WarehouseDetailTabsState();
}

class _WarehouseDetailTabsState extends State<WarehouseDetailTabs>
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
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v, [String suffix = '']) {
    if (v == null || v.toString().isEmpty || v.toString() == '0') return '-';
    return '${v.toString()}$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final wh = widget.warehouseDetail.warehouse;

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
                    _buildCard("Warehouse Info", Icons.warehouse_outlined, {
                      "Name": _safe(wh.warehouseName),
                      "Code": _safe(wh.warehouseCode),
                      "Branch": _safe(wh.branch),
                      "Address": _safe(wh.address),
                    }),
                    const SizedBox(height: 16),
                    _buildCard("Dimensions", Icons.straighten_outlined, {
                      "Length": _safe(wh.length, " m"),
                      "Width": _safe(wh.width, " m"),
                      "Height": _safe(wh.height, " m"),
                      "Volume": _safe(wh.volume, " m³"),
                    }),
                    if (wh.description != null &&
                        wh.description!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildCard("Description", Icons.notes_outlined, {
                        "Notes": wh.description!,
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
                          _safe(widget.warehouseDetail.createdByName),
                      "Created On": _formatDate(wh.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _buildCard("Last Update", Icons.update_outlined, {
                      "Updated By":
                          _safe(widget.warehouseDetail.updatedByName),
                      "Updated On": _formatDate(wh.updatedDate),
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