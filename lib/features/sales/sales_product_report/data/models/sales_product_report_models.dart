class SalesProductReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  SalesProductReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory SalesProductReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesProductReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class SalesProductReportSummary {
  final double totalSalesValue;
  final double totalQty;
  final int totalTransactions;

  final String totalSalesValueRaw;
  final String totalQtyRaw;
  final String totalTransactionsRaw;

  SalesProductReportSummary({
    required this.totalSalesValue,
    required this.totalQty,
    required this.totalTransactions,
    required this.totalSalesValueRaw,
    required this.totalQtyRaw,
    required this.totalTransactionsRaw,
  });

  factory SalesProductReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesProductReportSummary(
      totalSalesValue:
          double.tryParse('${json['total_amount'] ?? 0}') ?? 0,

      totalQty:
          double.tryParse('${json['total_quantity'] ?? 0}') ?? 0,

      totalTransactions:
          int.tryParse('${json['total_transaction'] ?? 0}') ?? 0,

      totalSalesValueRaw:
          '${json['total_amount'] ?? 0}',

      totalQtyRaw:
          '${json['total_quantity'] ?? 0}',

      totalTransactionsRaw:
          '${json['total_transaction'] ?? 0}',
    );
  }
}

class SalesProductReportModel {
  final int idProduct;
  final String productName;
  final String productCode;
  final String productCategory;

  final double qtySold;

  final double avgPrice;
  final String avgPriceRaw;

  final int transactionCount;

  final double salesContribution;
  final double salesValue;
  final String salesValueRaw;

  final String? lastSoldDate;

  SalesProductReportModel({
    required this.idProduct,
    required this.productName,
    required this.productCode,
    required this.productCategory,
    required this.qtySold,
    required this.avgPrice,
    required this.avgPriceRaw,
    required this.transactionCount,
    required this.salesContribution,
    required this.salesValue,
    required this.salesValueRaw,
    this.lastSoldDate,
  });

  factory SalesProductReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesProductReportModel(
      idProduct: json['id_product'] ?? 0,

      productName:
          json['product_name'] ?? '-',

      productCode:
          json['product_code'] ?? '-',

      productCategory:
          json['product_category'] ?? '-',

      qtySold:
          double.tryParse(
            '${json['qty_sold'] ?? 0}',
          ) ??
          0,

      avgPrice:
          double.tryParse(
            '${json['avg_price'] ?? 0}',
          ) ??
          0,

      avgPriceRaw:
          '${json['avg_price'] ?? 0}',

      transactionCount:
          int.tryParse(
            '${json['transaction_count'] ?? 0}',
          ) ??
          0,

      salesContribution:
          double.tryParse(
            '${json['sales_contribution'] ?? 0}',
          ) ??
          0,

      salesValue:
          double.tryParse(
            '${json['sales_value'] ?? 0}',
          ) ??
          0,

      salesValueRaw:
          '${json['sales_value'] ?? 0}',

      lastSoldDate:
          json['last_sold_date_formatted'] ??
          json['last_sold_date'],
    );
  }
}

class SalesProductOption {
  final int idProduct;
  final String productCode;
  final String productName;

  SalesProductOption({
    required this.idProduct,
    required this.productCode,
    required this.productName,
  });

  factory SalesProductOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesProductOption(
      idProduct: json['id_product'] ?? 0,
      productCode: json['product_code'] ?? '',
      productName: json['product_name'] ?? '',
    );
  }
}

class SalesProductCategoryOption {
  final int idProductCategory;
  final String productCategoryName;

  SalesProductCategoryOption({
    required this.idProductCategory,
    required this.productCategoryName,
  });

  factory SalesProductCategoryOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return SalesProductCategoryOption(
      idProductCategory: json['id_product_category'] ?? 0,
      productCategoryName: json['product_category_name'] ?? '',
    );
  }
}