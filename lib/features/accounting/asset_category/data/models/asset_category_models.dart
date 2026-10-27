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

String assetCategoryMethodLabel(String? m) {
  switch (m) {
    case 'straight_line':
      return 'Straight Line';
    case 'declining_balance':
      return 'Declining Balance';
    default:
      return (m == null || m.isEmpty) ? '-' : m;
  }
}

class AssetCategoryModel {
  final int idAssetCategory;
  final String encryption;
  final String categoryName;
  final String? categoryCode;
  final int defaultUsefulLifeMonths;
  final String? depreciationMethod;

  AssetCategoryModel({
    required this.idAssetCategory,
    required this.encryption,
    required this.categoryName,
    this.categoryCode,
    this.defaultUsefulLifeMonths = 0,
    this.depreciationMethod,
  });

  factory AssetCategoryModel.fromJson(Map<String, dynamic> j) => AssetCategoryModel(
        idAssetCategory:         _pi(j['id_asset_category']),
        encryption:              _ps(j['encryption']),
        categoryName:            _ps(j['category_name']),
        categoryCode:            j['category_code']?.toString(),
        defaultUsefulLifeMonths: _pi(j['default_useful_life_months']),
        depreciationMethod:      j['depreciation_method']?.toString(),
      );

  String get methodLabel => assetCategoryMethodLabel(depreciationMethod);
}

class AssetCategoryPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  AssetCategoryPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class AssetCoaOption {
  final int idCoa;
  final String? coaNumber;
  final String coaName;
  final String? type;

  AssetCoaOption({required this.idCoa, this.coaNumber, required this.coaName, this.type});

  factory AssetCoaOption.fromJson(Map<String, dynamic> j) => AssetCoaOption(
        idCoa:     _pi(j['id_coa']),
        coaNumber: j['coa_number']?.toString(),
        coaName:   _ps(j['coa_name']),
        type:      j['type']?.toString(),
      );

  String get display => coaNumber?.isNotEmpty == true ? '$coaNumber - $coaName' : coaName;

  @override
  bool operator ==(Object o) => o is AssetCoaOption && o.idCoa == idCoa;
  @override
  int get hashCode => idCoa.hashCode;
}

class AssetCategoryFormOptions {
  final List<AssetCoaOption> coaList;
  final List<String> depreciationMethods;

  AssetCategoryFormOptions({required this.coaList, required this.depreciationMethods});

  factory AssetCategoryFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AssetCategoryFormOptions(
      coaList: (data['coa_list'] as List? ?? []).map((e) => AssetCoaOption.fromJson(e)).toList(),
      depreciationMethods: (data['depreciation_methods'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class AssetCategoryDetailModel {
  final int idAssetCategory;
  final String encryption;
  final String categoryName;
  final String? categoryCode;
  final int defaultUsefulLifeMonths;
  final String? depreciationMethod;
  final int? coaAsset;
  final int? coaAccumulatedDepreciation;
  final int? coaDepreciationExpense;
  final int? coaDisposalGain;
  final int? coaDisposalLoss;
  final String? createdDate;
  final String? updatedDate;
  final String? createdByName;
  final String? updatedByName;

  AssetCategoryDetailModel({
    required this.idAssetCategory,
    required this.encryption,
    required this.categoryName,
    this.categoryCode,
    this.defaultUsefulLifeMonths = 0,
    this.depreciationMethod,
    this.coaAsset,
    this.coaAccumulatedDepreciation,
    this.coaDepreciationExpense,
    this.coaDisposalGain,
    this.coaDisposalLoss,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
  });

  factory AssetCategoryDetailModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] ?? json;
    return AssetCategoryDetailModel(
      idAssetCategory:            _pi(d['id_asset_category']),
      encryption:                 _ps(d['encryption']),
      categoryName:               _ps(d['category_name']),
      categoryCode:               d['category_code']?.toString(),
      defaultUsefulLifeMonths:    _pi(d['default_useful_life_months']),
      depreciationMethod:         d['depreciation_method']?.toString(),
      coaAsset:                   _pin(d['coa_asset']),
      coaAccumulatedDepreciation: _pin(d['coa_accumulated_depreciation']),
      coaDepreciationExpense:     _pin(d['coa_depreciation_expense']),
      coaDisposalGain:            _pin(d['coa_disposal_gain']),
      coaDisposalLoss:            _pin(d['coa_disposal_loss']),
      createdDate:                d['created_date']?.toString(),
      updatedDate:                d['updated_date']?.toString(),
      createdByName:              d['created_by_name']?.toString(),
      updatedByName:              d['updated_by_name']?.toString(),
    );
  }

  String get methodLabel => assetCategoryMethodLabel(depreciationMethod);

  bool get canEdit   => true;
  bool get canDelete => true;
}

class AssetCategoryFormModel {
  String? encryption;
  String? categoryName;
  String? categoryCode;
  int? defaultUsefulLifeMonths;
  String? depreciationMethod;
  int? coaAsset;
  int? coaAccumulatedDepreciation;
  int? coaDepreciationExpense;
  int? coaDisposalGain;
  int? coaDisposalLoss;

  AssetCategoryFormModel({
    this.encryption,
    this.categoryName,
    this.categoryCode,
    this.defaultUsefulLifeMonths,
    this.depreciationMethod,
    this.coaAsset,
    this.coaAccumulatedDepreciation,
    this.coaDepreciationExpense,
    this.coaDisposalGain,
    this.coaDisposalLoss,
  });

  bool get isEditMode => encryption != null;

  Map<String, dynamic> toJson() => {
        'category_name':                categoryName,
        'category_code':                categoryCode,
        'default_useful_life_months':   defaultUsefulLifeMonths,
        'depreciation_method':          depreciationMethod,
        'coa_asset':                    coaAsset,
        'coa_accumulated_depreciation': coaAccumulatedDepreciation,
        'coa_depreciation_expense':     coaDepreciationExpense,
        'coa_disposal_gain':            coaDisposalGain,
        'coa_disposal_loss':            coaDisposalLoss,
      };

  factory AssetCategoryFormModel.fromDetail(AssetCategoryDetailModel d) => AssetCategoryFormModel(
        encryption:                 d.encryption,
        categoryName:               d.categoryName,
        categoryCode:               d.categoryCode,
        defaultUsefulLifeMonths:    d.defaultUsefulLifeMonths > 0 ? d.defaultUsefulLifeMonths : null,
        depreciationMethod:         d.depreciationMethod,
        coaAsset:                   d.coaAsset,
        coaAccumulatedDepreciation: d.coaAccumulatedDepreciation,
        coaDepreciationExpense:     d.coaDepreciationExpense,
        coaDisposalGain:            d.coaDisposalGain,
        coaDisposalLoss:            d.coaDisposalLoss,
      );
}