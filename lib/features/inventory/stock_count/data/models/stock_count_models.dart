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

class StockCountModel {
  final int idStockOpname;
  final String encryption;
  final String status;
  final String statusLabel;
  final String? warehouseName;
  final String? locationNames;

  StockCountModel({
    required this.idStockOpname,
    required this.encryption,
    required this.status,
    required this.statusLabel,
    this.warehouseName,
    this.locationNames,
  });

  factory StockCountModel.fromJson(Map<String, dynamic> j) => StockCountModel(
        idStockOpname: _pi(j['id_stock_opname']),
        encryption:    _ps(j['encryption']),
        status:        _ps(j['status']),
        statusLabel:   j['status_label']?.toString() ?? _ps(j['status']),
        warehouseName: j['warehouse_name']?.toString(),
        locationNames: j['location_names']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Confirmed':        0xFF1565C0,
    'Waiting Approval': 0xFFFFA500,
    'Validated':        0xFF2E7D32,
    'Cancelled':        0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class StockCountPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  StockCountPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class StockCountItem {
  final int idProduct;
  final int? idUom;
  final String? productName;
  final String? uomName;
  final double qtyBefore;
  final double? qtyAfter;
  final double? qtyDifference;
  final String? adjustmentType;
  final String? note;
  final String status; 
  final int idLocation;
  final String? locationName;

  StockCountItem({
    required this.idProduct,
    this.idUom,
    this.productName,
    this.uomName,
    required this.qtyBefore,
    this.qtyAfter,
    this.qtyDifference,
    this.adjustmentType,
    this.note,
    this.status = 'Draft',
    required this.idLocation,
    this.locationName,
  });

  factory StockCountItem.fromJson(Map<String, dynamic> j) => StockCountItem(
        idProduct:      _pi(j['id_product']),
        idUom:          j['id_uom'] == null ? null : _pi(j['id_uom']),
        productName:    j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        uomName:        j['uom_name']?.toString(),
        qtyBefore:      _pd(j['qty_before'] ?? j['realtime_on_hand']),
        qtyAfter:       j['qty_after'] == null ? null : _pd(j['qty_after']),
        qtyDifference:  j['qty_difference'] == null ? null : _pd(j['qty_difference']),
        adjustmentType: j['adjustment_type']?.toString(),
        note:           j['note']?.toString(),
        status:         j['status']?.toString() ?? 'Draft',
        idLocation:     _pi(j['id_location']),
        locationName:   j['location']?['location_name']?.toString() ?? j['location_name']?.toString(),
      );
}

class StockCountAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  StockCountAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory StockCountAuditTrail.fromJson(Map<String, dynamic> j) => StockCountAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class StockCountDetailModel {
  final int idStockOpname;
  final String encryption;
  final String status;
  final bool isLock;
  final String? documentCode;
  final int? idWarehouse;
  final String? warehouseName;
  final int? idLocation;
  final String? locationName;
  final String selectBy; 
  final String? note;
  final bool isAllItemsConfirmed;
  final String locationDisplay;
  final int totalLocations;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelReason;
  final List<StockCountItem> items;
  final List<StockCountAuditTrail> auditTrails;

  StockCountDetailModel({
    required this.idStockOpname,
    required this.encryption,
    required this.status,
    required this.isLock,
    this.documentCode,
    this.idWarehouse,
    this.warehouseName,
    this.idLocation,
    this.locationName,
    required this.selectBy,
    this.note,
    this.isAllItemsConfirmed = false,
    this.locationDisplay = '-',
    this.totalLocations = 0,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelReason,
    required this.items,
    required this.auditTrails,
  });

  factory StockCountDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final rawItems = (data['stock_opname_items'] as List? ?? [])
        .map((e) => StockCountItem.fromJson(e))
        .where((i) => true)
        .toList();
    return StockCountDetailModel(
      idStockOpname:        _pi(data['id_stock_opname']),
      encryption:           _ps(data['encryption']),
      status:               _ps(data['status']),
      isLock:               data['is_lock'] == 'Y',
      documentCode:         data['document_code']?.toString(),
      idWarehouse:          _pi(data['id_warehouse']) == 0 ? null : _pi(data['id_warehouse']),
      warehouseName:        data['warehouse']?['warehouse_name']?.toString(),
      idLocation:           _pi(data['id_location']) == 0 ? null : _pi(data['id_location']),
      locationName:         data['location']?['location_name']?.toString(),
      selectBy:             data['select_by']?.toString() ?? 'all',
      note:                 data['note']?.toString(),
      isAllItemsConfirmed:  data['is_all_items_confirmed'] == true,
      locationDisplay:      data['location_display']?.toString() ?? '-',
      totalLocations:       _pi(data['total_locations']),
      createdByName:        data['created_by_name']?.toString(),
      updatedByName:        data['updated_by_name']?.toString(),
      cancelledByName:      data['cancelled_by_name']?.toString(),
      createdDate:          data['created_date']?.toString(),
      updatedDate:          data['updated_date']?.toString(),
      cancelledDate:        data['cancelled_date']?.toString(),
      cancelReason:         data['cancel_reason']?.toString(),
      items:       rawItems,
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => StockCountAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isValidated       => status == 'Validated';
  bool get isCancelled       => status == 'Cancelled';
  bool get canEditHeader     => isDraft && !isLock;
  bool get canCancel         => isConfirmed && !isLock;
  bool get canValidate       => isConfirmed && !isLock && isAllItemsConfirmed;
  bool get canDelete         => isDraft && !isLock;

  Map<int, List<StockCountItem>> get itemsByLocation {
    final map = <int, List<StockCountItem>>{};
    for (final i in items) {
      map.putIfAbsent(i.idLocation, () => []).add(i);
    }
    return map;
  }
}

class SCWarehouseOption {
  final int id;
  final String name;
  SCWarehouseOption({required this.id, required this.name});
  factory SCWarehouseOption.fromJson(Map<String, dynamic> j) =>
      SCWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));
  @override bool operator ==(Object o) => o is SCWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class SCLocationOption {
  final int id;
  final int warehouseId;
  final String name;
  SCLocationOption({required this.id, required this.warehouseId, required this.name});
  factory SCLocationOption.fromJson(Map<String, dynamic> j) => SCLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );
  @override bool operator ==(Object o) => o is SCLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class StockCountFormOptions {
  final List<SCWarehouseOption> warehouses;
  final List<SCLocationOption> locations;

  StockCountFormOptions({required this.warehouses, required this.locations});

  factory StockCountFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return StockCountFormOptions(
      warehouses: (data['warehouses'] as List? ?? []).map((e) => SCWarehouseOption.fromJson(e)).toList(),
      locations:  (data['locations']  as List? ?? []).map((e) => SCLocationOption.fromJson(e)).toList(),
    );
  }

  List<SCLocationOption> locationsForWarehouse(int warehouseId) {
    final filtered = locations.where((l) => l.warehouseId == warehouseId).toList();
    return filtered.isNotEmpty ? filtered : locations;
  }
}

class SCLocationProduct {
  final int idProduct;
  final String productName;
  final double stockQty;
  final int? defaultUom;
  final String? defaultUomName;

  SCLocationProduct({
    required this.idProduct,
    required this.productName,
    this.stockQty = 0,
    this.defaultUom,
    this.defaultUomName,
  });

  factory SCLocationProduct.fromJson(Map<String, dynamic> j) => SCLocationProduct(
        idProduct:      _pi(j['id_product']),
        productName:    _ps(j['product_name']),
        stockQty:       _pd(j['stock_qty'] ?? j['on_hand']),
        defaultUom:     j['default_uom'] == null ? null : _pi(j['default_uom']),
        defaultUomName: j['default_uom_name']?.toString(),
      );
}

class SCFormItem {
  int? idProduct;
  String? productName;
  int? idUom;
  String? uomName;
  double onHand;
  double? qtyAfter;
  String? notes;
  bool isExisting;

  SCFormItem({
    this.idProduct,
    this.productName,
    this.idUom,
    this.uomName,
    this.onHand = 0,
    this.qtyAfter,
    this.notes,
    this.isExisting = false,
  });

  Map<String, dynamic> toJson() => {
        'id_product': idProduct,
        'id_uom':     idUom,
        'qty_after':  qtyAfter ?? 0,
        'notes':      notes,
      };
}