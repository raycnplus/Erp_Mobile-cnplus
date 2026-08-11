import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/models/service_sales_order_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class ServiceSalesOrderDetailTabs extends StatefulWidget {
  final ServiceSalesOrderDetailModel detail;
  final VoidCallback? onCreateInvoiceFromTerm;

  const ServiceSalesOrderDetailTabs({
    super.key,
    required this.detail,
    this.onCreateInvoiceFromTerm,
  });

  @override
  State<ServiceSalesOrderDetailTabs> createState() => _State();
}

class _State extends State<ServiceSalesOrderDetailTabs>
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
  String _safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Draft': Color(0xFF757575),
    'Waiting Approval': Color(0xFFFFA500),
    'Confirmed': Color(0xFF1565C0),
    'Done': Color(0xFF2E7D32),
    'Cancelled': Color(0xFFC62828),
    'Closed': Color(0xFF546E7A),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps = (status == 'Cancelled' || status == 'Closed')
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
            return Expanded(
              child: Container(
                height: 2,
                color: passed ? colorPrimary : colorGreyLight,
              ),
            );
          }
          final idx = i ~/ 2;
          final isDone = idx < activeIdx;
          final isCurrent = idx == activeIdx;
          final label = steps[idx];

          Color dot = colorGreyLight;
          if (isCurrent) {
            dot = _statusColors[label] ?? colorPrimary;
          } else if (isDone) {
            dot = colorPrimary;
          }

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
                          ? const Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.white,
                            )
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
                    fontWeight:
                        isCurrent ? FontWeight.w700 : FontWeight.normal,
                    color: isCurrent
                        ? dot
                        : isDone
                            ? colorPrimary
                            : colorGrey,
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
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: [
            const Tab(text: 'Services'),
            const Tab(text: 'Info'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Payment'),
                  if (d.isMultiPayment &&
                      d.paymentSchedules.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${d.paymentSchedules.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: colorWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
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
              _buildServicesTab(d),
              _buildInfoTab(d),
              _buildPaymentTab(d),
              AuditTrailList(
                items: d.auditTrails
                    .map(
                      (a) => AuditTrailItem(
                        actionByName: a.actionByName,
                        actionById: a.actionById,
                        date: a.date,
                        description: a.description,
                      ),
                    )
                    .toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesTab(ServiceSalesOrderDetailModel d) {
    return Column(
      children: [
        Expanded(
          child: d.items.isEmpty
              ? Center(
                  child: Text(
                    'No services',
                    style: GoogleFonts.poppins(color: colorGrey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: d.items.length,
                  itemBuilder: (_, i) {
                    final item = d.items[i];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                                    item.serviceName ?? '-',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: colorTextPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Qty: ${_fmtNum(item.qty)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: colorTextSubtle,
                                  ),
                                ),
                              ],
                            ),
                            if (item.description?.isNotEmpty == true)
                              Text(
                                item.description!,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: colorGrey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Unit Price: Rp ${_fmtNum(item.unitPrice)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: colorTextSubtle,
                                        ),
                                      ),
                                      if (item.discountAmount > 0)
                                        Text(
                                          'Discount: Rp ${_fmtNum(item.discountAmount)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                      if (item.taxAmount > 0)
                                        Text(
                                          'PPN: Rp ${_fmtNum(item.taxAmount)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Subtotal',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: colorTextSubtle,
                                      ),
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
              if (d.totalDiscount > 0)
                _footerRow(
                  'Total Discount',
                  'Rp ${_fmtNum(d.totalDiscount)}',
                ),
              _footerRow(
                'Untaxed Amount',
                'Rp ${_fmtNum(d.untaxedAmount)}',
              ),
              if (d.totalTaxes > 0)
                _footerRow(
                  'PPN (${d.defaultTaxRate.toStringAsFixed(0)}%)',
                  'Rp ${_fmtNum(d.totalTaxes)}',
                ),
              const Divider(height: 12, thickness: 1, color: colorGreyLight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colorTextPrimary,
                    ),
                  ),
                  Text(
                    'Rp ${_fmtNum(d.grandTotal)}',
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

  Widget _buildInfoTab(ServiceSalesOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Service Sales Order Info', Icons.assignment_outlined, [
            _row('Reference', _safe(d.reference)),
            _row('Status', d.status),
            _row('Customer', _safe(d.customerName)),
            _row('Sales Person', _safe(d.salesPersonName)),
            _row('Order Date', _fmt(d.orderDate)),
            _row('Validity Date', _fmt(d.validityDate)),
            _row('Payment Type', d.paymentType),
            if (d.paymentTermName?.isNotEmpty == true)
              _row('Payment Term', d.paymentTermName!),
            if (d.priceListName?.isNotEmpty == true)
              _row('Price List', d.priceListName!),
            if (d.poNumber?.isNotEmpty == true)
              _row('PO Number', d.poNumber!),
            if (d.discountType?.isNotEmpty == true)
              _row('Discount Type', d.discountType!),
            _row(
              'PPN',
              d.isTaxEnabled
                  ? 'Yes (${d.defaultTaxRate.toStringAsFixed(0)}%)'
                  : 'No',
            ),
            if (d.eBupot?.isNotEmpty == true) _row('e-Bupot', d.eBupot!),
            if (d.note?.isNotEmpty == true) _row('Note', d.note!),
          ]),
          const SizedBox(height: 12),
          _infoCard('Totals', Icons.calculate_outlined, [
            _row('Untaxed Amount', 'Rp ${_fmtNum(d.untaxedAmount)}'),
            if (d.totalDiscount > 0)
              _row('Total Discount', 'Rp ${_fmtNum(d.totalDiscount)}'),
            if (d.totalTaxes > 0)
              _row('PPN', 'Rp ${_fmtNum(d.totalTaxes)}'),
            _rowBold('Grand Total', 'Rp ${_fmtNum(d.grandTotal)}'),
          ]),
          if (d.hasQuotation || d.hasInvoice) ...[
            const SizedBox(height: 12),
            _infoCard('Linked Documents', Icons.link_outlined, [
              if (d.hasQuotation) _row('Quotation', 'Linked'),
              if (d.hasInvoice) _row('Invoice', 'Linked'),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentTab(ServiceSalesOrderDetailModel d) {
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
                      'Payment Type: Full — single invoice for total amount',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (d.invoices.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...d.invoices.map((inv) => _invoiceCard(inv)),
            ],
          ],
        ),
      );
    }

    if (d.paymentSchedules.isEmpty) {
      return Center(
        child: Text(
          'No payment schedules',
          style: GoogleFonts.poppins(color: colorGrey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: d.paymentSchedules.length,
      itemBuilder: (_, i) => _scheduleCard(d.paymentSchedules[i], d),
    );
  }

  Widget _scheduleCard(
    ServiceSalesOrderPaymentSchedule s,
    ServiceSalesOrderDetailModel d,
  ) {
    Color statusColor;
    switch (s.status) {
      case 'Paid':
        statusColor = Colors.green;
        break;
      case 'Invoiced':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = colorGrey;
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
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
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: colorTextSubtle,
                        ),
                      ),
                      Text(
                        '${s.percentage.toStringAsFixed(1)}% of total',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: colorTextSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Rp ${_fmtNum(s.totalAmount)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: colorPrimary,
                  ),
                ),
              ],
            ),
            if (d.isDone &&
                s.canInvoice &&
                widget.onCreateInvoiceFromTerm != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onCreateInvoiceFromTerm,
                  icon: const Icon(Icons.receipt_outlined, size: 16),
                  label: Text(
                    'Create Invoice',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    foregroundColor: colorPrimary,
                    side: const BorderSide(color: colorPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _invoiceCard(ServiceSalesOrderInvoice inv) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.receipt_outlined, color: colorPrimary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inv.reference ?? 'Invoice #${inv.idServiceInvoice}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: colorTextPrimary,
                    ),
                  ),
                  Text(
                    'Rp ${_fmtNum(inv.grandTotal)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colorTextSubtle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                inv.status,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOthersTab(ServiceSalesOrderDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline, [
            _row('Created By', _safe(d.createdByName)),
            if (d.createdDate?.isNotEmpty == true)
              _row('Created On', _fmtDt(d.createdDate)),
          ]),
          if (d.updatedByName?.isNotEmpty == true ||
              d.updatedDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Last Update', Icons.update_outlined, [
              if (d.updatedByName?.isNotEmpty == true)
                _row('Updated By', _safe(d.updatedByName)),
              if (d.updatedDate?.isNotEmpty == true)
                _row('Updated On', _fmtDt(d.updatedDate)),
            ]),
          ],
          if (d.cancelledByName?.isNotEmpty == true ||
              d.cancelledReason?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true)
                _row('Cancelled By', _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true)
                _row('Cancelled On', _fmtDt(d.cancelledDate)),
              if (d.cancelledReason?.isNotEmpty == true)
                _row('Cancel Reason', _safe(d.cancelledReason)),
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
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colorTextSubtle,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colorTextPrimary,
              ),
            ),
          ],
        ),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: colorTextSubtle,
                ),
              ),
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
          width: 130,
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