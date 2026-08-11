double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

bool _pb(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v.toString().toLowerCase();
  return s == '1' || s == 'true';
}

int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

class ReceiptNoteModel {
  final int idReceiptNote;
  final String encryption;
  final String status;
  final String? reference;
  final String? sourceDocument;
  final String? vendorName;
  final String? locationName;
  final String? scheduledDate;

  ReceiptNoteModel({
    required this.idReceiptNote,
    required this.encryption,
    required this.status,
    this.reference,
    this.sourceDocument,
    this.vendorName,
    this.locationName,
    this.scheduledDate,
  });

  factory ReceiptNoteModel.fromJson(Map<String, dynamic> j) => ReceiptNoteModel(
        idReceiptNote:  _pi(j['id_receipt_note']),
        encryption:     _ps(j['encryption']),
        status:         _ps(j['status']),
        reference:      j['reference']?.toString(),
        sourceDocument: j['source_document']?.toString(),
        vendorName:     j['vendor_name']?.toString(),
        locationName:   j['location_name']?.toString(),
        scheduledDate:  j['scheduled_date']?.toString(),
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

class ReceiptNotePaginationMeta {
  final int currentPage, lastPage, perPage, total;

  ReceiptNotePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class ReceiptNoteLotSerial {
  final int idProductLotSerial;
  final String lotNumber;
  final double initialQuantity;
  final double remainingQuantity;
  final String? trackingMethod;

  ReceiptNoteLotSerial({
    required this.idProductLotSerial,
    required this.lotNumber,
    required this.initialQuantity,
    required this.remainingQuantity,
    this.trackingMethod,
  });

  factory ReceiptNoteLotSerial.fromJson(Map<String, dynamic> j) => ReceiptNoteLotSerial(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotNumber:          _ps(j['lot_number'] ?? j['lot_serial_number']),
        initialQuantity:    _pd(j['initial_quantity']),
        remainingQuantity:  _pd(j['quantity'] ?? j['remaining_quantity']),
        trackingMethod:     j['tracking_method']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'lot_number':      lotNumber,
        'quantity':        remainingQuantity,
        'tracking_method': trackingMethod,
      };
}

class ReceiptNoteItem {
  final int idReceiptNoteItem;
  final int idProduct;
  final int unitOfMeasure;
  final String? productName;
  final String? description;
  final String? uomName;
  final double demandQty;
  final double? receivedQty;
  final bool trackingRequired;    
  final String? trackingMethod;   
  final List<ReceiptNoteLotSerial> trackingData;

  ReceiptNoteItem({
    required this.idReceiptNoteItem,
    required this.idProduct,
    required this.unitOfMeasure,
    this.productName,
    this.description,
    this.uomName,
    required this.demandQty,
    this.receivedQty,
    this.trackingRequired = false,
    this.trackingMethod,
    List<ReceiptNoteLotSerial>? trackingData,
  }) : trackingData = trackingData ?? [];

  factory ReceiptNoteItem.fromJson(Map<String, dynamic> j) => ReceiptNoteItem(
        idReceiptNoteItem: _pi(j['id_receipt_note_item']),
        idProduct:         _pi(j['id_product']),
        unitOfMeasure:     _pi(j['unit_of_measure']),
        productName:       j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        description:       j['description']?.toString(),
        uomName:           j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        demandQty:         _pd(j['demand_qty']),
        receivedQty:       j['received_qty'] == null ? null : _pd(j['received_qty']),
        trackingRequired:  _pb(j['product']?['inventory']?['tracking']),
        trackingMethod:    j['product']?['inventory']?['tracking_method']?.toString(),
        trackingData:      (j['tracking_data'] as List? ?? [])
            .map((e) => ReceiptNoteLotSerial.fromJson(e))
            .toList(),
      );

  double get outstandingQty => demandQty - (receivedQty ?? 0);
}

class ReceiptNoteAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  ReceiptNoteAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory ReceiptNoteAuditTrail.fromJson(Map<String, dynamic> j) => ReceiptNoteAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class ReceiptNoteRelatedDoc {
  final int id;
  final String? encryption;

  ReceiptNoteRelatedDoc({required this.id, this.encryption});

  static ReceiptNoteRelatedDoc? maybeFromJson(dynamic j, String idKey) {
    if (j == null || j is! Map) return null;
    final map = Map<String, dynamic>.from(j);
    return ReceiptNoteRelatedDoc(
      id:         _pi(map[idKey]),
      encryption: map['encryption']?.toString(),
    );
  }
}

class ReceiptNoteDetailModel {
  final int idReceiptNote;
  final String encryption;
  final String status;
  final String? reference;
  final int? vendor;
  final String? vendorName;
  final String? branch;
  final String? vendorLocation;
  final int? destinationWarehouse;
  final String? warehouseName;
  final int? destinationLocation;
  final String? locationName;
  final String? scheduledDate;
  final String? dateOfTransfer;
  final String? sourceDocument;
  final String? notes;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? cancelReason;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? validatedDate;
  final int? backorderFrom;
  final bool isBackorder;
  final int? parentReceiptNoteId;
  final String? defaultSourceDocument;
  final ReceiptNoteRelatedDoc? purchaseOrder;
  final ReceiptNoteRelatedDoc? directPurchase;
  final ReceiptNoteRelatedDoc? returnReceiptNote;
  final List<ReceiptNoteItem> items;
  final List<ReceiptNoteAuditTrail> auditTrails;

  ReceiptNoteDetailModel({
    required this.idReceiptNote,
    required this.encryption,
    required this.status,
    this.reference,
    this.vendor,
    this.vendorName,
    this.branch,
    this.vendorLocation,
    this.destinationWarehouse,
    this.warehouseName,
    this.destinationLocation,
    this.locationName,
    this.scheduledDate,
    this.dateOfTransfer,
    this.sourceDocument,
    this.notes,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.cancelReason,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.validatedDate,
    this.backorderFrom,
    this.isBackorder = false,
    this.parentReceiptNoteId,
    this.defaultSourceDocument,
    this.purchaseOrder,
    this.directPurchase,
    this.returnReceiptNote,
    required this.items,
    required this.auditTrails,
  });

  factory ReceiptNoteDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ReceiptNoteDetailModel(
      idReceiptNote:         _pi(data['id_receipt_note']),
      encryption:            _ps(data['encryption']),
      status:                _ps(data['status']),
      reference:             data['reference']?.toString(),
      vendor:                _pi(data['vendor']) == 0 ? null : _pi(data['vendor']),
      vendorName:            data['vendor_name']?.toString() ?? data['vendor_data']?['vendor_name']?.toString(),
      branch:                data['branch']?.toString(),
      vendorLocation:        data['vendor_location']?.toString(),
      destinationWarehouse:  _pi(data['destination_warehouse']) == 0 ? null : _pi(data['destination_warehouse']),
      warehouseName:         data['warehouse']?['warehouse_name']?.toString(),
      destinationLocation:   _pi(data['destination_location']) == 0 ? null : _pi(data['destination_location']),
      locationName:          data['location']?['location_name']?.toString(),
      scheduledDate:         data['scheduled_date']?.toString(),
      dateOfTransfer:        data['date_of_transfer']?.toString(),
      sourceDocument:        data['source_document']?.toString(),
      notes:                 data['notes']?.toString(),
      createdByName:         data['created_by_name']?.toString(),
      updatedByName:         data['updated_by_name']?.toString(),
      cancelledByName:       data['cancelled_by_name']?.toString(),
      cancelReason:          data['cancel_reason']?.toString(),
      createdDate:           data['created_date']?.toString(),
      updatedDate:           data['updated_date']?.toString(),
      cancelledDate:         data['cancelled_date']?.toString(),
      validatedDate:         data['validated_date']?.toString(),
      backorderFrom:         data['backorder_from'] == null ? null : _pi(data['backorder_from']),
      isBackorder:           data['is_backorder'] == true,
      parentReceiptNoteId:   data['parent_receipt_note_id'] == null ? null : _pi(data['parent_receipt_note_id']),
      defaultSourceDocument: data['default_source_document']?.toString(),
      purchaseOrder:         ReceiptNoteRelatedDoc.maybeFromJson(data['purchase_order'], 'id_purchase_order'),
      directPurchase:        ReceiptNoteRelatedDoc.maybeFromJson(data['direct_purchase'], 'id_direct_purchase'),
      returnReceiptNote:     ReceiptNoteRelatedDoc.maybeFromJson(data['return_receipt_note'], 'id_return_receipt_note'),
      items:       (data['items']        as List? ?? []).map((e) => ReceiptNoteItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => ReceiptNoteAuditTrail.fromJson(e)).toList(),
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
  bool get canCreateReturn   => isDone;
  bool get hasReturn         => returnReceiptNote != null;
}

class RNVendorOption {
  final int id;
  final String name;

  RNVendorOption({required this.id, required this.name});

  factory RNVendorOption.fromJson(Map<String, dynamic> j) =>
      RNVendorOption(id: _pi(j['id_vendor']), name: _ps(j['vendor_name']));

  @override bool operator ==(Object o) => o is RNVendorOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RNWarehouseOption {
  final int id;
  final String name;

  RNWarehouseOption({required this.id, required this.name});

  factory RNWarehouseOption.fromJson(Map<String, dynamic> j) =>
      RNWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));

  @override bool operator ==(Object o) => o is RNWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RNLocationOption {
  final int id;
  final int warehouseId;
  final String name;

  RNLocationOption({required this.id, required this.warehouseId, required this.name});

  factory RNLocationOption.fromJson(Map<String, dynamic> j) => RNLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );

  @override bool operator ==(Object o) => o is RNLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RNProductOption {
  final int idProduct;
  final String productName;
  final int? defaultUom;
  final String? description;

  RNProductOption({
    required this.idProduct,
    required this.productName,
    this.defaultUom,
    this.description,
  });

  factory RNProductOption.fromJson(Map<String, dynamic> j) => RNProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        defaultUom:  j['default_uom'] == null ? null : _pi(j['default_uom']),
        description: j['description']?.toString(),
      );

  @override bool operator ==(Object o) => o is RNProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class RNUomOption {
  final int id;
  final String name;

  RNUomOption({required this.id, required this.name});

  factory RNUomOption.fromJson(Map<String, dynamic> j) =>
      RNUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));

  @override bool operator ==(Object o) => o is RNUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class ReceiptNoteFormOptions {
  final List<RNVendorOption> vendors;
  final List<RNWarehouseOption> warehouses;
  final List<RNLocationOption> locations;
  final List<RNProductOption> products;
  final List<RNUomOption> uoms;
  final Map<String, int> defaultUomPerProduct;

  ReceiptNoteFormOptions({
    required this.vendors,
    required this.warehouses,
    required this.locations,
    required this.products,
    required this.uoms,
    required this.defaultUomPerProduct,
  });

  factory ReceiptNoteFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final rawMap = (data['default_uom_per_product'] as Map?) ?? {};
    return ReceiptNoteFormOptions(
      vendors:    (data['vendors']    as List? ?? []).map((e) => RNVendorOption.fromJson(e)).toList(),
      warehouses: (data['warehouses'] as List? ?? []).map((e) => RNWarehouseOption.fromJson(e)).toList(),
      locations:  (data['locations']  as List? ?? []).map((e) => RNLocationOption.fromJson(e)).toList(),
      products:   (data['products']   as List? ?? []).map((e) => RNProductOption.fromJson(e)).toList(),
      uoms:       (data['uoms']       as List? ?? []).map((e) => RNUomOption.fromJson(e)).toList(),
      defaultUomPerProduct: rawMap.map((k, v) => MapEntry(k.toString(), _pi(v))),
    );
  }

  List<RNLocationOption> locationsForWarehouse(int warehouseId) =>
      locations.where((l) => l.warehouseId == warehouseId).toList();
}

class ReceiptNoteInventorySettings {
  final int autoGenerateLot;
  final String? lotPrefix;
  final String? lotSuffix;
  final int lotDigitNumber;
  final int lastSequence;
  final int useExpiration;
  final int? expirationDays;
  final int? bestBeforeDays;
  final int? removalDays;
  final int? alertDays;

  ReceiptNoteInventorySettings({
    required this.autoGenerateLot,
    this.lotPrefix,
    this.lotSuffix,
    required this.lotDigitNumber,
    required this.lastSequence,
    required this.useExpiration,
    this.expirationDays,
    this.bestBeforeDays,
    this.removalDays,
    this.alertDays,
  });

  factory ReceiptNoteInventorySettings.fromJson(Map<String, dynamic> j) => ReceiptNoteInventorySettings(
        autoGenerateLot: _pi(j['auto_generate_lot']),
        lotPrefix:       j['lot_prefix']?.toString(),
        lotSuffix:       j['lot_suffix']?.toString(),
        lotDigitNumber:  j['lot_digit_number'] == null ? 4 : _pi(j['lot_digit_number']),
        lastSequence:    _pi(j['last_sequence']),
        useExpiration:   _pi(j['use_expiration']),
        expirationDays:  j['expiration_days'] == null ? null : _pi(j['expiration_days']),
        bestBeforeDays:  j['best_before_days'] == null ? null : _pi(j['best_before_days']),
        removalDays:     j['removal_days'] == null ? null : _pi(j['removal_days']),
        alertDays:       j['alert_days'] == null ? null : _pi(j['alert_days']),
      );

  bool get isAutoGenerateLot => autoGenerateLot == 1;
  bool get isUseExpiration   => useExpiration == 1;
}

class ReceiptNoteFormItem {
  int? idProduct;
  String? productName;
  String? description;
  int? uomId;
  String? uomName;
  double demandQty;
  double? receivedQty;

  ReceiptNoteFormItem({
    this.idProduct,
    this.productName,
    this.description,
    this.uomId,
    this.uomName,
    this.demandQty = 0,
    this.receivedQty,
  });

  factory ReceiptNoteFormItem.fromItem(ReceiptNoteItem i) => ReceiptNoteFormItem(
        idProduct:   i.idProduct,
        productName: i.productName,
        description: i.description,
        uomId:       i.unitOfMeasure,
        uomName:     i.uomName,
        demandQty:   i.demandQty,
        receivedQty: i.receivedQty,
      );

  Map<String, dynamic> toSaveJson() => {
        'id_product':      idProduct,
        'demand_qty':      demandQty,
        'unit_of_measure': uomId,
      };

  Map<String, dynamic> toValidateJson() => {
        'id_product':   idProduct,
        'received_qty': receivedQty ?? 0,
      };
}

class ReceiptNoteFormModel {
  int? idReceiptNote;
  String? encryption;
  String? reference;
  int? vendor;
  String? branch;
  String? vendorLocation;
  int? destinationWarehouse;
  int? destinationLocation;
  DateTime? scheduledDate;
  String? sourceDocument;
  String? notes;
  int? backorderFrom;
  bool allowBackorder;
  List<ReceiptNoteFormItem> items;

  ReceiptNoteFormModel({
    this.idReceiptNote,
    this.encryption,
    this.reference,
    this.vendor,
    this.branch,
    this.vendorLocation,
    this.destinationWarehouse,
    this.destinationLocation,
    this.scheduledDate,
    this.sourceDocument,
    this.notes,
    this.backorderFrom,
    this.allowBackorder = false,
    List<ReceiptNoteFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idReceiptNote != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toSaveJson() => {
        if (idReceiptNote != null) 'id_receipt_note': idReceiptNote,
        'status':                 'save',
        'vendor':                 vendor,
        'branch':                 branch,
        'vendor_location':        vendorLocation ?? 'Vendor Location',
        'destination_warehouse':  destinationWarehouse,
        'destination_location':   destinationLocation,
        'scheduled_date':         scheduledDate != null ? _fmtDate(scheduledDate!) : null,
        'source_document':        sourceDocument,
        'notes':                  notes,
        if (backorderFrom != null) 'backorder_from': backorderFrom,
        'products': items.map((i) => i.toSaveJson()).toList(),
      };

  Map<String, dynamic> toConfirmJson() => {
        'id_receipt_note':        idReceiptNote,
        'status':                 'confirm',
        'vendor':                 vendor,
        'branch':                 branch,
        'vendor_location':        vendorLocation ?? 'Vendor Location',
        'destination_warehouse':  destinationWarehouse,
        'destination_location':   destinationLocation,
        'scheduled_date':         scheduledDate != null ? _fmtDate(scheduledDate!) : null,
        'source_document':        sourceDocument,
        'notes':                  notes,
        'products': items.map((i) => i.toSaveJson()).toList(),
      };

  Map<String, dynamic> toValidateJson() => {
        'id_receipt_note': idReceiptNote,
        'status':          'validate',
        'allow_backorder': allowBackorder,
        'products': items.map((i) => i.toValidateJson()).toList(),
      };

  factory ReceiptNoteFormModel.fromDetail(ReceiptNoteDetailModel d) => ReceiptNoteFormModel(
        idReceiptNote:         d.idReceiptNote,
        encryption:            d.encryption,
        reference:             d.reference,
        vendor:                d.vendor,
        branch:                d.branch,
        vendorLocation:        d.vendorLocation,
        destinationWarehouse:  d.destinationWarehouse,
        destinationLocation:   d.destinationLocation,
        scheduledDate:         d.scheduledDate != null ? DateTime.tryParse(d.scheduledDate!) : null,
        sourceDocument:        d.sourceDocument,
        notes:                 d.notes,
        backorderFrom:         d.backorderFrom,
        items: d.items.map((i) => ReceiptNoteFormItem.fromItem(i)).toList(),
      );
}