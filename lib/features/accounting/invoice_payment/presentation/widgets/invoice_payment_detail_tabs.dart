import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/models/invoice_payment_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';
import 'package:erp_mobile_cnplus/shared/widgets/attachment_viewer.dart';

class InvoicePaymentDetailTabs extends StatefulWidget {
  final InvoicePaymentDetailModel detail;

  const InvoicePaymentDetailTabs({super.key, required this.detail});

  @override
  State<InvoicePaymentDetailTabs> createState() => _State();
}

class _State extends State<InvoicePaymentDetailTabs> with SingleTickerProviderStateMixin {
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
    try { return DateFormat('d MMM yyyy').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _fmtDt(String? d) {
    if (d == null) return '-';
    try { return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d)); } catch (_) { return d; }
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Draft':     Color(0xFF757575),
    'Confirmed': Color(0xFF1565C0),
    'Posted':    Color(0xFF2E7D32),
    'Cancelled': Color(0xFFC62828),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps = (status == 'Cancelled') ? ['Draft', 'Confirmed', status] : ['Draft', 'Confirmed', 'Posted'];
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
                width: 26, height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDone || isCurrent) ? dot : Colors.white,
                  border: Border.all(color: (isDone || isCurrent) ? dot : colorGreyLight, width: 2),
                ),
                child: Center(
                  child: isDone ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : isCurrent ? const Icon(Icons.circle, size: 10, color: Colors.white) : null,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 56,
                child: Text(label, textAlign: TextAlign.center, style: GoogleFonts.poppins(
                  fontSize: 8, fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal,
                  color: isCurrent ? dot : isDone ? colorPrimary : colorGrey,
                )),
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
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [Tab(text: 'Info'), Tab(text: 'Journal'), Tab(text: 'Logs'), Tab(text: 'Others')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildInfoTab(d),
              _buildJournalTab(d),
              AuditTrailList(
                items: d.auditTrails.map((a) => AuditTrailItem(
                      actionByName: a.actionByName, actionById: a.actionById,
                      date: a.date, description: a.description,
                    )).toList(),
              ),
              _buildOthersTab(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(InvoicePaymentDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Payment Info', Icons.payments_outlined, [
            _row('Payment Number', _safe(d.paymentNumber)),
            _row('Status', d.status),
            _row('Invoice Type', d.invoiceType),
            _row('Customer', _safe(d.customerName)),
            _row('Invoice Number', _safe(d.invoiceNumber)),
            _row('Invoice Total', 'Rp ${_fmtNum(d.invoiceTotal)}'),
            _row('Payment Date', _fmt(d.paymentDate)),
            _row('Payment Method', d.paymentMethod.replaceAll('_', ' ')),
            _row('Bank Account', [d.bankName, d.bankAccountNumber].where((s) => s?.isNotEmpty == true).join(' - ')),
          ]),
          const SizedBox(height: 12),
          _infoCard('Amounts', Icons.calculate_outlined, [
            if (d.applyPph23) _row('PPh 23 Withheld', 'Rp ${_fmtNum(d.pph23Amount)}'),
            if (d.applyPpn) _row('PPN', 'Rp ${_fmtNum(d.ppnAmount)}'),
            _rowBold('Amount Paid', 'Rp ${_fmtNum(d.amountPaid)}'),
          ]),
          if (d.memo?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Memo', Icons.notes_outlined, [Text(d.memo!, style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary))]),
          ],
          if (d.attachmentUrl?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Attachment', Icons.attach_file, [
              AttachmentViewer(url: d.attachmentUrl!, fileName: d.attachment),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildJournalTab(InvoicePaymentDetailModel d) {
    if (d.accountingEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            d.isPosted ? 'No journal entries found' : 'Journal entries appear here once the payment is Posted',
            style: GoogleFonts.poppins(color: colorGrey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: d.accountingEntries.length,
      itemBuilder: (_, i) {
        final e = d.accountingEntries[i];
        final color = e.isDebit ? colorPrimary : Colors.indigo.shade700;
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(e.type, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.coaName ?? '-', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: colorTextPrimary)),
                      if (e.coaNumber?.isNotEmpty == true) Text(e.coaNumber!, style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
                    ],
                  ),
                ),
                Text('Rp ${_fmtNum(e.amount)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOthersTab(InvoicePaymentDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Creation', Icons.add_circle_outline_outlined, [
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
          if (d.isCancelled) ...[
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true) _row('Cancelled By', _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true) _row('Cancelled On', _fmtDt(d.cancelledDate)),
              if (d.cancelReason?.isNotEmpty == true) _row('Reason', _safe(d.cancelReason)),
            ]),
            const SizedBox(height: 12),
          ],
          if (d.unpostByName?.isNotEmpty == true || d.unpostDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Unpost', Icons.undo_outlined, [
              if (d.unpostByName?.isNotEmpty == true) _row('Unposted By', _safe(d.unpostByName)),
              if (d.unpostDate?.isNotEmpty == true) _row('Unposted On', _fmtDt(d.unpostDate)),
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
        SizedBox(width: 140, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
        Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w500))),
      ],
    ),
  );

  Widget _rowBold(String label, String value) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      children: [
        SizedBox(width: 140, child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: colorTextPrimary))),
        Expanded(child: Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorPrimary))),
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