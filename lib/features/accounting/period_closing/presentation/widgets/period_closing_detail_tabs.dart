import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/models/period_closing_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class PeriodClosingDetailTabs extends StatefulWidget {
  final PeriodClosingDetailModel detail;
  final List<PeriodClosingBalanceRow> balanceRows;
  final bool isLoadingBalance;
  final String? balanceError;
  final VoidCallback? onRetryBalance;

  const PeriodClosingDetailTabs({
    super.key,
    required this.detail,
    required this.balanceRows,
    this.isLoadingBalance = false,
    this.balanceError,
    this.onRetryBalance,
  });

  @override
  State<PeriodClosingDetailTabs> createState() => _State();
}

class _State extends State<PeriodClosingDetailTabs> with SingleTickerProviderStateMixin {
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
    'DRAFT':   Color(0xFF757575),
    'POSTING': Color(0xFF2E7D32),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    const steps = ['DRAFT', 'POSTING'];
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
                width: 70,
                child: Text(
                  label == 'DRAFT' ? 'Draft' : 'Posted & Locked',
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
                    child: Text('Balance', overflow: TextOverflow.ellipsis),
                  ),
                  if (widget.balanceRows.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: colorError,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.balanceRows.length}',
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
              _buildInfoTab(d),
              _buildBalanceTab(),
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

  Widget _buildInfoTab(PeriodClosingDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Period Closing Info', Icons.event_repeat_outlined, [
            _row('Period',       _safe(d.periodLabel)),
            _row('Closing Type', d.isMonthly ? 'Monthly' : 'Yearly'),
            _row('Status',       d.status),
          ]),
        ],
      ),
    );
  }

  Widget _buildOthersTab(PeriodClosingDetailModel d) {
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
          if (d.isPosted) ...[
            const SizedBox(height: 12),
            _infoCard('Posting', Icons.lock_outline, [
              _row('Posted By', _safe(d.postingByName)),
              if (d.postingDate?.isNotEmpty == true) _row('Posted On', _fmtDt(d.postingDate)),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceTab() {
    if (widget.isLoadingBalance) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    if (widget.balanceError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: colorError),
            const SizedBox(height: 12),
            Text(widget.balanceError!, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
            if (widget.onRetryBalance != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: widget.onRetryBalance,
                style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }
    if (widget.balanceRows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: Color(0xFF2E7D32)),
            const SizedBox(height: 12),
            Text(
              'All transactions posted & balanced',
              style: GoogleFonts.poppins(fontSize: 14, color: colorTextSubtle),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: widget.balanceRows.length,
      itemBuilder: (_, i) => _balanceCard(widget.balanceRows[i]),
    );
  }

  Widget _balanceCard(PeriodClosingBalanceRow row) {
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
                    row.reference,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: colorTextPrimary,
                    ),
                  ),
                ),
                Text(
                  row.sourceType,
                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                ),
              ],
            ),
            if (row.description.isNotEmpty && row.description != '-')
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  row.description,
                  style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (row.notPosted) _flagChip('Not Posted', colorError),
                if (row.notBalanced) _flagChip('Not Balanced', Colors.orange),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  row.transactionDate != null
                      ? DateFormat('d MMM yyyy').format(DateTime.parse(row.transactionDate!))
                      : '-',
                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                ),
                Text(
                  'D: ${_fmtNum(row.debit)}  •  C: ${_fmtNum(row.credit)}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: row.notBalanced ? Colors.orange.shade700 : colorTextPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _flagChip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600),
    ),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
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