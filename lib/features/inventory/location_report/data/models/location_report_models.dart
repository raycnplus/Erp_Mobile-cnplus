enum LocationDetailType { products, children, receipts, deliveries, transfers }

int _toInt(dynamic v) => int.tryParse('${v ?? 0}') ?? 0;
double _toDouble(dynamic v) => double.tryParse('${v ?? 0}') ?? 0;

class LocationReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  LocationReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory LocationReportPaginationMeta.fromJson(Map<String, dynamic> json) {
    return LocationReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class LocationReportModel {
  final int idLocation;
  final String encryption;
  final String locationName;
  final String locationCode;
  final String warehouseName;
  final String parentName;
  final int totalProduct;
  final int totalChild;
  final int totalReceiptNote;
  final int totalDeliveryNote;
  final int totalInternalTransfer;

  LocationReportModel({
    required this.idLocation,
    required this.encryption,
    required this.locationName,
    required this.locationCode,
    required this.warehouseName,
    required this.parentName,
    required this.totalProduct,
    required this.totalChild,
    required this.totalReceiptNote,
    required this.totalDeliveryNote,
    required this.totalInternalTransfer,
  });

  factory LocationReportModel.fromJson(Map<String, dynamic> json) {
    return LocationReportModel(
      idLocation: json['id_location'] ?? 0,
      encryption: json['encryption'] ?? '',
      locationName: json['location_name'] ?? '',
      locationCode: json['location_code'] ?? '',
      warehouseName: json['name_warehouse'] ?? '-',
      parentName: json['parent_name'] ?? '-',
      totalProduct: _toInt(json['total_product']),
      totalChild: _toInt(json['total_child']),
      totalReceiptNote: _toInt(json['total_receipt_note']),
      totalDeliveryNote: _toInt(json['total_delivery_note']),
      totalInternalTransfer: _toInt(json['total_internal_transfer']),
    );
  }
}

class LocationSummaryModel {
  final int product;
  final int child;
  final int receipt;
  final int delivery;
  final int transfer;

  LocationSummaryModel({
    required this.product,
    required this.child,
    required this.receipt,
    required this.delivery,
    required this.transfer,
  });

  factory LocationSummaryModel.fromJson(Map<String, dynamic> json) {
    return LocationSummaryModel(
      product: _toInt(json['product']),
      child: _toInt(json['child']),
      receipt: _toInt(json['receipt']),
      delivery: _toInt(json['delivery']),
      transfer: _toInt(json['transfer']),
    );
  }
}

class LocationReportDetailModel {
  final int idLocation;
  final String encryption;
  final String locationName;
  final String locationCode;
  final String? warehouseName;
  final String? parentName;
  final LocationSummaryModel summary;

  LocationReportDetailModel({
    required this.idLocation,
    required this.encryption,
    required this.locationName,
    required this.locationCode,
    this.warehouseName,
    this.parentName,
    required this.summary,
  });

  factory LocationReportDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return LocationReportDetailModel(
      idLocation: data['id_location'] ?? 0,
      encryption: data['encryption'] ?? '',
      locationName: data['location_name'] ?? '',
      locationCode: data['location_code'] ?? '',
      warehouseName: data['warehouse_name'],
      parentName: data['parent_name'],
      summary: LocationSummaryModel.fromJson(
        (data['summary'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }
}

class LocationDetailPageMeta {
  final int total;
  final int from;
  final int to;
  final int page;
  final int lastPage;

  LocationDetailPageMeta({
    required this.total,
    required this.from,
    required this.to,
    required this.page,
    required this.lastPage,
  });

  factory LocationDetailPageMeta.fromJson(Map<String, dynamic> json) {
    return LocationDetailPageMeta(
      total: _toInt(json['total']),
      from: _toInt(json['from']),
      to: _toInt(json['to']),
      page: json['page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
    );
  }
}

class LocationDetailPage<T> {
  final List<T> items;
  final LocationDetailPageMeta meta;

  LocationDetailPage({required this.items, required this.meta});
}

class LocationStockModel {
  final String productName;
  final double stockQty;
  final double reservedQty;
  final double onHand;

  LocationStockModel({
    required this.productName,
    required this.stockQty,
    required this.reservedQty,
    required this.onHand,
  });

  factory LocationStockModel.fromJson(Map<String, dynamic> json) {
    return LocationStockModel(
      productName: json['product_name'] ?? '-',
      stockQty: _toDouble(json['stock_qty']),
      reservedQty: _toDouble(json['reserved_qty']),
      onHand: _toDouble(json['on_hand']),
    );
  }
}

class LocationChildModel {
  final String locationName;
  final String locationCode;
  final int totalProduct;

  LocationChildModel({
    required this.locationName,
    required this.locationCode,
    required this.totalProduct,
  });

  factory LocationChildModel.fromJson(Map<String, dynamic> json) {
    return LocationChildModel(
      locationName: json['location_name'] ?? '-',
      locationCode: json['location_code'] ?? '-',
      totalProduct: _toInt(json['total_product']),
    );
  }
}

class LocationNoteModel {
  final String reference;
  final String? scheduledDate;
  final String? dateOfTransfer;
  final String sourceDocument;
  final String status;

  LocationNoteModel({
    required this.reference,
    this.scheduledDate,
    this.dateOfTransfer,
    required this.sourceDocument,
    required this.status,
  });

  factory LocationNoteModel.fromJson(Map<String, dynamic> json) {
    return LocationNoteModel(
      reference: json['reference'] ?? '-',
      scheduledDate: json['scheduled_date'],
      dateOfTransfer: json['date_of_transfer'],
      sourceDocument: json['source_document'] ?? '-',
      status: json['status'] ?? '-',
    );
  }
}

class LocationTransferModel {
  final String reference;
  final String sourceName;
  final String destinationName;
  final String? scheduledDate;
  final String status;

  LocationTransferModel({
    required this.reference,
    required this.sourceName,
    required this.destinationName,
    this.scheduledDate,
    required this.status,
  });

  factory LocationTransferModel.fromJson(Map<String, dynamic> json) {
    return LocationTransferModel(
      reference: json['reference'] ?? '-',
      sourceName: json['source_name'] ?? '-',
      destinationName: json['destination_name'] ?? '-',
      scheduledDate: json['scheduled_date'],
      status: json['status'] ?? '-',
    );
  }
}

class WarehouseOptionModel {
  final int idWarehouse;
  final String warehouseName;

  WarehouseOptionModel({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory WarehouseOptionModel.fromJson(Map<String, dynamic> json) {
    return WarehouseOptionModel(
      idWarehouse: json['id_warehouse'] ?? 0,
      warehouseName: json['warehouse_name'] ?? '',
    );
  }
}