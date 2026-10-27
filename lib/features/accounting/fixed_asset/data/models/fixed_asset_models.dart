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

int? _pin(dynamic v) {
  if (v == null || v.toString().isEmpty) return null;
  return v is int ? v : int.tryParse(v.toString());
}

String _ps(dynamic v) => v?.toString() ?? '';

String fixedAssetMethodLabel(String? m) {
  switch (m) {
    case 'straight_line':
      return 'Straight Line';
    case 'declining_balance':
      return 'Declining Balance';
    default:
      return (m == null || m.isEmpty) ? '-' : m;
  }
}

String fixedAssetStatusLabel(String? s) {
  if (s == null || s.isEmpty) return '-';
  return s[0].toUpperCase() + s.substring(1);
}

const _statusColors = <String, int>{
  'active':   0xFF2E7D32,
  'inactive': 0xFF757575,
  'disposed': 0xFFC62828,
};

class FixedAssetModel {
  final int idFixedAsset;
  final String encryption;
  final String assetCode;
  final String assetName;
  final String? categoryName;
  final String? acquisitionDate;
  final double acquisitionCost;
  final double bookValue;
  final String assetStatus;

  FixedAssetModel({
    required this.idFixedAsset,
    required this.encryption,
    required this.assetCode,
    required this.assetName,
    this.categoryName,
    this.acquisitionDate,
    this.acquisitionCost = 0,
    this.bookValue = 0,
    required this.assetStatus,
  });

  factory FixedAssetModel.fromJson(Map<String, dynamic> j) => FixedAssetModel(
        idFixedAsset:    _pi(j['id_fixed_asset']),
        encryption:      _ps(j['encryption']),
        assetCode:       _ps(j['asset_code']),
        assetName:       _ps(j['asset_name']),
        categoryName:    j['category_name']?.toString(),
        acquisitionDate: j['acquisition_date']?.toString(),
        acquisitionCost: _pd(j['acquisition_cost']),
        bookValue:       _pd(j['book_value']),
        assetStatus:     _ps(j['asset_status']),
      );

  int get statusColor => _statusColors[assetStatus] ?? 0xFF757575;
  String get statusLabel => fixedAssetStatusLabel(assetStatus);
}

class FixedAssetPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  FixedAssetPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class FACategoryOption {
  final int idAssetCategory;
  final String categoryName;
  final String? categoryCode;
  final int defaultUsefulLifeMonths;
  final String? depreciationMethod;

  FACategoryOption({
    required this.idAssetCategory,
    required this.categoryName,
    this.categoryCode,
    this.defaultUsefulLifeMonths = 0,
    this.depreciationMethod,
  });

  factory FACategoryOption.fromJson(Map<String, dynamic> j) => FACategoryOption(
        idAssetCategory:         _pi(j['id_asset_category']),
        categoryName:            _ps(j['category_name']),
        categoryCode:            j['category_code']?.toString(),
        defaultUsefulLifeMonths: _pi(j['default_useful_life_months']),
        depreciationMethod:      j['depreciation_method']?.toString(),
      );

  String get display => categoryCode?.isNotEmpty == true ? '$categoryCode - $categoryName' : categoryName;

  @override
  bool operator ==(Object o) => o is FACategoryOption && o.idAssetCategory == idAssetCategory;
  @override
  int get hashCode => idAssetCategory.hashCode;
}

class FAEmployeeOption {
  final int idEmployee;
  final String employeeName;

  FAEmployeeOption({required this.idEmployee, required this.employeeName});

  factory FAEmployeeOption.fromJson(Map<String, dynamic> j) =>
      FAEmployeeOption(idEmployee: _pi(j['id_employee']), employeeName: _ps(j['employee_name']));

  @override
  bool operator ==(Object o) => o is FAEmployeeOption && o.idEmployee == idEmployee;
  @override
  int get hashCode => idEmployee.hashCode;
}

class FADepartmentOption {
  final int idDepartment;
  final String departmentName;

  FADepartmentOption({required this.idDepartment, required this.departmentName});

  factory FADepartmentOption.fromJson(Map<String, dynamic> j) =>
      FADepartmentOption(idDepartment: _pi(j['id_department']), departmentName: _ps(j['department_name']));

  @override
  bool operator ==(Object o) => o is FADepartmentOption && o.idDepartment == idDepartment;
  @override
  int get hashCode => idDepartment.hashCode;
}

class FixedAssetFormOptions {
  final List<FACategoryOption> categories;
  final List<FAEmployeeOption> employees;
  final List<FADepartmentOption> departments;
  final List<String> depreciationMethods;
  final List<String> assetStatuses;

  FixedAssetFormOptions({
    required this.categories,
    required this.employees,
    required this.departments,
    required this.depreciationMethods,
    required this.assetStatuses,
  });

  factory FixedAssetFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return FixedAssetFormOptions(
      categories:  (data['asset_categories'] as List? ?? []).map((e) => FACategoryOption.fromJson(e)).toList(),
      employees:   (data['employees'] as List? ?? []).map((e) => FAEmployeeOption.fromJson(e)).toList(),
      departments: (data['departments'] as List? ?? []).map((e) => FADepartmentOption.fromJson(e)).toList(),
      depreciationMethods: (data['depreciation_methods'] as List? ?? []).map((e) => e.toString()).toList(),
      assetStatuses: (data['asset_statuses'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class FixedAssetDetailModel {
  final int idFixedAsset;
  final String encryption;
  final String assetCode;
  final String assetName;
  final int? assetCategory;
  final String? categoryName;
  final String? serialNumber;
  final String? acquisitionDate;
  final double acquisitionCost;
  final String? depreciationMethod;
  final int usefulLifeMonths;
  final double salvageValue;
  final double accumulatedDepreciation;
  final double bookValue;
  final int? picEmployee;
  final String? picName;
  final int? idDepartment;
  final String? departmentName;
  final String? location;
  final String? notes;
  final String assetStatus;
  final String? createdDate;
  final String? updatedDate;
  final String? createdByName;
  final String? updatedByName;

  FixedAssetDetailModel({
    required this.idFixedAsset,
    required this.encryption,
    required this.assetCode,
    required this.assetName,
    this.assetCategory,
    this.categoryName,
    this.serialNumber,
    this.acquisitionDate,
    this.acquisitionCost = 0,
    this.depreciationMethod,
    this.usefulLifeMonths = 0,
    this.salvageValue = 0,
    this.accumulatedDepreciation = 0,
    this.bookValue = 0,
    this.picEmployee,
    this.picName,
    this.idDepartment,
    this.departmentName,
    this.location,
    this.notes,
    required this.assetStatus,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
  });

  factory FixedAssetDetailModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] ?? json;
    return FixedAssetDetailModel(
      idFixedAsset:            _pi(d['id_fixed_asset']),
      encryption:              _ps(d['encryption']),
      assetCode:               _ps(d['asset_code']),
      assetName:               _ps(d['asset_name']),
      assetCategory:           _pin(d['asset_category']),
      categoryName:            d['category_name']?.toString(),
      serialNumber:            d['serial_number']?.toString(),
      acquisitionDate:         d['acquisition_date']?.toString(),
      acquisitionCost:         _pd(d['acquisition_cost']),
      depreciationMethod:      d['depreciation_method']?.toString(),
      usefulLifeMonths:        _pi(d['useful_life_months']),
      salvageValue:            _pd(d['salvage_value']),
      accumulatedDepreciation: _pd(d['accumulated_depreciation']),
      bookValue:               _pd(d['book_value']),
      picEmployee:             _pin(d['pic_employee']),
      picName:                 d['pic_name']?.toString(),
      idDepartment:            _pin(d['id_department']),
      departmentName:          d['department_name']?.toString(),
      location:                d['location']?.toString(),
      notes:                   d['notes']?.toString(),
      assetStatus:             _ps(d['asset_status']),
      createdDate:             d['created_date']?.toString(),
      updatedDate:             d['updated_date']?.toString(),
      createdByName:           d['created_by_name']?.toString(),
      updatedByName:           d['updated_by_name']?.toString(),
    );
  }

  bool get isActive   => assetStatus == 'active';
  bool get isInactive => assetStatus == 'inactive';
  bool get isDisposed => assetStatus == 'disposed';
  bool get canEdit    => true;
  bool get canDelete  => true;
  int get statusColor => _statusColors[assetStatus] ?? 0xFF757575;
  String get statusLabel => fixedAssetStatusLabel(assetStatus);
  String get methodLabel => fixedAssetMethodLabel(depreciationMethod);
}

class FixedAssetFormModel {
  String? encryption;
  String? assetCode;
  String? assetName;
  int? assetCategory;
  String? serialNumber;
  DateTime? acquisitionDate;
  double? acquisitionCost;
  String? depreciationMethod;
  int? usefulLifeMonths;
  double salvageValue;
  int? picEmployee;
  int? idDepartment;
  String? location;
  String assetStatus;
  String? notes;

  FixedAssetFormModel({
    this.encryption,
    this.assetCode,
    this.assetName,
    this.assetCategory,
    this.serialNumber,
    this.acquisitionDate,
    this.acquisitionCost,
    this.depreciationMethod,
    this.usefulLifeMonths,
    this.salvageValue = 0,
    this.picEmployee,
    this.idDepartment,
    this.location,
    this.assetStatus = 'active',
    this.notes,
  });

  bool get isEditMode => encryption != null;

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
    'asset_code':          assetCode,
    'asset_name':          assetName,
    'asset_category':      assetCategory,
    'serial_number':       serialNumber,
    'acquisition_date':    acquisitionDate != null ? _fmtDate(acquisitionDate!) : null,
    'acquisition_cost':    acquisitionCost,
    'depreciation_method': depreciationMethod,
    'useful_life_months':  usefulLifeMonths,
    'salvage_value':       salvageValue,
    'pic_employee':        picEmployee,
    'id_department':       idDepartment,
    'location':            location,
    'asset_status':        assetStatus,
    'notes':               notes,
  };

  factory FixedAssetFormModel.fromDetail(FixedAssetDetailModel d) => FixedAssetFormModel(
    encryption:         d.encryption,
    assetCode:          d.assetCode,
    assetName:          d.assetName,
    assetCategory:      d.assetCategory,
    serialNumber:       d.serialNumber,
    acquisitionDate:    d.acquisitionDate != null ? DateTime.tryParse(d.acquisitionDate!) : null,
    acquisitionCost:    d.acquisitionCost,
    depreciationMethod: d.depreciationMethod,
    usefulLifeMonths:   d.usefulLifeMonths > 0 ? d.usefulLifeMonths : null,
    salvageValue:       d.salvageValue,
    picEmployee:        d.picEmployee,
    idDepartment:       d.idDepartment,
    location:           d.location,
    assetStatus:        d.assetStatus.isNotEmpty ? d.assetStatus : 'active',
    notes:              d.notes,
  );
}