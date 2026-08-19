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

class ScrapOrderModel {
  final int idScrap;
  final String encryption;
  final String status;
  final String? documentCode;
  final String? documentDate;
  final String? scrapLocation;
  final String? scrapReason;
  final String? locationName;

  ScrapOrderModel({
    required this.idScrap,
    required this.encryption,
    required this.status,
    this.documentCode,
    this.documentDate,
    this.scrapLocation,
    this.scrapReason,
    this.locationName,
  });

  factory ScrapOrderModel.fromJson(Map<String, dynamic> j) => ScrapOrderModel(
        idScrap:       _pi(j['id_scrap']),
        encryption:    _ps(j['encryption']),
        status:        _ps(j['status']),
        documentCode:  j['document_code']?.toString(),
        documentDate:  j['document_date']?.toString(),
        scrapLocation: j['scrap_location']?.toString(),
        scrapReason:   j['scrap_reason']?.toString(),
        locationName:  j['location_name']?.toString(),
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

class ScrapOrderPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  ScrapOrderPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class ScrapOrderItem {
  final int idProduct;
  final int? unitOfMeasure;
  final String? productName;
  final String? uomName;
  final double? scrapQty;
  final double? stockQtyBefore;
  double onHand;

  ScrapOrderItem({
    required this.idProduct,
    this.unitOfMeasure,
    this.productName,
    this.uomName,
    this.scrapQty,
    this.stockQtyBefore,
    this.onHand = 0,
  });

  factory ScrapOrderItem.fromJson(Map<String, dynamic> j) => ScrapOrderItem(
      idProduct:      _pi(j['id_product']),
      unitOfMeasure:  j['unit_of_measure'] == null ? null : _pi(j['unit_of_measure']),
      productName:    j['product_name']?.toString(),
      uomName:        j['unit_of_measure_name']?.toString(),
      scrapQty:       j['scrap_qty'] == null ? null : _pd(j['scrap_qty']),
      stockQtyBefore: j['stock_qty_before'] == null ? null : _pd(j['stock_qty_before']),
      onHand:         _pd(j['on_hand']),
    );
}

class ScrapOrderAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  ScrapOrderAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory ScrapOrderAuditTrail.fromJson(Map<String, dynamic> j) => ScrapOrderAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class ScrapOrderDetailModel {
  final int idScrap;
  final String encryption;
  final String status;
  final String? documentCode;
  final String? sourceWarehouseName;
  final String? sourceLocationName;
  final int? sourceWarehouse;
  final int? sourceLocation;
  final String? documentDate;
  final String? scrapLocation;
  final String? scrapReason;
  final String? cancelReason;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final List<ScrapOrderItem> items;
  final List<ScrapOrderAuditTrail> auditTrails;

  ScrapOrderDetailModel({
    required this.idScrap,
    required this.encryption,
    required this.status,
    this.documentCode,
    this.sourceWarehouseName,
    this.sourceLocationName,
    this.sourceWarehouse,
    this.sourceLocation,
    this.documentDate,
    this.scrapLocation,
    this.scrapReason,
    this.cancelReason,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    required this.items,
    required this.auditTrails,
  });

  factory ScrapOrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ScrapOrderDetailModel(
      idScrap:             _pi(data['id_scrap']),
      encryption:          _ps(data['encryption']),
      status:              _ps(data['status']),
      documentCode:        data['document_code']?.toString(),
      sourceWarehouseName: data['source_warehouse_name']?.toString(),
      sourceLocationName:  data['source_location_name']?.toString(),
      sourceWarehouse:     _pi(data['source_warehouse']) == 0 ? null : _pi(data['source_warehouse']),
      sourceLocation:      _pi(data['source_location']) == 0 ? null : _pi(data['source_location']),
      documentDate:        data['document_date']?.toString(),
      scrapLocation:       data['scrap_location']?.toString(),
      scrapReason:         data['scrap_reason']?.toString(),
      cancelReason:        data['cancel_reason']?.toString(),
      createdByName:       data['created_by_name']?.toString(),
      updatedByName:       data['updated_by_name']?.toString(),
      cancelledByName:     data['cancelled_by_name']?.toString(),
      createdDate:         data['created_date']?.toString(),
      updatedDate:         data['updated_date']?.toString(),
      cancelledDate:       data['cancelled_date']?.toString(),
      items:       (data['items'] as List? ?? []).map((e) => ScrapOrderItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => ScrapOrderAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isDone            => status == 'Done';
  bool get isCancelled       => status == 'Cancelled';
  bool get canEdit           => isDraft || isConfirmed;
  bool get canConfirm        => isDraft;
  bool get canValidate       => isConfirmed;
  bool get canCancel         => isConfirmed;
  bool get canDelete         => isDraft;
}

class SOWarehouseOption {
  final int id;
  final String name;
  SOWarehouseOption({required this.id, required this.name});
  factory SOWarehouseOption.fromJson(Map<String, dynamic> j) =>
      SOWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));
  @override bool operator ==(Object o) => o is SOWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class SOLocationOption {
  final int id;
  final int warehouseId;
  final String name;
  SOLocationOption({required this.id, required this.warehouseId, required this.name});
  factory SOLocationOption.fromJson(Map<String, dynamic> j) => SOLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );
  @override bool operator ==(Object o) => o is SOLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class SOProductOption {
  final int idProduct;
  final String productName;
  final int? defaultUom;
  SOProductOption({required this.idProduct, required this.productName, this.defaultUom});
  factory SOProductOption.fromJson(Map<String, dynamic> j) => SOProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        defaultUom:  j['default_uom'] == null ? null : _pi(j['default_uom']),
      );
  @override bool operator ==(Object o) => o is SOProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class SOUomOption {
  final int id;
  final String name;
  SOUomOption({required this.id, required this.name});
  factory SOUomOption.fromJson(Map<String, dynamic> j) =>
      SOUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));
  @override bool operator ==(Object o) => o is SOUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class ScrapOrderFormOptions {
  final List<SOWarehouseOption> warehouses;
  final List<SOLocationOption> locations;
  final List<SOProductOption> products;
  final List<SOUomOption> uoms;
  final Map<int, int> defaultUomPerProduct;

  ScrapOrderFormOptions({
    required this.warehouses,
    required this.locations,
    required this.products,
    required this.uoms,
    this.defaultUomPerProduct = const {},
  });

  factory ScrapOrderFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final rawMap = (data['default_uom_per_product'] as Map?) ?? {};
    return ScrapOrderFormOptions(
      warehouses: (data['warehouses'] as List? ?? []).map((e) => SOWarehouseOption.fromJson(e)).toList(),
      locations:  (data['locations']  as List? ?? []).map((e) => SOLocationOption.fromJson(e)).toList(),
      products:   (data['products']   as List? ?? []).map((e) => SOProductOption.fromJson(e)).toList(),
      uoms:       (data['uoms']       as List? ?? []).map((e) => SOUomOption.fromJson(e)).toList(),
      defaultUomPerProduct: rawMap.map((k, v) => MapEntry(_pi(k), _pi(v))),
    );
  }

  List<SOLocationOption> locationsForWarehouse(int warehouseId) {
    final filtered = locations.where((l) => l.warehouseId == warehouseId).toList();
    return filtered.isNotEmpty ? filtered : locations;
  }
}

class ScrapOrderFormItem {
  int? idProduct;
  String? productName;
  int? uomId;
  String? uomName;
  double scrapQty;
  double onHand;

  ScrapOrderFormItem({
    this.idProduct,
    this.productName,
    this.uomId,
    this.uomName,
    this.scrapQty = 0,
    this.onHand = 0,
  });

  Map<String, dynamic> toJsonSave() => {
        'id_product':        idProduct,
        'unit_of_measure':   uomId,
        'stock_qty_before':  onHand,
      };

  Map<String, dynamic> toJsonConfirm() => {
        'id_product':        idProduct,
        'unit_of_measure':   uomId,
        'stock_qty_before':  onHand,
      };

  Map<String, dynamic> toJsonValidate() => {
        'id_product':        idProduct,
        'stock_qty_before':  onHand,
        'scrap_qty':         scrapQty,
      };

  factory ScrapOrderFormItem.fromItem(ScrapOrderItem i) => ScrapOrderFormItem(
        idProduct:   i.idProduct,
        productName: i.productName,
        uomId:       i.unitOfMeasure,
        uomName:     i.uomName,
        scrapQty:    i.scrapQty ?? 0,
        onHand:      i.onHand,
      );
}

class ScrapOrderFormModel {
  int? idScrap;
  String? encryption;
  String? documentCode;
  int? sourceWarehouse;
  int? sourceLocation;
  DateTime? documentDate;
  String? scrapReason;
  List<ScrapOrderFormItem> items;

  ScrapOrderFormModel({
    this.idScrap,
    this.encryption,
    this.documentCode,
    this.sourceWarehouse,
    this.sourceLocation,
    this.documentDate,
    this.scrapReason,
    List<ScrapOrderFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idScrap != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) {
    if (status == 'validate') {
      return {
        'id_scrap':      idScrap,
        'status':        'validate',
        'document_code': documentCode,
        'products':      items.map((i) => i.toJsonValidate()).toList(),
      };
    }

    if (status == 'confirm') {
      return {
        'id_scrap':          idScrap,
        'status':            'confirm',
        'source_warehouse':  sourceWarehouse,
        'source_location':   sourceLocation,
        'document_date':     documentDate != null ? _fmtDate(documentDate!) : null,
        'scrap_reason':      scrapReason,
        'products':          items.map((i) => i.toJsonConfirm()).toList(),
      };
    }

    return {
      if (idScrap != null) 'id_scrap': idScrap,
      'status':            'save',
      'source_warehouse':  sourceWarehouse,
      'source_location':   sourceLocation,
      'document_date':     documentDate != null ? _fmtDate(documentDate!) : null,
      if (scrapReason != null) 'scrap_reason': scrapReason,
      'products':          items.map((i) => i.toJsonSave()).toList(),
    };
  }

  factory ScrapOrderFormModel.fromDetail(ScrapOrderDetailModel d) => ScrapOrderFormModel(
        idScrap:         d.idScrap,
        encryption:      d.encryption,
        documentCode:    d.documentCode,
        sourceWarehouse: d.sourceWarehouse,
        sourceLocation:  d.sourceLocation,
        documentDate:    d.documentDate != null ? DateTime.tryParse(d.documentDate!) : null,
        scrapReason:     d.scrapReason,
        items: d.items.map((i) => ScrapOrderFormItem.fromItem(i)).toList(),
      );
}