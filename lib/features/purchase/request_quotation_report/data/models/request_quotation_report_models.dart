class RequestQuotationReportPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  RequestQuotationReportPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory RequestQuotationReportPaginationMeta.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestQuotationReportPaginationMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }
}

class RequestQuotationReportSummary {
  final String totalAmountRaw;
  final int totalRecords;

  RequestQuotationReportSummary({
    required this.totalAmountRaw,
    required this.totalRecords,
  });

  factory RequestQuotationReportSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestQuotationReportSummary(
      totalAmountRaw:
          '${json['total_amount'] ?? '0.00'}',
      totalRecords:
          json['total_records'] ?? 0,
    );
  }
}

class RequestQuotationReportModel {
  final int idRfq;
  final String reference;
  final int? idVendor;
  final String vendor;
  final int? idWarehouse;
  final String destinationWarehouse;
  final int? idLocation;
  final String destinationLocation;
  final String totalAmountRaw;
  final String status;
  final String createdDate;

  RequestQuotationReportModel({
    required this.idRfq,
    required this.reference,
    required this.idVendor,
    required this.vendor,
    required this.idWarehouse,
    required this.destinationWarehouse,
    required this.idLocation,
    required this.destinationLocation,
    required this.totalAmountRaw,
    required this.status,
    required this.createdDate,
  });

  factory RequestQuotationReportModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestQuotationReportModel(
      idRfq: json['id_rfq'] ?? 0,
      reference: json['reference'] ?? '-',

      idVendor: json['id_vendor'],

      vendor: json['vendor'] ?? '-',

      idWarehouse:
          json['id_warehouse'],

      destinationWarehouse:
          json['destination_warehouse'] ?? '-',

      idLocation:
          json['id_location'],

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

class RequestQuotationVendorOption {
  final int idVendor;
  final String vendorName;

  RequestQuotationVendorOption({
    required this.idVendor,
    required this.vendorName,
  });

  factory RequestQuotationVendorOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestQuotationVendorOption(
      idVendor:
          json['id_vendor'] ?? 0,
      vendorName:
          json['vendor_name'] ?? '-',
    );
  }
}

class RequestQuotationWarehouseOption {
  final int idWarehouse;
  final String warehouseName;

  RequestQuotationWarehouseOption({
    required this.idWarehouse,
    required this.warehouseName,
  });

  factory RequestQuotationWarehouseOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestQuotationWarehouseOption(
      idWarehouse:
          json['id_warehouse'] ?? 0,
      warehouseName:
          json['warehouse_name'] ?? '-',
    );
  }
}

class RequestQuotationLocationOption {
  final int idLocation;
  final String locationName;

  RequestQuotationLocationOption({
    required this.idLocation,
    required this.locationName,
  });

  factory RequestQuotationLocationOption.fromJson(
    Map<String, dynamic> json,
  ) {
    return RequestQuotationLocationOption(
      idLocation:
          json['id_location'] ?? 0,
      locationName:
          json['location_name'] ?? '-',
    );
  }
}

class RequestQuotationReportFormOptions {
  final List<RequestQuotationWarehouseOption>
      warehouses;

  final List<RequestQuotationVendorOption>
      vendors;

  RequestQuotationReportFormOptions({
    required this.warehouses,
    required this.vendors,
  });

  factory RequestQuotationReportFormOptions.fromJson(
    Map<String, dynamic> json,
  ) {
    final warehouseData =
        json['warehouses'] as List<dynamic>? ?? [];

    final vendorData =
        json['vendors'] as List<dynamic>? ?? [];

    return RequestQuotationReportFormOptions(
      warehouses: warehouseData
          .map(
            (e) =>
                RequestQuotationWarehouseOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),

      vendors: vendorData
          .map(
            (e) =>
                RequestQuotationVendorOption
                    .fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}