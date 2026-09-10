import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/models/bpe_management_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class BpeManagementDetailTabs extends StatefulWidget {
  final BpeDetailModel detail;

  const BpeManagementDetailTabs({super.key, required this.detail});

  @override
  State<BpeManagementDetailTabs> createState() => _State();
}

class _State extends State<BpeManagementDetailTabs> with SingleTickerProviderStateMixin {
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
    'Draft':     Color(0xFF757575),
    'Confirmed': Color(0xFF1565C0),
    'Validated': Color(0xFF2E7D32),
  };

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _periodLabel(BpeDetailModel d) {
    final m = (d.periodMonth >= 1 && d.periodMonth <= 12) ? _months[d.periodMonth - 1] : '-';
    return '$m ${d.periodYear}';
  }

  Widget _buildPipeline() {
    final status = widget.detail.status;
    const steps = ['Draft', 'Confirmed', 'Validated'];
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
                width: 60,
                child: Text(
                  label,
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
          tabs: [
            const Tab(text: 'Info'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(
                    child: Text('Transactions', overflow: TextOverflow.ellipsis),
                  ),
                  if (d.transactions.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '${d.transactions.length}',
                        style: GoogleFonts.poppins(fontSize: 9, color: colorWhite, fontWeight: FontWeight.w600),
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
              _buildInfoTab(d),
              _buildTransactionsTab(d),
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

  Widget _buildInfoTab(BpeDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('BPE Info', Icons.description_outlined, [
            _row('BPE Number', _safe(d.bpeNumber)),
            _row('Status',     d.status),
            _row('BPE Date',   _fmt(d.bpeDate)),
            _row('Period',     _periodLabel(d)),
            if (d.note?.isNotEmpty == true) _row('Note', d.note!),
          ]),
          const SizedBox(height: 12),
          _infoCard('Totals', Icons.calculate_outlined, [
            _row('Transaction Count', '${d.transactions.length}'),
            _rowBold('Total Amount', 'Rp ${_fmtNum(d.totalAmount)}'),
          ]),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab(BpeDetailModel d) {
    if (d.transactions.isEmpty) {
      return Center(child: Text('No transactions', style: GoogleFonts.poppins(color: colorGrey)));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: d.transactions.length,
            itemBuilder: (_, i) => _transactionCard(d.transactions[i]),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: colorCard,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
              Text(
                'Rp ${_fmtNum(d.totalAmount)}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: colorPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOthersTab(BpeDetailModel d) {
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
        ],
      ),
    );
  }

  Widget _transactionCard(BpeTransactionModel t) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                t.isServiceInvoice ? Icons.build_outlined : Icons.receipt_outlined,
                color: colorPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.invoiceNumber ?? '-',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorTextPrimary),
                  ),
                  Text(
                    t.customerName ?? '-',
                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${t.isServiceInvoice ? "Service Invoice" : "Invoice"} • ${_fmt(t.invoiceDate)}',
                    style: GoogleFonts.poppins(fontSize: 10, color: colorGrey),
                  ),
                ],
              ),
            ),
            Text(
              'Rp ${_fmtNum(t.grandTotal)}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w500),
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
          width: 120,
          child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: colorTextPrimary)),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorPrimary),
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
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
            ],
          ),
          const Divider(height: 16),
          ...rows,
        ],
      ),
    ),
  );
}