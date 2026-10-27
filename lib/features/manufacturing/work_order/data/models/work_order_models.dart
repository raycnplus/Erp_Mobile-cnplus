int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

class WorkOrderModel {
  final int idMoOperationTracking;
  final String? operationName;
  final String status;
  final int plannedDuration;
  final int actualDuration;
  final String? startTime;
  final int? workstationId;
  final String? workstationName;
  final String? moReference;
  final int idManufacturingOrder;
  final String? moEncryption;
  final String? scheduledDate;
  final String? productName;
  final int? idProduct;
  final String? bomName;
  final String? durationFormatted;
  final String? actualDurationFormatted;

  WorkOrderModel({
    required this.idMoOperationTracking,
    this.operationName,
    required this.status,
    this.plannedDuration = 0,
    this.actualDuration = 0,
    this.startTime,
    this.workstationId,
    this.workstationName,
    this.moReference,
    required this.idManufacturingOrder,
    this.moEncryption,
    this.scheduledDate,
    this.productName,
    this.idProduct,
    this.bomName,
    this.durationFormatted,
    this.actualDurationFormatted,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> j) => WorkOrderModel(
        idMoOperationTracking: _pi(j['id_mo_operation_tracking']),
        operationName:  j['operation_name']?.toString(),
        status:         _ps(j['status']),
        plannedDuration: _pi(j['planned_duration']),
        actualDuration:  _pi(j['actual_duration']),
        startTime:      j['start_time']?.toString(),
        workstationId:  _pi(j['workstation_id']) == 0 ? null : _pi(j['workstation_id']),
        workstationName: j['workstation_name']?.toString(),
        moReference:    j['mo_reference']?.toString(),
        idManufacturingOrder: _pi(j['id_manufacturing_order']),
        moEncryption:   j['mo_encryption']?.toString(),
        scheduledDate:  j['scheduled_date']?.toString(),
        productName:    j['product_name']?.toString(),
        idProduct:      _pi(j['id_product']) == 0 ? null : _pi(j['id_product']),
        bomName:        j['bom_name']?.toString(),
        durationFormatted:       j['duration_formatted']?.toString(),
        actualDurationFormatted: j['actual_duration_formatted']?.toString(),
      );

  bool get isPending    => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isPaused     => status == 'paused';
  bool get isCompleted  => status == 'completed';

  static const _statusColors = <String, int>{
    'pending':     0xFF757575,
    'in_progress': 0xFF1565C0,
    'paused':      0xFFFFA500,
    'completed':   0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;

  static const _statusLabels = <String, String>{
    'pending':     'Pending',
    'in_progress': 'In Progress',
    'paused':      'Paused',
    'completed':   'Completed',
  };

  String get statusLabel => _statusLabels[status] ?? status;
}

class WOPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  WOPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class WOWorkstationOption {
  final int id;
  final String name;
  WOWorkstationOption({required this.id, required this.name});
  factory WOWorkstationOption.fromJson(Map<String, dynamic> j) =>
      WOWorkstationOption(id: _pi(j['id_workstation']), name: _ps(j['workstation_name']));
  @override bool operator ==(Object o) => o is WOWorkstationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class WOProductOption {
  final int id;
  final String name;
  WOProductOption({required this.id, required this.name});
  factory WOProductOption.fromJson(Map<String, dynamic> j) =>
      WOProductOption(id: _pi(j['id_product']), name: _ps(j['product_name']));
  @override bool operator ==(Object o) => o is WOProductOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class WorkOrderFormOptions {
  final List<WOWorkstationOption> workstations;
  final List<WOProductOption> products;
  final List<String> statuses;

  WorkOrderFormOptions({
    required this.workstations,
    required this.products,
    required this.statuses,
  });

  factory WorkOrderFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return WorkOrderFormOptions(
      workstations: (data['workstations'] as List? ?? []).map((e) => WOWorkstationOption.fromJson(e)).toList(),
      products:     (data['products']     as List? ?? []).map((e) => WOProductOption.fromJson(e)).toList(),
      statuses:     (data['statuses']     as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class WorkOrderFilter {
  int? workstationId;
  String? status;
  String? moReference;
  int? productId;
  DateTime? dateFrom;
  DateTime? dateTo;

  WorkOrderFilter({
    this.workstationId,
    this.status,
    this.moReference,
    this.productId,
    this.dateFrom,
    this.dateTo,
  });

  bool get isActive =>
      workstationId != null ||
      (status != null && status!.isNotEmpty) ||
      (moReference != null && moReference!.isNotEmpty) ||
      productId != null ||
      dateFrom != null ||
      dateTo != null;

  void clear() {
    workstationId = null;
    status = null;
    moReference = null;
    productId = null;
    dateFrom = null;
    dateTo = null;
  }
}