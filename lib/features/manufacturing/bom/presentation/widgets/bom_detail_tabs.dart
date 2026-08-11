import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/models/bom_models.dart';

class BomDetailTabs extends StatefulWidget {
  final BomDetailModel detail;

  const BomDetailTabs({super.key, required this.detail});

  @override
  State<BomDetailTabs> createState() => _BomDetailTabsState();
}

class _BomDetailTabsState extends State<BomDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
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

  String _currency(double v) =>
      'Rp ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\b)'), (m) => '${m[1]}.')}';

  String _duration(int mins) {
    final h = mins ~/ 60;
    final m = mins % 60;
    return h == 0 ? '${m}m' : '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail.bom;
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          isScrollable: true,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: [
            const Tab(text: 'Info'),
            Tab(text: 'Components (${widget.detail.components.length})'),
            Tab(text: 'By-Products (${widget.detail.byproducts.length})'),
            Tab(text: 'Operations (${widget.detail.operations.length})'),
            Tab(text: 'Equipment (${widget.detail.equipments.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoCard('BOM Info', Icons.list_alt_outlined, {
                      'BOM Name': _safe(d.bomName),
                      'Product': _safe(d.productName),
                      'Product Qty': d.productQty.toStringAsFixed(2),
                      'Flexible Consumption': _safe(d.flexibleConsumption),
                      'Preparation Time': _duration(d.preparationTime),
                      'Total Duration': _duration(d.totalDurationTime),
                      'Total Estimated Cost':
                          _currency(d.totalEstimatedCost),
                      'Description': d.description?.isNotEmpty == true
                          ? d.description!
                          : '-',
                    }),
                    const SizedBox(height: 16),
                    _infoCard('Audit', Icons.update_outlined, {
                      'Created By': _safe(widget.detail.createdByName),
                      'Created On': _fmt(d.createdDate),
                      'Updated By': _safe(widget.detail.updatedByName),
                      'Updated On': _fmt(d.updatedDate),
                    }),
                  ],
                ),
              ),
              widget.detail.components.isEmpty
                  ? _emptyTab('No components')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.detail.components.length,
                      itemBuilder: (_, i) {
                        final c = widget.detail.components[i];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: colorCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: colorGreyLight),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: colorPrimary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: colorPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.componentProductName,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Qty: ${c.quantity.toStringAsFixed(2)}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: colorTextSubtle,
                                            ),
                                          ),
                                          if (c.uomName != null)
                                            Text(
                                              ' ${c.uomName}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: colorTextSubtle,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _currency(c.estimatedCost),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              widget.detail.byproducts.isEmpty
                  ? _emptyTab('No by-products')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.detail.byproducts.length,
                      itemBuilder: (_, i) {
                        final b = widget.detail.byproducts[i];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: colorCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: colorGreyLight),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.orange.withOpacity(0.1),
                              child: Text(
                                '${i + 1}',
                                style: GoogleFonts.poppins(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            title: Text(
                              b.productName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              'Qty: ${b.quantity.toStringAsFixed(2)} ${b.uomName ?? ''}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: colorTextSubtle,
                              ),
                            ),
                            trailing: b.notes?.isNotEmpty == true
                                ? Tooltip(
                                    message: b.notes!,
                                    child: const Icon(
                                      Icons.notes_outlined,
                                      color: colorGrey,
                                      size: 18,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
              widget.detail.operations.isEmpty
                  ? _emptyTab('No operations')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.detail.operations.length,
                      itemBuilder: (_, i) {
                        final o = widget.detail.operations[i];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: colorCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: colorGreyLight),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${o.sequence}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        o.operationName,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (o.workstationName?.isNotEmpty ==
                                          true)
                                        Text(
                                          o.workstationName!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: colorPrimary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _duration(o.duration),
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                    if (o.notes?.isNotEmpty == true)
                                      Text(
                                        'Has notes',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: colorGrey,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              widget.detail.equipments.isEmpty
                  ? _emptyTab('No equipment')
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.detail.equipments.length,
                      itemBuilder: (_, i) {
                        final e = widget.detail.equipments[i];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 8),
                          color: colorCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: colorGreyLight),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.purple.withOpacity(0.1),
                              child: Text(
                                '${i + 1}',
                                style: GoogleFonts.poppins(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            title: Text(
                              e.equipmentName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: e.notes?.isNotEmpty == true
                                ? Text(
                                    e.notes!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: colorTextSubtle,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyTab(String msg) {
    return Center(
      child: Text(
        msg,
        style: GoogleFonts.poppins(color: colorGrey, fontSize: 14),
      ),
    );
  }

  Widget _infoCard(
    String title,
    IconData icon,
    Map<String, String> fields,
  ) {
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