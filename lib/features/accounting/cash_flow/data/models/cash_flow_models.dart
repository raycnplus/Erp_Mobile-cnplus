double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

enum CashFlowRowType { header, data, subtotal, total }

CashFlowRowType _parseRowType(dynamic v) {
  switch (v) {
    case 'header':
      return CashFlowRowType.header;
    case 'subtotal':
      return CashFlowRowType.subtotal;
    case 'total':
      return CashFlowRowType.total;
    default:
      return CashFlowRowType.data;
  }
}

class CashFlowDateLabel {
  final String date;
  final String label;

  CashFlowDateLabel({required this.date, required this.label});

  factory CashFlowDateLabel.fromJson(Map<String, dynamic> j) => CashFlowDateLabel(
        date:  _ps(j['date']),
        label: _ps(j['label']),
      );
}

class CashFlowRow {
  final CashFlowRowType rowType;
  final String? level;
  final String coaName;
  final List<double> amounts;

  CashFlowRow({
    required this.rowType,
    this.level,
    required this.coaName,
    required this.amounts,
  });

  factory CashFlowRow.fromJson(Map<String, dynamic> j) => CashFlowRow(
        rowType: _parseRowType(j['row_type']),
        level:   j['level']?.toString(),
        coaName: _ps(j['coa_name']),
        amounts: (j['amounts'] as List? ?? []).map((e) => _pd(e)).toList(),
      );

  bool get isMainTotal => rowType == CashFlowRowType.total && level == 'main';
}

class CashFlowFilters {
  final List<CashFlowDateLabel> dates;
  final String filterType;
  final String periodLabel;

  CashFlowFilters({
    required this.dates,
    required this.filterType,
    required this.periodLabel,
  });

  factory CashFlowFilters.fromJson(Map<String, dynamic> j) => CashFlowFilters(
        dates: (j['dates'] as List? ?? [])
            .map((e) => CashFlowDateLabel.fromJson(e as Map<String, dynamic>))
            .toList(),
        filterType:  _ps(j['filter_type']),
        periodLabel: _ps(j['period_label']),
      );
}

class CashFlowResult {
  final CashFlowFilters filters;
  final List<CashFlowRow> rows;

  CashFlowResult({required this.filters, required this.rows});

  factory CashFlowResult.fromJson(Map<String, dynamic> json) => CashFlowResult(
        filters: CashFlowFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {}),
        rows: (json['data'] as List? ?? [])
            .map((e) => CashFlowRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  List<CashFlowDateLabel> get dates => filters.dates;

  String get periodLabel => filters.periodLabel;

  CashFlowRow? get closingBalanceRow {
    final totals = rows.where((r) => r.isMainTotal).toList();
    return totals.isNotEmpty ? totals.last : null;
  }
}
