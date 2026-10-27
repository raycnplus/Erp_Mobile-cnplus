double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString().trim() ?? '';

enum ProfitLossRowType { header, data, subtotal, total }

ProfitLossRowType _parseRowType(dynamic v) {
  switch (v) {
    case 'header':
      return ProfitLossRowType.header;
    case 'subtotal':
      return ProfitLossRowType.subtotal;
    case 'total':
      return ProfitLossRowType.total;
    default:
      return ProfitLossRowType.data;
  }
}

class ProfitLossDateLabel {
  final String date;
  final String label;

  ProfitLossDateLabel({required this.date, required this.label});

  factory ProfitLossDateLabel.fromJson(Map<String, dynamic> j) => ProfitLossDateLabel(
        date:  j['date']?.toString() ?? '',
        label: j['label']?.toString() ?? '',
      );
}

class ProfitLossRow {
  final ProfitLossRowType rowType;
  final String? level; 
  final String? coaNumber;
  final String coaName;
  final List<double> amounts;

  ProfitLossRow({
    required this.rowType,
    this.level,
    this.coaNumber,
    required this.coaName,
    required this.amounts,
  });

  factory ProfitLossRow.fromJson(Map<String, dynamic> j) => ProfitLossRow(
        rowType:   _parseRowType(j['row_type']),
        level:     j['level']?.toString(),
        coaNumber: j['coa_number']?.toString(),
        coaName:   _ps(j['coa_name']),
        amounts:   (j['amounts'] as List? ?? []).map((e) => _pd(e)).toList(),
      );

  bool get isMainTotal => rowType == ProfitLossRowType.total && level == 'main';
  bool get isSubItem => level == 'sub_item';
}

class ProfitLossResult {
  final List<ProfitLossDateLabel> dates;
  final List<ProfitLossRow> rows;

  ProfitLossResult({required this.dates, required this.rows});

  factory ProfitLossResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ProfitLossResult(
      dates: (data['dates'] as List? ?? [])
          .map((e) => ProfitLossDateLabel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rows: (data['result'] as List? ?? [])
          .map((e) => ProfitLossRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<ProfitLossRow> get _mainTotals => rows.where((r) => r.isMainTotal).toList();

  ProfitLossRow? get totalRevenueRow => _mainTotals.isNotEmpty ? _mainTotals.first : null;

  ProfitLossRow? get netProfitRow => _mainTotals.isNotEmpty ? _mainTotals.last : null;
}