import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/models/price_list_models.dart';

class PriceListDetailTabs extends StatefulWidget {
  final PriceListDetailModel detail;

  const PriceListDetailTabs({super.key, required this.detail});

  @override
  State<PriceListDetailTabs> createState() => _PriceListDetailTabsState();
}

class _PriceListDetailTabsState extends State<PriceListDetailTabs> with SingleTickerProviderStateMixin {
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
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  String _currency(double v) => 'Rp ${v.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+\b)'),
    (m) => '${m[1]}.',
  )}';

  @override
  Widget build(BuildContext context) {
    final d = widget.detail.priceList;
    final isActive = d.isActive == 'Y';
    return Column(children: [
      TabBar(
        controller: _tab,
        labelColor: colorPrimary,
        unselectedLabelColor: colorTextSubtle,
        indicatorColor: colorPrimary,
        isScrollable: true,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        tabs: [
          const Tab(text: "Info"),
          Tab(text: "Products (${widget.detail.itemCount})"),
          const Tab(text: "Audit"),
        ],
      ),
      Expanded(
        child: TabBarView(controller: _tab, children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _card("Price List Info", Icons.price_check_outlined, {
              "Name": _safe(d.priceListName),
              "Status": isActive ? 'Active' : 'Inactive',
              "Total Products": '${widget.detail.itemCount} products',
              "Description": d.description?.isNotEmpty == true ? d.description! : '-',
            }),
          ),
          widget.detail.items.isEmpty
              ? Center(child: Text("No products", style: GoogleFonts.poppins(color: colorGrey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.detail.items.length,
                  itemBuilder: (_, i) {
                    final item = widget.detail.items[i];
                    final discount = item.originalPrice > 0
                        ? ((1 - item.customPrice / item.originalPrice) * 100)
                        : 0.0;
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: colorGreyLight),
                      ),
                      color: colorCard,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                item.productName,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: colorTextPrimary),
                              ),
                              Text(item.productCode, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
                              if (item.originalPrice > 0)
                                Text(
                                  'Original: ${_currency(item.originalPrice)}',
                                  style: GoogleFonts.poppins(fontSize: 11, color: colorGrey, decoration: TextDecoration.lineThrough),
                                ),
                            ]),
                          ),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text(
                              _currency(item.customPrice),
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorPrimary),
                            ),
                            if (discount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorSuccess.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '-${discount.toStringAsFixed(0)}%',
                                  style: GoogleFonts.poppins(fontSize: 11, color: colorSuccess, fontWeight: FontWeight.w600),
                                ),
                              ),
                          ]),
                        ]),
                      ),
                    );
                  },
                ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _card("Creation", Icons.add_circle_outline, {
                "Created By": _safe(widget.detail.createdByName),
                "Created On": _fmt(d.createdDate),
              }),
              const SizedBox(height: 16),
              _card("Last Update", Icons.update_outlined, {
                "Updated By": _safe(widget.detail.updatedByName),
                "Updated On": _fmt(d.updatedDate),
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