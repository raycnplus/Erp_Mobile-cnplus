class TopPurchaseOrderReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  TopPurchaseOrderReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory TopPurchaseOrderReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchaseOrderReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class TopPurchaseOrderReportSummary {
  final String totalAmountRaw;
  final int totalRecords;

  TopPurchaseOrderReportSummary({
    required this.totalAmountRaw,
    required this.totalRecords,
  });

  factory TopPurchaseOrderReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchaseOrderReportSummary(
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
      totalRecords:
          json['total_records'] ?? 0,
    );
  }
}

class TopPurchaseOrderReportModel {
  final int idPurchaseOrder;
  final String encryption;
  final String reference;
  final String vendor;
  final String totalAmountRaw;

  TopPurchaseOrderReportModel({
    required this.idPurchaseOrder,
    required this.encryption,
    required this.reference,
    required this.vendor,
    required this.totalAmountRaw,
  });

  factory TopPurchaseOrderReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchaseOrderReportModel(
      idPurchaseOrder:
          json['id_purchase_order'] ?? 0,
      encryption:
          json['encryption'] ?? '',
      reference:
          json['reference'] ?? '-',
      vendor:
          json['vendor'] ?? '-',
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
    );
  }
}

class TopPurchaseOrderVendorOption {
  final int idVendor;
  final String vendorName;

  TopPurchaseOrderVendorOption({
    required this.idVendor,
    required this.vendorName,
  });

  factory TopPurchaseOrderVendorOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchaseOrderVendorOption(
      idVendor:
          json['id_vendor'] ?? 0,
      vendorName:
          json['vendor_name'] ?? '-',
    );
  }
}

class TopPurchaseOrderReportFormOptions {
  final List<TopPurchaseOrderVendorOption> vendors;

  TopPurchaseOrderReportFormOptions({
    required this.vendors,
  });

  factory TopPurchaseOrderReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final vendorData =
        json['vendors'] as List<dynamic>? ?? [];

    return TopPurchaseOrderReportFormOptions(
      vendors: vendorData
          .map(
            (e) =>
                TopPurchaseOrderVendorOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}