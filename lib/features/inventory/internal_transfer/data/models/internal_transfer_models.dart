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

class InternalTransferModel {
  final int idInternalTransfer;
  final String encryption;
  final String status;
  final String? scheduledDate;
  final String? sourceDocument;
  final String? sourceWarehouseName;
  final String? sourceLocationName;
  final String? destinationWarehouseName;
  final String? destinationLocationName;

  InternalTransferModel({
    required this.idInternalTransfer,
    required this.encryption,
    required this.status,
    this.scheduledDate,
    this.sourceDocument,
    this.sourceWarehouseName,
    this.sourceLocationName,
    this.destinationWarehouseName,
    this.destinationLocationName,
  });

  factory InternalTransferModel.fromJson(Map<String, dynamic> j) => InternalTransferModel(
        idInternalTransfer:       _pi(j['id_internal_transfer']),
        encryption:               _ps(j['encryption']),
        status:                   _ps(j['status']),
        scheduledDate:            j['scheduled_date']?.toString(),
        sourceDocument:           j['source_document']?.toString(),
        sourceWarehouseName:      j['source_warehouse_name']?.toString(),
        sourceLocationName:       j['source_location_name']?.toString(),
        destinationWarehouseName: j['destination_warehouse_name']?.toString(),
        destinationLocationName:  j['destination_location_name']?.toString(),
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

class InternalTransferPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  InternalTransferPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class ITLotSerial {
  final int idProductLotSerial;
  final String? lotSerialNumber;
  final String? trackingMethod;
  final String? status;
  final double remainingQuantity;
  final String? expirationDate;
  final String? removalDate;

  ITLotSerial({
    required this.idProductLotSerial,
    this.lotSerialNumber,
    this.trackingMethod,
    this.status,
    this.remainingQuantity = 0,
    this.expirationDate,
    this.removalDate,
  });

  factory ITLotSerial.fromJson(Map<String, dynamic> j) => ITLotSerial(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotSerialNumber:    j['lot_serial_number']?.toString(),
        trackingMethod:     j['tracking_method']?.toString(),
        status:             j['status']?.toString(),
        remainingQuantity:  _pd(j['remaining_quantity']),
        expirationDate:     j['expiration_date']?.toString(),
        removalDate:        j['removal_date']?.toString(),
      );
}

class ITTrackingUsage {
  final int idProductLotSerial;
  final String lotNumber;
  final double quantity;
  final String? trackingMethod;

  ITTrackingUsage({
    required this.idProductLotSerial,
    required this.lotNumber,
    required this.quantity,
    this.trackingMethod,
  });

  factory ITTrackingUsage.fromJson(Map<String, dynamic> j) => ITTrackingUsage(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotNumber:          _ps(j['lot_number']),
        quantity:           _pd(j['quantity']),
        trackingMethod:     j['tracking_method']?.toString(),
      );
}

class InternalTransferItem {
  final int idInternalTransferItem;
  final int idProduct;
  final int unitOfMeasure;
  final String? productName;
  final String? uomName;
  final double demandQty;
  final double? transferredQty;
  double onHand;
  final bool trackingRequired;
  final List<ITTrackingUsage> trackingData;

  InternalTransferItem({
    required this.idInternalTransferItem,
    required this.idProduct,
    required this.unitOfMeasure,
    this.productName,
    this.uomName,
    required this.demandQty,
    this.transferredQty,
    this.onHand = 0,
    this.trackingRequired = false,
    List<ITTrackingUsage>? trackingData,
  }) : trackingData = trackingData ?? [];

  factory InternalTransferItem.fromJson(Map<String, dynamic> j) => InternalTransferItem(
        idInternalTransferItem: _pi(j['id_internal_transfer_item']),
        idProduct:              _pi(j['id_product']),
        unitOfMeasure:          _pi(j['unit_of_measure']),
        productName:            j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        uomName:                j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        demandQty:              _pd(j['demand_qty']),
        transferredQty:         j['transferred_qty'] != null ? _pd(j['transferred_qty']) : null,
        onHand:                 _pd(j['on_hand']),
        trackingRequired:       j['tracking_required'] == true ||
                                 j['product']?['inventory']?['tracking'] == true,
        trackingData: (j['tracking_data'] as List? ?? [])
            .map((e) => ITTrackingUsage.fromJson(e))
            .toList(),
      );
}

class InternalTransferAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  InternalTransferAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory InternalTransferAuditTrail.fromJson(Map<String, dynamic> j) => InternalTransferAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class InternalTransferDetailModel {
  final int idInternalTransfer;
  final String encryption;
  final String status;
  final String? reference;
  final String? sourceWarehouseName;
  final String? sourceLocationName;
  final String? destinationWarehouseName;
  final String? destinationLocationName;
  final int? sourceWarehouse;
  final int? sourceLocation;
  final int? destinationWarehouse;
  final int? destinationLocation;
  final String? scheduledDate;
  final String? sourceDocument;
  final String? notes;
  final String? cancelReason;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final List<InternalTransferItem> items;
  final List<InternalTransferAuditTrail> auditTrails;
  final Map<String, dynamic> lotSerialsPerItem;

  InternalTransferDetailModel({
    required this.idInternalTransfer,
    required this.encryption,
    required this.status,
    this.reference,
    this.sourceWarehouseName,
    this.sourceLocationName,
    this.destinationWarehouseName,
    this.destinationLocationName,
    this.sourceWarehouse,
    this.sourceLocation,
    this.destinationWarehouse,
    this.destinationLocation,
    this.scheduledDate,
    this.sourceDocument,
    this.notes,
    this.cancelReason,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    required this.items,
    required this.auditTrails,
    this.lotSerialsPerItem = const {},
  });

  factory InternalTransferDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return InternalTransferDetailModel(
      idInternalTransfer:       _pi(data['id_internal_transfer']),
      encryption:               _ps(data['encryption']),
      status:                   _ps(data['status']),
      reference:                data['reference']?.toString(),
      sourceWarehouseName:      data['source_warehouse_name']?.toString(),
      sourceLocationName:       data['source_location_name']?.toString(),
      destinationWarehouseName: data['destination_warehouse_name']?.toString(),
      destinationLocationName:  data['destination_location_name']?.toString(),
      sourceWarehouse:          _pi(data['source_warehouse']) == 0 ? null : _pi(data['source_warehouse']),
      sourceLocation:           _pi(data['source_location']) == 0 ? null : _pi(data['source_location']),
      destinationWarehouse:     _pi(data['destination_warehouse']) == 0 ? null : _pi(data['destination_warehouse']),
      destinationLocation:      _pi(data['destination_location']) == 0 ? null : _pi(data['destination_location']),
      scheduledDate:            data['scheduled_date']?.toString(),
      sourceDocument:           data['source_document']?.toString(),
      notes:                    data['notes']?.toString(),
      cancelReason:             data['cancel_reason']?.toString(),
      createdByName:            data['created_by_name']?.toString(),
      updatedByName:            data['updated_by_name']?.toString(),
      cancelledByName:          data['cancelled_by_name']?.toString(),
      createdDate:              data['created_date']?.toString(),
      updatedDate:              data['updated_date']?.toString(),
      cancelledDate:            data['cancelled_date']?.toString(),
      items:       (data['items'] as List? ?? []).map((e) => InternalTransferItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => InternalTransferAuditTrail.fromJson(e)).toList(),
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
}

class ITWarehouseOption {
  final int id;
  final String name;
  ITWarehouseOption({required this.id, required this.name});
  factory ITWarehouseOption.fromJson(Map<String, dynamic> j) =>
      ITWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));
  @override bool operator ==(Object o) => o is ITWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class ITLocationOption {
  final int id;
  final int warehouseId;
  final String name;

  ITLocationOption({required this.id, required this.warehouseId, required this.name});

  factory ITLocationOption.fromJson(Map<String, dynamic> j) => ITLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );

  @override bool operator ==(Object o) => o is ITLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class ITProductOption {
  final int idProduct;
  final String productName;
  final int? defaultUom;
  ITProductOption({required this.idProduct, required this.productName, this.defaultUom});
  factory ITProductOption.fromJson(Map<String, dynamic> j) => ITProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        defaultUom:  j['default_uom'] != null ? _pi(j['default_uom']) : null,
      );
  @override bool operator ==(Object o) => o is ITProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class ITUomOption {
  final int id;
  final String name;
  ITUomOption({required this.id, required this.name});
  factory ITUomOption.fromJson(Map<String, dynamic> j) =>
      ITUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));
  @override bool operator ==(Object o) => o is ITUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class InternalTransferFormOptions {
  final List<ITWarehouseOption> warehouses;
  final List<ITLocationOption> locations;
  final List<ITProductOption> products;
  final List<ITUomOption> uoms;
  final Map<int, int> defaultUomPerProduct;

  InternalTransferFormOptions({
    required this.warehouses,
    required this.locations,
    required this.products,
    required this.uoms,
    this.defaultUomPerProduct = const {},
  });

  factory InternalTransferFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final rawMap = (data['default_uom_per_product'] as Map?) ?? {};
    return InternalTransferFormOptions(
      warehouses: (data['warehouses'] as List? ?? []).map((e) => ITWarehouseOption.fromJson(e)).toList(),
      locations:  (data['locations']  as List? ?? []).map((e) => ITLocationOption.fromJson(e)).toList(),
      products:   (data['products']   as List? ?? []).map((e) => ITProductOption.fromJson(e)).toList(),
      uoms:       (data['uoms']       as List? ?? []).map((e) => ITUomOption.fromJson(e)).toList(),
      defaultUomPerProduct: rawMap.map((k, v) => MapEntry(_pi(k), _pi(v))),
    );
  }

  List<ITLocationOption> locationsForWarehouse(int warehouseId) {
    final filtered = locations.where((l) => l.warehouseId == warehouseId).toList();
    return filtered.isNotEmpty ? filtered : locations;
  }
}

class InternalTransferFormItem {
  int? idProduct;
  String? productName;
  int? uomId;
  String? uomName;
  double demandQty;
  double transferredQty;
  double onHand;

  InternalTransferFormItem({
    this.idProduct,
    this.productName,
    this.uomId,
    this.uomName,
    this.demandQty = 0,
    this.transferredQty = 0,
    this.onHand = 0,
  });

  Map<String, dynamic> toJsonDemand() => {
        'id_product':      idProduct,
        'demand_qty':      demandQty,
        'unit_of_measure': uomId,
      };

  Map<String, dynamic> toJsonTransferred() => {
        'id_product':       idProduct,
        'unit_of_measure':  uomId,
        'demand_qty':       demandQty,
        'transferred_qty':  transferredQty,
      };
}

class InternalTransferFormModel {
  int? idInternalTransfer;
  String? encryption;
  String? reference;
  int? sourceWarehouse;
  int? sourceLocation;
  int? destinationWarehouse;
  int? destinationLocation;
  DateTime? scheduledDate;
  String? sourceDocument;
  String? notes;
  bool allowBackorder;
  int? backorderFrom;
  List<InternalTransferFormItem> items;

  InternalTransferFormModel({
    this.idInternalTransfer,
    this.encryption,
    this.reference,
    this.sourceWarehouse,
    this.sourceLocation,
    this.destinationWarehouse,
    this.destinationLocation,
    this.scheduledDate,
    this.sourceDocument,
    this.notes,
    this.allowBackorder = false,
    this.backorderFrom,
    List<InternalTransferFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idInternalTransfer != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) {
    if (status == 'validate') {
      return {
        'id_internal_transfer': idInternalTransfer,
        'status':               'validate', 
        'products':             items.map((i) => i.toJsonTransferred()).toList(),
        'allow_backorder':      allowBackorder,
      };
    }

    return {
      if (idInternalTransfer != null) 'id_internal_transfer': idInternalTransfer,
      'source_warehouse':      sourceWarehouse,
      'source_location':       sourceLocation,
      'destination_warehouse': destinationWarehouse,
      'destination_location':  destinationLocation,
      'scheduled_date':        scheduledDate != null ? _fmtDate(scheduledDate!) : null,
      if (sourceDocument != null) 'source_document': sourceDocument,
      if (notes != null) 'notes': notes,
      if (backorderFrom != null) 'backorder_from': backorderFrom,
      'status':   status,
      'products': items.map((i) => i.toJsonDemand()).toList(),
    };
  }

  factory InternalTransferFormModel.fromDetail(InternalTransferDetailModel d) => InternalTransferFormModel(
        idInternalTransfer:   d.idInternalTransfer,
        encryption:           d.encryption,
        reference:            d.reference,
        sourceWarehouse:      d.sourceWarehouse,
        sourceLocation:       d.sourceLocation,
        destinationWarehouse: d.destinationWarehouse,
        destinationLocation:  d.destinationLocation,
        scheduledDate:        d.scheduledDate != null ? DateTime.tryParse(d.scheduledDate!) : null,
        sourceDocument:       d.sourceDocument,
        notes:                d.notes,
        items: d.items.map((i) => InternalTransferFormItem(
              idProduct:       i.idProduct,
              productName:     i.productName,
              uomId:           i.unitOfMeasure,
              uomName:         i.uomName,
              demandQty:       i.demandQty,
              transferredQty:  i.transferredQty ?? 0,
              onHand:          i.onHand,
            )).toList(),
      );
}