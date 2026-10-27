int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

int? _pin(dynamic v) {
  if (v == null || v.toString().isEmpty) return null;
  return v is int ? v : int.tryParse(v.toString());
}

String _ps(dynamic v) => v?.toString() ?? '';

class AssetMovementModel {
  final int idAssetMovement;
  final String encryption;
  final String? reference;
  final String? movementDate;
  final String? assetCode;
  final String? assetName;
  final String? fromLocation;
  final String? toLocation;

  AssetMovementModel({
    required this.idAssetMovement,
    required this.encryption,
    this.reference,
    this.movementDate,
    this.assetCode,
    this.assetName,
    this.fromLocation,
    this.toLocation,
  });

  factory AssetMovementModel.fromJson(Map<String, dynamic> j) => AssetMovementModel(
        idAssetMovement: _pi(j['id_asset_movement']),
        encryption:      _ps(j['encryption']),
        reference:       j['reference']?.toString(),
        movementDate:    j['movement_date']?.toString(),
        assetCode:       j['asset_code']?.toString(),
        assetName:       j['asset_name']?.toString(),
        fromLocation:    j['from_location']?.toString(),
        toLocation:      j['to_location']?.toString(),
      );
}

class AssetMovementPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  AssetMovementPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class AMAssetOption {
  final int idFixedAsset;
  final String assetCode;
  final String assetName;
  final String? location;
  final int? picEmployee;
  final String? currentPicName;

  AMAssetOption({
    required this.idFixedAsset,
    required this.assetCode,
    required this.assetName,
    this.location,
    this.picEmployee,
    this.currentPicName,
  });

  factory AMAssetOption.fromJson(Map<String, dynamic> j) => AMAssetOption(
        idFixedAsset:   _pi(j['id_fixed_asset']),
        assetCode:      _ps(j['asset_code']),
        assetName:      _ps(j['asset_name']),
        location:       j['location']?.toString(),
        picEmployee:    _pin(j['pic_employee']),
        currentPicName: j['current_pic_name']?.toString(),
      );

  String get display => assetCode.isNotEmpty ? '$assetCode - $assetName' : assetName;

  @override
  bool operator ==(Object o) => o is AMAssetOption && o.idFixedAsset == idFixedAsset;
  @override
  int get hashCode => idFixedAsset.hashCode;
}

class AMEmployeeOption {
  final int idEmployee;
  final String employeeName;

  AMEmployeeOption({required this.idEmployee, required this.employeeName});

  factory AMEmployeeOption.fromJson(Map<String, dynamic> j) =>
      AMEmployeeOption(idEmployee: _pi(j['id_employee']), employeeName: _ps(j['employee_name']));

  @override
  bool operator ==(Object o) => o is AMEmployeeOption && o.idEmployee == idEmployee;
  @override
  int get hashCode => idEmployee.hashCode;
}

class AssetMovementFormOptions {
  final List<AMAssetOption> assets;
  final List<AMEmployeeOption> employees;

  AssetMovementFormOptions({required this.assets, required this.employees});

  factory AssetMovementFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AssetMovementFormOptions(
      assets:    (data['assets'] as List? ?? []).map((e) => AMAssetOption.fromJson(e)).toList(),
      employees: (data['employees'] as List? ?? []).map((e) => AMEmployeeOption.fromJson(e)).toList(),
    );
  }
}

class AssetMovementAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  AssetMovementAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory AssetMovementAuditTrail.fromJson(Map<String, dynamic> j) => AssetMovementAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class AssetMovementDetailModel {
  final int idAssetMovement;
  final String encryption;
  final String? reference;
  final String? movementDate;
  final int? idFixedAsset;
  final String? assetCode;
  final String? assetName;
  final String? fromPicName;
  final String? toPicName;
  final String? fromLocation;
  final String? toLocation;
  final String? reason;
  final String? createdDate;
  final String? createdByName;
  final List<AssetMovementAuditTrail> auditTrails;

  AssetMovementDetailModel({
    required this.idAssetMovement,
    required this.encryption,
    this.reference,
    this.movementDate,
    this.idFixedAsset,
    this.assetCode,
    this.assetName,
    this.fromPicName,
    this.toPicName,
    this.fromLocation,
    this.toLocation,
    this.reason,
    this.createdDate,
    this.createdByName,
    required this.auditTrails,
  });

  factory AssetMovementDetailModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] ?? json;
    return AssetMovementDetailModel(
      idAssetMovement: _pi(d['id_asset_movement']),
      encryption:      _ps(d['encryption']),
      reference:       d['reference']?.toString(),
      movementDate:    d['movement_date']?.toString(),
      idFixedAsset:    _pin(d['id_fixed_asset']),
      assetCode:       d['asset_code']?.toString(),
      assetName:       d['asset_name']?.toString(),
      fromPicName:     d['from_pic_name']?.toString(),
      toPicName:       d['to_pic_name']?.toString(),
      fromLocation:    d['from_location']?.toString(),
      toLocation:      d['to_location']?.toString(),
      reason:          d['reason']?.toString(),
      createdDate:     d['created_date']?.toString(),
      createdByName:   d['created_by_name']?.toString(),
      auditTrails: (d['audit_trails'] as List? ?? []).map((e) => AssetMovementAuditTrail.fromJson(e)).toList(),
    );
  }
}

class AssetMovementFormModel {
  int? idFixedAsset;
  DateTime? movementDate;
  int? toPicEmployee;
  String? toLocation;
  String? reason;

  AssetMovementFormModel({
    this.idFixedAsset,
    this.movementDate,
    this.toPicEmployee,
    this.toLocation,
    this.reason,
  });

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id_fixed_asset':  idFixedAsset,
        'movement_date':   movementDate != null ? _fmtDate(movementDate!) : null,
        'to_pic_employee': toPicEmployee,
        'to_location':     toLocation,
        'reason':          reason,
      };
}