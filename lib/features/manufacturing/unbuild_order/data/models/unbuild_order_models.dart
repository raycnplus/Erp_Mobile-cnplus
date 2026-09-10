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

class UnbuildOrderModel {
  final int idUnbuildOrder;
  final String encryption;
  final String status;
  final String? reference;
  final String? moReference;
  final String? createdDate;

  UnbuildOrderModel({
    required this.idUnbuildOrder,
    required this.encryption,
    required this.status,
    this.reference,
    this.moReference,
    this.createdDate,
  });

  factory UnbuildOrderModel.fromJson(Map<String, dynamic> j) => UnbuildOrderModel(
        idUnbuildOrder: _pi(j['id_unbuild_order']),
        encryption:     _ps(j['encryption']),
        status:         _ps(j['status']),
        reference:      j['reference']?.toString(),
        moReference:    j['mo_reference']?.toString(),
        createdDate:    j['created_date']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed':        0xFF1565C0,
    'Done':             0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class UOPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  UOPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class UOItemComponent {
  final int componentProductId;
  final String? productName;
  final double componentQty;
  final int? unitOfMeasure;
  final String? uomName;

  UOItemComponent({
    required this.componentProductId,
    this.productName,
    required this.componentQty,
    this.unitOfMeasure,
    this.uomName,
  });

  factory UOItemComponent.fromJson(Map<String, dynamic> j) => UOItemComponent(
        componentProductId: _pi(j['component_product_id']),
        productName:   j['component_product']?['product_name']?.toString(),
        componentQty:  _pd(j['component_qty']),
        unitOfMeasure: _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
        uomName:       j['uom']?['unit_of_measure_name']?.toString(),
      );
}

class UOItem {
  final int idUnbuildOrderItem;
  final int idProduct;
  final String? productName;
  final int? idBom;
  final String? bomName;
  final double unbuildQty;
  final int? unitOfMeasure;
  final String? uomName;
  final List<UOItemComponent> components;

  UOItem({
    required this.idUnbuildOrderItem,
    required this.idProduct,
    this.productName,
    this.idBom,
    this.bomName,
    required this.unbuildQty,
    this.unitOfMeasure,
    this.uomName,
    required this.components,
  });

  factory UOItem.fromJson(Map<String, dynamic> j) => UOItem(
        idUnbuildOrderItem: _pi(j['id_unbuild_order_item']),
        idProduct:   _pi(j['id_product']),
        productName: j['product']?['product_name']?.toString(),
        idBom:       _pi(j['id_bom']) == 0 ? null : _pi(j['id_bom']),
        bomName:     j['bill_material']?['bom_name']?.toString(),
        unbuildQty:  _pd(j['unbuild_qty']),
        unitOfMeasure: _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
        uomName:     j['uom']?['unit_of_measure_name']?.toString(),
        components:  (j['components'] as List? ?? []).map((e) => UOItemComponent.fromJson(e)).toList(),
      );
}

class UOAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;
  final String? image;

  UOAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
    this.image,
  });

  factory UOAuditTrail.fromJson(Map<String, dynamic> j) => UOAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
        image:        j['image']?.toString(),
      );
}

class UnbuildOrderDetailModel {
  final int idUnbuildOrder;
  final String encryption;
  final String status;
  final String? reference;
  final int? idManufacturingOrder;
  final String? moReference;
  final String? manufacturingEncryption;
  final String? unbuildDate;
  final String? notes;
  final int? sourceWarehouse;
  final String? sourceWarehouseName;
  final int? sourceLocation;
  final String? sourceLocationName;
  final int? destinationWarehouse;
  final String? destinationWarehouseName;
  final int? destinationLocation;
  final String? destinationLocationName;
  final String? createdByName;
  final String? updatedByName;
  final String? createdDate;
  final String? updatedDate;
  final List<UOItem> items;
  final List<UOAuditTrail> auditTrails;

  UnbuildOrderDetailModel({
    required this.idUnbuildOrder,
    required this.encryption,
    required this.status,
    this.reference,
    this.idManufacturingOrder,
    this.moReference,
    this.manufacturingEncryption,
    this.unbuildDate,
    this.notes,
    this.sourceWarehouse,
    this.sourceWarehouseName,
    this.sourceLocation,
    this.sourceLocationName,
    this.destinationWarehouse,
    this.destinationWarehouseName,
    this.destinationLocation,
    this.destinationLocationName,
    this.createdByName,
    this.updatedByName,
    this.createdDate,
    this.updatedDate,
    required this.items,
    required this.auditTrails,
  });

  factory UnbuildOrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    final srcWh   = data['source_warehouse'];
    final srcLoc  = data['source_location'];
    final destWh  = data['destination_warehouse'];
    final destLoc = data['destination_location'];

    return UnbuildOrderDetailModel(
      idUnbuildOrder: _pi(data['id_unbuild_order']),
      encryption:     _ps(data['encryption']),
      status:         _ps(data['status']),
      reference:      data['reference']?.toString(),
      idManufacturingOrder: _pi(data['id_manufacturing_order']) == 0 ? null : _pi(data['id_manufacturing_order']),
      moReference:            data['manufacturing_order']?['reference']?.toString(),
      manufacturingEncryption: data['manufacturing_encryption']?.toString(),
      unbuildDate: data['unbuild_date']?.toString(),
      notes:       data['notes']?.toString(),
      sourceWarehouse:     srcWh is Map ? (_pi(srcWh['id_warehouse']) == 0 ? null : _pi(srcWh['id_warehouse'])) : (_pi(srcWh) == 0 ? null : _pi(srcWh)),
      sourceWarehouseName: srcWh is Map ? srcWh['warehouse_name']?.toString() : null,
      sourceLocation:      srcLoc is Map ? (_pi(srcLoc['id_location']) == 0 ? null : _pi(srcLoc['id_location'])) : (_pi(srcLoc) == 0 ? null : _pi(srcLoc)),
      sourceLocationName:  srcLoc is Map ? srcLoc['location_name']?.toString() : null,
      destinationWarehouse:     destWh is Map ? (_pi(destWh['id_warehouse']) == 0 ? null : _pi(destWh['id_warehouse'])) : (_pi(destWh) == 0 ? null : _pi(destWh)),
      destinationWarehouseName: destWh is Map ? destWh['warehouse_name']?.toString() : null,
      destinationLocation:      destLoc is Map ? (_pi(destLoc['id_location']) == 0 ? null : _pi(destLoc['id_location'])) : (_pi(destLoc) == 0 ? null : _pi(destLoc)),
      destinationLocationName:  destLoc is Map ? destLoc['location_name']?.toString() : null,
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      createdDate:   data['created_date']?.toString(),
      updatedDate:   data['updated_date']?.toString(),
      items:       (data['items'] as List? ?? []).map((e) => UOItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => UOAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isDone            => status == 'Done';
  bool get canEdit           => isDraft;
  bool get canConfirm        => isDraft;
  bool get canValidate       => isConfirmed;
  bool get canDelete         => isDraft;
}

class UOManufacturingOrderOption {
  final int id;
  final String reference;
  final int? idProduct;

  UOManufacturingOrderOption({required this.id, required this.reference, this.idProduct});

  factory UOManufacturingOrderOption.fromJson(Map<String, dynamic> j) => UOManufacturingOrderOption(
        id:        _pi(j['id_manufacturing_order']),
        reference: _ps(j['reference']),
        idProduct: _pi(j['id_product']) == 0 ? null : _pi(j['id_product']),
      );

  @override bool operator ==(Object o) => o is UOManufacturingOrderOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class UOWarehouseOption {
  final int id;
  final String name;
  UOWarehouseOption({required this.id, required this.name});
  factory UOWarehouseOption.fromJson(Map<String, dynamic> j) =>
      UOWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));
  @override bool operator ==(Object o) => o is UOWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class UOLocationOption {
  final int id;
  final int? warehouseId;
  final String name;
  UOLocationOption({required this.id, this.warehouseId, required this.name});
  factory UOLocationOption.fromJson(Map<String, dynamic> j) => UOLocationOption(
        id:   _pi(j['id_location']),
        warehouseId: _pi(j['warehouse']) == 0 ? null : _pi(j['warehouse']),
        name: _ps(j['location_name']),
      );
  @override bool operator ==(Object o) => o is UOLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class UnbuildOrderFormOptions {
  final List<UOManufacturingOrderOption> manufacturingOrders;
  final List<UOWarehouseOption> warehouses;
  final List<UOLocationOption> locations;
  final String? reference;

  UnbuildOrderFormOptions({
    required this.manufacturingOrders,
    required this.warehouses,
    required this.locations,
    this.reference,
  });

  factory UnbuildOrderFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return UnbuildOrderFormOptions(
      manufacturingOrders: (data['manufacturing_orders'] as List? ?? [])
          .map((e) => UOManufacturingOrderOption.fromJson(e)).toList(),
      warehouses: (data['warehouses'] as List? ?? []).map((e) => UOWarehouseOption.fromJson(e)).toList(),
      locations:  (data['locations']  as List? ?? []).map((e) => UOLocationOption.fromJson(e)).toList(),
      reference:  data['reference']?.toString(),
    );
  }
}

class UOManufacturingOrderDetails {
  final int idProduct;
  final String? productName;
  final int? idBom;
  final String? bomName;
  final int? idUnitOfMeasure;
  final String? unitOfMeasureName;
  final int? sourceWarehouse;
  final String? sourceWarehouseName;
  final int? sourceLocation;
  final String? sourceLocationName;
  final double plannedQty;

  UOManufacturingOrderDetails({
    required this.idProduct,
    this.productName,
    this.idBom,
    this.bomName,
    this.idUnitOfMeasure,
    this.unitOfMeasureName,
    this.sourceWarehouse,
    this.sourceWarehouseName,
    this.sourceLocation,
    this.sourceLocationName,
    required this.plannedQty,
  });

  factory UOManufacturingOrderDetails.fromJson(Map<String, dynamic> j) => UOManufacturingOrderDetails(
        idProduct:   _pi(j['id_product']),
        productName: j['product_name']?.toString(),
        idBom:       _pi(j['id_bom']) == 0 ? null : _pi(j['id_bom']),
        bomName:     j['bom_name']?.toString(),
        idUnitOfMeasure: _pi(j['id_unit_of_measure']) == 0 ? null : _pi(j['id_unit_of_measure']),
        unitOfMeasureName: j['unit_of_measure_name']?.toString(),
        sourceWarehouse: _pi(j['source_warehouse']) == 0 ? null : _pi(j['source_warehouse']),
        sourceWarehouseName: j['source_warehouse_name']?.toString(),
        sourceLocation: _pi(j['source_location']) == 0 ? null : _pi(j['source_location']),
        sourceLocationName: j['source_location_name']?.toString(),
        plannedQty: _pd(j['planned_qty']),
      );
}

class UOPreviewRequestItem {
  final int idBom;
  final double qty;
  final String productName;

  UOPreviewRequestItem({required this.idBom, required this.qty, required this.productName});

  Map<String, dynamic> toJson() => {
        'id_bom': idBom,
        'qty': qty,
        'product_name': productName,
      };
}

class UOPreviewComponent {
  final int componentProductId;
  final String? productName;
  final double quantity;
  final int? unitOfMeasure;
  final String? uomName;
  final String? sourceProduct;

  UOPreviewComponent({
    required this.componentProductId,
    this.productName,
    required this.quantity,
    this.unitOfMeasure,
    this.uomName,
    this.sourceProduct,
  });

  factory UOPreviewComponent.fromJson(Map<String, dynamic> j) => UOPreviewComponent(
        componentProductId: _pi(j['component_product_id']),
        productName: j['product_name']?.toString(),
        quantity:    _pd(j['quantity']),
        unitOfMeasure: _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
        uomName:     j['uom_name']?.toString(),
        sourceProduct: j['source_product']?.toString(),
      );
}

class UnbuildOrderFormModel {
  int? idUnbuildOrder;
  String? encryption;
  String? reference;
  int? idManufacturingOrder;
  DateTime? unbuildDate;
  int? sourceWarehouse;
  int? sourceLocation;
  int? destinationWarehouse;
  int? destinationLocation;
  int? idProduct;
  int? idBom;
  double unbuildQty;
  int? unitOfMeasure;
  String? notes;

  UnbuildOrderFormModel({
    this.idUnbuildOrder,
    this.encryption,
    this.reference,
    this.idManufacturingOrder,
    this.unbuildDate,
    this.sourceWarehouse,
    this.sourceLocation,
    this.destinationWarehouse,
    this.destinationLocation,
    this.idProduct,
    this.idBom,
    this.unbuildQty = 0,
    this.unitOfMeasure,
    this.notes,
  });

  bool get isEditMode => idUnbuildOrder != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) => {
        if (idUnbuildOrder != null) 'id_unbuild_order': idUnbuildOrder,
        if (reference != null) 'reference': reference,
        'id_manufacturing_order': idManufacturingOrder,
        'unbuild_date':           unbuildDate != null ? _fmtDate(unbuildDate!) : null,
        'source_warehouse':       sourceWarehouse,
        'source_location':        sourceLocation,
        'destination_warehouse':  destinationWarehouse,
        'destination_location':   destinationLocation,
        'id_product':             idProduct,
        'id_bom':                 idBom,
        'unbuild_qty':            unbuildQty,
        'unit_of_measure':        unitOfMeasure,
        'notes':                  notes,
        'status':                 status,
      };

  factory UnbuildOrderFormModel.fromDetail(UnbuildOrderDetailModel d) {
    final firstItem = d.items.isNotEmpty ? d.items.first : null;
    return UnbuildOrderFormModel(
      idUnbuildOrder:        d.idUnbuildOrder,
      encryption:            d.encryption,
      reference:             d.reference,
      idManufacturingOrder:  d.idManufacturingOrder,
      unbuildDate:           d.unbuildDate != null ? DateTime.tryParse(d.unbuildDate!) : null,
      sourceWarehouse:       d.sourceWarehouse,
      sourceLocation:        d.sourceLocation,
      destinationWarehouse:  d.destinationWarehouse,
      destinationLocation:   d.destinationLocation,
      idProduct:             firstItem?.idProduct,
      idBom:                 firstItem?.idBom,
      unbuildQty:            firstItem?.unbuildQty ?? 0,
      unitOfMeasure:         firstItem?.unitOfMeasure,
      notes:                 d.notes,
    );
  }
}