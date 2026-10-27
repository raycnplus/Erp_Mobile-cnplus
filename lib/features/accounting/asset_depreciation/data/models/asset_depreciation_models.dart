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

class AssetDepreciationModel {
  final int idAssetDepreciation;
  final String encryption;
  final String? reference;
  final String? periodDate;
  final int totalAssetsProcessed;
  final double totalDepreciationAmount;

  AssetDepreciationModel({
    required this.idAssetDepreciation,
    required this.encryption,
    this.reference,
    this.periodDate,
    this.totalAssetsProcessed = 0,
    this.totalDepreciationAmount = 0,
  });

  factory AssetDepreciationModel.fromJson(Map<String, dynamic> j) => AssetDepreciationModel(
        idAssetDepreciation:     _pi(j['id_asset_depreciation']),
        encryption:              _ps(j['encryption']),
        reference:               j['reference']?.toString(),
        periodDate:              j['period_date']?.toString(),
        totalAssetsProcessed:    _pi(j['total_assets_processed']),
        totalDepreciationAmount: _pd(j['total_depreciation_amount']),
      );
}

class AssetDepreciationPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  AssetDepreciationPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class AssetDepreciationFormOptions {
  final int activeAssetCount;

  AssetDepreciationFormOptions({required this.activeAssetCount});

  factory AssetDepreciationFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AssetDepreciationFormOptions(activeAssetCount: _pi(data['active_asset_count']));
  }
}

class DepreciationDetailItem {
  final String assetCode;
  final String assetName;
  final double depreciationAmount;
  final double accumulatedDepreciation;
  final double bookValue;

  DepreciationDetailItem({
    required this.assetCode,
    required this.assetName,
    this.depreciationAmount = 0,
    this.accumulatedDepreciation = 0,
    this.bookValue = 0,
  });

  factory DepreciationDetailItem.fromJson(Map<String, dynamic> j) => DepreciationDetailItem(
        assetCode:               _ps(j['asset_code']),
        assetName:               _ps(j['asset_name']),
        depreciationAmount:      _pd(j['depreciation_amount']),
        accumulatedDepreciation: _pd(j['accumulated_depreciation']),
        bookValue:               _pd(j['book_value']),
      );
}

class DepreciationAccountingEntry {
  final String coaNumber;
  final String coaName;
  final String type;
  final double amount;
  final String? reference;
  final String? description;
  final String? journalDate;

  DepreciationAccountingEntry({
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.amount,
    this.reference,
    this.description,
    this.journalDate,
  });

  factory DepreciationAccountingEntry.fromJson(Map<String, dynamic> j) => DepreciationAccountingEntry(
        coaNumber:   _ps(j['coa_number']),
        coaName:     _ps(j['coa_name']),
        type:        _ps(j['type']),
        amount:      _pd(j['amount']),
        reference:   j['reference']?.toString(),
        description: j['entry_description']?.toString(),
        journalDate: j['journal_date']?.toString(),
      );
}

class DepreciationAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  DepreciationAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory DepreciationAuditTrail.fromJson(Map<String, dynamic> j) => DepreciationAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class AssetDepreciationDetailModel {
  final int idAssetDepreciation;
  final String encryption;
  final String? reference;
  final String? periodDate;
  final int totalAssetsProcessed;
  final double totalDepreciationAmount;
  final String? createdDate;
  final String? createdByName;
  final List<DepreciationDetailItem> details;
  final List<DepreciationAccountingEntry> accountingEntries;
  final List<DepreciationAuditTrail> auditTrails;

  AssetDepreciationDetailModel({
    required this.idAssetDepreciation,
    required this.encryption,
    this.reference,
    this.periodDate,
    this.totalAssetsProcessed = 0,
    this.totalDepreciationAmount = 0,
    this.createdDate,
    this.createdByName,
    required this.details,
    required this.accountingEntries,
    required this.auditTrails,
  });

  factory AssetDepreciationDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AssetDepreciationDetailModel(
      idAssetDepreciation:     _pi(data['id_asset_depreciation']),
      encryption:              _ps(data['encryption']),
      reference:               data['reference']?.toString(),
      periodDate:              data['period_date']?.toString(),
      totalAssetsProcessed:    _pi(data['total_assets_processed']),
      totalDepreciationAmount: _pd(data['total_depreciation_amount']),
      createdDate:             data['created_date']?.toString(),
      createdByName:           data['created_by_name']?.toString(),
      details:           (data['details']            as List? ?? []).map((e) => DepreciationDetailItem.fromJson(e)).toList(),
      accountingEntries: (data['accounting_entries'] as List? ?? []).map((e) => DepreciationAccountingEntry.fromJson(e)).toList(),
      auditTrails:       (data['audit_trails']       as List? ?? []).map((e) => DepreciationAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get hasJournal => accountingEntries.isNotEmpty;
}

class AssetDepreciationFormModel {
  int month;
  int year;

  AssetDepreciationFormModel({int? month, int? year})
      : month = month ?? DateTime.now().month,
        year = year ?? DateTime.now().year;

  Map<String, dynamic> toJson() => {
        'period_date': '$year-${month.toString().padLeft(2, '0')}-01',
      };
}