class TopPurchasingProductReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  TopPurchasingProductReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory TopPurchasingProductReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchasingProductReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class TopPurchasingProductReportSummary {
  final String totalDemandQtyRaw;
  final String totalAmountRaw;
  final int totalProducts;

  TopPurchasingProductReportSummary({
    required this.totalDemandQtyRaw,
    required this.totalAmountRaw,
    required this.totalProducts,
  });

  factory TopPurchasingProductReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchasingProductReportSummary(
      totalDemandQtyRaw:
          '${json['total_demand_qty'] ?? '0.00'}',
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
      totalProducts:
          json['total_products'] ?? 0,
    );
  }
}

class TopPurchasingProductReportModel {
  final String product;
  final String vendor;
  final String demandQtyRaw;
  final String totalAmountRaw;

  TopPurchasingProductReportModel({
    required this.product,
    required this.vendor,
    required this.demandQtyRaw,
    required this.totalAmountRaw,
  });

  factory TopPurchasingProductReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchasingProductReportModel(
      product:
          json['product'] ?? '-',
      vendor:
          json['vendor'] ?? '-',
      demandQtyRaw:
          '${json['demand_qty'] ?? '0.00'}',
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
    );
  }
}

class TopPurchasingProductVendorOption {
  final int idVendor;
  final String vendorName;

  TopPurchasingProductVendorOption({
    required this.idVendor,
    required this.vendorName,
  });

  factory TopPurchasingProductVendorOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopPurchasingProductVendorOption(
      idVendor:
          json['id_vendor'] ?? 0,
      vendorName:
          json['vendor_name'] ?? '-',
    );
  }
}

class TopPurchasingProductReportFormOptions {
  final List<TopPurchasingProductVendorOption> vendors;

  TopPurchasingProductReportFormOptions({
    required this.vendors,
  });

  factory TopPurchasingProductReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final vendorData =
        json['vendors'] as List<dynamic>? ?? [];

    return TopPurchasingProductReportFormOptions(
      vendors: vendorData
          .map(
            (e) =>
                TopPurchasingProductVendorOption.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}