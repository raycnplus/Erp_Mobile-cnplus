import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/models/stock_count_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class StockCountDetailTabs extends StatefulWidget {
  final StockCountDetailModel detail;
  final VoidCallback? onOpenLocationList;

  const StockCountDetailTabs({super.key, required this.detail, this.onOpenLocationList});

  @override
  State<StockCountDetailTabs> createState() => _State();
}

class _State extends State<StockCountDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null) return '-';
    try {
      return d.split('T').first;
    } catch (_) {
      return d;
    }
  }

  String _fmtNum(double v) => v.toStringAsFixed(2);
  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Draft':            Color(0xFF757575),
    'Confirmed':        Color(0xFF1565C0),
    'Waiting Approval': Color(0xFFFFA500),
    'Validated':        Color(0xFF2E7D32),
    'Cancelled':        Color(0xFFC62828),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps = (status == 'Cancelled')
        ? ['Draft', 'Confirmed', status]
        : ['Draft', 'Confirmed', 'Waiting Approval', 'Validated'];
    int activeIdx = steps.indexOf(status);
    if (activeIdx < 0) activeIdx = 0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final passed = (i ~/ 2) < activeIdx;
            return Expanded(child: Container(height: 2, color: passed ? colorPrimary : colorGreyLight));
          }
          final idx = i ~/ 2;
          final isDone = idx < activeIdx;
          final isCurrent = idx == activeIdx;
          final label = steps[idx];

          Color dot = colorGreyLight;
          if (isCurrent) dot = _statusColors[label] ?? colorPrimary;
          else if (isDone) dot = colorPrimary;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDone || isCurrent) ? dot : Colors.white,
                  border: Border.all(color: (isDone || isCurrent) ? dot : colorGreyLight, width: 2),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : isCurrent
                          ? const Icon(Icons.circle, size: 10, color: Colors.white)
                          : null,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 56,
                child: Text(
                  label == 'Waiting Approval' ? 'Waiting' : label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
                    color: isCurrent ? dot : isDone ? colorPrimary : colorGrey,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        _buildPipeline(),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Info'),
            Tab(text: 'Logs'),
            Tab(text: 'Others'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildProductsTab(d),
              _buildInfoTab(d),
              AuditTrailList(
                items: d.auditTrails
                    .map((a) => AuditTrailItem(
                          actionByName: a.actionByName,
                          actionById: a.actionById,
                          date: a.date,
                          description: a.description,
                        ))
                    .toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsTab(StockCountDetailModel d) {
    if (d.isConfirmed || d.isValidated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, size: 64, color: colorGrey),
            const SizedBox(height: 12),
            Text('${d.totalLocations} location(s) to count', style: GoogleFonts.poppins(fontSize: 15, color: colorTextSubtle)),
            const SizedBox(height: 4),
            Text(
              d.isAllItemsConfirmed ? 'All locations confirmed' : 'Some locations still pending',
              style: GoogleFonts.poppins(fontSize: 12, color: d.isAllItemsConfirmed ? colorSuccess : Colors.orange),
            ),
            const SizedBox(height: 16),
            if (!d.isLock)
              ElevatedButton.icon(
                onPressed: widget.onOpenLocationList,
                icon: const Icon(Icons.list_alt_outlined, size: 18),
                label: Text('View Location List', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: colorWhite,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
          ],
        ),
      );
    }

    if (d.items.isEmpty) {
      return Center(child: Text('No products yet — confirm the header to begin counting.', style: GoogleFonts.poppins(color: colorGrey), textAlign: TextAlign.center));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: d.items.length,
      itemBuilder: (_, i) {
        final item = d.items[i];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: colorCard,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName ?? '-', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('On Hand', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
                          Text('${_fmtNum(item.qtyBefore)} ${item.uomName ?? ''}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Counted', style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
                        Text(
                          item.qtyAfter != null ? _fmtNum(item.qtyAfter!) : '-',
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: colorPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTab(StockCountDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Stock Count Info', Icons.fact_check_outlined, [
            _row('Document Code', _safe(d.documentCode)),
            _row('Status', d.status),
            _row('Warehouse', _safe(d.warehouseName)),
            _row('Location', d.locationDisplay),
            _row('Select By', d.selectBy == 'all' ? 'All Products' : 'Specific Product'),
            if (d.note?.isNotEmpty == true) _row('Note', d.note!),
          ]),
        ],
      ),
    );
  }

  Widget _buildOthersTab(StockCountDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline_outlined, [
            _row('Created By', _safe(d.createdByName)),
            if (d.createdDate?.isNotEmpty == true) _row('Created On', _fmt(d.createdDate)),
          ]),
          if (d.updatedByName?.isNotEmpty == true || d.updatedDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Last Update', Icons.update_outlined, [
              if (d.updatedByName?.isNotEmpty == true) _row('Updated By', _safe(d.updatedByName)),
              if (d.updatedDate?.isNotEmpty == true) _row('Updated On', _fmt(d.updatedDate)),
            ]),
          ],
          if (d.cancelledByName?.isNotEmpty == true || d.cancelReason?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true) _row('Cancelled By', _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true) _row('Cancelled On', _fmt(d.cancelledDate)),
              if (d.cancelReason?.isNotEmpty == true) _row('Cancel Reason', _safe(d.cancelReason)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
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