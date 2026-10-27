double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

enum BalanceStatus { balance, mismatch }

BalanceStatus _parseStatus(dynamic v) => v == 'Balance' ? BalanceStatus.balance : BalanceStatus.mismatch;

class CheckBalanceJournalRow {
  final String? transactionDate; 
  final String reference;
  final String description;
  final String sourceType;
  final double debit;
  final double credit;
  final BalanceStatus status;

  CheckBalanceJournalRow({
    this.transactionDate,
    required this.reference,
    required this.description,
    required this.sourceType,
    required this.debit,
    required this.credit,
    required this.status,
  });

  factory CheckBalanceJournalRow.fromJson(Map<String, dynamic> j) => CheckBalanceJournalRow(
        transactionDate: j['transaction_date']?.toString(),
        reference:       _ps(j['reference']),
        description:     _ps(j['description']),
        sourceType:      _ps(j['source_type']),
        debit:           _pd(j['debit']),
        credit:          _pd(j['credit']),
        status:          _parseStatus(j['balance_status']),
      );

  bool get isBalanced => status == BalanceStatus.balance;
}

class CheckBalanceJournalFilters {
  final String? dateFrom;
  final String? dateTo;

  CheckBalanceJournalFilters({this.dateFrom, this.dateTo});

  factory CheckBalanceJournalFilters.fromJson(Map<String, dynamic> j) => CheckBalanceJournalFilters(
        dateFrom: j['date_from']?.toString(),
        dateTo:   j['date_to']?.toString(),
      );
}

class CheckBalanceJournalResult {
  final CheckBalanceJournalFilters filters;
  final List<CheckBalanceJournalRow> rows;

  CheckBalanceJournalResult({required this.filters, required this.rows});

  factory CheckBalanceJournalResult.fromJson(Map<String, dynamic> json) => CheckBalanceJournalResult(
        filters: CheckBalanceJournalFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {}),
        rows: (json['data'] as List? ?? [])
            .map((e) => CheckBalanceJournalRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  int get mismatchCount => rows.where((r) => !r.isBalanced).length;
  int get balanceCount => rows.where((r) => r.isBalanced).length;
}