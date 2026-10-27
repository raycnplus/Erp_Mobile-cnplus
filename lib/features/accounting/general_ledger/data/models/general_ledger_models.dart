double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

class GeneralLedgerTransaction {
  final String? journalDate;
  final String? reference;
  final String journalDescription;
  final double debit;
  final double credit;
  final double saldo;

  GeneralLedgerTransaction({
    this.journalDate,
    this.reference,
    required this.journalDescription,
    required this.debit,
    required this.credit,
    required this.saldo,
  });

  factory GeneralLedgerTransaction.fromJson(Map<String, dynamic> j) => GeneralLedgerTransaction(
        journalDate:        j['journal_date']?.toString(),
        reference:          j['reference']?.toString(),
        journalDescription: _ps(j['journal_description']),
        debit:              _pd(j['debit']),
        credit:             _pd(j['credit']),
        saldo:              _pd(j['saldo']),
      );

  bool get isDebit => debit > 0;
}

class GeneralLedgerCoaReport {
  final String? coaNumber;
  final String coaName;
  final double saldoAwal;
  final List<GeneralLedgerTransaction> transactions;
  final double totalDebit;
  final double totalCredit;
  final double saldoAkhir;

  GeneralLedgerCoaReport({
    this.coaNumber,
    required this.coaName,
    required this.saldoAwal,
    required this.transactions,
    required this.totalDebit,
    required this.totalCredit,
    required this.saldoAkhir,
  });

  factory GeneralLedgerCoaReport.fromJson(Map<String, dynamic> j) => GeneralLedgerCoaReport(
        coaNumber:    j['coa_number']?.toString(),
        coaName:      _ps(j['coa_name']),
        saldoAwal:    _pd(j['saldo_awal']),
        transactions: (j['transactions'] as List? ?? [])
            .map((e) => GeneralLedgerTransaction.fromJson(e))
            .toList(),
        totalDebit:   _pd(j['total_debit']),
        totalCredit:  _pd(j['total_credit']),
        saldoAkhir:   _pd(j['saldo_akhir']),
      );

  String get display => coaNumber?.isNotEmpty == true ? '$coaNumber - $coaName' : coaName;
}

class GeneralLedgerFilters {
  final String coaFrom;
  final String coaTo;
  final String? dateFrom;
  final String? dateTo;

  GeneralLedgerFilters({
    required this.coaFrom,
    required this.coaTo,
    this.dateFrom,
    this.dateTo,
  });

  factory GeneralLedgerFilters.fromJson(Map<String, dynamic> j) => GeneralLedgerFilters(
        coaFrom:  _ps(j['coa_from']).isEmpty ? 'All' : _ps(j['coa_from']),
        coaTo:    _ps(j['coa_to']).isEmpty ? 'All' : _ps(j['coa_to']),
        dateFrom: j['date_from']?.toString(),
        dateTo:   j['date_to']?.toString(),
      );
}

class GeneralLedgerReportResult {
  final GeneralLedgerFilters filters;
  final List<GeneralLedgerCoaReport> data;

  GeneralLedgerReportResult({required this.filters, required this.data});

  factory GeneralLedgerReportResult.fromJson(Map<String, dynamic> json) => GeneralLedgerReportResult(
        filters: GeneralLedgerFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {}),
        data: (json['data'] as List? ?? [])
            .map((e) => GeneralLedgerCoaReport.fromJson(e))
            .toList(),
      );

  double get grandTotalDebit => data.fold(0.0, (s, c) => s + c.totalDebit);
  double get grandTotalCredit => data.fold(0.0, (s, c) => s + c.totalCredit);
}

enum GeneralLedgerRowType { header, saldoAwal, transaction, total }

class GeneralLedgerRow {
  final GeneralLedgerRowType type;
  final String? journalDate;
  final String? reference;
  final String description;
  final double? debit;
  final double? credit;
  final double? saldo;

  GeneralLedgerRow({
    required this.type,
    this.journalDate,
    this.reference,
    required this.description,
    this.debit,
    this.credit,
    this.saldo,
  });
}

extension GeneralLedgerReportRowsX on GeneralLedgerReportResult {
  List<GeneralLedgerRow> toRows() {
    final rows = <GeneralLedgerRow>[];
    for (final coa in data) {
      rows.add(GeneralLedgerRow(
        type: GeneralLedgerRowType.header,
        description: coa.display,
      ));
      rows.add(GeneralLedgerRow(
        type: GeneralLedgerRowType.saldoAwal,
        description: 'Beginning Balance',
        saldo: coa.saldoAwal,
      ));
      for (final t in coa.transactions) {
        rows.add(GeneralLedgerRow(
          type: GeneralLedgerRowType.transaction,
          journalDate: t.journalDate,
          reference: t.reference,
          description: t.journalDescription,
          debit: t.debit,
          credit: t.credit,
          saldo: t.saldo,
        ));
      }
      rows.add(GeneralLedgerRow(
        type: GeneralLedgerRowType.total,
        description: 'Total',
        debit: coa.totalDebit,
        credit: coa.totalCredit,
        saldo: coa.saldoAkhir,
      ));
    }
    return rows;
  }
}

class CoaOption {
  final int idCoa;
  final String? coaNumber;
  final String coaName;

  CoaOption({required this.idCoa, this.coaNumber, required this.coaName});

  factory CoaOption.fromJson(Map<String, dynamic> j) => CoaOption(
        idCoa:     _pi(j['id_coa']),
        coaNumber: j['coa_number']?.toString(),
        coaName:   _ps(j['coa_name']),
      );

  String get display => coaNumber?.isNotEmpty == true ? '$coaNumber - $coaName' : coaName;

  @override bool operator ==(Object o) => o is CoaOption && o.idCoa == idCoa;
  @override int get hashCode => idCoa.hashCode;
}

class GeneralLedgerFormOptions {
  final List<CoaOption> coaList;

  GeneralLedgerFormOptions({required this.coaList});

  factory GeneralLedgerFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return GeneralLedgerFormOptions(
      coaList: (data['coa_list'] as List? ?? []).map((e) => CoaOption.fromJson(e)).toList(),
    );
  }
}

class ExportUrlInfo {
  final String url;
  final Map<String, String> headers;
  ExportUrlInfo({required this.url, required this.headers});
}