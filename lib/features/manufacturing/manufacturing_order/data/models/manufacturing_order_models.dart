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

class ManufacturingOrderModel {
  final int idManufacturingOrder;
  final String encryption;
  final String status;
  final String? reference;
  final String? productName;
  final double plannedQty;
  final String? scheduledDate;
  final String? createdDate;

  ManufacturingOrderModel({
    required this.idManufacturingOrder,
    required this.encryption,
    required this.status,
    this.reference,
    this.productName,
    this.plannedQty = 0,
    this.scheduledDate,
    this.createdDate,
  });

  factory ManufacturingOrderModel.fromJson(Map<String, dynamic> j) => ManufacturingOrderModel(
        idManufacturingOrder: _pi(j['id_manufacturing_order']),
        encryption:   _ps(j['encryption']),
        status:       _ps(j['status']),
        reference:    j['reference']?.toString(),
        productName:  j['product_name']?.toString(),
        plannedQty:   _pd(j['planned_qty']),
        scheduledDate: j['scheduled_date']?.toString(),
        createdDate:   j['created_date']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed':        0xFF1565C0,
    'Done':             0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class MOPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  MOPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class MOLaborPerson {
  final int id;
  final String name;

  MOLaborPerson({required this.id, required this.name});

  factory MOLaborPerson.fromJson(Map<String, dynamic> j) => MOLaborPerson(
        id:   _pi(j['id_employee'] ?? j['labor_person_id']),
        name: _ps(j['employee_name'] ?? j['labor_name']),
      );
}

class MOUsageMaterial {
  final int idMoUsage;
  final int componentProductId;
  final String? productName;
  final int? unitOfMeasure;
  final String? uomName;
  final double qtyUsed;
  final String? usageDate;

  MOUsageMaterial({
    required this.idMoUsage,
    required this.componentProductId,
    this.productName,
    this.unitOfMeasure,
    this.uomName,
    required this.qtyUsed,
    this.usageDate,
  });

  factory MOUsageMaterial.fromJson(Map<String, dynamic> j) => MOUsageMaterial(
        idMoUsage:          _pi(j['id_mo_usage']),
        componentProductId: _pi(j['component_product_id']),
        productName:        j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        unitOfMeasure:      _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
        uomName:            j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        qtyUsed:            _pd(j['qty_used']),
        usageDate:          j['usage_date']?.toString(),
      );
}

class MOOperation {
  final int idBomOperation;
  final String? operationName;
  final String? workstationName;
  final int sequence;
  final int duration;
  final String? notes;
  final int? idMoOperationTracking;
  final String? trackingStatus;
  final String? startTime;
  final int actualDuration;
  final String? durationFormatted;
  final String? actualDurationFormatted;

  MOOperation({
    required this.idBomOperation,
    this.operationName,
    this.workstationName,
    this.sequence = 0,
    this.duration = 0,
    this.notes,
    this.idMoOperationTracking,
    this.trackingStatus,
    this.startTime,
    this.actualDuration = 0,
    this.durationFormatted,
    this.actualDurationFormatted,
  });

  factory MOOperation.fromJson(Map<String, dynamic> j) => MOOperation(
        idBomOperation:  _pi(j['id_bom_operation']),
        operationName:   j['operation_name']?.toString(),
        workstationName: j['workstation_name']?.toString(),
        sequence:        _pi(j['sequence']),
        duration:        _pi(j['duration']),
        notes:           j['notes']?.toString(),
        idMoOperationTracking: _pi(j['id_mo_operation_tracking']) == 0 ? null : _pi(j['id_mo_operation_tracking']),
        trackingStatus:  j['tracking_status']?.toString(),
        startTime:       j['start_time']?.toString(),
        actualDuration:  _pi(j['actual_duration']),
        durationFormatted:       j['duration_formatted']?.toString(),
        actualDurationFormatted: j['actual_duration_formatted']?.toString(),
      );

  bool get isPending    => (trackingStatus ?? 'pending') == 'pending';
  bool get isInProgress => trackingStatus == 'in_progress';
  bool get isPaused     => trackingStatus == 'paused';
  bool get isCompleted  => trackingStatus == 'completed';
}

class MOOperationGroup {
  final String? productName;
  final String? bomName;
  final List<MOOperation> operations;

  MOOperationGroup({this.productName, this.bomName, required this.operations});

  factory MOOperationGroup.fromJson(Map<String, dynamic> j) => MOOperationGroup(
        productName: j['product_name']?.toString(),
        bomName:     j['bom_name']?.toString(),
        operations:  (j['operations'] as List? ?? []).map((e) => MOOperation.fromJson(e)).toList(),
      );
}

class MOAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;
  final String? image;

  MOAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
    this.image,
  });

  factory MOAuditTrail.fromJson(Map<String, dynamic> j) => MOAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
        image:        j['image']?.toString(),
      );
}

class ManufacturingOrderDetailModel {
  final int idManufacturingOrder;
  final String encryption;
  final String status;
  final String? reference;
  final int? idProduct;
  final int? idBom;
  final double plannedQty;
  final int? unitOfMeasure;
  final int? sourceWarehouse;
  final int? sourceLocation;
  final int? finishedLocation;
  final int? rejectedLocation;
  final int? byproductLocation;
  final int? rejectedProductId;
  final String? scheduledDate;
  final String? notes;
  final String? createdDate;
  final String? updatedDate;
  final String? productName;
  final String? uomName;
  final String? bomName;
  final String? rejectedProductName;
  final String? sourceWarehouseName;
  final String? sourceLocationName;
  final String? finishedLocationName;
  final String? rejectedLocationName;
  final String? byproductLocationName;
  final String? unbuildEncryption;
  final String? createdByName;
  final String? updatedByName;
  final List<MOLaborPerson> laborPersons;
  final List<MOUsageMaterial> usageMaterials;
  final List<MOOperationGroup> allOperations;
  final List<MOAuditTrail> auditTrails;

  ManufacturingOrderDetailModel({
    required this.idManufacturingOrder,
    required this.encryption,
    required this.status,
    this.reference,
    this.idProduct,
    this.idBom,
    required this.plannedQty,
    this.unitOfMeasure,
    this.sourceWarehouse,
    this.sourceLocation,
    this.finishedLocation,
    this.rejectedLocation,
    this.byproductLocation,
    this.rejectedProductId,
    this.scheduledDate,
    this.notes,
    this.createdDate,
    this.updatedDate,
    this.productName,
    this.uomName,
    this.bomName,
    this.rejectedProductName,
    this.sourceWarehouseName,
    this.sourceLocationName,
    this.finishedLocationName,
    this.rejectedLocationName,
    this.byproductLocationName,
    this.unbuildEncryption,
    this.createdByName,
    this.updatedByName,
    required this.laborPersons,
    required this.usageMaterials,
    required this.allOperations,
    required this.auditTrails,
  });

  factory ManufacturingOrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ManufacturingOrderDetailModel(
      idManufacturingOrder: _pi(data['id_manufacturing_order']),
      encryption:           _ps(data['encryption']),
      status:               _ps(data['status']),
      reference:            data['reference']?.toString(),
      idProduct:            _pi(data['id_product']) == 0 ? null : _pi(data['id_product']),
      idBom:                _pi(data['id_bom']) == 0 ? null : _pi(data['id_bom']),
      plannedQty:           _pd(data['planned_qty']),
      unitOfMeasure:        _pi(data['unit_of_measure']) == 0 ? null : _pi(data['unit_of_measure']),
      sourceWarehouse:      _pi(data['source_warehouse']) == 0 ? null : _pi(data['source_warehouse']),
      sourceLocation:       _pi(data['source_location']) == 0 ? null : _pi(data['source_location']),
      finishedLocation:     _pi(data['finished_location']) == 0 ? null : _pi(data['finished_location']),
      rejectedLocation:     _pi(data['rejected_location']) == 0 ? null : _pi(data['rejected_location']),
      byproductLocation:    _pi(data['byproduct_location']) == 0 ? null : _pi(data['byproduct_location']),
      rejectedProductId:    _pi(data['rejected_product_id']) == 0 ? null : _pi(data['rejected_product_id']),
      scheduledDate:        data['scheduled_date']?.toString(),
      notes:                data['notes']?.toString(),
      createdDate:          data['created_date']?.toString(),
      updatedDate:          data['updated_date']?.toString(),
      productName:          data['product']?['product_name']?.toString(),
      uomName:              data['uom']?['unit_of_measure_name']?.toString(),
      bomName:              data['bill_material']?['bom_name']?.toString(),
      rejectedProductName:  data['rejected_product']?['product_name']?.toString(),
      sourceWarehouseName:  data['source_warehouse_name']?.toString(),
      sourceLocationName:   data['source_location_name']?.toString(),
      finishedLocationName: data['finished_location_name']?.toString(),
      rejectedLocationName: data['rejected_location_name']?.toString(),
      byproductLocationName:data['byproduct_location_name']?.toString(),
      unbuildEncryption:    data['unbuild_encryption']?.toString(),
      createdByName:        data['created_by_name']?.toString(),
      updatedByName:        data['updated_by_name']?.toString(),
      laborPersons:   (data['labor_persons'] as List? ?? []).map((e) => MOLaborPerson.fromJson(e)).toList(),
      usageMaterials: (data['usage_materials'] as List? ?? []).map((e) => MOUsageMaterial.fromJson(e)).toList(),
      allOperations:  (data['all_operations']  as List? ?? []).map((e) => MOOperationGroup.fromJson(e)).toList(),
      auditTrails:    (data['audit_trails']    as List? ?? []).map((e) => MOAuditTrail.fromJson(e)).toList(),
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
  bool get hasUnbuild        => unbuildEncryption != null && unbuildEncryption!.isNotEmpty;
  bool get canCreateUnbuild  => isDone && !hasUnbuild;
}

class MOProductOption {
  final int id;
  final String name;
  MOProductOption({required this.id, required this.name});
  factory MOProductOption.fromJson(Map<String, dynamic> j) =>
      MOProductOption(id: _pi(j['id_product']), name: _ps(j['product_name']));
  @override bool operator ==(Object o) => o is MOProductOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class MOWarehouseOption {
  final int id;
  final String name;
  MOWarehouseOption({required this.id, required this.name});
  factory MOWarehouseOption.fromJson(Map<String, dynamic> j) =>
      MOWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));
  @override bool operator ==(Object o) => o is MOWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class MOLocationOption {
  final int id;
  final int warehouseId; 
  final String name;
  MOLocationOption({required this.id, required this.warehouseId, required this.name});
  factory MOLocationOption.fromJson(Map<String, dynamic> j) => MOLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );
  @override bool operator ==(Object o) => o is MOLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class MOUomOption {
  final int id;
  final String name;
  MOUomOption({required this.id, required this.name});
  factory MOUomOption.fromJson(Map<String, dynamic> j) =>
      MOUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));
  @override bool operator ==(Object o) => o is MOUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class MOLaborOption {
  final int id;
  final String name;
  MOLaborOption({required this.id, required this.name});
  factory MOLaborOption.fromJson(Map<String, dynamic> j) =>
      MOLaborOption(id: _pi(j['id_employee']), name: _ps(j['employee_name']));
  @override bool operator ==(Object o) => o is MOLaborOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class MOBomOption {
  final int id;
  final String name;
  final String? productName;
  MOBomOption({required this.id, required this.name, this.productName});
  factory MOBomOption.fromJson(Map<String, dynamic> j) => MOBomOption(
        id:   _pi(j['id_bom']),
        name: _ps(j['bom_name']),
        productName: j['product_name']?.toString(),
      );
  @override bool operator ==(Object o) => o is MOBomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class ManufacturingOrderFormOptions {
  final List<MOProductOption> products;
  final List<MOWarehouseOption> warehouses;
  final List<MOLocationOption> locations;
  final List<MOUomOption> uoms;
  final List<MOLaborOption> labors;
  final List<MOBomOption> boms;
  final List<MOProductOption> equipmentProducts;
  final String? reference;

  ManufacturingOrderFormOptions({
    required this.products,
    required this.warehouses,
    required this.locations,
    required this.uoms,
    required this.labors,
    required this.boms,
    required this.equipmentProducts,
    this.reference,
  });

  factory ManufacturingOrderFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ManufacturingOrderFormOptions(
      products:   (data['products']   as List? ?? []).map((e) => MOProductOption.fromJson(e)).toList(),
      warehouses: (data['warehouses'] as List? ?? []).map((e) => MOWarehouseOption.fromJson(e)).toList(),
      locations:  (data['locations']  as List? ?? []).map((e) => MOLocationOption.fromJson(e)).toList(),
      uoms:       (data['uoms']       as List? ?? []).map((e) => MOUomOption.fromJson(e)).toList(),
      labors:     (data['labors']     as List? ?? []).map((e) => MOLaborOption.fromJson(e)).toList(),
      boms:       (data['boms']       as List? ?? []).map((e) => MOBomOption.fromJson(e)).toList(),
      equipmentProducts: (data['equipment_products'] as List? ?? []).map((e) => MOProductOption.fromJson(e)).toList(),
      reference:  data['reference']?.toString(),
    );
  }
}

class MOProductBomsResult {
  final List<MOBomOption> boms;
  final int productId;
  final String? productName;

  MOProductBomsResult({required this.boms, required this.productId, this.productName});

  factory MOProductBomsResult.fromJson(Map<String, dynamic> j) => MOProductBomsResult(
        boms: (j['boms'] as List? ?? []).map((e) => MOBomOption.fromJson(e)).toList(),
        productId: _pi(j['product']?['product_id']),
        productName: j['product']?['product_name']?.toString(),
      );
}

class MOBomDetail {
  final int idBom;
  final String bomName;
  final int productId;
  final String? productName;
  final double productQty;
  final int? unitOfMeasure;
  final String? uomName;
  final int? rejectedProductId;

  MOBomDetail({
    required this.idBom,
    required this.bomName,
    required this.productId,
    this.productName,
    required this.productQty,
    this.unitOfMeasure,
    this.uomName,
    this.rejectedProductId,
  });

  factory MOBomDetail.fromJson(Map<String, dynamic> j) => MOBomDetail(
        idBom:       _pi(j['id_bom']),
        bomName:     _ps(j['bom_name']),
        productId:   _pi(j['product_id']),
        productName: j['product_name']?.toString(),
        productQty:  _pd(j['product_qty']),
        unitOfMeasure: _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
        uomName:     j['uom_name']?.toString(),
        rejectedProductId: _pi(j['rejected_product_id']) == 0 ? null : _pi(j['rejected_product_id']),
      );
}

class MOBomComponent {
  final int componentProductId;
  final String? productName;
  final double quantity;
  final int? unitOfMeasure;
  final String? uomName;

  MOBomComponent({
    required this.componentProductId,
    this.productName,
    required this.quantity,
    this.unitOfMeasure,
    this.uomName,
  });

  factory MOBomComponent.fromJson(Map<String, dynamic> j) => MOBomComponent(
        componentProductId: _pi(j['component_product_id']),
        productName: j['product_name']?.toString(),
        quantity:    _pd(j['quantity']),
        unitOfMeasure: _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
        uomName:     j['uom_name']?.toString(),
      );
}

class MOPlanMaterial {
  final int componentProductId;
  final String? productName;
  final double requiredQty;
  final int? unitOfMeasure;
  final String? uomName;
  final int? uomId;
  final String? sourceProduct;
  final double availableStock;
  final bool isAvailable;
  final double realQty;

  MOPlanMaterial({
    required this.componentProductId,
    this.productName,
    required this.requiredQty,
    this.unitOfMeasure,
    this.uomName,
    this.uomId,
    this.sourceProduct,
    required this.availableStock,
    required this.isAvailable,
    required this.realQty,
  });

  factory MOPlanMaterial.fromJson(Map<String, dynamic> j) => MOPlanMaterial(
        componentProductId: _pi(j['component_product_id']),
        productName:   j['product_name']?.toString(),
        requiredQty:   _pd(j['required_qty']),
        unitOfMeasure: _pi(j['unit_of_measure']) == 0 ? null : _pi(j['unit_of_measure']),
        uomName:       j['uom_name']?.toString(),
        uomId:         _pi(j['uom_id']) == 0 ? null : _pi(j['uom_id']),
        sourceProduct: j['source_product']?.toString(),
        availableStock: _pd(j['available_stock']),
        isAvailable:    j['is_available'] == true,
        realQty:        _pd(j['real_qty']),
      );
}

class MOCreateUnbuildResult {
  final String reference;
  final int idUnbuildOrder;
  final String encryption;
  final String message;

  MOCreateUnbuildResult({
    required this.reference,
    required this.idUnbuildOrder,
    required this.encryption,
    required this.message,
  });

  factory MOCreateUnbuildResult.fromJson(Map<String, dynamic> j) => MOCreateUnbuildResult(
        reference:      _ps(j['reference']),
        idUnbuildOrder: _pi(j['id_unbuild_order']),
        encryption:     _ps(j['encryption']),
        message:        _ps(j['message']),
      );
}

class MORealMaterialUsage {
  int? componentProductId;
  double qtyUsed;
  int? unitOfMeasure;

  MORealMaterialUsage({this.componentProductId, this.qtyUsed = 0, this.unitOfMeasure});

  Map<String, dynamic> toJson() => {
        'component_product_id': componentProductId,
        'qty_used': qtyUsed,
        'unit_of_measure': unitOfMeasure,
      };
}

class ManufacturingOrderFormModel {
  int? idManufacturingOrder;
  String? encryption;
  String? reference;
  int? idProduct;
  int? idBom;
  double plannedQty;
  int? unitOfMeasure;
  int? sourceWarehouse;
  int? sourceLocation;
  int? finishedLocation;
  int? rejectedLocation;
  int? byproductLocation;
  int? rejectedProductId;
  DateTime? scheduleDate;
  String? notes;
  List<int> laborPerson;
  List<MORealMaterialUsage> realMaterials;

  ManufacturingOrderFormModel({
    this.idManufacturingOrder,
    this.encryption,
    this.reference,
    this.idProduct,
    this.idBom,
    this.plannedQty = 0,
    this.unitOfMeasure,
    this.sourceWarehouse,
    this.sourceLocation,
    this.finishedLocation,
    this.rejectedLocation,
    this.byproductLocation,
    this.rejectedProductId,
    this.scheduleDate,
    this.notes,
    List<int>? laborPerson,
    List<MORealMaterialUsage>? realMaterials,
  })  : laborPerson  = laborPerson ?? [],
        realMaterials = realMaterials ?? [];

  bool get isEditMode => idManufacturingOrder != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) {
    return {
      if (idManufacturingOrder != null) 'id_manufacturing_order': idManufacturingOrder,
      if (reference != null) 'reference': reference,
      'id_product':          idProduct,
      'id_bom':              idBom,
      'planned_qty':         plannedQty,
      'unit_of_measure':     unitOfMeasure,
      'source_warehouse':    sourceWarehouse,
      'source_location':     sourceLocation,
      'finished_location':   finishedLocation,
      'rejected_location':   rejectedLocation,
      'byproduct_location':  byproductLocation,
      'rejected_product_id': rejectedProductId,
      'schedule_date':       scheduleDate != null ? _fmtDate(scheduleDate!) : null,
      'scheduled_date':      scheduleDate != null ? _fmtDate(scheduleDate!) : null,
      'notes':               notes,
      'labor_person':        laborPerson,
      'status':              status,
      if (realMaterials.isNotEmpty)
        'real_materials': realMaterials.map((e) => e.toJson()).toList(),
    };
  }

  factory ManufacturingOrderFormModel.fromDetail(ManufacturingOrderDetailModel d) =>
      ManufacturingOrderFormModel(
        idManufacturingOrder: d.idManufacturingOrder,
        encryption:           d.encryption,
        reference:            d.reference,
        idProduct:            d.idProduct,
        idBom:                d.idBom,
        plannedQty:           d.plannedQty,
        unitOfMeasure:        d.unitOfMeasure,
        sourceWarehouse:      d.sourceWarehouse,
        sourceLocation:       d.sourceLocation,
        finishedLocation:     d.finishedLocation,
        rejectedLocation:     d.rejectedLocation,
        byproductLocation:    d.byproductLocation,
        rejectedProductId:    d.rejectedProductId,
        scheduleDate:         d.scheduledDate != null ? DateTime.tryParse(d.scheduledDate!) : null,
        notes:                d.notes,
        laborPerson:          d.laborPersons.map((e) => e.id).toList(),
      );
}