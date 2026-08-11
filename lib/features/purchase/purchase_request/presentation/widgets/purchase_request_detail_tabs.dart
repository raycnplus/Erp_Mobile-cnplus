import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/models/purchase_request_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class PurchaseRequestDetailTabs extends StatefulWidget {
  final PurchaseRequestDetailModel detail;

  const PurchaseRequestDetailTabs({
    super.key,
    required this.detail,
  });

  @override
  State<PurchaseRequestDetailTabs> createState() {
    return _State();
  }
}

class _State extends State<PurchaseRequestDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(
      length: 4,
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
    'Draft':            Color(0xFF757575),
    'Waiting Approval': Color(0xFFFFA500),
    'Confirmed':        Color(0xFF1565C0),
    'Done':             Color(0xFF2E7D32),
    'Cancelled':        Color(0xFFC62828),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final List<String> steps;
    if (status == 'Cancelled' || status == 'Rejected') {
      steps = ['Draft', 'Waiting Approval', status];
    } else {
      steps = ['Draft', 'Waiting Approval', 'Confirmed', 'Done'];
    }

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

          final shortLabel = switch (label) {
            'Waiting Approval' => 'Waiting',
            _ => label,
          };

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
                width: 52,
                child: Text(
                  shortLabel,
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
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Items'),
                  if (d.items.isNotEmpty) ...[
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
                        '${d.items.length}',
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
            const Tab(text: 'Info'),
            const Tab(text: 'Logs'),
            const Tab(text: 'Others'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildItemsTab(d),
              _buildInfoTab(d),
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

  Widget _buildItemsTab(PurchaseRequestDetailModel d) {
    return Column(
      children: [
        Expanded(
          child: d.items.isEmpty
              ? Center(
                  child: Text(
                    'No items',
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: colorPrimary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${_fmtNum(item.demandQty)} ${item.uomName ?? ''}',  
                                    style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            if (item.description?.isNotEmpty == true) ...[
                              const SizedBox(height: 4),
                              Text(
                                item.description!,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: colorGrey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _statChip(
                                    'Unit Price',
                                    'Rp ${_fmtNum(item.estimatedUnitPrice)}',   
                                    Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _statChip(
                                    'Total',
                                    'Rp ${_fmtNum(item.totalEstimatedPrice)}',
                                    colorPrimary,
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
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: colorCard,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Estimated',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colorTextPrimary,
                ),
              ),
              Text(
                'Rp ${_fmtNum(d.totalPrice)}',  
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16, 
                  color: colorPrimary
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(PurchaseRequestDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Purchase Request Info', Icons.shopping_cart_outlined, [
            _row('Reference', _safe(d.reference)),
            _row('Status', d.status),
            _row('Requested By', _safe(d.requestedByName)),
            _row('Vendor', _safe(d.vendorName)),
            _row('Dest. Warehouse', _safe(d.destinationWarehouseName)),
            _row('Dest. Location', _safe(d.destinationLocationName)),
            _row('Request Date', _fmt(d.requestDate)),
            _row('Expected Arrival', _fmt(d.expectedArrival)),
            if (d.note?.isNotEmpty == true) _row('Note', d.note!),
          ]),
          const SizedBox(height: 12),
          _infoCard('Total', Icons.calculate_outlined, [
            _rowBold('Total Estimated Price', 'Rp ${_fmtNum(d.totalPrice)}'),
          ]),
          if (d.hasRfq || d.hasDp) ...[
            const SizedBox(height: 12),
            _infoCard('Linked Documents', Icons.link_outlined, [
              if (d.hasRfq) _row('RFQ', 'Linked'),
              if (d.hasDp) _row('Direct Purchase', 'Linked'),
            ]),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildOthersTab(PurchaseRequestDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline, [
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
          if (d.cancelledByName?.isNotEmpty == true || d.cancelledDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true)
                _row('Cancelled By', _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true)
                _row('Cancelled On', _fmtDt(d.cancelledDate)),
              if (d.cancelledReason?.isNotEmpty == true)
                _row('Cancelled Reason', _safe(d.cancelledReason)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: colorGrey,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
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
            width: 140,
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

  Widget _rowBold(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: colorTextPrimary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: colorPrimary,
          ),
        ),
      ],
    );
  }

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