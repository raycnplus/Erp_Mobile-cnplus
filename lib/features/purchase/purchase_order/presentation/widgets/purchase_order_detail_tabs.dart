import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/models/purchase_order_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class PurchaseOrderDetailTabs extends StatefulWidget {
  final PurchaseOrderDetailModel detail;
  final VoidCallback? onCreateBillFromTerm;

  const PurchaseOrderDetailTabs({super.key, required this.detail, this.onCreateBillFromTerm});

  @override
  State<PurchaseOrderDetailTabs> createState() => _State();
}

class _State extends State<PurchaseOrderDetailTabs> with SingleTickerProviderStateMixin {
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
    'Cancelled':        Color(0xFFC62828),
    'Closed':           Color(0xFF546E7A),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps  = (status == 'Cancelled' || status == 'Closed')
        ? ['Draft', 'Confirmed', status]
        : ['Draft', 'Waiting Approval', 'Confirmed', 'Done'];
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
          final idx       = i ~/ 2;
          final isDone    = idx < activeIdx;
          final isCurrent = idx == activeIdx;
          final label     = steps[idx];

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
          tabs: [
            const Tab(text: 'Products'),
            const Tab(text: 'Info'),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Payment'),
                    if (d.isMultiPayment && d.paymentSchedules.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      _countBadge(d.paymentSchedules.length),
                    ],
                  ],
                ),
              ),
            ),
            const Tab(text: 'Logs'),
            const Tab(text: 'Others'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildProductsTab(d),
              _buildInfoTab(d),
              _buildPaymentTab(d),
              AuditTrailList(
                items: d.auditTrails.map((a) => AuditTrailItem(
                      actionByName: a.actionByName,
                      actionById:   a.actionById,
                      date:         a.date,
                      description:  a.description,
                    )).toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _countBadge(int count) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$count',
          style: GoogleFonts.poppins(fontSize: 9, color: colorWhite, fontWeight: FontWeight.w600),
        ),
      );

  Widget _buildProductsTab(PurchaseOrderDetailModel d) {
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
                                      if (item.lastPurchasedPrice > 0)
                                        Text(
                                          'Last Price: Rp ${_fmtNum(item.lastPurchasedPrice)}',
                                          style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
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
                                      'Rp ${_fmtNum(item.subtotal)}',
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

  Widget _buildInfoTab(PurchaseOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Purchase Order Info', Icons.receipt_long_outlined, [
            _row('Reference',              _safe(d.reference)),
            _row('RFQ Reference',          _safe(d.rfqReference)),
            _row('Status',                 d.status),
            _row('Vendor',                 _safe(d.vendorName)),
            _row('Destination Warehouse',  _safe(d.destinationWarehouseName)),
            _row('Destination Location',   _safe(d.destinationLocationName)),
            _row('Purchase Team',          _safe(d.purchaseTeamName)),
            _row('Price List',             _safe(d.priceListName)),
            _row('Purchase Person',        _safe(d.purchasePersonName)),
            _row('Requested Date',         _fmt(d.requestedDate)),
            _row('Expected Arrival',       _fmt(d.expectedArrival)),
            _row('Expiration Date',        _fmt(d.expirationDate)),
            _row('Payment Type',           d.paymentType),
            if (d.paymentTermName?.isNotEmpty == true) _row('Payment Term', d.paymentTermName!),
            if (d.priceListName?.isNotEmpty == true)   _row('Price List',   d.priceListName!),
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
          if (d.hasRfq || d.receiptNotes.isNotEmpty || d.bills.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildLinkedDocumentsCard(d),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkedDocumentsCard(PurchaseOrderDetailModel d) {
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
            if (d.hasRfq) _row('RFQ', 'Linked'),
            if (d.receiptNotes.isNotEmpty) ...[
              if (d.hasRfq) const SizedBox(height: 6),
              _linkedSectionLabel('Receipt Notes', d.receiptNotes.length),
              const SizedBox(height: 8),
              ...d.receiptNotes.map(_receiptNoteRow),
            ],
            if (d.bills.isNotEmpty) ...[
              if (d.hasRfq || d.receiptNotes.isNotEmpty) const SizedBox(height: 6),
              _linkedSectionLabel('Bills', d.bills.length),
              const SizedBox(height: 8),
              ...d.bills.map(_billRow),
            ],
          ],
        ),
      ),
    );
  }

  Widget _linkedSectionLabel(String label, int count) => Row(
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: colorPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(fontSize: 9, color: colorWhite, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );

  Widget _receiptNoteRow(PurchaseOrderReceiptNote rn) {
    Color statusColor;
    switch (rn.status) {
      case 'Done':      statusColor = Colors.green; break;
      case 'Cancelled': statusColor = colorError;   break;
      case 'Confirmed': statusColor = Colors.blue;  break;
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
          const Icon(Icons.inventory_outlined, color: colorPrimary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rn.reference ?? '-',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: colorTextPrimary),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
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

  Widget _billRow(PurchaseOrderBill bill) {
    Color statusColor;
    switch (bill.status) {
      case 'Paid':      statusColor = Colors.green;  break;
      case 'Posted':    statusColor = Colors.blue;   break;
      case 'Confirmed': statusColor = Colors.indigo; break;
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
          const Icon(Icons.receipt_outlined, color: colorPrimary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.reference ?? '-',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: colorTextPrimary),
                ),
                Text(
                  'Rp ${_fmtNum(bill.grandTotal)}',
                  style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              bill.status,
              style: GoogleFonts.poppins(fontSize: 10, color: statusColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTab(PurchaseOrderDetailModel d) {
    if (!d.isMultiPayment) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorPrimary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: colorPrimary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment Type: Full — single bill for total amount',
                      style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (d.paymentSchedules.isEmpty) {
      return Center(
        child: Text('No payment schedules', style: GoogleFonts.poppins(color: colorGrey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: d.paymentSchedules.length,
      itemBuilder: (_, i) => _scheduleCard(d.paymentSchedules[i], d),
    );
  }

  Widget _scheduleCard(PurchaseOrderPaymentSchedule s, PurchaseOrderDetailModel d) {
    Color statusColor;
    switch (s.status) {
      case 'Paid':            statusColor = Colors.green;  break;
      case 'Waiting Payment': statusColor = Colors.blue;   break;
      case 'Cancelled':       statusColor = colorError;    break;
      default:                statusColor = colorGrey;
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    s.termName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: colorTextPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    s.status,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date: ${_fmt(s.dueDate)}',
                        style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                      ),
                      Text(
                        '${s.percentage.toStringAsFixed(1)}% of total',
                        style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Rp ${_fmtNum(s.amount)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: colorPrimary,
                  ),
                ),
              ],
            ),
            if (d.isDone && s.canCreateBill && widget.onCreateBillFromTerm != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onCreateBillFromTerm,
                  icon: const Icon(Icons.receipt_outlined, size: 16),
                  label: Text(
                    'Create Bill',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    foregroundColor: colorPrimary,
                    side: const BorderSide(color: colorPrimary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOthersTab(PurchaseOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline_outlined, [
            _row('Created By', _safe(d.createdByName)),
            if (d.createdDate?.isNotEmpty == true)
              _row('Created On', _fmtDt(d.createdDate)),
          ]),
          if (d.updatedByName?.isNotEmpty == true || d.updatedDate?.isNotEmpty == true) ... [
            const SizedBox(height: 12),
            _infoCard('Last Update', Icons.update_outlined, [
              if (d.updatedByName?.isNotEmpty == true)
                _row('Updated By', _safe(d.updatedByName)),
              if (d.updatedDate?.isNotEmpty == true)
                _row('Updated On', _fmtDt(d.updatedDate)),
            ]),
          ],
          if (d.cancelledByName?.isNotEmpty == true || d.cancelReason?.isNotEmpty == true) ... [
            const SizedBox(height: 12),
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true)
                _row('Cancelled By', _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true)
                _row('Cancelled On', _fmtDt(d.cancelledDate)),
              if (d.cancelReason?.isNotEmpty == true)
                _row('Cancel Reason', _safe(d.cancelReason)),  
            ])
          ]
        ],
      )
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