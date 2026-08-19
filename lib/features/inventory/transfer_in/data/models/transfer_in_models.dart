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

class TransferInModel {
  final int idInternalTransfer;
  final String encryption;
  final String? reference;
  final String status;
  final String? scheduledDate;
  final String? sourceDocument;
  final String? sourceLocationName;
  final String? destinationLocationName;

  TransferInModel({
    required this.idInternalTransfer,
    required this.encryption,
    this.reference,
    required this.status,
    this.scheduledDate,
    this.sourceDocument,
    this.sourceLocationName,
    this.destinationLocationName,
  });

  factory TransferInModel.fromJson(Map<String, dynamic> j) => TransferInModel(
        idInternalTransfer:      _pi(j['id_internal_transfer']),
        encryption:              _ps(j['encryption']),
        reference:               j['reference']?.toString(),
        status:                  _ps(j['status']),
        scheduledDate:           j['scheduled_date']?.toString(),
        sourceDocument:          j['source_document']?.toString(),
        sourceLocationName:      j['source_location_name']?.toString(),
        destinationLocationName: j['destination_location_name']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Confirmed': 0xFF1565C0,
    'Done':      0xFF2E7D32,
    'Cancelled': 0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class TransferInPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  TransferInPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class TILotSerial {
  final int idProductLotSerial;
  final String? lotSerialNumber;
  final String? expirationDate;
  final String? removalDate;

  TILotSerial({
    required this.idProductLotSerial,
    this.lotSerialNumber,
    this.expirationDate,
    this.removalDate,
  });

  factory TILotSerial.fromJson(Map<String, dynamic> j) => TILotSerial(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        lotSerialNumber:    j['lot_serial_number']?.toString(),
        expirationDate:     j['expiration_date']?.toString(),
        removalDate:        j['removal_date']?.toString(),
      );
}

class TITrackingUsage {
  final int idProductLotSerial;
  final double quantity;

  TITrackingUsage({required this.idProductLotSerial, required this.quantity});

  factory TITrackingUsage.fromJson(Map<String, dynamic> j) => TITrackingUsage(
        idProductLotSerial: _pi(j['id_product_lot_serial']),
        quantity:           _pd(j['quantity']),
      );
}

class TransferInItem {
  final int mappingKey; 
  final int idProduct;
  final int unitOfMeasure;
  final String? productName;
  final String? uomName;
  final double? transferredQty; 
  final double? receivedQty;

  TransferInItem({
    required this.mappingKey,
    required this.idProduct,
    required this.unitOfMeasure,
    this.productName,
    this.uomName,
    this.transferredQty,
    this.receivedQty,
  });

  factory TransferInItem.fromJson(Map<String, dynamic> j) => TransferInItem(
        mappingKey:     _pi(j['mapping_key']),
        idProduct:      _pi(j['id_product']),
        unitOfMeasure:  _pi(j['unit_of_measure']),
        productName:    j['product_name']?.toString(),
        uomName:        j['unit_of_measure_name']?.toString(),
        transferredQty: j['transferred_qty'] == null ? null : _pd(j['transferred_qty']),
        receivedQty:    j['received_qty'] == null ? null : _pd(j['received_qty']),
      );
}

class TransferInAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  TransferInAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory TransferInAuditTrail.fromJson(Map<String, dynamic> j) => TransferInAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class TransferInDetailModel {
  final int idInternalTransfer;
  final String encryption;
  final String status;
  final String? reference;
  final String? sourceWarehouseName;
  final String? sourceLocationName;
  final String? destinationWarehouseName;
  final String? destinationLocationName;
  final String? scheduledDate;
  final String? sourceDocument;
  final String? notes;
  final String? createdByName;
  final String? updatedByName;
  final String? createdDate;
  final String? updatedDate;
  final bool hasEmptyTransferredQty;
  final List<TransferInItem> items;
  final List<TransferInAuditTrail> auditTrails;
  final Map<String, dynamic> lotSerialsPerItem; 

  TransferInDetailModel({
    required this.idInternalTransfer,
    required this.encryption,
    required this.status,
    this.reference,
    this.sourceWarehouseName,
    this.sourceLocationName,
    this.destinationWarehouseName,
    this.destinationLocationName,
    this.scheduledDate,
    this.sourceDocument,
    this.notes,
    this.createdByName,
    this.updatedByName,
    this.createdDate,
    this.updatedDate,
    this.hasEmptyTransferredQty = false,
    required this.items,
    required this.auditTrails,
    this.lotSerialsPerItem = const {},
  });

  factory TransferInDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return TransferInDetailModel(
      idInternalTransfer:       _pi(data['id_internal_transfer']),
      encryption:               _ps(data['encryption']),
      status:                   _ps(data['status']),
      reference:                data['reference']?.toString(),
      sourceWarehouseName:      data['source_warehouse']?.toString(),
      sourceLocationName:       data['source_location']?.toString(),
      destinationWarehouseName: data['destination_warehouse']?.toString(),
      destinationLocationName:  data['destination_location']?.toString(),
      scheduledDate:            data['scheduled_date']?.toString(),
      sourceDocument:           data['source_document']?.toString(),
      notes:                    data['notes']?.toString(),
      createdByName:            data['created_by_name']?.toString(),
      updatedByName:            data['updated_by_name']?.toString(),
      createdDate:              data['created_date']?.toString(),
      updatedDate:              data['updated_date']?.toString(),
      hasEmptyTransferredQty:   data['has_empty_transferred_qty'] == true,
      items:       (data['items']        as List? ?? []).map((e) => TransferInItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => TransferInAuditTrail.fromJson(e)).toList(),
      lotSerialsPerItem: (data['lot_serials_per_item'] as Map?)?.cast<String, dynamic>() ?? {},
    );
  }

  bool get isConfirmed => status == 'Confirmed';
  bool get isDone       => status == 'Done';
  bool get isCancelled  => status == 'Cancelled';
  bool get canEdit     => isConfirmed && !hasEmptyTransferredQty;
  bool get canValidate => isConfirmed && !hasEmptyTransferredQty;

  bool hasTrackingFor(int idProduct) {
    final entry = lotSerialsPerItem[idProduct.toString()];
    if (entry == null) return false;
    final usage = entry['usage'];
    return usage is List && usage.isNotEmpty;
  }
}

class TransferInFormItem {
  final int mappingKey;
  final int idProduct;
  final String? productName;
  final String? uomName;
  final double? transferredQty;
  double? receivedQty;

  TransferInFormItem({
    required this.mappingKey,
    required this.idProduct,
    this.productName,
    this.uomName,
    this.transferredQty,
    this.receivedQty,
  });

  factory TransferInFormItem.fromItem(TransferInItem i) => TransferInFormItem(
        mappingKey:     i.mappingKey,
        idProduct:      i.idProduct,
        productName:    i.productName,
        uomName:        i.uomName,
        transferredQty: i.transferredQty,
        receivedQty:    i.receivedQty,
      );

  Map<String, dynamic> toJson() => {
        'id_internal_transfer_item': mappingKey,
        'id_product':                idProduct,
        'received_qty':              receivedQty ?? 0,
      };
}

class TransferInFormModel {
  List<TransferInFormItem> items;
  String? scrapReason;

  TransferInFormModel({required this.items, this.scrapReason});

  Map<String, dynamic> toJson(String action) => {
        'action':   action,
        if (action == 'validate' && scrapReason != null) 'scrap_reason': scrapReason,
        'products': items.map((i) => i.toJson()).toList(),
      };
}