import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/data/models/bill_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';
import 'package:erp_mobile_cnplus/shared/widgets/journal_entry_list.dart';

class BillDetailTabs extends StatefulWidget {
  final BillDetailModel detail;

  const BillDetailTabs({
    super.key,
    required this.detail,
  });

  @override
  State<BillDetailTabs> createState() {
    return _State();
  }
}

class _State extends State<BillDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(
      length: 6,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null) {
      return '-';
    }
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null) {
      return '-';
    }
    try {
      return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtNum(double v) {
    return NumberFormat('#,##0.00', 'id_ID').format(v);
  }

  String _safe(dynamic v) {
    return (v == null || v.toString().isEmpty) ? '-' : v.toString();
  }

  static const _statusColors = <String, Color>{
    'Draft': Color(0xFF757575),
    'Waiting Approval': Color(0xFFFFA500),
    'Confirmed': Color(0xFF1565C0),
    'Posted': Color(0xFF2E7D32),
    'Cancelled': Color(0xFFC62828),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps = status == 'Cancelled'
        ? ['Draft', 'Confirmed', 'Cancelled']
        : ['Draft', 'Waiting Approval', 'Confirmed', 'Posted'];
    int activeIdx = steps.indexOf(status);
    if (activeIdx < 0) {
      activeIdx = 0;
    }

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
                      ? const Icon(
                          Icons.check,
                          size: 13,
                          color: Colors.white,
                        )
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
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
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
        const Divider(
          height: 1,
          thickness: 1,
          color: colorGreyLight,
        ),
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
            const Tab(text: 'Products'),
            const Tab(text: 'Info'),
            const Tab(text: 'Payment'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Journal'),
                  if (d.hasJournal) ...[
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
                        '${d.accountingEntries.length}',
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
              _buildProductsTab(d),
              _buildInfoTab(d),
              _buildPaymentTab(d),
              JournalEntryList(
                entries: d.accountingEntries.map((e) => JournalEntryItem(
                      coaNumber:       e.coaNumber,
                      coaName:         e.coaName,
                      type:            e.type,
                      amount:          e.amount,
                      description:     null,
                      transactionDate: d.billDate,
                    )).toList(),
              ),
              AuditTrailList(
                items: d.auditTrails.map((a) {
                  return AuditTrailItem(
                    actionByName: a.actionByName,
                    actionById: a.actionById,
                    date: a.date,
                    description: a.description,
                  );
                }).toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsTab(BillDetailModel d) {
    return Column(
      children: [
        Expanded(
          child: d.items.isEmpty
              ? Center(
                  child: Text(
                    'No products',
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
                                    item.productName ?? '-',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: colorTextPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Qty: ${_fmtNum(item.demandQty)}${item.uomName != null ? ' ${item.uomName}' : ''}',
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
              if (d.totalDiscount > 0) _footerRow('Total Discount', 'Rp ${_fmtNum(d.totalDiscount)}'),
              _footerRow('Untaxed Amount', 'Rp ${_fmtNum(d.untaxedAmount)}'),
              if (d.totalTaxes > 0)
                _footerRow('PPN (${d.defaultTaxRate.toStringAsFixed(0)}%)', 'Rp ${_fmtNum(d.totalTaxes)}'),
              const Divider(
                height: 12,
                thickness: 1,
                color: colorGreyLight,
              ),
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

  Widget _buildInfoTab(BillDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Bill Info', Icons.receipt_long_outlined, [
            _row('Reference', _safe(d.reference)),
            _row('Status', d.status),
            _row('Vendor', _safe(d.vendorName)),
            _row('Bill Date', _fmt(d.billDate)),
            _row('Order Deadline', _fmt(d.orderDeadline)),
            _row('Expected Arrival', _fmt(d.expectedArrival)),
            _row('Price List', _safe(d.priceListName)),
            _row('Payment Terms', _safe(d.paymentTermName)),
            _row('Due Date', _fmt(d.dueDate)),
            if (d.paymentTermName?.isNotEmpty == true) _row('Payment Term', d.paymentTermName!),
            if (d.discountType?.isNotEmpty == true) _row('Discount Type', d.discountType!),
            _row('PPN', d.isTaxEnabled ? 'Yes (${d.defaultTaxRate.toStringAsFixed(0)}%)' : 'No'),
            if (d.paymentInfo?.isNotEmpty == true) _rowColored('Payment Status', d.paymentInfo!, d.paymentInfoColor),
            if (d.note?.isNotEmpty == true) _row('Note', d.note!),
          ]),
          const SizedBox(height: 12),
          _infoCard('Totals', Icons.calculate_outlined, [
            _row('Untaxed Amount', 'Rp ${_fmtNum(d.untaxedAmount)}'),
            if (d.totalDiscount > 0) _row('Total Discount', 'Rp ${_fmtNum(d.totalDiscount)}'),
            if (d.totalTaxes > 0) _row('PPN', 'Rp ${_fmtNum(d.totalTaxes)}'),
            _rowBold('Grand Total', 'Rp ${_fmtNum(d.grandTotal)}'),
          ]),
          if (d.hasPurchaseOrder) ...[
            const SizedBox(height: 12),
            _infoCard('Linked Documents', Icons.link_outlined, [
              _row('Purchase Order', d.poReference ?? 'Linked'),
            ]),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildPaymentTab(BillDetailModel d) {
    if (!d.hasPayment) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: colorGrey,
            ),
            const SizedBox(height: 12),
            Text(
              d.isPosted ? 'No payment recorded yet' : 'Bill not yet posted',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: colorTextSubtle,
              ),
            ),
          ],
        ),
      );
    }
    final p = d.paymentDetails!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (d.paymentInfo?.isNotEmpty == true)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: d.paymentInfoColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: d.paymentInfoColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: d.paymentInfoColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      d.paymentInfo!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: d.paymentInfoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          _infoCard('Payment Details', Icons.payment_outlined, [
            _rowBold('Grand Total', 'Rp ${_fmtNum(p.grandTotal)}'),
            if (p.paymentAmount > 0) _row('Paid Amount', 'Rp ${_fmtNum(p.paymentAmount)}'),
            if (p.paymentDate?.isNotEmpty == true) _row('Payment Date', _fmt(p.paymentDate)),
            if (p.bankName?.isNotEmpty == true) ...[
              const Divider(
                height: 14,
                color: colorGreyLight,
              ),
              _row('Bank', _safe(p.bankName)),
              _row('Account Name', _safe(p.bankAccountName)),
              _row('Account Number', _safe(p.bankAccountNumber)),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _buildOthersTab(BillDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline, [
            _row('Created By', _safe(d.createdByName)),
            if (d.createdDate?.isNotEmpty == true)
              _row('Created On', _fmtDt(d.createdDate)),
          ]),
          if (d.updatedByName?.isNotEmpty == true || d.updatedDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Last Update', Icons.update_outlined, [
              if (d.updatedByName?.isNotEmpty == true)
                _row('Updated By', _safe(d.updatedByName)),
              if (d.updatedDate?.isNotEmpty == true)
                _row('Updated On', _fmtDt(d.updatedDate)),
            ]),
          ],
          if (d.cancelledByName?.isNotEmpty == true || d.cancelReason?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true)
                _row('Cancelled By', _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true)
                _row('Cancelled On', _fmtDt(d.cancelledDate)),
              if (d.cancelReason?.isNotEmpty == true)
                _row('Cancel Reason', _safe(d.cancelReason)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _footerRow(String label, String value) {
    return Padding(
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
  }

  Widget _row(String label, String value) {
    return Padding(
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
  }

  Widget _rowColored(String label, String value, Color color) {
    return Padding(
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
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              color: colorTextPrimary
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: colorPrimary,
            )
          )
        )
      ],
    ),
  );

  Widget _infoCard(String title, IconData icon, List<Widget> rows) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: colorPrimary,
                  size: 18,
                ),
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
}