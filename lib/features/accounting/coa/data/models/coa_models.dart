class CoaModel {
  final String encryption;
  final String coaNumber;
  final String coaName;
  final String type;
  final String reportType;
  final String isHeader;
  final String taxAdjustment;
  final int? parentId;
  final String? description;
  final int level; 

  CoaModel({
    required this.encryption,
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.reportType,
    required this.isHeader,
    required this.taxAdjustment,
    this.parentId,
    this.description,
    this.level = 0,
  });

  factory CoaModel.fromJson(Map<String, dynamic> json) => CoaModel(
    encryption: json['encryption']?.toString() ?? '',
    coaNumber: json['coa_number']?.toString() ?? '',
    coaName: json['coa_name']?.toString() ?? '',
    type: json['type']?.toString() ?? '',
    reportType: json['report_type']?.toString() ?? '',
    isHeader: json['is_header']?.toString() ?? 'N',
    taxAdjustment: json['tax_adjustment']?.toString() ?? 'N',
    parentId: json['parent_id'] is int ? json['parent_id'] : int.tryParse(json['parent_id']?.toString() ?? ''),
    description: json['description']?.toString(),
    level: json['level'] is int ? json['level'] : int.tryParse(json['level']?.toString() ?? '0') ?? 0,
  );

  bool get isHeaderAccount => isHeader == 'Y';
}

class CoaDetailModel {
  final CoaData coa;
  final String? createdByName;
  final String? updatedByName;
  final CoaParentData? parentCoa;

  CoaDetailModel({required this.coa, this.createdByName, this.updatedByName, this.parentCoa});

  factory CoaDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CoaDetailModel(
      coa: CoaData.fromJson(data),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      parentCoa: data['parent_coa'] != null ? CoaParentData.fromJson(data['parent_coa']) : null,
    );
  }
}

class CoaParentData {
  final int idCoa;
  final String coaNumber;
  final String coaName;
  CoaParentData({required this.idCoa, required this.coaNumber, required this.coaName});
  factory CoaParentData.fromJson(Map<String, dynamic> json) => CoaParentData(
    idCoa: json['id_coa'] is int ? json['id_coa'] : int.tryParse(json['id_coa']?.toString() ?? '0') ?? 0,
    coaNumber: json['coa_number']?.toString() ?? '',
    coaName: json['coa_name']?.toString() ?? '',
  );
}

class CoaData {
  final String encryption;
  final String coaNumber;
  final String coaName;
  final String type;
  final String reportType;
  final String isHeader;
  final String taxAdjustment;
  final int? parentId;
  final String? description;
  final String? createdDate;
  final String? updatedDate;

  CoaData({
    required this.encryption,
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.reportType,
    required this.isHeader,
    required this.taxAdjustment,
    this.parentId,
    this.description,
    this.createdDate,
    this.updatedDate,
  });

  factory CoaData.fromJson(Map<String, dynamic> json) => CoaData(
    encryption: json['encryption']?.toString() ?? '',
    coaNumber: json['coa_number']?.toString() ?? '',
    coaName: json['coa_name']?.toString() ?? '',
    type: json['type']?.toString() ?? '',
    reportType: json['report_type']?.toString() ?? '',
    isHeader: json['is_header']?.toString() ?? 'N',
    taxAdjustment: json['tax_adjustment']?.toString() ?? 'N',
    parentId: json['parent_id'] is int ? json['parent_id'] : int.tryParse(json['parent_id']?.toString() ?? ''),
    description: json['description']?.toString(),
    createdDate: json['created_date']?.toString(),
    updatedDate: json['updated_date']?.toString(),
  );
}

class CoaParentOption {
  final int idCoa;
  final String coaNumber;
  final String coaName;
  final String displayName;
  CoaParentOption({required this.idCoa, required this.coaNumber, required this.coaName, required this.displayName});
  factory CoaParentOption.fromJson(Map<String, dynamic> json) => CoaParentOption(
    idCoa: json['id_coa'] is int ? json['id_coa'] : int.tryParse(json['id_coa']?.toString() ?? '0') ?? 0,
    coaNumber: json['coa_number']?.toString() ?? '',
    coaName: json['coa_name']?.toString() ?? '',
    displayName: json['display_name']?.toString() ?? '',
  );
  @override bool operator ==(Object o) => o is CoaParentOption && o.idCoa == idCoa;
  @override int get hashCode => idCoa.hashCode;
}

class CoaFormOptions {
  final List<CoaParentOption> parentCoaList;
  final List<String> types;
  final List<String> reportTypes;
  final List<String> isHeaderOpts;
  final List<String> taxAdjustments;

  CoaFormOptions({required this.parentCoaList, required this.types, required this.reportTypes, required this.isHeaderOpts, required this.taxAdjustments});

  factory CoaFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CoaFormOptions(
      parentCoaList: (data['parent_coa_list'] as List? ?? []).map((e) => CoaParentOption.fromJson(e)).toList(),
      types: List<String>.from(data['types'] ?? ['DEBIT', 'CREDIT']),
      reportTypes: List<String>.from(data['report_types'] ?? ['NERACA', 'LABA RUGI']),
      isHeaderOpts: List<String>.from(data['is_header_opts'] ?? ['Y', 'N']),
      taxAdjustments: List<String>.from(data['tax_adjustments'] ?? ['N', 'PA', 'NA']),
    );
  }
}

class CoaFormModel {
  String? encryption;
  String coaNumber;
  String coaName;
  String? type;
  String? reportType;
  int? parentId;
  String isHeader;
  String? taxAdjustment;
  String? description;

  CoaFormModel({
    this.encryption,
    this.coaNumber = '',
    this.coaName = '',
    this.type = 'DEBIT',
    this.reportType = 'NERACA',
    this.parentId,
    this.isHeader = 'N',
    this.taxAdjustment = 'N',
    this.description,
  });

  factory CoaFormModel.fromDetail(CoaDetailModel detail) {
    final d = detail.coa;
    return CoaFormModel(
      encryption: d.encryption,
      coaNumber: d.coaNumber,
      coaName: d.coaName,
      type: d.type,
      reportType: d.reportType,
      parentId: d.parentId,
      isHeader: d.isHeader,
      taxAdjustment: d.taxAdjustment,
      description: d.description,
    );
  }

  bool isValid() => coaNumber.trim().isNotEmpty && coaName.trim().isNotEmpty && type != null && reportType != null;

  Map<String, dynamic> toJson() => {
    'coa_number': coaNumber,
    'coa_name': coaName,
    'type': type,
    'report_type': reportType,
    if (parentId != null) 'parent_id': parentId,
    'is_header': isHeader,
    'tax_adjustment': taxAdjustment ?? 'N',
    if (description != null && description!.isNotEmpty) 'description': description,
  };
}