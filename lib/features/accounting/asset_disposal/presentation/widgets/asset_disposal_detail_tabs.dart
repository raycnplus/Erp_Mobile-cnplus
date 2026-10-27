import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/models/asset_disposal_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';
import 'package:erp_mobile_cnplus/shared/widgets/journal_entry_list.dart';

class AssetDisposalDetailTabs extends StatefulWidget {
  final AssetDisposalDetailModel detail;

  const AssetDisposalDetailTabs({super.key, required this.detail});

  @override
  State<AssetDisposalDetailTabs> createState() => _State();
}

class _State extends State<AssetDisposalDetailTabs> with SingleTickerProviderStateMixin {
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
  String _rp(double v)     => 'Rp ${_fmtNum(v)}';
  String _safe(dynamic v)  => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  static const _statusColors = <String, Color>{
    'Draft':     Color(0xFF757575),
    'Confirmed': Color(0xFF1565C0),
    'Posted':    Color(0xFF2E7D32),
    'Cancelled': Color(0xFFC62828),
  };

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final steps  = (status == 'Cancelled')
        ? ['Draft', 'Confirmed', 'Cancelled']
        : ['Draft', 'Confirmed', 'Posted'];
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
              child: Container(height: 2, color: passed ? colorPrimary : colorGreyLight),
            );
          }
          final idx       = i ~/ 2;
          final isDone    = idx < activeIdx;
          final isCurrent = idx == activeIdx;
          final label     = steps[idx];

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
                          ? const Icon(Icons.circle, size: 10, color: Colors.white)
                          : null,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 56,
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
                    child: Text('Journal', overflow: TextOverflow.ellipsis),
                  ),
                  if (d.hasJournal) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
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
              _buildInfoTab(d),
              JournalEntryList(
                entries: d.accountingEntries.map((e) => JournalEntryItem(
                      coaNumber:       e.coaNumber,
                      coaName:         e.coaName,
                      type:            e.type,
                      amount:          e.amount,
                      description:     e.description,
                      transactionDate: e.journalDate,
                    )).toList(),
              ),
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

  Widget _buildInfoTab(AssetDisposalDetailModel d) {
    final gl = d.gainLossValue;
    final glColor = gl > 0 ? const Color(0xFF2E7D32) : gl < 0 ? const Color(0xFFC62828) : colorTextPrimary;
    final glLabel = d.isGainLossFinal ? 'Gain / (Loss)' : 'Gain / (Loss) - estimate';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Disposal Info', Icons.remove_circle_outline, [
            _row('Reference',       _safe(d.reference)),
            _row('Status',          d.status),
            _row('Asset',           '${_safe(d.assetCode)} - ${_safe(d.assetName)}'),
            _row('Disposal Date',   _fmt(d.disposalDate)),
            _row('Method',          d.methodLabel),
            if (d.isSold) _row('Disposal Value', _rp(d.disposalValue)),
            if (d.isSold) _row('Bank Account',   _safe(d.bankName)),
            if (d.reason?.isNotEmpty == true) _row('Reason', d.reason!),
          ]),
          const SizedBox(height: 12),
          _infoCard('Value Summary', Icons.calculate_outlined, [
            if (d.bookValueAtDisposal == null)
              _row('Current Book Value', _rp(d.currentBookValue))
            else ...[
              if (d.accumulatedDepreciationAtDisposal != null)
                _row('Accumulated Dep.', _rp(d.accumulatedDepreciationAtDisposal!)),
              _row('Book Value', _rp(d.bookValueAtDisposal!)),
            ],
            _row('Proceeds', _rp(d.isSold ? d.disposalValue : 0)),
            _rowBold(glLabel, _rp(gl), color: glColor),
          ]),
        ],
      ),
    );
  }

  Widget _buildOthersTab(AssetDisposalDetailModel d) {
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
          if (d.cancelledByName?.isNotEmpty == true || d.cancelledDate?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            _infoCard('Cancellation', Icons.cancel_outlined, [
              if (d.cancelledByName?.isNotEmpty == true) _row('Cancelled By',  _safe(d.cancelledByName)),
              if (d.cancelledDate?.isNotEmpty == true)   _row('Cancelled On',  _fmtDt(d.cancelledDate)),
              if (d.cancelReason?.isNotEmpty == true)    _row('Cancel Reason', _safe(d.cancelReason)),
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

  Widget _rowBold(String label, String value, {Color? color}) => Padding(
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
              fontSize: 12,
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
              color: color ?? colorPrimary,
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