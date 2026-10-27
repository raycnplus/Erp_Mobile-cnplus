import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/models/tax_payment_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class TaxPaymentDetailTabs extends StatefulWidget {
  final TaxPaymentDetailModel detail;

  const TaxPaymentDetailTabs({super.key, required this.detail});

  @override
  State<TaxPaymentDetailTabs> createState() => _State();
}

class _State extends State<TaxPaymentDetailTabs> with SingleTickerProviderStateMixin {
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
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMM yyyy, HH:mm').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
  String _safe(dynamic v)  => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Draft':  Color(0xFF757575),
    'Posted': Color(0xFF2E7D32),
  };

  Widget _buildStatusBanner() {
    final d = widget.detail;
    final color = _statusColors[d.status] ?? colorGrey;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Icon(d.isPosted ? Icons.check_circle : Icons.edit_note, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            d.status,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: color),
          ),
          const Spacer(),
          Text(
            _safe(d.transactionNumber),
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBanner() {
    final d = widget.detail;
    if (d.invoicePaymentStatus?.isNotEmpty != true) return const SizedBox.shrink();
    final color = d.invoicePaymentIsPaid ? const Color(0xFF2E7D32) : const Color(0xFFFFA000);
    return Container(
      width: double.infinity,
      color: color.withOpacity(0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            d.invoicePaymentIsPaid ? Icons.check_circle_outline : Icons.schedule_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            'Invoice payment: ${d.invoicePaymentStatus}',
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        _buildStatusBanner(),
        _buildPaymentBanner(),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [Tab(text: 'Info'), Tab(text: 'Logs'), Tab(text: 'Others')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildInfoTab(d),
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

  Widget _buildInfoTab(TaxPaymentDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Transaction', Icons.receipt_long_outlined, [
            _row('Type',               d.typeLabel),
            _row('Transaction Number', _safe(d.transactionNumber)),
            _row('Customer',           _safe(d.customerName)),
            _row('Invoice Payment',    _safe(d.invoicePaymentStatus)),
          ]),
          const SizedBox(height: 12),
          _infoCard('Tax Payment', Icons.account_balance_outlined, [
            _row('e-Billing Number', _safe(d.taxReferenceNumber)),
            _row('Payment Date',     _fmt(d.paymentDate)),
            _row('Signer Name',      _safe(d.signerName)),
            _rowBold('Amount', 'Rp ${_fmtNum(d.amount)}'),
          ]),
          if (d.note?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Note', Icons.notes_outlined, [_row('Note', d.note!)]),
          ],
        ],
      ),
    );
  }

  Widget _buildOthersTab(TaxPaymentDetailModel d) {
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
              if (d.updatedDate?.isNotEmpty == true)   _row('Updated On', _fmtDt(d.updatedDate)),
            ]),
          ],
          if (d.unpostedByName?.isNotEmpty == true || d.unpostDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Unpost', Icons.undo_outlined, [
              if (d.unpostedByName?.isNotEmpty == true) _row('Unposted By', _safe(d.unpostedByName)),
              if (d.unpostDate?.isNotEmpty == true)     _row('Unposted On', _fmtDt(d.unpostDate)),
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
            SizedBox(
              width: 130,
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