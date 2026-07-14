import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/models/bank_account_models.dart';

class BankAccountDetailTabs extends StatefulWidget {
  final BankAccountDetailModel detail;

  const BankAccountDetailTabs({super.key, required this.detail});

  @override
  State<BankAccountDetailTabs> createState() => _BankAccountDetailTabsState();
}

class _BankAccountDetailTabsState extends State<BankAccountDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _fmt(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? '-' : v.toString();

  @override
  Widget build(BuildContext context) {
    final b = widget.detail.bankAccount;
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Info'), Tab(text: 'Audit Trail')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Bank Info', Icons.account_balance_outlined, {
                      'Bank Name': _safe(b.bankName),
                      'Account Name': _safe(b.bankAccountName),
                      'Account Number': _safe(b.bankAccountNumber),
                      'Description': b.description?.isNotEmpty == true
                          ? b.description!
                          : '-',
                    }),
                    if (widget.detail.coa != null) ...[
                      const SizedBox(height: 16),
                      _card('Linked COA', Icons.account_tree_outlined, {
                        'COA Number': _safe(widget.detail.coa!.coaNumber),
                        'COA Name': _safe(widget.detail.coa!.coaName),
                      }),
                    ],
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Creation', Icons.add_circle_outline, {
                      'Created By': _safe(widget.detail.createdByName),
                      'Created On': _fmt(b.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card('Last Update', Icons.update_outlined, {
                      'Updated By': _safe(widget.detail.updatedByName),
                      'Updated On': _fmt(b.updatedDate),
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(String title, IconData icon, Map<String, String> fields) {
    final visible = {
      for (final e in fields.entries)
        if (e.value != '-') e.key: e.value,
    };
    if (visible.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorTextPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...visible.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.key,
                      style: GoogleFonts.poppins(
                        color: colorTextSubtle,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        e.value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: colorTextPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}