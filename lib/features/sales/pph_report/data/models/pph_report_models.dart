class PPHReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PPHReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PPHReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return PPHReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class PPHReportSummary {
  final int totalTransaction;
  final String totalGrossIncomeRaw;
  final String totalPph23Raw;

  PPHReportSummary({
    required this.totalTransaction,
    required this.totalGrossIncomeRaw,
    required this.totalPph23Raw,
  });

  factory PPHReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return PPHReportSummary(
      totalTransaction:
          json['total_transaction'] ?? 0,
      totalGrossIncomeRaw:
          '${json['total_gross_income'] ?? '0.00'}',
      totalPph23Raw:
          '${json['total_pph_23'] ?? '0.00'}',
    );
  }
}

class PPHReportModel {
  final String soReference;
  final String paymentNumber;
  final String type;
  final String taxWithholderName;
  final String npwp;
  final String grossIncomeRaw;
  final String pph23Raw;
  final String? eBupot;
  final String date;

  PPHReportModel({
    required this.soReference,
    required this.paymentNumber,
    required this.type,
    required this.taxWithholderName,
    required this.npwp,
    required this.grossIncomeRaw,
    required this.pph23Raw,
    this.eBupot,
    required this.date,
  });

  factory PPHReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PPHReportModel(
      soReference:
          json['so_reference'] ?? '-',
      paymentNumber:
          json['payment_number'] ?? '-',
      type:
          json['type'] ?? '-',
      taxWithholderName:
          json['tax_withholder_name'] ?? '-',
      npwp:
          json['npwp'] ?? '-',
      grossIncomeRaw:
          '${json['gross_income'] ?? '0.00'}',
      pph23Raw:
          '${json['pph_23'] ?? '0.00'}',
      eBupot:
          json['e_bupot'],
      date:
          json['date'] ?? '-',
    );
  }
}

class PPHReportTaxWithholderOption {
  final int idCustomer;
  final String customerName;
  final String npwp;

  PPHReportTaxWithholderOption({
    required this.idCustomer,
    required this.customerName,
    required this.npwp,
  });

  factory PPHReportTaxWithholderOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return PPHReportTaxWithholderOption(
      idCustomer:
          json['id_customer'] ?? 0,
      customerName:
          json['customer_name'] ?? '-',
      npwp:
          json['npwp'] ?? '-',
    );
  }
}

class PPHReportFormOptions {
  final List<String> types;
  final List<PPHReportTaxWithholderOption>
      taxWithholders;

  PPHReportFormOptions({
    required this.types,
    required this.taxWithholders,
  });

  factory PPHReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final typeData =
        json['types'] as List<dynamic>? ?? [];

    final taxWithholderData =
        json['tax_withholders'] as List<dynamic>? ?? [];

    return PPHReportFormOptions(
      types: typeData
          .map((e) => e.toString())
          .toList(),

      taxWithholders: taxWithholderData
          .map(
            (e) =>
                PPHReportTaxWithholderOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}