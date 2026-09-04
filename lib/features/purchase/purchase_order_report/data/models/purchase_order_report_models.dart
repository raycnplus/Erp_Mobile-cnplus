class PurchaseOrderReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PurchaseOrderReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PurchaseOrderReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseOrderReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class PurchaseOrderReportSummary {
  final String totalAmountRaw;
  final int totalRecords;

  PurchaseOrderReportSummary({
    required this.totalAmountRaw,
    required this.totalRecords,
  });

  factory PurchaseOrderReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseOrderReportSummary(
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
      totalRecords:
          json['total_records'] ?? 0,
    );
  }
}

class PurchaseOrderReportModel {
  final int idPurchaseOrder;
  final String reference;
  final String vendor;
  final String destinationWarehouse;
  final String destinationLocation;
  final String totalAmountRaw;
  final String status;
  final String createdDate;

  PurchaseOrderReportModel({
    required this.idPurchaseOrder,
    required this.reference,
    required this.vendor,
    required this.destinationWarehouse,
    required this.destinationLocation,
    required this.totalAmountRaw,
    required this.status,
    required this.createdDate,
  });

  factory PurchaseOrderReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseOrderReportModel(
      idPurchaseOrder:
          json['id_purchase_order'] ?? 0,
      reference:
          json['reference'] ?? '-',
      vendor:
          json['vendor'] ?? '-',
      destinationWarehouse:
          json['destination_warehouse'] ?? '-',
      destinationLocation:
          json['destination_location'] ?? '-',
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
      status:
          json['status'] ?? '-',
      createdDate:
          json['created_date_formatted'] ??
          json['created_date'] ??
          '-',
    );
  }
}

class PurchaseOrderVendorOption {
  final int idVendor;
  final String vendorName;

  PurchaseOrderVendorOption({
    required this.idVendor,
    required this.vendorName,
  });

  factory PurchaseOrderVendorOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseOrderVendorOption(
      idVendor:
          json['id_vendor'] ?? 0,
      vendorName:
          json['vendor_name'] ?? '-',
    );
  }
}

class PurchaseOrderWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  PurchaseOrderWarehouseOption({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory PurchaseOrderWarehouseOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseOrderWarehouseOption(
      idWarehouse:
          json['id_warehouse'] ?? 0,
      warehouseName:
          json['warehouse_name'] ?? '-',
    );
  }
}

class PurchaseOrderLocationOption {
  final int idLocation;
  final String locationName;

  PurchaseOrderLocationOption({
    required this.idLocation,
    required this.locationName,
  });

  factory PurchaseOrderLocationOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseOrderLocationOption(
      idLocation:
          json['id_location'] ?? 0,
      locationName:
          json['location_name'] ?? '-',
    );
  }
}

class PurchaseOrderReportFormOptions {
  final List<PurchaseOrderWarehouseOption>
      warehouses;

  final List<PurchaseOrderVendorOption>
      vendors;

  PurchaseOrderReportFormOptions({
    required this.warehouses,
    required this.vendors,
  });

  factory PurchaseOrderReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final warehouseData =
        json['warehouses']
                as List<dynamic>? ??
            [];

    final vendorData =
        json['vendors']
                as List<dynamic>? ??
            [];

    return PurchaseOrderReportFormOptions(
      warehouses: warehouseData
          .map(
            (e) =>
                PurchaseOrderWarehouseOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      vendors: vendorData
          .map(
            (e) =>
                PurchaseOrderVendorOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}