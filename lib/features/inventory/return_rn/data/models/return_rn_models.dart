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

class ReturnRNModel {
  final int idReturnReceiptNote;
  final String encryption;
  final String status;
  final String? documentCode;
  final String? scheduledDate;
  final String? resolvedReference;
  final String? poReference;

  ReturnRNModel({
    required this.idReturnReceiptNote,
    required this.encryption,
    required this.status,
    this.documentCode,
    this.scheduledDate,
    this.resolvedReference,
    this.poReference,
  });

  factory ReturnRNModel.fromJson(Map<String, dynamic> j) => ReturnRNModel(
        idReturnReceiptNote: _pi(j['id_return_receipt_note']),
        encryption:          _ps(j['encryption']),
        status:              _ps(j['status']),
        documentCode:        j['document_code']?.toString(),
        scheduledDate:       j['scheduled_date']?.toString(),
        resolvedReference:   j['resolved_reference']?.toString(),
        poReference:         j['po_reference']?.toString(),
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

class ReturnRNPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  ReturnRNPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class ReturnRNItem {
  final int idReturnReceiptNoteItem;
  final int idProduct;
  final String? productName;
  final int? idReceiptNote;
  final int? idReceiptNoteItem;
  final String? rnReference;
  final int? destinationLocation;
  final double deliveredQty;
  final double returnQty;
  final int? uomId;
  final String? uomName;
  final String? returnType;
  final int? replaceProductId;
  final String? trackingMethod;
  final double onHandQty;
  final double remainingQty;

  ReturnRNItem({
    required this.idReturnReceiptNoteItem,
    required this.idProduct,
    this.productName,
    this.idReceiptNote,
    this.idReceiptNoteItem,
    this.rnReference,
    this.destinationLocation,
    required this.deliveredQty,
    required this.returnQty,
    this.uomId,
    this.uomName,
    this.returnType,
    this.replaceProductId,
    this.trackingMethod,
    this.onHandQty = 0,
    this.remainingQty = 0,
  });

  factory ReturnRNItem.fromJson(Map<String, dynamic> j) => ReturnRNItem(
        idReturnReceiptNoteItem: _pi(j['id_return_receipt_note_item']),
        idProduct:               _pi(j['id_product']),
        productName:             j['product_name']?.toString(),
        idReceiptNote:           _pi(j['id_receipt_note']) == 0 ? null : _pi(j['id_receipt_note']),
        idReceiptNoteItem:       _pi(j['id_receipt_note_item']) == 0 ? null : _pi(j['id_receipt_note_item']),
        rnReference:             j['rn_reference']?.toString(),
        destinationLocation:     _pi(j['destination_location']) == 0 ? null : _pi(j['destination_location']),
        deliveredQty:            _pd(j['delivered_qty']),
        returnQty:               _pd(j['return_qty']),
        uomId:                   _pi(j['uom_id']) == 0 ? null : _pi(j['uom_id']),
        uomName:                 j['uom_name']?.toString(),
        returnType:              j['return_type']?.toString(),
        replaceProductId:        j['replace_product_id'] == null ? null : _pi(j['replace_product_id']),
        trackingMethod:          j['tracking_method']?.toString(),
        onHandQty:               _pd(j['on_hand_qty']),
        remainingQty:            _pd(j['remaining_qty']),
      );

  bool get hasTracking => trackingMethod != null && trackingMethod!.isNotEmpty;
}

class ReturnRNAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  ReturnRNAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory ReturnRNAuditTrail.fromJson(Map<String, dynamic> j) => ReturnRNAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class RNLotSerial {
  final int idProductLotSerial;
  final String? lotSerialNumber;
  final double remainingQuantity;
  final String? trackingMethod;
  final String? expirationDate;
  final String? removalDate;

  RNLotSerial({required this.idProductLotSerial, this.lotSerialNumber, this.remainingQuantity = 0, this.trackingMethod, this.expirationDate, this.removalDate});

  factory RNLotSerial.fromJson(Map<String, dynamic> j) => RNLotSerial(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotSerialNumber:    j['lot_serial_number']?.toString(),
        remainingQuantity:  _pd(j['remaining_quantity']),
        trackingMethod:     j['tracking_method']?.toString(),
        expirationDate:     j['expiration_date']?.toString(),
        removalDate:        j['removal_date']?.toString(),
      );
}

class RNTrackingUsage {
  final int idProductLotSerial;
  final double quantity;

  RNTrackingUsage({required this.idProductLotSerial, required this.quantity});

  factory RNTrackingUsage.fromJson(Map<String, dynamic> j) => RNTrackingUsage(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        quantity:           _pd(j['quantity']),
      );
}

class RNReferenceInfo {
  final int idReceiptNote;
  final String encryption;
  final String reference;
  final int? destinationWarehouse;
  final int? destinationLocation;

  RNReferenceInfo({required this.idReceiptNote, required this.encryption, required this.reference, this.destinationWarehouse, this.destinationLocation});

  factory RNReferenceInfo.fromJson(Map<String, dynamic> j) => RNReferenceInfo(
        idReceiptNote:        _pi(j['id_receipt_note']),
        encryption:           _ps(j['encryption']),
        reference:            _ps(j['reference']),
        destinationWarehouse: _pi(j['destination_warehouse']) == 0 ? null : _pi(j['destination_warehouse']),
        destinationLocation:  _pi(j['destination_location']) == 0 ? null : _pi(j['destination_location']),
      );
}

class ReturnRNDetailModel {
  final int idReturnReceiptNote;
  final String encryption;
  final String status;
  final String? reference;
  final int? idPurchaseOrder;
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
  final List<ReturnRNItem> items;
  final List<ReturnRNAuditTrail> auditTrails;
  final List<RNReferenceInfo> rnReferences;
  final Map<String, dynamic> lotSerialsPerItem;

  ReturnRNDetailModel({
    required this.idReturnReceiptNote,
    required this.encryption,
    required this.status,
    this.reference,
    this.idPurchaseOrder,
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
    required this.rnReferences,
    this.lotSerialsPerItem = const {},
  });

  factory ReturnRNDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ReturnRNDetailModel(
      idReturnReceiptNote: _pi(data['id_return_receipt_note']),
      encryption:          _ps(data['encryption']),
      status:              _ps(data['status']),
      reference:           data['reference']?.toString(),
      idPurchaseOrder:     _pi(data['id_purchase_order']) == 0 ? null : _pi(data['id_purchase_order']),
      scheduledDate:       data['scheduled_date']?.toString(),
      note:                data['note']?.toString(),
      cancelReason:        data['cancel_reason']?.toString(),
      serialNumberSetting: data['serial_number_setting'] == true,
      createdByName:       data['created_by_name']?.toString(),
      updatedByName:       data['updated_by_name']?.toString(),
      cancelledByName:     data['cancelled_by_name']?.toString(),
      createdDate:         data['created_date']?.toString(),
      updatedDate:         data['updated_date']?.toString(),
      cancelledDate:       data['cancelled_date']?.toString(),
      items:          (data['rn_items'] as List? ?? []).map((e) => ReturnRNItem.fromJson(e)).toList(),
      auditTrails:    (data['audit_trails'] as List? ?? []).map((e) => ReturnRNAuditTrail.fromJson(e)).toList(),
      rnReferences:   (data['rn_references'] as List? ?? []).map((e) => RNReferenceInfo.fromJson(e)).toList(),
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

  bool hasTrackingUsageFor(int idReturnReceiptNoteItem) {
    final entry = lotSerialsPerItem[idReturnReceiptNoteItem.toString()];
    if (entry == null) return false;
    final usage = entry['usage'];
    return usage is List && usage.isNotEmpty;
  }

  List<RNTrackingUsage> getTrackingUsage(int idReturnReceiptNoteItem) {
    final entry = lotSerialsPerItem[idReturnReceiptNoteItem.toString()];
    if (entry == null) return [];
    return ((entry['usage'] as List?) ?? []).map((e) => RNTrackingUsage.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  List<RNLotSerial> getLotSerials(int idReturnReceiptNoteItem) {
    final entry = lotSerialsPerItem[idReturnReceiptNoteItem.toString()];
    if (entry == null) return [];
    return ((entry['lot_serials'] as List?) ?? []).map((e) => RNLotSerial.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  String get rnReferenceDisplay {
    if (rnReferences.isNotEmpty) return rnReferences.map((r) => r.reference).join(', ');
    if (items.isNotEmpty && items.first.rnReference?.isNotEmpty == true) return items.first.rnReference!;
    return '-';
  }
}

class RRNUomOption {
  final int id;
  final String name;
  RRNUomOption({required this.id, required this.name});
  factory RRNUomOption.fromJson(Map<String, dynamic> j) =>
      RRNUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));
  @override bool operator ==(Object o) => o is RRNUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class ReturnRNFormOptions {
  final List<RRNUomOption> uoms;
  final List<String> returnTypes;

  ReturnRNFormOptions({
    required this.uoms,
    this.returnTypes = const ['Return', 'Replace', 'Repair'],
  });

  factory ReturnRNFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ReturnRNFormOptions(
      uoms: (data['uoms'] as List? ?? []).map((e) => RRNUomOption.fromJson(e)).toList(),
      returnTypes: (data['return_types'] as List?)?.map((e) => e.toString()).toList() ?? ['Return', 'Replace', 'Repair'],
    );
  }
}

class ValidatedRNOption {
  final int idReceiptNote;
  final String reference;

  ValidatedRNOption({required this.idReceiptNote, required this.reference});

  factory ValidatedRNOption.fromJson(Map<String, dynamic> j) => ValidatedRNOption(
        idReceiptNote: _pi(j['id_receipt_note']),
        reference:     _ps(j['reference']),
      );

  @override bool operator ==(Object o) => o is ValidatedRNOption && o.idReceiptNote == idReceiptNote;
  @override int get hashCode => idReceiptNote.hashCode;
}

class RNSourceItem {
  final int idReceiptNote;
  final int idReceiptNoteItem;
  final int idProduct;
  final String productName;
  final int? uomId;
  final String uomName;
  final double deliveredQty;
  final double remainingQty;

  RNSourceItem({
    required this.idReceiptNote,
    required this.idReceiptNoteItem,
    required this.idProduct,
    required this.productName,
    this.uomId,
    required this.uomName,
    required this.deliveredQty,
    required this.remainingQty,
  });

  factory RNSourceItem.fromJson(Map<String, dynamic> j) => RNSourceItem(
        idReceiptNote:     _pi(j['id_receipt_note']),
        idReceiptNoteItem: _pi(j['id_receipt_note_item']),
        idProduct:         _pi(j['id_product']),
        productName:       _ps(j['product_name']),
        uomId:             j['uom_id'] == null ? null : _pi(j['uom_id']),
        uomName:           _ps(j['uom_name']),
        deliveredQty:      _pd(j['delivered_qty']),
        remainingQty:      _pd(j['remaining_qty']),
      );
}

class ReturnRNFormItem {
  int? idProduct;
  String? productName;
  int? uomId;
  String? uomName;
  double returnQty;
  double availableQty;
  double deliveredQty;
  String? returnType;
  int? replaceProductId;
  int? idReceiptNote;
  int? idReceiptNoteItem;

  ReturnRNFormItem({
    this.idProduct,
    this.productName,
    this.uomId,
    this.uomName,
    this.returnQty = 0,
    this.availableQty = 0,
    this.deliveredQty = 0,
    this.returnType,
    this.replaceProductId,
    this.idReceiptNote,
    this.idReceiptNoteItem,
  });

  Map<String, dynamic> toJsonSave() => {
        'id_product':         idProduct,
        'unit_of_measure':    uomId,
        'return_qty':         returnQty,
        'delivered_qty':      deliveredQty,
        'return_type':        returnType,
        if (replaceProductId != null) 'replace_product_id': replaceProductId,
        if (idReceiptNote != null) 'id_receipt_note': idReceiptNote,
        if (idReceiptNoteItem != null) 'id_receipt_note_item': idReceiptNoteItem,
      };

  Map<String, dynamic> toJsonValidate() => {
        'id_product':         idProduct,
        'unit_of_measure':    uomId,
        'return_qty':         returnQty,
        'delivered_qty':      deliveredQty,
        'return_type':        returnType,
        if (replaceProductId != null) 'replace_product_id': replaceProductId,
        if (idReceiptNote != null) 'id_receipt_note': idReceiptNote,
        if (idReceiptNoteItem != null) 'id_receipt_note_item': idReceiptNoteItem,
      };
}

class ReturnRNFormModel {
  int? idReturnReceiptNote;
  String? encryption;
  int? idPurchaseOrder;
  DateTime? scheduledDate;
  String? note;
  List<ReturnRNFormItem> items;

  ReturnRNFormModel({
    this.idReturnReceiptNote,
    this.encryption,
    this.idPurchaseOrder,
    this.scheduledDate,
    this.note,
    List<ReturnRNFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idReturnReceiptNote != null;

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) {
    if (status == 'validate') {
      return {
        'id_return_receipt_note': idReturnReceiptNote,
        'status':                 'validate',
        'products':               items.map((i) => i.toJsonValidate()).toList(),
      };
    }
    return {
      if (idReturnReceiptNote != null) 'id_return_receipt_note': idReturnReceiptNote,
      if (idPurchaseOrder != null) 'id_purchase_order': idPurchaseOrder,
      'scheduled_date': scheduledDate != null ? _fmtDate(scheduledDate!) : null,
      if (note != null) 'note': note,
      'status':   status,
      'products': items.map((i) => i.toJsonSave()).toList(),
    };
  }

  factory ReturnRNFormModel.fromDetail(ReturnRNDetailModel d) => ReturnRNFormModel(
        idReturnReceiptNote: d.idReturnReceiptNote,
        encryption:          d.encryption,
        idPurchaseOrder:     d.idPurchaseOrder,
        scheduledDate:       d.scheduledDate != null ? DateTime.tryParse(d.scheduledDate!) : null,
        note:                d.note,
        items: d.items.map((i) => ReturnRNFormItem(
              idProduct:         i.idProduct,
              productName:       i.productName,
              uomId:             i.uomId,
              uomName:           i.uomName,
              returnQty:         i.returnQty,
              availableQty:      i.remainingQty,
              deliveredQty:      i.deliveredQty,
              returnType:        i.returnType,
              replaceProductId:  i.replaceProductId,
              idReceiptNote:     i.idReceiptNote,
              idReceiptNoteItem: i.idReceiptNoteItem,
            )).toList(),
      );
}