import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class CashBankDetailTabs extends StatefulWidget {
  final CashBankDetailModel detail;

  const CashBankDetailTabs({super.key, required this.detail});

  @override
  State<CashBankDetailTabs> createState() => _State();
}

class _State extends State<CashBankDetailTabs> with SingleTickerProviderStateMixin {
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

  static const _noteTypeLabels = <String, String>{
    'BANK_DEBIT':  'Bank Debit',
    'BANK_CREDIT': 'Bank Credit',
    'CASH_DEBIT':  'Cash Debit',
    'CASH_CREDIT': 'Cash Credit',
  };

  static const _statusColors = <String, Color>{'Draft': Color(0xFF757575), 'Posted': Color(0xFF2E7D32)};

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
          Text(d.status, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
          const Spacer(),
          Text(d.reference ?? '-', style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
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
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [Tab(text: 'Entries'), Tab(text: 'Info'), Tab(text: 'Logs'), Tab(text: 'Others')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildEntriesTab(d),
              _buildInfoTab(d),
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

  Widget _buildEntriesTab(CashBankDetailModel d) {
    final hasHeaderLine = d.cashbankCoaName != null && (d.headerDebit > 0 || d.headerCredit > 0);

    if (d.details.isEmpty && !hasHeaderLine) {
      return Center(child: Text('No entries', style: GoogleFonts.poppins(color: colorGrey)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              if (hasHeaderLine) _buildEntryCard(
                type: d.headerDebit > 0 ? 'DEBIT' : 'CREDIT',
                coaLabel: d.cashbankCoaNumber != null
                    ? '${d.cashbankCoaNumber} - ${d.cashbankCoaName}'
                    : d.cashbankCoaName!,
                description: d.description,
                amount: d.headerDebit > 0 ? d.headerDebit : d.headerCredit,
              ),
              ...d.details.map((item) => _buildEntryCard(
                    type: item.type,
                    coaLabel: item.coaName ?? 'COA #${item.idCoa}',
                    description: item.description,
                    amount: item.amount,
                  )),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          color: colorCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Debit: Rp ${_fmtNum(d.totalDebit)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total Credit: Rp ${_fmtNum(d.totalCredit)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEntryCard({
    required String type,
    required String coaLabel,
    String? description,
    required double amount,
  }) {
    final isDebit = type == 'DEBIT';
    final color = isDebit ? colorPrimary : Colors.indigo.shade700;
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
              child: Text(type, style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coaLabel, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: colorTextPrimary)),
                  if (description?.isNotEmpty == true)
                    Text(description!, style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                ],
              ),
            ),
            Text('Rp ${_fmtNum(amount)}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(CashBankDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Cash & Bank Info', Icons.account_balance_wallet_outlined, [
            _row('Reference', _safe(d.reference)),
            _row('Status', d.status),
            _row('Note Type', _noteTypeLabels[d.noteType] ?? d.noteType),
            _row('Transaction Date', _fmt(d.transactionDate)),
            if (d.description?.isNotEmpty == true) _row('Description', d.description!),
            if (d.notes?.isNotEmpty == true) _row('Notes', d.notes!),
          ]),
        ],
      ),
    );
  }

  Widget _buildOthersTab(CashBankDetailModel d) {
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
          if (d.unpostDate?.isNotEmpty == true) ...[
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