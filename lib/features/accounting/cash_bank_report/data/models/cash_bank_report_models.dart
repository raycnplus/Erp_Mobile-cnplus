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

class CashBankCoaLine {
  final String? coaNumber;
  final String coaName;
  final double lineDebit;
  final double lineCredit;

  CashBankCoaLine({
    this.coaNumber,
    required this.coaName,
    required this.lineDebit,
    required this.lineCredit,
  });

  factory CashBankCoaLine.fromJson(Map<String, dynamic> j) => CashBankCoaLine(
        coaNumber:  j['coa_number']?.toString(),
        coaName:    _ps(j['coa_name']),
        lineDebit:  _pd(j['line_debit']),
        lineCredit: _pd(j['line_credit']),
      );

  String get display => coaNumber?.isNotEmpty == true ? '$coaNumber - $coaName' : coaName;
}

class CashBankTransaction {
  final String? transactionDate;
  final String? reference;
  final String description;
  final double debit;
  final double credit;
  final double saldo;
  final List<CashBankCoaLine> coaLines;

  CashBankTransaction({
    this.transactionDate,
    this.reference,
    required this.description,
    required this.debit,
    required this.credit,
    required this.saldo,
    required this.coaLines,
  });

  factory CashBankTransaction.fromJson(Map<String, dynamic> j) => CashBankTransaction(
        transactionDate: j['transaction_date']?.toString(),
        reference:       j['reference']?.toString(),
        description:     _ps(j['description']),
        debit:           _pd(j['debit']),
        credit:          _pd(j['credit']),
        saldo:           _pd(j['saldo']),
        coaLines: (j['coa_lines'] as List? ?? [])
            .map((e) => CashBankCoaLine.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  bool get isDebit => debit > 0;
}

class CashBankAccountReport {
  final String? accountId;
  final String? coaNumber;
  final String? coaName;
  final double saldoAwal;
  final List<CashBankTransaction> transactions;
  final double totalDebit;
  final double totalCredit;
  final double saldoAkhir;

  CashBankAccountReport({
    this.accountId,
    this.coaNumber,
    this.coaName,
    required this.saldoAwal,
    required this.transactions,
    required this.totalDebit,
    required this.totalCredit,
    required this.saldoAkhir,
  });

  factory CashBankAccountReport.fromAccountRow(Map<String, dynamic> j) => CashBankAccountReport(
        accountId:  j['account_id']?.toString(),
        coaNumber:  j['coa_number']?.toString(),
        coaName:    j['coa_name']?.toString(),
        saldoAwal:  _pd(j['saldo_awal']),
        transactions: (j['transactions'] as List? ?? [])
            .map((e) => CashBankTransaction.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalDebit:  _pd(j['total_debit']),
        totalCredit: _pd(j['total_credit']),
        saldoAkhir:  _pd(j['saldo_akhir']),
      );

  factory CashBankAccountReport.fromFlatRows({
    required String? accountId,
    String? coaNumber,
    String? coaName,
    required double saldoAwal,
    required List<CashBankTransaction> transactions,
    required Map<String, dynamic> endingRow,
  }) =>
      CashBankAccountReport(
        accountId:   accountId,
        coaNumber:   coaNumber,
        coaName:     coaName,
        saldoAwal:   saldoAwal,
        transactions: transactions,
        totalDebit:  _pd(endingRow['total_debit']),
        totalCredit: _pd(endingRow['total_credit']),
        saldoAkhir:  _pd(endingRow['saldo']),
      );

  String get display {
    if (coaNumber?.isNotEmpty == true && coaName?.isNotEmpty == true) return '$coaNumber - $coaName';
    return coaName ?? coaNumber ?? '-';
  }
}

class CashBankGrandTotal {
  final double saldoAwal;
  final double totalDebit;
  final double totalCredit;
  final double saldoAkhir;

  CashBankGrandTotal({
    required this.saldoAwal,
    required this.totalDebit,
    required this.totalCredit,
    required this.saldoAkhir,
  });

  factory CashBankGrandTotal.fromJson(Map<String, dynamic> j) => CashBankGrandTotal(
        saldoAwal:   _pd(j['saldo_awal']),
        totalDebit:  _pd(j['total_debit']),
        totalCredit: _pd(j['total_credit']),
        saldoAkhir:  _pd(j['saldo_akhir']),
      );
}

class CashBankReportFilters {
  final String? dateFrom;
  final String? dateTo;
  final String accountId;
  final String type;

  CashBankReportFilters({
    this.dateFrom,
    this.dateTo,
    required this.accountId,
    required this.type,
  });

  factory CashBankReportFilters.fromJson(Map<String, dynamic> j) => CashBankReportFilters(
        dateFrom:  j['dateFrom']?.toString(),
        dateTo:    j['dateTo']?.toString(),
        accountId: _ps(j['accountId']).isEmpty ? 'All' : _ps(j['accountId']),
        type:      _ps(j['type']).isEmpty ? 'All' : _ps(j['type']),
      );
}

class CashBankReportResult {
  final CashBankReportFilters filters;
  final List<CashBankAccountReport> accounts;
  final CashBankGrandTotal? grandTotal;

  CashBankReportResult({
    required this.filters,
    required this.accounts,
    this.grandTotal,
  });

  factory CashBankReportResult.fromJson(Map<String, dynamic> json) {
    final filters = CashBankReportFilters.fromJson(json['filters'] as Map<String, dynamic>? ?? {});
    final rawRows = (json['data'] as List? ?? []).cast<Map<String, dynamic>>();

    final accounts = <CashBankAccountReport>[];
    CashBankGrandTotal? grandTotal;

    double? pendingSaldoAwal;
    List<CashBankTransaction> pendingTransactions = [];

    for (final row in rawRows) {
      switch (row['row_type']) {
        case 'account':
          accounts.add(CashBankAccountReport.fromAccountRow(row));
          break;

        case 'grand_total':
          grandTotal = CashBankGrandTotal.fromJson(row);
          break;

        case 'saldo_awal':
          pendingSaldoAwal = _pd(row['saldo']);
          pendingTransactions = [];
          break;

        case 'data':
          pendingTransactions.add(CashBankTransaction.fromJson(row));
          break;

        case 'account_ending':
          accounts.add(CashBankAccountReport.fromFlatRows(
            accountId: filters.accountId == 'All' ? null : filters.accountId,
            saldoAwal: pendingSaldoAwal ?? 0,
            transactions: pendingTransactions,
            endingRow: row,
          ));
          pendingSaldoAwal = null;
          pendingTransactions = [];
          break;
      }
    }

    return CashBankReportResult(filters: filters, accounts: accounts, grandTotal: grandTotal);
  }

  double get grandTotalDebit => grandTotal?.totalDebit ?? accounts.fold(0.0, (s, c) => s + c.totalDebit);
  double get grandTotalCredit => grandTotal?.totalCredit ?? accounts.fold(0.0, (s, c) => s + c.totalCredit);

  double get endingBalance => grandTotal?.saldoAkhir
      ?? (accounts.length == 1 ? accounts.first.saldoAkhir : accounts.fold(0.0, (s, a) => s + a.saldoAkhir));
}

enum CashBankReportRowType { header, saldoAwal, transaction, coaLine, total, grandTotal }

class CashBankReportRow {
  final CashBankReportRowType type;
  final String? transactionDate;
  final String? reference;
  final String description;
  final double? debit;
  final double? credit;
  final double? saldo;

  CashBankReportRow({
    required this.type,
    this.transactionDate,
    this.reference,
    required this.description,
    this.debit,
    this.credit,
    this.saldo,
  });
}

extension CashBankReportRowsX on CashBankReportResult {
  List<CashBankReportRow> toRows() {
    final rows = <CashBankReportRow>[];
    for (final acc in accounts) {
      rows.add(CashBankReportRow(
        type: CashBankReportRowType.header,
        description: acc.display,
      ));
      rows.add(CashBankReportRow(
        type: CashBankReportRowType.saldoAwal,
        description: 'Opening Balance',
        saldo: acc.saldoAwal,
      ));
      for (final t in acc.transactions) {
        rows.add(CashBankReportRow(
          type: CashBankReportRowType.transaction,
          transactionDate: t.transactionDate,
          reference: t.reference,
          description: t.description,
          debit: t.debit,
          credit: t.credit,
          saldo: t.saldo,
        ));
        for (final line in t.coaLines) {
          rows.add(CashBankReportRow(
            type: CashBankReportRowType.coaLine,
            description: line.display,
            debit: line.lineDebit,
            credit: line.lineCredit,
          ));
        }
      }
      rows.add(CashBankReportRow(
        type: CashBankReportRowType.total,
        description: acc.display.isNotEmpty ? 'Ending Balance — ${acc.display}' : 'Ending Balance',
        debit: acc.totalDebit,
        credit: acc.totalCredit,
        saldo: acc.saldoAkhir,
      ));
    }
    if (grandTotal != null) {
      rows.add(CashBankReportRow(
        type: CashBankReportRowType.grandTotal,
        description: 'GRAND TOTAL (All Cash & Bank)',
        debit: grandTotal!.totalDebit,
        credit: grandTotal!.totalCredit,
        saldo: grandTotal!.saldoAkhir,
      ));
    }
    return rows;
  }
}

class CashBankCoaOption {
  final int idCoa;
  final String? coaNumber;
  final String coaName;

  CashBankCoaOption({required this.idCoa, this.coaNumber, required this.coaName});

  factory CashBankCoaOption.fromJson(Map<String, dynamic> j) => CashBankCoaOption(
        idCoa:     _pi(j['id_coa']),
        coaNumber: j['coa_number']?.toString(),
        coaName:   _ps(j['coa_name']),
      );

  String get display => coaNumber?.isNotEmpty == true ? '$coaNumber - $coaName' : coaName;

  @override bool operator ==(Object o) => o is CashBankCoaOption && o.idCoa == idCoa;
  @override int get hashCode => idCoa.hashCode;
}

class CashBankReportFormOptions {
  final List<CashBankCoaOption> accounts;
  final List<String> noteTypes;

  CashBankReportFormOptions({required this.accounts, required this.noteTypes});

  factory CashBankReportFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CashBankReportFormOptions(
      accounts: (data['accounts'] as List? ?? [])
          .map((e) => CashBankCoaOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      noteTypes: (data['note_types'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
