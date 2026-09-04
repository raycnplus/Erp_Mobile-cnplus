class DirectPurchaseReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  DirectPurchaseReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory DirectPurchaseReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectPurchaseReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class DirectPurchaseReportSummary {
  final String totalAmountRaw;
  final int totalRecords;

  DirectPurchaseReportSummary({
    required this.totalAmountRaw,
    required this.totalRecords,
  });

  factory DirectPurchaseReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectPurchaseReportSummary(
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
      totalRecords:
          json['total_records'] ?? 0,
    );
  }
}

class DirectPurchaseReportModel {
  final int idDirectPurchase;
  final String reference;
  final String prReference;
  final String vendorName;
  final String destinationWarehouse;
  final String destinationLocation;
  final String totalAmountRaw;
  final String status;
  final String createdDate;

  DirectPurchaseReportModel({
    required this.idDirectPurchase,
    required this.reference,
    required this.prReference,
    required this.vendorName,
    required this.destinationWarehouse,
    required this.destinationLocation,
    required this.totalAmountRaw,
    required this.status,
    required this.createdDate,
  });

  factory DirectPurchaseReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectPurchaseReportModel(
      idDirectPurchase:
          json['id_direct_purchase'] ?? 0,
      reference:
          json['reference'] ?? '-',
      prReference:
          json['pr_reference'] ?? '-',
      vendorName:
          json['vendor_name'] ?? '-',
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

class DirectPurchaseVendorOption {
  final int idVendor;
  final String vendorName;

  DirectPurchaseVendorOption({
    required this.idVendor,
    required this.vendorName,
  });

  factory DirectPurchaseVendorOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectPurchaseVendorOption(
      idVendor:
          json['id_vendor'] ?? 0,
      vendorName:
          json['vendor_name'] ?? '-',
    );
  }
}

class DirectPurchaseWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  DirectPurchaseWarehouseOption({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory DirectPurchaseWarehouseOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectPurchaseWarehouseOption(
      idWarehouse:
          json['id_warehouse'] ?? 0,
      warehouseName:
          json['warehouse_name'] ?? '-',
    );
  }
}

class DirectPurchaseLocationOption {
  final int idLocation;
  final String locationName;

  DirectPurchaseLocationOption({
    required this.idLocation,
    required this.locationName,
  });

  factory DirectPurchaseLocationOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return DirectPurchaseLocationOption(
      idLocation:
          json['id_location'] ?? 0,
      locationName:
          json['location_name'] ?? '-',
    );
  }
}

class DirectPurchaseReportFormOptions {
  final List<DirectPurchaseWarehouseOption>
      warehouses;

  final List<DirectPurchaseVendorOption>
      vendors;

  DirectPurchaseReportFormOptions({
    required this.warehouses,
    required this.vendors,
  });

  factory DirectPurchaseReportFormOptions.fromJson(
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

    return DirectPurchaseReportFormOptions(
      warehouses: warehouseData
          .map(
            (e) =>
                DirectPurchaseWarehouseOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      vendors: vendorData
          .map(
            (e) =>
                DirectPurchaseVendorOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}