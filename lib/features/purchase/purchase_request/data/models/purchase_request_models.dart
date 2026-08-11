double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

class PurchaseRequestModel {
  final String encryption;
  final String status;
  final String? reference;
  final String? requestedByName;
  final String? warehouseName;
  final String? locationName;
  final String? requestDate;

  PurchaseRequestModel({
    required this.encryption,
    required this.status,
    this.reference,
    this.requestedByName,
    this.warehouseName,
    this.locationName,
    this.requestDate,
  });

  factory PurchaseRequestModel.fromJson(Map<String, dynamic> j) {
    return PurchaseRequestModel(
      encryption: _ps(j['encryption']),
      status: _ps(j['status']),
      reference: j['reference']?.toString(),
      requestedByName: j['requested_by_name']?.toString(),
      warehouseName: j['warehouse_name']?.toString(),
      locationName: j['location_name']?.toString(),
      requestDate: j['requested_date']?.toString(),
    );
  }

  static const _statusColors = <String, int>{
    'Draft': 0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed': 0xFF1565C0,
    'Done': 0xFF2E7D32,
    'Cancelled': 0xFFC62828,
    'Closed': 0xFF546E7A,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class PurchaseRequestPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PurchaseRequestPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class PurchaseRequestItem {
  final int idPurchaseRequestItem;
  final int idProduct;
  final int? unitOfMeasure;
  final String? productName;
  final String? description;
  final String? uomName;
  final double demandQty;
  final double estimatedUnitPrice;
  final double totalEstimatedPrice;

  PurchaseRequestItem({
    required this.idPurchaseRequestItem,
    required this.idProduct,
    this.unitOfMeasure,
    this.productName,
    this.description,
    this.uomName,
    required this.demandQty,
    required this.estimatedUnitPrice,
    required this.totalEstimatedPrice,
  });

  factory PurchaseRequestItem.fromJson(Map<String, dynamic> j) {
    return PurchaseRequestItem(
      idPurchaseRequestItem: _pi(j['id_purchase_request_item']),
      idProduct: _pi(j['id_product']),
      unitOfMeasure: _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
      productName: j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
      description: j['description']?.toString(),
      uomName: j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
      demandQty: _pd(j['demand_qty']),
      estimatedUnitPrice: _pd(j['estimated_unit_price']),
      totalEstimatedPrice: _pd(j['total_estimated_price']),
    );
  }
}

class PurchaseRequestAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  PurchaseRequestAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory PurchaseRequestAuditTrail.fromJson(Map<String, dynamic> j) {
    return PurchaseRequestAuditTrail(
      actionByName: j['action_by_name']?.toString(),
      actionById: j['action_by']?.toString(),
      description: j['description']?.toString(),
      type: j['type']?.toString(),
      date: j['date']?.toString(),
    );
  }
}

class PurchaseRequestDetailModel {
  final int idPurchaseRequest;
  final String encryption;
  final String status;
  final String? reference;
  final int? requestedBy;
  final String? requestedByName;
  final int? idVendor;
  final String? vendorName;
  final int? idPriceList;
  final String? priceListName;
  final int? destinationWarehouse;
  final String? destinationWarehouseName;
  final int? destinationLocation;
  final String? destinationLocationName;
  final String? requestDate;
  final String? expectedArrival;
  final String? note;
  final double totalPrice;
  final String? rfqEncryption;
  final String? dpEncryption;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelledReason;
  final String? approvedDate;
  final List<PurchaseRequestItem> items;
  final List<PurchaseRequestAuditTrail> auditTrails;

  PurchaseRequestDetailModel({
    required this.idPurchaseRequest,
    required this.encryption,
    required this.status,
    this.reference,
    this.requestedBy,
    this.requestedByName,
    this.idVendor,
    this.vendorName,
    this.idPriceList,
    this.priceListName,
    this.destinationWarehouse,
    this.destinationWarehouseName,
    this.destinationLocation,
    this.destinationLocationName,
    this.requestDate,
    this.expectedArrival,
    this.note,
    this.totalPrice = 0,
    this.rfqEncryption,
    this.dpEncryption,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelledReason,
    this.approvedDate,
    required this.items,
    required this.auditTrails,
  });

  factory PurchaseRequestDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PurchaseRequestDetailModel(
      idPurchaseRequest: _pi(data['id_purchase_request']),
      encryption: _ps(data['encryption']),
      status: _ps(data['status']),
      reference: data['reference']?.toString(),
      requestedBy: _pi(data['requested_by']) == 0 ? null : _pi(data['requested_by']),
      requestedByName: data['requested_by_name']?.toString(),
      idVendor: _pi(data['id_vendor']) == 0 ? null : _pi(data['id_vendor']),
      vendorName: data['vendor_name']?.toString() ?? data['vendor']?['vendor_name']?.toString(),
      idPriceList: _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      priceListName: data['price_list_name']?.toString() ?? data['priceList']?['price_list_name']?.toString(),
      destinationWarehouse: _pi(data['destination_warehouse']) == 0 ? null : _pi(data['destination_warehouse']),
      destinationWarehouseName: data['destination_warehouse_name']?.toString(),
      destinationLocation: _pi(data['destination_location']) == 0 ? null : _pi(data['destination_location']),
      destinationLocationName: data['destination_location_name']?.toString(),
      requestDate: data['requested_date']?.toString(),
      expectedArrival: data['expected_arrival']?.toString(),
      note: data['note']?.toString(),
      totalPrice: _pd(data['total_price']),
      rfqEncryption: data['rfq_encryption']?.toString(),
      dpEncryption: data['direct_purchase_encryption']?.toString(),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      cancelledByName: data['cancelled_by_name']?.toString(),
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      cancelledDate: data['cancelled_date']?.toString(),
      cancelledReason: data['cancel_reason']?.toString(),
      approvedDate: data['validated_date']?.toString(),
      items: (data['items'] as List? ?? []).map((e) => PurchaseRequestItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => PurchaseRequestAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed => status == 'Confirmed';
  bool get isDone => status == 'Done';
  bool get isRejected => status == 'Rejected';
  bool get isCancelled => status == 'Cancelled';

  bool get canEdit => isDraft;
  bool get canConfirm => isDraft;
  bool get canValidate => isConfirmed;
  bool get canCancel => isConfirmed;
  bool get canDelete => isDraft;

  bool get hasRfq => rfqEncryption != null && rfqEncryption!.isNotEmpty;
  bool get hasDp => dpEncryption != null && dpEncryption!.isNotEmpty;
  bool get canCreateRfq => isDone && !hasRfq && !hasDp;
  bool get canCreateDp => isDone && !hasRfq && !hasDp;
}

class PRUserOption {
  final int id;
  final String name;
  PRUserOption({required this.id, required this.name});
  factory PRUserOption.fromJson(Map<String, dynamic> j) =>
      PRUserOption(id: _pi(j['id_user']), name: _ps(j['nama_lengkap']));
  @override bool operator ==(Object o) => o is PRUserOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class PRVendorOption {
  final int id;
  final String name;
  PRVendorOption({required this.id, required this.name});
  factory PRVendorOption.fromJson(Map<String, dynamic> j) =>
      PRVendorOption(id: _pi(j['id_vendor']), name: _ps(j['vendor_name']));
  @override bool operator ==(Object o) => o is PRVendorOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class PRWarehouseOption {
  final int id;
  final String name;
  PRWarehouseOption({required this.id, required this.name});
  factory PRWarehouseOption.fromJson(Map<String, dynamic> j) =>
      PRWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));
  @override bool operator ==(Object o) => o is PRWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class PRLocationOption {
  final int id;
  final int warehouseId;
  final String name;
  PRLocationOption({required this.id, required this.warehouseId, required this.name});
  factory PRLocationOption.fromJson(Map<String, dynamic> j) => PRLocationOption(
        id: _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name: _ps(j['location_name']),
      );
  @override bool operator ==(Object o) => o is PRLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class PRPriceListOption {
  final int id;
  final String name;
  PRPriceListOption({required this.id, required this.name});
  factory PRPriceListOption.fromJson(Map<String, dynamic> j) =>
      PRPriceListOption(id: _pi(j['id_price_list']), name: _ps(j['price_list_name']));
  @override bool operator ==(Object o) => o is PRPriceListOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class PRProductOption {
  final int idProduct;
  final String productName;
  final String? description;
  PRProductOption({required this.idProduct, required this.productName, this.description});
  factory PRProductOption.fromJson(Map<String, dynamic> j) => PRProductOption(
        idProduct: _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
      );
  @override bool operator ==(Object o) => o is PRProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class PRUomOption {
  final int id;
  final String name;
  PRUomOption({required this.id, required this.name});
  factory PRUomOption.fromJson(Map<String, dynamic> j) =>
      PRUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));
  @override bool operator ==(Object o) => o is PRUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class PurchaseRequestFormOptions {
  final List<PRUserOption> users;
  final List<PRVendorOption> vendors;
  final List<PRWarehouseOption> warehouses;
  final List<PRLocationOption> locations;
  final List<PRPriceListOption> priceLists;
  final List<PRProductOption> products;
  final List<PRUomOption> uoms;
  final int? currentUserId;

  PurchaseRequestFormOptions({
    required this.users,
    required this.vendors,
    required this.warehouses,
    required this.locations,
    required this.priceLists,
    required this.products,
    required this.uoms,
    this.currentUserId,
  });

  factory PurchaseRequestFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PurchaseRequestFormOptions(
      users: (data['requesters'] as List? ?? []).map((e) => PRUserOption.fromJson(e)).toList(),
      vendors: (data['vendors'] as List? ?? []).map((e) => PRVendorOption.fromJson(e)).toList(),
      warehouses: (data['warehouses'] as List? ?? []).map((e) => PRWarehouseOption.fromJson(e)).toList(),
      locations: (data['locations'] as List? ?? []).map((e) => PRLocationOption.fromJson(e)).toList(),
      priceLists: (data['price_lists'] as List? ?? []).map((e) => PRPriceListOption.fromJson(e)).toList(),
      products: (data['products'] as List? ?? []).map((e) => PRProductOption.fromJson(e)).toList(),
      uoms: (data['uoms'] as List? ?? []).map((e) => PRUomOption.fromJson(e)).toList(),
      currentUserId: _pi(data['current_user_id']) == 0 ? null : _pi(data['current_user_id']),
    );
  }

  List<PRLocationOption> locationsForWarehouse(int warehouseId) =>
      locations.where((l) => l.warehouseId == warehouseId).toList();
}

class PurchaseRequestFormItem {
  int? idProduct;
  String? productName;
  String? description;
  int? uomId;
  String? uomName;
  double demandQty;
  double estimatedUnitPrice;

  PurchaseRequestFormItem({
    this.idProduct,
    this.productName,
    this.description,
    this.uomId,
    this.uomName,
    this.demandQty = 0,
    this.estimatedUnitPrice = 0,
  });

  double get totalEstimatedPrice => demandQty * estimatedUnitPrice;

  Map<String, dynamic> toJson() => {
        'id_product': idProduct,
        'description': description ?? '',
        'unit_of_measure': uomId,
        'demand_qty': demandQty,
        'estimated_unit_price': estimatedUnitPrice,
        'total_estimated_price': totalEstimatedPrice,
      };
}

class PurchaseRequestFormModel {
  int? idPurchaseRequest;
  String? encryption;
  String? reference;
  int? requestedBy;
  int? idVendor;
  int? idPriceList;
  int? destinationWarehouse;
  int? destinationLocation;
  DateTime? requestDate;
  DateTime? expectedArrival;
  String? note;
  List<PurchaseRequestFormItem> items;

  PurchaseRequestFormModel({
    this.idPurchaseRequest,
    this.encryption,
    this.reference,
    this.requestedBy,
    this.idVendor,
    this.idPriceList,
    this.destinationWarehouse,
    this.destinationLocation,
    this.requestDate,
    this.expectedArrival,
    this.note,
    List<PurchaseRequestFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idPurchaseRequest != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get totalPrice => items.fold(0, (s, i) => s + i.totalEstimatedPrice);

  Map<String, dynamic> toJson(String status) {
    return {
      if (idPurchaseRequest != null) 'id_purchase_request': idPurchaseRequest,
      if (reference != null) 'reference': reference,
      'requested_by': requestedBy,
      'id_vendor': idVendor,
      'id_price_list': idPriceList,
      'destination_warehouse': destinationWarehouse,
      'destination_location': destinationLocation,
      'requested_date': requestDate != null ? _fmtDate(requestDate!) : null,
      'expected_arrival': expectedArrival != null ? _fmtDate(expectedArrival!) : null,
      if (note?.isNotEmpty == true) 'note': note,
      'total_price': totalPrice,
      'status': status,
      'products': items.map((i) => i.toJson()).toList(),
    };
  }

  factory PurchaseRequestFormModel.fromDetail(PurchaseRequestDetailModel d) {
    return PurchaseRequestFormModel(
      idPurchaseRequest: d.idPurchaseRequest,
      encryption: d.encryption,
      reference: d.reference,
      requestedBy: d.requestedBy,
      idVendor: d.idVendor,
      idPriceList: d.idPriceList,
      destinationWarehouse: d.destinationWarehouse,
      destinationLocation: d.destinationLocation,
      requestDate: d.requestDate != null ? DateTime.tryParse(d.requestDate!) : null,
      expectedArrival: d.expectedArrival != null ? DateTime.tryParse(d.expectedArrival!) : null,
      note: d.note,
      items: d.items.map((i) => PurchaseRequestFormItem(
            idProduct: i.idProduct,
            productName: i.productName,
            description: i.description,
            uomId: i.unitOfMeasure,
            uomName: i.uomName,
            demandQty: i.demandQty,
            estimatedUnitPrice: i.estimatedUnitPrice,
          )).toList(),
    );
  }
}