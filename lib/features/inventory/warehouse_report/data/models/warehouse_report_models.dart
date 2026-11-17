enum WarehouseDetailType { locations, products, receipts, deliveries, transfers }

int _toInt(dynamic v) => int.tryParse('${v ?? 0}') ?? 0;
double _toDouble(dynamic v) => double.tryParse('${v ?? 0}') ?? 0;

class WarehouseReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  WarehouseReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory WarehouseReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return WarehouseReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class WarehouseReportModel {
  final int idWarehouse;
  final String encryption;
  final String warehouseName;
  final String warehouseCode;
  final int totalLocation;
  final int totalProduct;
  final int totalReceiptNote;
  final int totalDeliveryNote;
  final int totalInternalTransfer;

  WarehouseReportModel({
    required this.idWarehouse,
    required this.encryption,
    required this.warehouseName,
    required this.warehouseCode,
    required this.totalLocation,
    required this.totalProduct,
    required this.totalReceiptNote,
    required this.totalDeliveryNote,
    required this.totalInternalTransfer,
  });

  factory WarehouseReportModel.fromJson(Map<String, dynamic> json) {
    return WarehouseReportModel(
      idWarehouse: json['id_warehouse'] ?? 0,
      encryption: json['encryption'] ?? '',
      warehouseName: json['warehouse_name'] ?? '',
      warehouseCode: json['warehouse_code'] ?? '',
      totalLocation: _toInt(json['total_location']),
      totalProduct: _toInt(json['total_product']),
      totalReceiptNote: _toInt(json['total_receipt_note']),
      totalDeliveryNote: _toInt(json['total_delivery_note']),
      totalInternalTransfer: _toInt(json['total_internal_transfer']),
    );
  }
}

class WarehouseSummaryModel {
  final int location;
  final int product;
  final int receipt;
  final int delivery;
  final int transfer;

  WarehouseSummaryModel({
    required this.location,
    required this.product,
    required this.receipt,
    required this.delivery,
    required this.transfer,
  });

  factory WarehouseSummaryModel.fromJson(Map<String, dynamic> json) {
    return WarehouseSummaryModel(
      location: _toInt(json['location']),
      product: _toInt(json['product']),
      receipt: _toInt(json['receipt']),
      delivery: _toInt(json['delivery']),
      transfer: _toInt(json['transfer']),
    );
  }
}

class WarehouseReportDetailModel {
  final int idWarehouse;
  final String encryption;
  final String warehouseName;
  final String warehouseCode;
  final WarehouseSummaryModel summary;

  WarehouseReportDetailModel({
    required this.idWarehouse,
    required this.encryption,
    required this.warehouseName,
    required this.warehouseCode,
    required this.summary,
  });

  factory WarehouseReportDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return WarehouseReportDetailModel(
      idWarehouse: data['id_warehouse'] ?? 0,
      encryption: data['encryption'] ?? '',
      warehouseName: data['warehouse_name'] ?? '',
      warehouseCode: data['warehouse_code'] ?? '',
      summary: WarehouseSummaryModel.fromJson(
        (data['summary'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class WarehouseDetailPageMeta {
  final int total;
  final int from;
  final int to;
  final int page;
  final int lastPage;

  WarehouseDetailPageMeta({
    required this.total,
    required this.from,
    required this.to,
    required this.page,
    required this.lastPage,
  });

  factory WarehouseDetailPageMeta.fromJson(Map<String, dynamic> json) {
    return WarehouseDetailPageMeta(
      total: _toInt(json['total']),
      from: _toInt(json['from']),
      to: _toInt(json['to']),
      page: json['page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
    );
  }
}

class WarehouseDetailPage<T> {
  final List<T> items;
  final WarehouseDetailPageMeta meta;

  WarehouseDetailPage({required this.items, required this.meta});
}

class WarehouseLocationModel {
  final String locationName;
  final int totalProduct;

  WarehouseLocationModel({
    required this.locationName,
    required this.totalProduct,
  });

  factory WarehouseLocationModel.fromJson(Map<String, dynamic> json) {
    return WarehouseLocationModel(
      locationName: json['location_name'] ?? '-',
      totalProduct: _toInt(json['total_product']),
    );
  }
}

class WarehouseStockModel {
  final String productName;
  final String locationName;
  final double stockQty;
  final double reservedQty;
  final double onHand;

  WarehouseStockModel({
    required this.productName,
    required this.locationName,
    required this.stockQty,
    required this.reservedQty,
    required this.onHand,
  });

  factory WarehouseStockModel.fromJson(Map<String, dynamic> json) {
    return WarehouseStockModel(
      productName: json['product_name'] ?? '-',
      locationName: json['location_name'] ?? '-',
      stockQty: _toDouble(json['stock_qty']),
      reservedQty: _toDouble(json['reserved_qty']),
      onHand: _toDouble(json['on_hand']),
    );
  }
}

class WarehouseNoteModel {
  final String reference;
  final String? scheduledDate;
  final String? dateOfTransfer;
  final String sourceDocument;
  final String status;

  WarehouseNoteModel({
    required this.reference,
    this.scheduledDate,
    this.dateOfTransfer,
    required this.sourceDocument,
    required this.status,
  });

  factory WarehouseNoteModel.fromJson(Map<String, dynamic> json) {
    return WarehouseNoteModel(
      reference: json['reference'] ?? '-',
      scheduledDate: json['scheduled_date'],
      dateOfTransfer: json['date_of_transfer'],
      sourceDocument: json['source_document'] ?? '-',
      status: json['status'] ?? '-',
    );
  }
}

class WarehouseTransferModel {
  final String reference;
  final String sourceName;
  final String destinationName;
  final String? scheduledDate;
  final String status;

  WarehouseTransferModel({
    required this.reference,
    required this.sourceName,
    required this.destinationName,
    this.scheduledDate,
    required this.status,
  });

  factory WarehouseTransferModel.fromJson(Map<String, dynamic> json) {
    return WarehouseTransferModel(
      reference: json['reference'] ?? '-',
      sourceName: json['source_name'] ?? '-',
      destinationName: json['destination_name'] ?? '-',
      scheduledDate: json['scheduled_date'],
      status: json['status'] ?? '-',
    );
  }
}
