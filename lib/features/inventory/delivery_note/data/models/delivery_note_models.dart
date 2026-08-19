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

class DeliveryNoteModel {
  final int idDeliveryNote;
  final String encryption;
  final String status;
  final String? reference;
  final String? scheduledDate;
  final String? sourceDocument;
  final String? customerName;
  final String? locationName;

  DeliveryNoteModel({
    required this.idDeliveryNote,
    required this.encryption,
    required this.status,
    this.reference,
    this.scheduledDate,
    this.sourceDocument,
    this.customerName,
    this.locationName,
  });

  factory DeliveryNoteModel.fromJson(Map<String, dynamic> j) => DeliveryNoteModel(
        idDeliveryNote: _pi(j['id_delivery_note']),
        encryption:     _ps(j['encryption']),
        status:         _ps(j['status']),
        reference:      j['reference']?.toString(),
        scheduledDate:  j['scheduled_date']?.toString(),
        sourceDocument: j['source_document']?.toString(),
        customerName:   j['customer_name']?.toString(),
        locationName:   j['location_name']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed':        0xFF1565C0,
    'Done':             0xFF2E7D32,
    'Cancelled':        0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class DeliveryNotePaginationMeta {
  final int currentPage, lastPage, perPage, total;

  DeliveryNotePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class DeliveryNoteLotSerial {
  final int idProductLotSerial;
  final String? lotSerialNumber;
  final String? trackingMethod;
  final String? status;
  final double remainingQuantity;
  final String? expirationDate;
  final String? removalDate;

  DeliveryNoteLotSerial({
    required this.idProductLotSerial,
    this.lotSerialNumber,
    this.trackingMethod,
    this.status,
    this.remainingQuantity = 0,
    this.expirationDate,
    this.removalDate,
  });

  factory DeliveryNoteLotSerial.fromJson(Map<String, dynamic> j) => DeliveryNoteLotSerial(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotSerialNumber:    j['lot_serial_number']?.toString(),
        trackingMethod:     j['tracking_method']?.toString(),
        status:             j['status']?.toString(),
        remainingQuantity:  _pd(j['remaining_quantity']),
        expirationDate:     j['expiration_date']?.toString(),
        removalDate:        j['removal_date']?.toString(),
      );
}

class DeliveryNoteTrackingUsage {
  final int idProductLotSerial;
  final String lotNumber;
  final double quantity;
  final String? trackingMethod;

  DeliveryNoteTrackingUsage({
    required this.idProductLotSerial,
    required this.lotNumber,
    required this.quantity,
    this.trackingMethod,
  });

  factory DeliveryNoteTrackingUsage.fromJson(Map<String, dynamic> j) => DeliveryNoteTrackingUsage(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotNumber:          _ps(j['lot_number']),
        quantity:           _pd(j['quantity']),
        trackingMethod:     j['tracking_method']?.toString(),
      );
}

class DeliveryNoteItem {
  final int idDeliveryNoteItem;
  final int idProduct;
  final int unitOfMeasure;
  final String? productName;
  final String? uomName;
  final double demandQty;
  final double? deliveredQty;
  double onHand;
  final bool trackingRequired;
  final List<DeliveryNoteTrackingUsage> trackingData;

  DeliveryNoteItem({
    required this.idDeliveryNoteItem,
    required this.idProduct,
    required this.unitOfMeasure,
    this.productName,
    this.uomName,
    required this.demandQty,
    this.deliveredQty,
    this.onHand = 0,
    this.trackingRequired = false,
    List<DeliveryNoteTrackingUsage>? trackingData,
  }) : trackingData = trackingData ?? [];

  factory DeliveryNoteItem.fromJson(Map<String, dynamic> j) => DeliveryNoteItem(
        idDeliveryNoteItem: _pi(j['id_delivery_note_item']),
        idProduct:          _pi(j['id_product']),
        unitOfMeasure:      _pi(j['unit_of_measure']),
        productName:        j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        uomName:            j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        demandQty:          _pd(j['demand_qty']),
        deliveredQty:       j['delivered_qty'] != null ? _pd(j['delivered_qty']) : null,
        onHand:             _pd(j['on_hand']),
        trackingRequired:   j['tracking_required'] == true ||
                             j['product']?['inventory']?['tracking'] == true,
        trackingData: (j['tracking_data'] as List? ?? [])
            .map((e) => DeliveryNoteTrackingUsage.fromJson(e))
            .toList(),
      );
}

class DeliveryNoteAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  DeliveryNoteAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory DeliveryNoteAuditTrail.fromJson(Map<String, dynamic> j) => DeliveryNoteAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class DeliveryNoteDetailModel {
  final int idDeliveryNote;
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final String? sourceWarehouseName;
  final String? sourceLocationName;
  final int? idCustomer;
  final int? branch;
  final int? sourceWarehouse;
  final int? sourceLocation;
  final String? deliveryAddress;
  final String? scheduledDate;
  final String? sourceDocument;
  final String? notes;
  final String? dateOfTransfer;
  final String? cancelReason;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? salesOrderEncryption;
  final String? directSalesEncryption;
  final String? returnDeliveryNoteEncryption;
  final List<DeliveryNoteItem> items;
  final List<DeliveryNoteAuditTrail> auditTrails;
  final Map<String, dynamic> lotSerialsPerItem;

  DeliveryNoteDetailModel({
    required this.idDeliveryNote,
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.sourceWarehouseName,
    this.sourceLocationName,
    this.idCustomer,
    this.branch,
    this.sourceWarehouse,
    this.sourceLocation,
    this.deliveryAddress,
    this.scheduledDate,
    this.sourceDocument,
    this.notes,
    this.dateOfTransfer,
    this.cancelReason,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.salesOrderEncryption,
    this.directSalesEncryption,
    this.returnDeliveryNoteEncryption,
    required this.items,
    required this.auditTrails,
    this.lotSerialsPerItem = const {},
  });

  factory DeliveryNoteDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DeliveryNoteDetailModel(
      idDeliveryNote:      _pi(data['id_delivery_note']),
      encryption:          _ps(data['encryption']),
      status:              _ps(data['status']),
      reference:           data['reference']?.toString(),
      customerName:        data['customer_name']?.toString(),
      sourceWarehouseName: data['source_warehouse_name']?.toString(),
      sourceLocationName:  data['source_location_name']?.toString(),
      idCustomer:          _pi(data['customer']) == 0 ? null : _pi(data['customer']),
      branch:              _pi(data['branch']) == 0 ? null : _pi(data['branch']),
      sourceWarehouse:     _pi(data['source_warehouse']) == 0 ? null : _pi(data['source_warehouse']),
      sourceLocation:      _pi(data['source_location']) == 0 ? null : _pi(data['source_location']),
      deliveryAddress:     data['delivery_address']?.toString(),
      scheduledDate:       data['scheduled_date']?.toString(),
      sourceDocument:      data['source_document']?.toString(),
      notes:               data['notes']?.toString(),
      dateOfTransfer:      data['date_of_transfer']?.toString(),
      cancelReason:        data['cancel_reason']?.toString(),
      createdByName:       data['created_by_name']?.toString(),
      updatedByName:       data['updated_by_name']?.toString(),
      cancelledByName:     data['cancelled_by_name']?.toString(),
      createdDate:         data['created_date']?.toString(),
      updatedDate:         data['updated_date']?.toString(),
      cancelledDate:       data['cancelled_date']?.toString(),
      salesOrderEncryption:         data['sales_order_encryption']?.toString(),
      directSalesEncryption:        data['direct_sales_encryption']?.toString(),
      returnDeliveryNoteEncryption: data['return_delivery_note']?['encryption']?.toString(),
      items:       (data['items'] as List? ?? []).map((e) => DeliveryNoteItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => DeliveryNoteAuditTrail.fromJson(e)).toList(),
      lotSerialsPerItem: (data['lot_serials_per_item'] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isDone            => status == 'Done';
  bool get isCancelled       => status == 'Cancelled';
  bool get canEdit           => isDraft;
  bool get canConfirm        => isDraft;
  bool get canValidate       => isConfirmed;
  bool get canCancel         => isConfirmed;
  bool get canDelete         => isDraft;
  bool get hasSalesOrder     => salesOrderEncryption != null && salesOrderEncryption!.isNotEmpty;
  bool get hasDirectSales    => directSalesEncryption != null && directSalesEncryption!.isNotEmpty;
  bool get hasReturn         => returnDeliveryNoteEncryption != null && returnDeliveryNoteEncryption!.isNotEmpty;
}

class DNCustomerOption {
  final int id;
  final String name;
  DNCustomerOption({required this.id, required this.name});
  factory DNCustomerOption.fromJson(Map<String, dynamic> j) =>
      DNCustomerOption(id: _pi(j['id_customer']), name: _ps(j['customer_name']));
  @override bool operator ==(Object o) => o is DNCustomerOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DNWarehouseOption {
  final int id;
  final String name;
  DNWarehouseOption({required this.id, required this.name});
  factory DNWarehouseOption.fromJson(Map<String, dynamic> j) =>
      DNWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));
  @override bool operator ==(Object o) => o is DNWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DNLocationOption {
  final int id;
  final int warehouseId;
  final String name;

  DNLocationOption({required this.id, required this.warehouseId, required this.name});

  factory DNLocationOption.fromJson(Map<String, dynamic> j) => DNLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );

  @override bool operator ==(Object o) => o is DNLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DNProductOption {
  final int idProduct;
  final String productName;
  final int? defaultUom;
  DNProductOption({required this.idProduct, required this.productName, this.defaultUom});
  factory DNProductOption.fromJson(Map<String, dynamic> j) => DNProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        defaultUom:  j['default_uom'] != null ? _pi(j['default_uom']) : null,
      );
  @override bool operator ==(Object o) => o is DNProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class DNUomOption {
  final int id;
  final String name;
  DNUomOption({required this.id, required this.name});
  factory DNUomOption.fromJson(Map<String, dynamic> j) =>
      DNUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));
  @override bool operator ==(Object o) => o is DNUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DeliveryNoteFormOptions {
  final List<DNCustomerOption> customers;
  final List<DNLocationOption> locations;
  final List<DNWarehouseOption> warehouses;
  final List<DNProductOption> products;
  final List<DNUomOption> uoms;
  final Map<int, int> defaultUomPerProduct;

  DeliveryNoteFormOptions({
    required this.customers,
    required this.locations,
    required this.warehouses,
    required this.products,
    required this.uoms,
    this.defaultUomPerProduct = const {},
  });

  factory DeliveryNoteFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final rawMap = (data['default_uom_per_product'] as Map?) ?? {};
    return DeliveryNoteFormOptions(
      customers:  (data['customers']  as List? ?? []).map((e) => DNCustomerOption.fromJson(e)).toList(),
      locations:  (data['locations']  as List? ?? []).map((e) => DNLocationOption.fromJson(e)).toList(),
      warehouses: (data['warehouses'] as List? ?? []).map((e) => DNWarehouseOption.fromJson(e)).toList(),
      products:   (data['products']   as List? ?? []).map((e) => DNProductOption.fromJson(e)).toList(),
      uoms:       (data['uoms']       as List? ?? []).map((e) => DNUomOption.fromJson(e)).toList(),
      defaultUomPerProduct: rawMap.map((k, v) => MapEntry(_pi(k), _pi(v))),
    );
  }

  List<DNLocationOption> locationsForWarehouse(int warehouseId) {
    final filtered = locations.where((l) => l.warehouseId == warehouseId).toList();
    return filtered.isNotEmpty ? filtered : locations;
  }
}

class DeliveryNoteFormItem {
  int? idProduct;
  String? productName;
  int? uomId;
  String? uomName;
  double demandQty;
  double deliveredQty;
  double onHand;

  DeliveryNoteFormItem({
    this.idProduct,
    this.productName,
    this.uomId,
    this.uomName,
    this.demandQty = 0,
    this.deliveredQty = 0,
    this.onHand = 0,
  });

  Map<String, dynamic> toJsonDemand() => {
        'id_product':      idProduct,
        'demand_qty':      demandQty,
        'unit_of_measure': uomId,
      };

  Map<String, dynamic> toJsonDelivered() => {
        'id_product':      idProduct,
        'unit_of_measure': uomId,
        'delivered_qty':   deliveredQty,
      };
}

class DeliveryNoteFormModel {
  int? idDeliveryNote;
  String? encryption;
  String? reference;
  int? idCustomer;
  int? branch;
  String deliveryAddress;
  int? sourceWarehouse;
  int? sourceLocation;
  DateTime? scheduledDate;
  String? sourceDocument;
  String? notes;
  bool allowBackorder;
  List<DeliveryNoteFormItem> items;

  DeliveryNoteFormModel({
    this.idDeliveryNote,
    this.encryption,
    this.reference,
    this.idCustomer,
    this.branch,
    this.deliveryAddress = 'Customer Location',
    this.sourceWarehouse,
    this.sourceLocation,
    this.scheduledDate,
    this.sourceDocument,
    this.notes,
    this.allowBackorder = false,
    List<DeliveryNoteFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idDeliveryNote != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) {
    if (status == 'validate') {
      return {
        'id_delivery_note': idDeliveryNote,
        'status':           'validate',
        'products':         items.map((i) => i.toJsonDelivered()).toList(),
        'allow_backorder':  allowBackorder,
      };
    }

    return {
      if (idDeliveryNote != null) 'id_delivery_note': idDeliveryNote,
      'customer':          idCustomer,
      if (branch != null) 'branch': branch,
      'delivery_address':  deliveryAddress,
      'source_warehouse':  sourceWarehouse,
      'source_location':   sourceLocation,
      'scheduled_date':    scheduledDate != null ? _fmtDate(scheduledDate!) : null,
      if (sourceDocument != null) 'source_document': sourceDocument,
      if (notes != null) 'notes': notes,
      'status':   status,
      'products': items.map((i) => i.toJsonDemand()).toList(),
    };
  }

  factory DeliveryNoteFormModel.fromDetail(DeliveryNoteDetailModel d) => DeliveryNoteFormModel(
        idDeliveryNote:  d.idDeliveryNote,
        encryption:      d.encryption,
        reference:       d.reference,
        idCustomer:      d.idCustomer,
        branch:          d.branch,
        deliveryAddress: d.deliveryAddress ?? 'Customer Location',
        sourceWarehouse: d.sourceWarehouse,
        sourceLocation:  d.sourceLocation,
        scheduledDate:   d.scheduledDate != null ? DateTime.tryParse(d.scheduledDate!) : null,
        sourceDocument:  d.sourceDocument,
        notes:           d.notes,
        items: d.items.map((i) => DeliveryNoteFormItem(
              idProduct:    i.idProduct,
              productName:  i.productName,
              uomId:        i.unitOfMeasure,
              uomName:      i.uomName,
              demandQty:    i.demandQty,
              deliveredQty: i.deliveredQty ?? 0,
              onHand:       i.onHand,
            )).toList(),
      );
}