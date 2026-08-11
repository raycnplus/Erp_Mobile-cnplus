import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/models/direct_purchase_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class DirectPurchaseDetailTabs extends StatefulWidget {
  final DirectPurchaseDetailModel detail;

  const DirectPurchaseDetailTabs({super.key, required this.detail});

  @override
  State<DirectPurchaseDetailTabs> createState() => _State();
}

class _State extends State<DirectPurchaseDetailTabs> with SingleTickerProviderStateMixin {
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
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Draft':            Color(0xFF757575),
    'Waiting Approval': Color(0xFFFFA500),
    'Confirmed':        Color(0xFF1565C0),
    'Done':             Color(0xFF2E7D32),
    'Closed':           Color(0xFF00695C),
    'Cancelled':        Color(0xFFC62828),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps = status == 'Cancelled'
        ? ['Draft', 'Confirmed', status]
        : ['Draft', 'Waiting Approval', 'Confirmed', 'Done', 'Closed'];
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
                  border: Border.all(
                    color: (isDone || isCurrent) ? dot : colorGreyLight,
                    width: 2,
                  ),
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
                width: 52,
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
                items: d.auditTrails.map((a) => AuditTrailItem(
                      actionByName: a.actionByName,
                      actionById: a.actionById,
                      date: a.date,
                      description: a.description,
                    )).toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsTab(DirectPurchaseDetailModel d) {
    return Column(
      children: [
        Expanded(
          child: d.items.isEmpty
              ? Center(child: Text('No products', style: GoogleFonts.poppins(color: colorGrey)))
              : ListView.builder(
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.productName ?? '-',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: colorTextPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${_fmtNum(item.demandQty)} ${item.uomName ?? ''}',
                                  style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                                ),
                              ],
                            ),
                            if (item.description?.isNotEmpty == true)
                              Text(
                                item.description!,
                                style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (item.lastPurchasedPrice > 0 || item.vendorLastPrice > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Wrap(
                                  spacing: 12,
                                  children: [
                                    if (item.lastPurchasedPrice > 0)
                                      Text(
                                        'Last Purchased: Rp ${_fmtNum(item.lastPurchasedPrice)}',
                                        style: GoogleFonts.poppins(fontSize: 10, color: colorGrey),
                                      ),
                                    if (item.vendorLastPrice > 0)
                                      Text(
                                        'Vendor Last Price: Rp ${_fmtNum(item.vendorLastPrice)}',
                                        style: GoogleFonts.poppins(fontSize: 10, color: colorGrey),
                                      ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Unit Price: Rp ${_fmtNum(item.unitPrice)}',
                                        style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                                      ),
                                      if (item.discountAmount > 0)
                                        Text(
                                          'Discount: Rp ${_fmtNum(item.discountAmount)}',
                                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.orange.shade700),
                                        ),
                                      if (item.taxAmount > 0)
                                        Text(
                                          'PPN: Rp ${_fmtNum(item.taxAmount)}',
                                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.indigo),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                                    ),
                                    Text(
                                      'Rp ${_fmtNum(item.amount)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: colorPrimary,
                                      ),
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
                ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: colorCard,
          child: Column(
            children: [
              if (d.totalDiscount > 0) _footerRow('Total Discount', 'Rp ${_fmtNum(d.totalDiscount)}'),
              _footerRow('Subtotal', 'Rp ${_fmtNum(d.subtotal)}'),
              if (d.totalTaxes > 0)
                _footerRow('PPN (${d.defaultTaxRate.toStringAsFixed(0)}%)', 'Rp ${_fmtNum(d.totalTaxes)}'),
              const Divider(height: 12, thickness: 1, color: colorGreyLight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colorTextPrimary,
                    ),
                  ),
                  Text(
                    'Rp ${_fmtNum(d.totalAmount)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(DirectPurchaseDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Direct Purchase Info', Icons.shopping_bag_outlined, [
            _row('Reference', _safe(d.reference)),
            if (d.prReference?.isNotEmpty == true) _row('PR Reference', d.prReference!),
            _row('Status', d.status),
            _row('Vendor', _safe(d.vendorName)),
            _row('Destination Warehouse', _safe(d.destinationWarehouseName)),
            _row('Destination Location', _safe(d.destinationLocationName)),
            _row('Price List', _safe(d.priceListName)),
            _row('Requested Date', _fmt(d.requestedDate)),
            _row('Expected Arrival', _fmt(d.expectedArrival)),
            if (d.discountType?.isNotEmpty == true) _row('Discount Type', d.discountType!),
            _row('PPN', d.isTaxEnabled ? 'Yes (${d.defaultTaxRate.toStringAsFixed(0)}%)' : 'No'),
            if (d.note?.isNotEmpty == true) _row('Note', d.note!),
          ]),
          const SizedBox(height: 12),
          _infoCard('Totals', Icons.calculate_outlined, [
            _row('Subtotal', 'Rp ${_fmtNum(d.subtotal)}'),
            if (d.totalDiscount > 0) _row('Total Discount', 'Rp ${_fmtNum(d.totalDiscount)}'),
            if (d.totalTaxes > 0) _row('PPN', 'Rp ${_fmtNum(d.totalTaxes)}'),
            _rowBold('Total Amount', 'Rp ${_fmtNum(d.totalAmount)}'),
          ]),
          if (d.hasPr || d.receiptNotes.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildLinkedDocumentsCard(d),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkedDocumentsCard(DirectPurchaseDetailModel d) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.link_outlined, color: colorPrimary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Linked Documents',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colorTextPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            if (d.hasPr) _row('Purchase Request', 'Linked'),
            if (d.receiptNotes.isNotEmpty) ...[
              if (d.hasPr) const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    'Receipt Notes',
                    style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${d.receiptNotes.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: colorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...d.receiptNotes.map(_receiptNoteCard),
            ],
          ],
        ),
      ),
    );
  }

  Widget _receiptNoteCard(DirectPurchaseReceiptNote rn) {
    Color statusColor;
    switch (rn.status) {
      case 'Done':      statusColor = Colors.green; break;
      case 'Confirmed':  statusColor = Colors.blue; break;
      case 'Cancelled': statusColor = colorError; break;
      default:          statusColor = colorGrey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorGreyLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _safe(rn.reference),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12, color: colorTextPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  'Scheduled: ${_fmt(rn.scheduledDate)}',
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              rn.status,
              style: GoogleFonts.poppins(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOthersTab(DirectPurchaseDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline, [
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
          if (d.cancelledByName?.isNotEmpty == true || d.cancelledDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true) _row('Cancelled By', _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true) _row('Cancelled On', _fmtDt(d.cancelledDate)),
              if (d.cancelReason?.isNotEmpty == true) _row('Cancel Reason', _safe(d.cancelReason)),
            ]),
          ],
          if (d.closedByName?.isNotEmpty == true || d.closedDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Closing', Icons.lock_outline, [
              if (d.closedByName?.isNotEmpty == true) _row('Closed By', _safe(d.closedByName)),
              if (d.closedDate?.isNotEmpty == true) _row('Closed On', _fmtDt(d.closedDate)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _footerRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
            Text(value, style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
          ],
        ),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: colorTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _rowBold(String label, String value) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: colorTextPrimary,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colorPrimary,
                ),
              ),
            ),
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
              Row(
                children: [
                  Icon(icon, color: colorPrimary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colorTextPrimary,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              ...rows,
            ],
          ),
        ),
      );
}