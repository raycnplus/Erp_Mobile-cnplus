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

class BomPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const BomPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory BomPaginationMeta.fromJson(Map<String, dynamic> json) {
    final m = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;
    return BomPaginationMeta(
      currentPage: m['current_page'] ?? 1,
      lastPage: m['last_page'] ?? 1,
      perPage: m['per_page'] ?? 15,
      total: m['total'] ?? 0,
    );
  }
}

class BomModel {
  final String encryption;
  final String bomName;
  final String productName;
  final double productQty;
  final String? flexibleConsumption;
  final double totalEstimatedCost;
  final int totalDurationTime;

  const BomModel({
    required this.encryption,
    required this.bomName,
    required this.productName,
    this.productQty = 1,
    this.flexibleConsumption,
    this.totalEstimatedCost = 0,
    this.totalDurationTime = 0,
  });

  factory BomModel.fromJson(Map<String, dynamic> json) {
    return BomModel(
      encryption: json['encryption']?.toString() ?? '',
      bomName: json['bom_name']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '-',
      productQty: _pd(json['product_qty']),
      flexibleConsumption: json['flexible_consumption']?.toString(),
      totalEstimatedCost: _pd(json['total_estimated_cost']),
      totalDurationTime: _pi(json['total_duration_time']),
    );
  }
}

class BomComponent {
  final int? componentProductId;
  final String componentProductName;
  final double quantity;
  final int? unitOfMeasure;
  final String? uomName;
  final double estimatedCost;

  const BomComponent({
    this.componentProductId,
    this.componentProductName = '',
    this.quantity = 1,
    this.unitOfMeasure,
    this.uomName,
    this.estimatedCost = 0,
  });

  factory BomComponent.fromJson(Map<String, dynamic> json) {
    return BomComponent(
      componentProductId: _pi(json['component_product_id']) == 0
          ? null
          : _pi(json['component_product_id']),
      componentProductName:
          json['component_product']?['product_name']?.toString() ??
              json['component_product_name']?.toString() ??
              '',
      quantity: _pd(json['quantity']),
      unitOfMeasure: _pi(json['unit_of_measure']) == 0
          ? null
          : _pi(json['unit_of_measure']),
      uomName: json['uom']?['unit_of_measure_name']?.toString() ??
          json['uom_name']?.toString(),
      estimatedCost: _pd(json['estimated_cost']),
    );
  }
}

class BomByproduct {
  final int? productId;
  final String productName;
  final int? uomId;
  final String? uomName;
  final double quantity;
  final String? notes;

  const BomByproduct({
    this.productId,
    this.productName = '',
    this.uomId,
    this.uomName,
    this.quantity = 0,
    this.notes,
  });

  factory BomByproduct.fromJson(Map<String, dynamic> json) {
    return BomByproduct(
      productId:
          _pi(json['product_id']) == 0 ? null : _pi(json['product_id']),
      productName: json['product_name']?.toString() ?? '',
      uomId: _pi(json['uom_id']) == 0 ? null : _pi(json['uom_id']),
      uomName: json['unit_of_measure_name']?.toString(),
      quantity: _pd(json['quantity']),
      notes: json['notes']?.toString(),
    );
  }
}

class BomOperation {
  final int? idBomOperation;
  final int sequence;
  final String operationName;
  final int? workstationId;
  final String? workstationName;
  final int duration;
  final String? notes;

  const BomOperation({
    this.idBomOperation,
    this.sequence = 1,
    this.operationName = '',
    this.workstationId,
    this.workstationName,
    this.duration = 0,
    this.notes,
  });

  factory BomOperation.fromJson(Map<String, dynamic> json) {
    return BomOperation(
      idBomOperation: _pi(json['id_bom_operation']) == 0
          ? null
          : _pi(json['id_bom_operation']),
      sequence: _pi(json['sequence']),
      operationName: json['operation_name']?.toString() ?? '',
      workstationId: _pi(json['workstation_id']) == 0
          ? null
          : _pi(json['workstation_id']),
      workstationName: json['workstation_name']?.toString(),
      duration: _pi(json['duration']),
      notes: json['notes']?.toString(),
    );
  }
}

class BomEquipment {
  final int? equipmentId;
  final String equipmentName;
  final String? notes;

  const BomEquipment({
    this.equipmentId,
    this.equipmentName = '',
    this.notes,
  });

  factory BomEquipment.fromJson(Map<String, dynamic> json) {
    return BomEquipment(
      equipmentId: _pi(json['equipment_id']) == 0
          ? null
          : _pi(json['equipment_id']),
      equipmentName: json['product_name']?.toString() ??
          json['equipment_name']?.toString() ??
          '',
      notes: json['notes']?.toString(),
    );
  }
}

class BomDetailModel {
  final BomData bom;
  final List<BomComponent> components;
  final List<BomByproduct> byproducts;
  final List<BomOperation> operations;
  final List<BomEquipment> equipments;
  final String? createdByName;
  final String? updatedByName;

  const BomDetailModel({
    required this.bom,
    required this.components,
    required this.byproducts,
    required this.operations,
    required this.equipments,
    this.createdByName,
    this.updatedByName,
  });

  factory BomDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BomDetailModel(
      bom: BomData.fromJson(data),
      components: (data['components'] as List? ?? [])
          .map((e) => BomComponent.fromJson(e))
          .toList(),
      byproducts: (data['byproducts'] as List? ?? [])
          .map((e) => BomByproduct.fromJson(e))
          .toList(),
      operations: (data['operations'] as List? ?? [])
          .map((e) => BomOperation.fromJson(e))
          .toList(),
      equipments: (data['equipments'] as List? ?? [])
          .map((e) => BomEquipment.fromJson(e))
          .toList(),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
    );
  }
}

class BomData {
  final String encryption;
  final String bomName;
  final int? productId;
  final String? productName;
  final double productQty;
  final String flexibleConsumption;
  final int? rejectedProductId;
  final int preparationTime;
  final double totalEstimatedCost;
  final int totalDurationTime;
  final String? description;
  final String? createdDate;
  final String? updatedDate;

  const BomData({
    required this.encryption,
    required this.bomName,
    this.productId,
    this.productName,
    this.productQty = 1,
    this.flexibleConsumption = 'warning',
    this.rejectedProductId,
    this.preparationTime = 0,
    this.totalEstimatedCost = 0,
    this.totalDurationTime = 0,
    this.description,
    this.createdDate,
    this.updatedDate,
  });

  factory BomData.fromJson(Map<String, dynamic> json) {
    return BomData(
      encryption: json['encryption']?.toString() ?? '',
      bomName: json['bom_name']?.toString() ?? '',
      productId:
          _pi(json['product_id']) == 0 ? null : _pi(json['product_id']),
      productName: json['product_name']?.toString(),
      productQty: _pd(json['product_qty']),
      flexibleConsumption:
          json['flexible_consumption']?.toString() ?? 'warning',
      rejectedProductId: _pi(json['rejected_product_id']) == 0
          ? null
          : _pi(json['rejected_product_id']),
      preparationTime: _pi(json['preparation_time']),
      totalEstimatedCost: _pd(json['total_estimated_cost']),
      totalDurationTime: _pi(json['total_duration_time']),
      description: json['description']?.toString(),
      createdDate: json['created_date']?.toString(),
      updatedDate: json['updated_date']?.toString(),
    );
  }
}

class BomProductOption {
  final int id;
  final String name;

  const BomProductOption({required this.id, required this.name});

  factory BomProductOption.fromJson(Map<String, dynamic> json) {
    return BomProductOption(
      id: _pi(json['id_product']),
      name: json['product_name']?.toString() ?? '',
    );
  }

  @override
  bool operator ==(Object o) => o is BomProductOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BomUomOption {
  final int id;
  final String name;

  const BomUomOption({required this.id, required this.name});

  factory BomUomOption.fromJson(Map<String, dynamic> json) {
    return BomUomOption(
      id: _pi(json['id_unit_of_measure']),
      name: json['unit_of_measure_name']?.toString() ?? '',
    );
  }

  @override
  bool operator ==(Object o) => o is BomUomOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BomWorkstationOption {
  final int id;
  final String name;
  final String? code;

  const BomWorkstationOption({
    required this.id,
    required this.name,
    this.code,
  });

  factory BomWorkstationOption.fromJson(Map<String, dynamic> json) {
    return BomWorkstationOption(
      id: _pi(json['id_workstation']),
      name: json['workstation_name']?.toString() ?? '',
      code: json['workstation_code']?.toString(),
    );
  }

  @override
  bool operator ==(Object o) => o is BomWorkstationOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BomFlexOption {
  final String value;
  final String label;

  const BomFlexOption({required this.value, required this.label});

  factory BomFlexOption.fromJson(Map<String, dynamic> json) {
    return BomFlexOption(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
    );
  }
}

class BomFormOptions {
  final List<BomProductOption> products;
  final List<BomProductOption> storableProducts;
  final List<BomUomOption> uoms;
  final List<BomWorkstationOption> workstations;
  final List<BomProductOption> equipmentProducts;
  final Map<int, double> purchasePriceMap;
  final List<BomFlexOption> flexibleConsumptions;

  const BomFormOptions({
    required this.products,
    required this.storableProducts,
    required this.uoms,
    required this.workstations,
    required this.equipmentProducts,
    required this.purchasePriceMap,
    required this.flexibleConsumptions,
  });

  factory BomFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final priceMap = <int, double>{};
    if (data['purchase_price_map'] is Map) {
      (data['purchase_price_map'] as Map).forEach((k, v) {
        final id = int.tryParse(k.toString());
        if (id != null) priceMap[id] = _pd(v);
      });
    }
    return BomFormOptions(
      products: (data['products'] as List? ?? [])
          .map((e) => BomProductOption.fromJson(e))
          .toList(),
      storableProducts: (data['storable_products'] as List? ?? [])
          .map((e) => BomProductOption.fromJson(e))
          .toList(),
      uoms: (data['uoms'] as List? ?? [])
          .map((e) => BomUomOption.fromJson(e))
          .toList(),
      workstations: (data['workstations'] as List? ?? [])
          .map((e) => BomWorkstationOption.fromJson(e))
          .toList(),
      equipmentProducts: (data['equipment_products'] as List? ?? [])
          .map((e) => BomProductOption.fromJson(e))
          .toList(),
      purchasePriceMap: priceMap,
      flexibleConsumptions: (data['flexible_consumptions'] as List? ?? [])
          .map((e) => BomFlexOption.fromJson(e))
          .toList(),
    );
  }
}

class BomComponentRow {
  int? componentProductId;
  String componentProductName;
  double quantity;
  int? unitOfMeasure;
  double estimatedCost;

  BomComponentRow({
    this.componentProductId,
    this.componentProductName = '',
    this.quantity = 1,
    this.unitOfMeasure,
    this.estimatedCost = 0,
  });

  Map<String, dynamic> toJson() => {
        'component_product_id': componentProductId,
        'quantity': quantity,
        'unit_of_measure': unitOfMeasure,
        'estimated_cost': estimatedCost,
      };
}

class BomByproductRow {
  int? productId;
  String productName;
  int? uomId;
  double quantity;
  String? notes;

  BomByproductRow({
    this.productId,
    this.productName = '',
    this.uomId,
    this.quantity = 0,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        if (uomId != null) 'uom_id': uomId,
        'quantity': quantity,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

class BomOperationRow {
  int? idBomOperation;
  int sequence;
  String operationName;
  int? workstationId;
  int duration;
  String? notes;

  BomOperationRow({
    this.idBomOperation,
    this.sequence = 1,
    this.operationName = '',
    this.workstationId,
    this.duration = 0,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        if (idBomOperation != null) 'id_bom_operation': idBomOperation,
        'sequence': sequence,
        'operation_name': operationName,
        if (workstationId != null) 'workstation_id': workstationId,
        'duration': duration,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

class BomEquipmentRow {
  int? equipmentId;
  String equipmentName;
  String? notes;

  BomEquipmentRow({
    this.equipmentId,
    this.equipmentName = '',
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'equipment_id': equipmentId,
        if (notes != null && notes!.isNotEmpty) 'notes': notes,
      };
}

class BomFormModel {
  String? encryption;
  String bomName;
  int? productId;
  double productQty;
  String flexibleConsumption;
  int? rejectedProductId;
  int preparationTime;
  String? description;
  List<BomComponentRow> components;
  List<BomByproductRow> byproducts;
  List<BomOperationRow> operations;
  List<BomEquipmentRow> equipments;

  BomFormModel({
    this.encryption,
    this.bomName = '',
    this.productId,
    this.productQty = 1,
    this.flexibleConsumption = 'warning',
    this.rejectedProductId,
    this.preparationTime = 0,
    this.description,
    List<BomComponentRow>? components,
    List<BomByproductRow>? byproducts,
    List<BomOperationRow>? operations,
    List<BomEquipmentRow>? equipments,
  })  : components = components ?? [BomComponentRow()],
        byproducts = byproducts ?? [],
        operations = operations ?? [],
        equipments = equipments ?? [];

  factory BomFormModel.fromDetail(BomDetailModel detail) {
    final d = detail.bom;
    return BomFormModel(
      encryption: d.encryption,
      bomName: d.bomName,
      productId: d.productId,
      productQty: d.productQty,
      flexibleConsumption: d.flexibleConsumption,
      rejectedProductId: d.rejectedProductId,
      preparationTime: d.preparationTime,
      description: d.description,
      components: detail.components
          .map((c) => BomComponentRow(
                componentProductId: c.componentProductId,
                componentProductName: c.componentProductName,
                quantity: c.quantity,
                unitOfMeasure: c.unitOfMeasure,
                estimatedCost: c.estimatedCost,
              ))
          .toList(),
      byproducts: detail.byproducts
          .map((b) => BomByproductRow(
                productId: b.productId,
                productName: b.productName,
                uomId: b.uomId,
                quantity: b.quantity,
                notes: b.notes,
              ))
          .toList(),
      operations: detail.operations
          .map((o) => BomOperationRow(
                idBomOperation: o.idBomOperation,
                sequence: o.sequence,
                operationName: o.operationName,
                workstationId: o.workstationId,
                duration: o.duration,
                notes: o.notes,
              ))
          .toList(),
      equipments: detail.equipments
          .map((e) => BomEquipmentRow(
                equipmentId: e.equipmentId,
                equipmentName: e.equipmentName,
                notes: e.notes,
              ))
          .toList(),
    );
  }

  bool isValid() =>
      bomName.trim().isNotEmpty &&
      productId != null &&
      components.isNotEmpty &&
      components.every((c) => c.componentProductId != null);

  Map<String, dynamic> toJson() => {
        'bom_name': bomName,
        'product_id': productId,
        'product_qty': productQty,
        'flexible_consumption': flexibleConsumption,
        if (rejectedProductId != null) 'rejected_product_id': rejectedProductId,
        'preparation_time': preparationTime,
        if (description != null && description!.isNotEmpty)
          'description': description,
        'components': components.map((c) => c.toJson()).toList(),
        if (byproducts.isNotEmpty)
          'byproducts': byproducts.map((b) => b.toJson()).toList(),
        if (operations.isNotEmpty)
          'operations': operations.map((o) => o.toJson()).toList(),
        if (equipments.isNotEmpty)
          'equipments': equipments.map((e) => e.toJson()).toList(),
      };
}