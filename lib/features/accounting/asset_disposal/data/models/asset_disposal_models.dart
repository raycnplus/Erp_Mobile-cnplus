double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

double? _pdn(dynamic v) {
  if (v == null || v.toString().isEmpty) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
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

String disposalMethodLabel(String? m) {
  switch (m) {
    case 'sold':
      return 'Sold';
    case 'scrap':
      return 'Scrap';
    case 'lost':
      return 'Lost';
    default:
      return (m == null || m.isEmpty) ? '-' : m;
  }
}

class AssetDisposalModel {
  final int idAssetDisposal;
  final String encryption;
  final String status;
  final String? reference;
  final String? disposalDate;
  final String? assetCode;
  final String? assetName;
  final String? disposalMethod;

  AssetDisposalModel({
    required this.idAssetDisposal,
    required this.encryption,
    required this.status,
    this.reference,
    this.disposalDate,
    this.assetCode,
    this.assetName,
    this.disposalMethod,
  });

  factory AssetDisposalModel.fromJson(Map<String, dynamic> j) => AssetDisposalModel(
        idAssetDisposal: _pi(j['id_asset_disposal']),
        encryption:      _ps(j['encryption']),
        status:          _ps(j['status']),
        reference:       j['reference']?.toString(),
        disposalDate:    j['disposal_date']?.toString(),
        assetCode:       j['asset_code']?.toString(),
        assetName:       j['asset_name']?.toString(),
        disposalMethod:  j['disposal_method']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':     0xFF757575,
    'Confirmed': 0xFF1565C0,
    'Posted':    0xFF2E7D32,
    'Cancelled': 0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
  String get methodLabel => disposalMethodLabel(disposalMethod);
}

class AssetDisposalPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  AssetDisposalPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class DisposalAccountingEntry {
  final String coaNumber;
  final String coaName;
  final String type;
  final double amount;
  final String? reference;
  final String? description;
  final String? journalDate;

  DisposalAccountingEntry({
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.amount,
    this.reference,
    this.description,
    this.journalDate,
  });

  factory DisposalAccountingEntry.fromJson(Map<String, dynamic> j) => DisposalAccountingEntry(
        coaNumber:   _ps(j['coa_number']),
        coaName:     _ps(j['coa_name']),
        type:        _ps(j['type']),
        amount:      _pd(j['amount']),
        reference:   j['reference']?.toString(),
        description: j['entry_description']?.toString(),
        journalDate: j['journal_date']?.toString(),
      );
}

class DisposalAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  DisposalAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory DisposalAuditTrail.fromJson(Map<String, dynamic> j) => DisposalAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class AssetDisposalDetailModel {
  final int idAssetDisposal;
  final String encryption;
  final String status;
  final String? reference;
  final int? idFixedAsset;
  final String? assetCode;
  final String? assetName;
  final double currentBookValue;
  final String? disposalDate;
  final String? disposalMethod;
  final double disposalValue;
  final int? idBankAccount;
  final String? bankName;
  final String? reason;
  final double? bookValueAtDisposal;
  final double? accumulatedDepreciationAtDisposal;
  final double? gainLoss;
  final String? cancelReason;
  final String? cancelledDate;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final List<DisposalAccountingEntry> accountingEntries;
  final List<DisposalAuditTrail> auditTrails;

  AssetDisposalDetailModel({
    required this.idAssetDisposal,
    required this.encryption,
    required this.status,
    this.reference,
    this.idFixedAsset,
    this.assetCode,
    this.assetName,
    this.currentBookValue = 0,
    this.disposalDate,
    this.disposalMethod,
    this.disposalValue = 0,
    this.idBankAccount,
    this.bankName,
    this.reason,
    this.bookValueAtDisposal,
    this.accumulatedDepreciationAtDisposal,
    this.gainLoss,
    this.cancelReason,
    this.cancelledDate,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    required this.accountingEntries,
    required this.auditTrails,
  });

  factory AssetDisposalDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AssetDisposalDetailModel(
      idAssetDisposal:  _pi(data['id_asset_disposal']),
      encryption:       _ps(data['encryption']),
      status:           _ps(data['status']),
      reference:        data['reference']?.toString(),
      idFixedAsset:     _pin(data['id_fixed_asset']),
      assetCode:        data['asset_code']?.toString(),
      assetName:        data['asset_name']?.toString(),
      currentBookValue: _pd(data['current_book_value']),
      disposalDate:     data['disposal_date']?.toString(),
      disposalMethod:   data['disposal_method']?.toString(),
      disposalValue:    _pd(data['disposal_value']),
      idBankAccount:    _pin(data['id_bank_account']),
      bankName:         data['bank_name']?.toString(),
      reason:           data['reason']?.toString(),
      bookValueAtDisposal:              _pdn(data['book_value_at_disposal']),
      accumulatedDepreciationAtDisposal: _pdn(data['accumulated_depreciation_at_disposal']),
      gainLoss:         _pdn(data['gain_loss']),
      cancelReason:     data['cancel_reason']?.toString(),
      cancelledDate:    data['cancelled_date']?.toString(),
      createdByName:    data['created_by_name']?.toString(),
      updatedByName:    data['updated_by_name']?.toString(),
      cancelledByName:  data['cancelled_by_name']?.toString(),
      createdDate:      data['created_date']?.toString(),
      updatedDate:      data['updated_date']?.toString(),
      accountingEntries: (data['accounting_entries'] as List? ?? []).map((e) => DisposalAccountingEntry.fromJson(e)).toList(),
      auditTrails:       (data['audit_trails']       as List? ?? []).map((e) => DisposalAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft     => status == 'Draft';
  bool get isConfirmed => status == 'Confirmed';
  bool get isPosted    => status == 'Posted';
  bool get isCancelled => status == 'Cancelled';
  bool get isSold      => disposalMethod == 'sold';
  bool get canEdit     => isDraft;
  bool get canConfirm  => isDraft;
  bool get canPost     => isConfirmed;
  bool get canCancel   => isConfirmed;
  bool get canDelete   => isDraft;
  bool get hasJournal  => accountingEntries.isNotEmpty;

  String get methodLabel => disposalMethodLabel(disposalMethod);

  double get effectiveBookValue => bookValueAtDisposal ?? currentBookValue;

  double get gainLossValue => gainLoss ?? ((isSold ? disposalValue : 0) - effectiveBookValue);

  bool get isGainLossFinal => gainLoss != null;
}

class DspAssetOption {
  final int idFixedAsset;
  final String assetCode;
  final String assetName;
  final double acquisitionCost;
  final double accumulatedDepreciation;
  final double bookValue;

  DspAssetOption({
    required this.idFixedAsset,
    required this.assetCode,
    required this.assetName,
    this.acquisitionCost = 0,
    this.accumulatedDepreciation = 0,
    this.bookValue = 0,
  });

  factory DspAssetOption.fromJson(Map<String, dynamic> j) => DspAssetOption(
        idFixedAsset:            _pi(j['id_fixed_asset']),
        assetCode:               _ps(j['asset_code']),
        assetName:               _ps(j['asset_name']),
        acquisitionCost:         _pd(j['acquisition_cost']),
        accumulatedDepreciation: _pd(j['accumulated_depreciation']),
        bookValue:               _pd(j['book_value']),
      );

  String get display => assetCode.isNotEmpty ? '$assetCode - $assetName' : assetName;

  @override
  bool operator ==(Object o) => o is DspAssetOption && o.idFixedAsset == idFixedAsset;

  @override
  int get hashCode => idFixedAsset.hashCode;
}

class DspBankOption {
  final int id;
  final String bankName;
  final String? accountName;
  final String? accountNumber;

  DspBankOption({required this.id, required this.bankName, this.accountName, this.accountNumber});

  factory DspBankOption.fromJson(Map<String, dynamic> j) => DspBankOption(
        id:            _pi(j['id_bank_account']),
        bankName:      _ps(j['bank_name']),
        accountName:   j['bank_account_name']?.toString(),
        accountNumber: j['bank_account_number']?.toString(),
      );

  String get display {
    final parts = <String>[bankName];
    if (accountNumber?.isNotEmpty == true) parts.add(accountNumber!);
    if (accountName?.isNotEmpty == true) parts.add(accountName!);
    return parts.join(' - ');
  }

  @override
  bool operator ==(Object o) => o is DspBankOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class AssetDisposalFormOptions {
  final List<DspAssetOption> assets;
  final List<DspBankOption> bankAccounts;
  final List<String> disposalMethods;

  AssetDisposalFormOptions({
    required this.assets,
    required this.bankAccounts,
    required this.disposalMethods,
  });

  factory AssetDisposalFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AssetDisposalFormOptions(
      assets:          (data['assets']        as List? ?? []).map((e) => DspAssetOption.fromJson(e)).toList(),
      bankAccounts:    (data['bank_accounts'] as List? ?? []).map((e) => DspBankOption.fromJson(e)).toList(),
      disposalMethods: (data['disposal_methods'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class AssetDisposalFormModel {
  int? idAssetDisposal;
  String? encryption;
  int? idFixedAsset;
  DateTime? disposalDate;
  String? disposalMethod;
  double disposalValue;
  int? idBankAccount;
  String? reason;

  AssetDisposalFormModel({
    this.idAssetDisposal,
    this.encryption,
    this.idFixedAsset,
    this.disposalDate,
    this.disposalMethod,
    this.disposalValue = 0,
    this.idBankAccount,
    this.reason,
  });

  bool get isEditMode => idAssetDisposal != null;
  bool get isSold     => disposalMethod == 'sold';

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String status) => {
        if (idAssetDisposal != null) 'id_asset_disposal': idAssetDisposal,
        'id_fixed_asset':  idFixedAsset,
        'disposal_date':   disposalDate != null ? _fmtDate(disposalDate!) : null,
        'disposal_method': disposalMethod,
        'disposal_value':  isSold ? disposalValue : 0,
        'id_bank_account': isSold ? idBankAccount : null,
        'reason':          reason,
        'status':          status,
      };

  factory AssetDisposalFormModel.fromDetail(AssetDisposalDetailModel d) => AssetDisposalFormModel(
        idAssetDisposal: d.idAssetDisposal,
        encryption:      d.encryption,
        idFixedAsset:    d.idFixedAsset,
        disposalDate:    d.disposalDate != null ? DateTime.tryParse(d.disposalDate!) : null,
        disposalMethod:  d.disposalMethod,
        disposalValue:   d.disposalValue,
        idBankAccount:   d.idBankAccount,
        reason:          d.reason,
      );
}