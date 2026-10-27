import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/models/asset_depreciation_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';
import 'package:erp_mobile_cnplus/shared/widgets/journal_entry_list.dart';

class AssetDepreciationDetailTabs extends StatefulWidget {
  final AssetDepreciationDetailModel detail;

  const AssetDepreciationDetailTabs({super.key, required this.detail});

  @override
  State<AssetDepreciationDetailTabs> createState() => _State();
}

class _State extends State<AssetDepreciationDetailTabs> with SingleTickerProviderStateMixin {
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

  String _period(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('MMMM yyyy').format(DateTime.parse(d));
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
  String _safe(dynamic v)  => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  Widget _buildBanner() {
    final d = widget.detail;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          const Icon(Icons.trending_down_rounded, color: colorPrimary, size: 20),
          const SizedBox(width: 8),
          Text(
            _period(d.periodDate),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: colorTextPrimary,
            ),
          ),
          const Spacer(),
          Text(
            d.reference ?? '-',
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
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
        _buildBanner(),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        TabBar(
          controller: _tab,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: [
            const Tab(text: 'Assets'),
            const Tab(text: 'Info'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Journal'),
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
              _buildAssetsTab(d),
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

  Widget _buildAssetsTab(AssetDepreciationDetailModel d) {
    return Column(
      children: [
        Expanded(
          child: d.details.isEmpty
              ? Center(child: Text('No assets', style: GoogleFonts.poppins(color: colorGrey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: d.details.length,
                  itemBuilder: (_, i) {
                    final item = d.details[i];
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
                            Text(
                              item.assetName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: colorTextPrimary,
                              ),
                            ),
                            Text(
                              item.assetCode,
                              style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Depreciation: Rp ${_fmtNum(item.depreciationAmount)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: colorPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Accumulated: Rp ${_fmtNum(item.accumulatedDepreciation)}',
                              style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                            ),
                            Text(
                              'Book Value: Rp ${_fmtNum(item.bookValue)}',
                              style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
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
                'Total Depreciation',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: colorTextPrimary,
                ),
              ),
              Text(
                'Rp ${_fmtNum(d.totalDepreciationAmount)}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(AssetDepreciationDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _infoCard('Depreciation Run', Icons.trending_down_rounded, [
        _row('Reference',         _safe(d.reference)),
        _row('Period',            _period(d.periodDate)),
        _row('Assets Processed',  '${d.totalAssetsProcessed}'),
        _rowBold('Total Depreciation', 'Rp ${_fmtNum(d.totalDepreciationAmount)}'),
      ]),
    );
  }

  Widget _buildOthersTab(AssetDepreciationDetailModel d) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _infoCard('Creation', Icons.add_circle_outline, [
        _row('Created By', _safe(d.createdByName)),
        if (d.createdDate?.isNotEmpty == true) _row('Created On', _fmtDt(d.createdDate)),
      ]),
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