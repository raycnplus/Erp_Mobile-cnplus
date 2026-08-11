import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class JournalEntryItem {
  final String coaNumber;
  final String coaName;
  final String type;
  final double amount;
  final String? reference;
  final String? description;
  final String? transactionDate;

  const JournalEntryItem({
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.amount,
    this.reference,
    this.description,
    this.transactionDate,
  });

  bool get isDebit  => type.toLowerCase() == 'debit';
  bool get isCredit => type.toLowerCase() == 'credit';
}

class JournalEntryList extends StatelessWidget {
  final List<JournalEntryItem> entries;

  const JournalEntryList({super.key, required this.entries});

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_outlined, size: 64, color: colorGrey),
            const SizedBox(height: 12),
            Text(
              'No journal entries',
              style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle),
            ),
            const SizedBox(height: 4),
            Text(
              'Journal will appear after invoice is validated',
              style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final totalDebit  = entries.where((e) => e.isDebit).fold(0.0, (s, e) => s + e.amount);
    final totalCredit = entries.where((e) => e.isCredit).fold(0.0, (s, e) => s + e.amount);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: entries.length,
            itemBuilder: (_, i) => _entryCard(entries[i]),
          ),
        ),
        Container(
          color: colorCard,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              _footerRow('Total Debit',  'Rp ${_fmtNum(totalDebit)}'),
              _footerRow('Total Credit', 'Rp ${_fmtNum(totalCredit)}'),
              const Divider(height: 12, thickness: 1, color: colorGreyLight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Balance',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: colorTextPrimary,
                    ),
                  ),
                  Text(
                    (totalDebit - totalCredit).abs() < 0.01
                        ? 'Balanced'
                        : 'Rp ${_fmtNum(totalDebit - totalCredit)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: (totalDebit - totalCredit).abs() < 0.01 ? colorSuccess : colorError,
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

  Widget _entryCard(JournalEntryItem e) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.coaNumber,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    e.coaName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (e.description?.isNotEmpty == true) ...[
              const SizedBox(height: 2),
              Text(
                e.description!,
                style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _amountColumn('Debit',  e.isDebit  ? e.amount : null)),
                Container(width: 1, height: 30, color: colorGreyLight),
                const SizedBox(width: 12),
                Expanded(child: _amountColumn('Credit', e.isCredit ? e.amount : null)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountColumn(String label, double? amount) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle),
          ),
          const SizedBox(height: 2),
          Text(
            amount != null ? 'Rp ${_fmtNum(amount)}' : '-',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: amount != null ? FontWeight.w700 : FontWeight.normal,
              color: amount != null ? colorTextPrimary : colorGrey,
            ),
          ),
        ],
      );

  Widget _footerRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle)),
            Text(
              value,
              style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
}