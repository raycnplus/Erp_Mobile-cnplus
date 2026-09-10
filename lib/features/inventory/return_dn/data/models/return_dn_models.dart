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

class ReturnDNModel {
  final int idReturnDeliveryNote;
  final String encryption;
  final String status;
  final String? documentCode;
  final String? scheduledDate;
  final String? resolvedReference;
  final String? soReference;

  ReturnDNModel({
    required this.idReturnDeliveryNote,
    required this.encryption,
    required this.status,
    this.documentCode,
    this.scheduledDate,
    this.resolvedReference,
    this.soReference,
  });

  factory ReturnDNModel.fromJson(Map<String, dynamic> j) => ReturnDNModel(
        idReturnDeliveryNote: _pi(j['id_return_delivery_note']),
        encryption:           _ps(j['encryption']),
        status:               _ps(j['status']),
        documentCode:         j['document_code']?.toString(),
        scheduledDate:        j['scheduled_date']?.toString(),
        resolvedReference:    j['resolved_reference']?.toString(),
        soReference:          j['so_reference']?.toString(),
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

class ReturnDNPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  ReturnDNPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class ReturnDNItem {
  final int? idReturnDeliveryNoteItem;
  final int idProduct;
  final String? productName;
  final int? idDeliveryNote;
  final int? idDeliveryNoteItem;
  final String? dnReference;
  final int? sourceLocation;
  final double receivedQty;
  final double returnQty;
  final double remainingQty;
  final double onHandQty;
  final int? uomId;
  final String? uomName;
  final String? returnType;
  final int? replaceProductId;
  final String? replaceProductName;
  final double? replaceOnHand;
  final String? trackingMethod;

  ReturnDNItem({
    this.idReturnDeliveryNoteItem,
    required this.idProduct,
    this.productName,
    this.idDeliveryNote,
    this.idDeliveryNoteItem,
    this.dnReference,
    this.sourceLocation,
    this.receivedQty = 0,
    this.returnQty = 0,
    this.remainingQty = 0,
    this.onHandQty = 0,
    this.uomId,
    this.uomName,
    this.returnType,
    this.replaceProductId,
    this.replaceProductName,
    this.replaceOnHand,
    this.trackingMethod,
  });

  factory ReturnDNItem.fromJson(Map<String, dynamic> j) => ReturnDNItem(
        idReturnDeliveryNoteItem: j['id_return_delivery_note_item'] == null ? null : _pi(j['id_return_delivery_note_item']),
        idProduct:                _pi(j['id_product']),
        productName:              j['product_name']?.toString(),
        idDeliveryNote:           j['id_delivery_note'] == null ? null : _pi(j['id_delivery_note']),
        idDeliveryNoteItem:       j['id_delivery_note_item'] == null ? null : _pi(j['id_delivery_note_item']),
        dnReference:              j['dn_reference']?.toString(),
        sourceLocation:           j['source_location'] == null ? null : _pi(j['source_location']),
        receivedQty:              _pd(j['received_qty']),
        returnQty:                _pd(j['return_qty']),
        remainingQty:             _pd(j['remaining_qty']),
        onHandQty:                _pd(j['on_hand_qty']),
        uomId:                    j['uom_id'] == null ? null : _pi(j['uom_id']),
        uomName:                  j['uom_name']?.toString(),
        returnType:               j['return_type']?.toString(),
        replaceProductId:         j['replace_product_id'] == null ? null : _pi(j['replace_product_id']),
        replaceProductName:      (j['replace_product_name']?.toString().isEmpty ?? true) ? null : j['replace_product_name'].toString(),
        replaceOnHand:            j['replace_on_hand'] == null ? null : _pd(j['replace_on_hand']),
        trackingMethod:           j['tracking_method']?.toString(),
      );

  bool get hasTracking => trackingMethod != null && trackingMethod!.isNotEmpty;
}

class ReturnDNAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  ReturnDNAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory ReturnDNAuditTrail.fromJson(Map<String, dynamic> j) => ReturnDNAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class DNLotSerial {
  final int idProductLotSerial;
  final String? lotSerialNumber;
  final double remainingQuantity;
  final String? trackingMethod;
  final String? expirationDate;
  final String? removalDate;

  DNLotSerial({required this.idProductLotSerial, this.lotSerialNumber, this.remainingQuantity = 0, this.trackingMethod, this.expirationDate, this.removalDate});

  factory DNLotSerial.fromJson(Map<String, dynamic> j) => DNLotSerial(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotSerialNumber:    j['lot_serial_number']?.toString(),
        remainingQuantity:  _pd(j['remaining_quantity']),
        trackingMethod:     j['tracking_method']?.toString(),
        expirationDate:     j['expiration_date']?.toString(),
        removalDate:        j['removal_date']?.toString(),
      );
}

class DNTrackingUsage {
  final int idProductLotSerial;
  final double quantity;

  DNTrackingUsage({required this.idProductLotSerial, required this.quantity});

  factory DNTrackingUsage.fromJson(Map<String, dynamic> j) => DNTrackingUsage(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        quantity:           _pd(j['quantity']),
      );
}

class DNReferenceInfo {
  final int idDeliveryNote;
  final String encryption;
  final String reference;
  final int? sourceWarehouse;
  final int? sourceLocation;

  DNReferenceInfo({required this.idDeliveryNote, required this.encryption, required this.reference, this.sourceWarehouse, this.sourceLocation});

  factory DNReferenceInfo.fromJson(Map<String, dynamic> j) => DNReferenceInfo(
        idDeliveryNote:  _pi(j['id_delivery_note']),
        encryption:      _ps(j['encryption']),
        reference:       _ps(j['reference']),
        sourceWarehouse: j['source_warehouse'] == null ? null : _pi(j['source_warehouse']),
        sourceLocation:  j['source_location'] == null ? null : _pi(j['source_location']),
      );
}

class ReturnDNDetailModel {
  final int idReturnDeliveryNote;
  final String encryption;
  final String status;
  final String? reference;
  final int? idSalesOrder;
  final String? scheduledDate;
  final String? note;
  final String? cancelReason;
  final bool serialNumberSetting;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final List<ReturnDNItem> items;
  final List<ReturnDNAuditTrail> auditTrails;
  final List<DNReferenceInfo> dnReferences;
  final Map<String, dynamic> lotSerialsPerItem;

  ReturnDNDetailModel({
    required this.idReturnDeliveryNote,
    required this.encryption,
    required this.status,
    this.reference,
    this.idSalesOrder,
    this.scheduledDate,
    this.note,
    this.cancelReason,
    this.serialNumberSetting = false,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    required this.items,
    required this.auditTrails,
    required this.dnReferences,
    this.lotSerialsPerItem = const {},
  });

  factory ReturnDNDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ReturnDNDetailModel(
      idReturnDeliveryNote: _pi(data['id_return_delivery_note']),
      encryption:           _ps(data['encryption']),
      status:               _ps(data['status']),
      reference:            data['reference']?.toString(),
      idSalesOrder:         _pi(data['id_sales_order']) == 0 ? null : _pi(data['id_sales_order']),
      scheduledDate:        data['scheduled_date']?.toString(),
      note:                 data['note']?.toString(),
      cancelReason:         data['cancel_reason']?.toString(),
      serialNumberSetting:  data['serial_number_setting'] == true,
      createdByName:        data['created_by_name']?.toString(),
      updatedByName:        data['updated_by_name']?.toString(),
      cancelledByName:      data['cancelled_by_name']?.toString(),
      createdDate:          data['created_date']?.toString(),
      updatedDate:          data['updated_date']?.toString(),
      cancelledDate:        data['cancelled_date']?.toString(),
      items:          (data['dn_items'] as List? ?? []).map((e) => ReturnDNItem.fromJson(e)).toList(),
      auditTrails:    (data['audit_trails'] as List? ?? []).map((e) => ReturnDNAuditTrail.fromJson(e)).toList(),
      dnReferences:   (data['dn_references'] as List? ?? []).map((e) => DNReferenceInfo.fromJson(e)).toList(),
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

  bool hasTrackingUsageFor(int idReturnDeliveryNoteItem) {
    final entry = lotSerialsPerItem[idReturnDeliveryNoteItem.toString()];
    if (entry == null) return false;
    final usage = entry['usage'];
    return usage is List && usage.isNotEmpty;
  }

  List<DNTrackingUsage> getTrackingUsage(int idReturnDeliveryNoteItem) {
    final entry = lotSerialsPerItem[idReturnDeliveryNoteItem.toString()];
    if (entry == null) return [];
    return ((entry['usage'] as List?) ?? []).map((e) => DNTrackingUsage.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  List<DNLotSerial> getLotSerials(int idReturnDeliveryNoteItem) {
    final entry = lotSerialsPerItem[idReturnDeliveryNoteItem.toString()];
    if (entry == null) return [];
    return ((entry['lot_serials'] as List?) ?? []).map((e) => DNLotSerial.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  String get dnReferenceDisplay {
    if (dnReferences.isNotEmpty) return dnReferences.map((r) => r.reference).join(', ');
    if (items.isNotEmpty && items.first.dnReference?.isNotEmpty == true) return items.first.dnReference!;
    return '-';
  }
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

class DNProductOption {
  final int idProduct;
  final String productName;
  final String? productCode;
  DNProductOption({required this.idProduct, required this.productName, this.productCode});
  factory DNProductOption.fromJson(Map<String, dynamic> j) => DNProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        productCode: j['product_code']?.toString(),
      );
  @override bool operator ==(Object o) => o is DNProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class SOOption {
  final int idSalesOrder;
  final String reference;
  SOOption({required this.idSalesOrder, required this.reference});
  factory SOOption.fromJson(Map<String, dynamic> j) => SOOption(
        idSalesOrder: _pi(j['id_sales_order']),
        reference:    _ps(j['reference']),
      );
  @override bool operator ==(Object o) => o is SOOption && o.idSalesOrder == idSalesOrder;
  @override int get hashCode => idSalesOrder.hashCode;
}

class ReturnDNFormOptions {
  final List<DNUomOption> uoms;
  final List<DNProductOption> products;
  final List<SOOption> validatedSOs;
  final List<String> returnTypes;

  ReturnDNFormOptions({
    required this.uoms,
    required this.products,
    required this.validatedSOs,
    this.returnTypes = const ['Return', 'Replace', 'Repair'],
  });

  factory ReturnDNFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ReturnDNFormOptions(
      uoms:         (data['uoms'] as List? ?? []).map((e) => DNUomOption.fromJson(e)).toList(),
      products:     (data['products'] as List? ?? []).map((e) => DNProductOption.fromJson(e)).toList(),
      validatedSOs: (data['validated_sos'] as List? ?? []).map((e) => SOOption.fromJson(e)).toList(),
      returnTypes:  (data['return_types'] as List?)?.map((e) => e.toString()).toList() ?? ['Return', 'Replace', 'Repair'],
    );
  }
}

class DNOption {
  final int idDeliveryNote;
  final String reference;
  final int? sourceLocation;

  DNOption({required this.idDeliveryNote, required this.reference, this.sourceLocation});

  factory DNOption.fromJson(Map<String, dynamic> j) => DNOption(
        idDeliveryNote: _pi(j['id_delivery_note']),
        reference:      _ps(j['reference']),
        sourceLocation: j['source_location'] == null ? null : _pi(j['source_location']),
      );

  @override bool operator ==(Object o) => o is DNOption && o.idDeliveryNote == idDeliveryNote;
  @override int get hashCode => idDeliveryNote.hashCode;
}

class ReplaceProductOption {
  final int idProduct;
  final String productName;
  final double stockQty;

  ReplaceProductOption({required this.idProduct, required this.productName, this.stockQty = 0});

  factory ReplaceProductOption.fromJson(Map<String, dynamic> j) => ReplaceProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        stockQty:    _pd(j['stock_qty']),
      );
}

class ReplaceProductsResult {
  final List<ReplaceProductOption> products;
  final int? location;
  final int? warehouse;

  ReplaceProductsResult({required this.products, this.location, this.warehouse});

  factory ReplaceProductsResult.fromJson(Map<String, dynamic> j) => ReplaceProductsResult(
        products:  (j['products'] as List? ?? []).map((e) => ReplaceProductOption.fromJson(e)).toList(),
        location:  j['location'] == null ? null : _pi(j['location']),
        warehouse: j['warehouse'] == null ? null : _pi(j['warehouse']),
      );
}

class ReturnDNFormItem {
  int? idProduct;
  String? productName;
  int? uomId;
  String? uomName;
  double returnQty;
  double availableQty;
  double receivedQty;
  double onHandQty;
  String? returnType;
  int? replaceProductId;
  String? replaceProductName;
  double? replaceOnHand;
  int? idDeliveryNote;
  int? idDeliveryNoteItem;

  ReturnDNFormItem({
    this.idProduct,
    this.productName,
    this.uomId,
    this.uomName,
    this.returnQty = 0,
    this.availableQty = 0,
    this.receivedQty = 0,
    this.onHandQty = 0,
    this.returnType,
    this.replaceProductId,
    this.replaceProductName,
    this.replaceOnHand,
    this.idDeliveryNote,
    this.idDeliveryNoteItem,
  });

  Map<String, dynamic> toJsonSave() => {
        'id_product':            idProduct,
        'id_delivery_note':      idDeliveryNote,
        'id_delivery_note_item': idDeliveryNoteItem,
        'received_qty':          receivedQty,
        'return_qty':            returnQty,
        'unit_of_measure':       uomId,
        'return_type':           returnType,
        if (replaceProductId != null) 'replace_product_id': replaceProductId,
      };

  Map<String, dynamic> toJsonValidate() => toJsonSave();

  factory ReturnDNFormItem.fromItem(ReturnDNItem i) => ReturnDNFormItem(
        idProduct:           i.idProduct,
        productName:         i.productName,
        uomId:               i.uomId,
        uomName:             i.uomName,
        returnQty:           i.returnQty,
        availableQty:        i.remainingQty,
        receivedQty:         i.receivedQty,
        onHandQty:           i.onHandQty,
        returnType:          i.returnType,
        replaceProductId:    i.replaceProductId,
        replaceProductName:  i.replaceProductName,
        replaceOnHand:       i.replaceOnHand,
        idDeliveryNote:      i.idDeliveryNote,
        idDeliveryNoteItem:  i.idDeliveryNoteItem,
      );
}

class ReturnDNFormModel {
  int? idReturnDeliveryNote;
  String? encryption;
  int? idSalesOrder;
  DateTime? scheduledDate;
  String? note;
  List<ReturnDNFormItem> items;

  ReturnDNFormModel({
    this.idReturnDeliveryNote,
    this.encryption,
    this.idSalesOrder,
    this.scheduledDate,
    this.note,
    List<ReturnDNFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idReturnDeliveryNote != null;

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) {
    if (status == 'validate') {
      return {
        'id_return_delivery_note': idReturnDeliveryNote,
        'status':                  'validate',
        'products':                items.map((i) => i.toJsonValidate()).toList(),
      };
    }
    return {
      if (idReturnDeliveryNote != null) 'id_return_delivery_note': idReturnDeliveryNote,
      if (idSalesOrder != null) 'id_sales_order': idSalesOrder,
      'scheduled_date': scheduledDate != null ? _fmtDate(scheduledDate!) : null,
      if (note != null) 'note': note,
      'status':   status,
      'products': items.map((i) => i.toJsonSave()).toList(),
    };
  }

  factory ReturnDNFormModel.fromDetail(ReturnDNDetailModel d) => ReturnDNFormModel(
        idReturnDeliveryNote: d.idReturnDeliveryNote,
        encryption:           d.encryption,
        idSalesOrder:         d.idSalesOrder,
        scheduledDate:        d.scheduledDate != null ? DateTime.tryParse(d.scheduledDate!) : null,
        note:                 d.note,
        items: d.items.map((i) => ReturnDNFormItem.fromItem(i)).toList(),
      );
}