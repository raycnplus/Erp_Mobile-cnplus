double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString().trim() ?? '';

enum BalanceSheetRowType { header, data, subtotal, total }

BalanceSheetRowType _parseRowType(dynamic v) {
  switch (v) {
    case 'header':
      return BalanceSheetRowType.header;
    case 'subtotal':
      return BalanceSheetRowType.subtotal;
    case 'total':
      return BalanceSheetRowType.total;
    default:
      return BalanceSheetRowType.data;
  }
}

class BalanceSheetDateLabel {
  final String date;
  final String label;

  BalanceSheetDateLabel({required this.date, required this.label});

  factory BalanceSheetDateLabel.fromJson(Map<String, dynamic> j) => BalanceSheetDateLabel(
        date:  j['date']?.toString() ?? '',
        label: j['label']?.toString() ?? '',
      );
}

class BalanceSheetRow {
  final BalanceSheetRowType rowType;
  final String? level;
  final String coaName;
  final List<double> amounts;

  BalanceSheetRow({
    required this.rowType,
    this.level,
    required this.coaName,
    required this.amounts,
  });

  factory BalanceSheetRow.fromJson(Map<String, dynamic> j) => BalanceSheetRow(
        rowType: _parseRowType(j['row_type']),
        level:   j['level']?.toString(),
        coaName: _ps(j['coa_name']),
        amounts: (j['amounts'] as List? ?? []).map((e) => _pd(e)).toList(),
      );

  bool get isMainTotal => rowType == BalanceSheetRowType.total && level == 'main';
  bool get isSubItem => level == 'sub_item';
}

class BalanceSheetResult {
  final List<BalanceSheetDateLabel> dates;
  final List<BalanceSheetRow> rows;

  BalanceSheetResult({required this.dates, required this.rows});

  factory BalanceSheetResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BalanceSheetResult(
      dates: (data['dates'] as List? ?? [])
          .map((e) => BalanceSheetDateLabel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rows: (data['result'] as List? ?? [])
          .map((e) => BalanceSheetRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  BalanceSheetRow? get totalLiabilitiesAndEquityRow {
    final totals = rows.where((r) => r.isMainTotal).toList();
    return totals.isNotEmpty ? totals.last : null;
  }

  BalanceSheetRow? get totalAssetsRow {
    final totals = rows.where((r) => r.isMainTotal).toList();
    return totals.isNotEmpty ? totals.first : null;
  }
}