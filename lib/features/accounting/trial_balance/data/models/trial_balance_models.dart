double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

enum TrialBalanceRowType { data, subtotal, grandTotal }

TrialBalanceRowType _parseRowType(dynamic v) {
  switch (v) {
    case 'subtotal':
      return TrialBalanceRowType.subtotal;
    case 'total':
      return TrialBalanceRowType.grandTotal;
    default:
      return TrialBalanceRowType.data;
  }
}

class TrialBalanceRow {
  final TrialBalanceRowType rowType;
  final String? coaNumber;
  final String coaName;
  final double saldoAwalDebit;
  final double saldoAwalKredit;
  final double mutasiDebit;
  final double mutasiKredit;
  final double saldoAkhirDebit;
  final double saldoAkhirKredit;

  TrialBalanceRow({
    required this.rowType,
    this.coaNumber,
    required this.coaName,
    required this.saldoAwalDebit,
    required this.saldoAwalKredit,
    required this.mutasiDebit,
    required this.mutasiKredit,
    required this.saldoAkhirDebit,
    required this.saldoAkhirKredit,
  });

  factory TrialBalanceRow.fromJson(Map<String, dynamic> j) => TrialBalanceRow(
        rowType:          _parseRowType(j['row_type']),
        coaNumber:        j['coa_number']?.toString(),
        coaName:          _ps(j['coa_name']),
        saldoAwalDebit:   _pd(j['saldo_awal_debit']),
        saldoAwalKredit:  _pd(j['saldo_awal_kredit']),
        mutasiDebit:      _pd(j['mutasi_debit']),
        mutasiKredit:     _pd(j['mutasi_kredit']),
        saldoAkhirDebit:  _pd(j['saldo_akhir_debit']),
        saldoAkhirKredit: _pd(j['saldo_akhir_kredit']),
      );
}

class TrialBalanceFilters {
  final String? dateFrom;
  final String? dateTo;

  TrialBalanceFilters({this.dateFrom, this.dateTo});

  factory TrialBalanceFilters.fromJson(Map<String, dynamic> j) => TrialBalanceFilters(
        dateFrom: j['date_from']?.toString(),
        dateTo:   j['date_to']?.toString(),
      );
}

class TrialBalanceResult {
  final TrialBalanceFilters filters;
  final List<TrialBalanceRow> rows;

  TrialBalanceResult({required this.filters, required this.rows});

  factory TrialBalanceResult.fromJson(Map<String, dynamic> json) => TrialBalanceResult(
        filters: TrialBalanceFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {}),
        rows: (json['data'] as List? ?? [])
            .map((e) => TrialBalanceRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  TrialBalanceRow? get _grandTotalRow =>
      rows.where((r) => r.rowType == TrialBalanceRowType.grandTotal).isNotEmpty
          ? rows.firstWhere((r) => r.rowType == TrialBalanceRowType.grandTotal)
          : null;

  double get totalSaldoAwalDebit => _grandTotalRow?.saldoAwalDebit ?? 0;
  double get totalSaldoAwalKredit => _grandTotalRow?.saldoAwalKredit ?? 0;
  double get totalMutasiDebit => _grandTotalRow?.mutasiDebit ?? 0;
  double get totalMutasiKredit => _grandTotalRow?.mutasiKredit ?? 0;
  double get totalSaldoAkhirDebit => _grandTotalRow?.saldoAkhirDebit ?? 0;
  double get totalSaldoAkhirKredit => _grandTotalRow?.saldoAkhirKredit ?? 0;
}