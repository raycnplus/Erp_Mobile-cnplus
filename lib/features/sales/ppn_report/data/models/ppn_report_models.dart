class PPNReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PPNReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PPNReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return PPNReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class PPNReportSummary {
  final int totalTransaction;
  final String totalGrossIncomeRaw;
  final String totalPpnRaw;

  PPNReportSummary({
    required this.totalTransaction,
    required this.totalGrossIncomeRaw,
    required this.totalPpnRaw,
  });

  factory PPNReportSummary.fromJson(Map<String, dynamic> json) {
    return PPNReportSummary(
      totalTransaction: json['total_transaction'] ?? 0,
      totalGrossIncomeRaw:
          '${json['total_gross_income'] ?? '0.00'}',
      totalPpnRaw:
          '${json['total_ppn'] ?? '0.00'}',
    );
  }
}

class PPNReportModel {
  final String soReference;
  final String encryption;
  final String type;
  final String source;
  final String taxWithholderName;
  final String npwp;
  final String grossIncomeRaw;
  final String ppnRaw;
  final String? eBupot;
  final String date;

  PPNReportModel({
    required this.soReference,
    required this.encryption,
    required this.type,
    required this.source,
    required this.taxWithholderName,
    required this.npwp,
    required this.grossIncomeRaw,
    required this.ppnRaw,
    this.eBupot,
    required this.date,
  });

  factory PPNReportModel.fromJson(Map<String, dynamic> json) {
    return PPNReportModel(
      soReference: json['so_reference'] ?? '-',
      encryption: json['encryption'] ?? '',
      type: json['type'] ?? '-',
      source: json['source'] ?? '-',
      taxWithholderName:
          json['tax_withholder_name'] ?? '-',
      npwp: json['npwp'] ?? '-',
      grossIncomeRaw:
          '${json['gross_income'] ?? '0.00'}',
      ppnRaw:
          '${json['ppn'] ?? '0.00'}',
      eBupot: json['e_bupot'],
      date: json['date'] ?? '-',
    );
  }
}