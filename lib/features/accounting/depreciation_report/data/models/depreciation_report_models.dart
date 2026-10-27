String _ps(dynamic v) => v?.toString() ?? '';

enum DepreciationRowType { header, saldoAwal, data, total }

DepreciationRowType _parseRowType(dynamic v) {
  switch (v) {
    case 'header':
      return DepreciationRowType.header;
    case 'saldo_awal':
      return DepreciationRowType.saldoAwal;
    case 'total':
      return DepreciationRowType.total;
    default:
      return DepreciationRowType.data;
  }
}

class DepreciationReportRow {
  final DepreciationRowType rowType;
  final String no;
  final String journalDate;
  final String reference;
  final String journalDescription;
  final String debit;
  final String credit;
  final String saldo;

  DepreciationReportRow({
    required this.rowType,
    required this.no,
    required this.journalDate,
    required this.reference,
    required this.journalDescription,
    required this.debit,
    required this.credit,
    required this.saldo,
  });

  factory DepreciationReportRow.fromJson(Map<String, dynamic> j) =>
      DepreciationReportRow(
        rowType: _parseRowType(j['row_type']),
        no: _ps(j['no']),
        journalDate: _ps(j['journal_date']),
        reference: _ps(j['reference']),
        journalDescription: _ps(j['journal_description']),
        debit: _ps(j['debit']),
        credit: _ps(j['credit']),
        saldo: _ps(j['saldo']),
      );
}

class DepreciationReportFilters {
  final String? dateFrom;
  final String? dateTo;

  DepreciationReportFilters({this.dateFrom, this.dateTo});

  factory DepreciationReportFilters.fromJson(Map<String, dynamic> j) =>
      DepreciationReportFilters(
        dateFrom: j['date_from']?.toString(),
        dateTo: j['date_to']?.toString(),
      );
}

class DepreciationReportResult {
  final DepreciationReportFilters filters;
  final List<DepreciationReportRow> rows;

  DepreciationReportResult({required this.filters, required this.rows});

  factory DepreciationReportResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return DepreciationReportResult(
      filters: DepreciationReportFilters.fromJson(
          data['filters'] as Map<String, dynamic>? ?? {}),
      rows: (data['rows'] as List? ?? [])
          .map((e) => DepreciationReportRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}