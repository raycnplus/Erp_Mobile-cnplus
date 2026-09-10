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

class CashBankModel {
  final int idCashBank;
  final String encryption;
  final String? reference;
  final String? transactionDate;
  final String? createdDate;
  final String? description;
  final String noteType;
  final String status;
  final double total;

  CashBankModel({
    required this.idCashBank,
    required this.encryption,
    this.reference,
    this.transactionDate,
    this.createdDate,
    this.description,
    required this.noteType,
    required this.status,
    this.total = 0,
  });

  factory CashBankModel.fromJson(Map<String, dynamic> j) => CashBankModel(
        idCashBank:      _pi(j['id_cash_bank']),
        encryption:      _ps(j['encryption']),
        reference:       j['reference']?.toString(),
        transactionDate: j['transaction_date']?.toString(),
        createdDate:     j['created_date']?.toString(),
        description:     j['description']?.toString(),
        noteType:        _ps(j['note_type']),
        status:          _ps(j['status']),
        total:           _pd(j['total']),
      );

  static const _statusColors = <String, int>{
    'Draft':  0xFF757575,
    'Posted': 0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;

  static const _noteTypeLabels = <String, String>{
    'BANK_DEBIT':  'Bank Debit',
    'BANK_CREDIT': 'Bank Credit',
    'CASH_DEBIT':  'Cash Debit',
    'CASH_CREDIT': 'Cash Credit',
  };

  String get noteTypeLabel => _noteTypeLabels[noteType] ?? noteType;
  bool get isBank => noteType.startsWith('BANK_');
}

class CashBankPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  CashBankPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class CoaOption {
  final int idCoa;
  final String? coaNumber;
  final String coaName;

  CoaOption({required this.idCoa, this.coaNumber, required this.coaName});

  factory CoaOption.fromJson(Map<String, dynamic> j) => CoaOption(
        idCoa:     _pi(j['id_coa']),
        coaNumber: j['coa_number']?.toString(),
        coaName:   _ps(j['coa_name']),
      );

  String get display => coaNumber?.isNotEmpty == true ? '$coaNumber - $coaName' : coaName;

  @override bool operator ==(Object o) => o is CoaOption && o.idCoa == idCoa;
  @override int get hashCode => idCoa.hashCode;
}

class CBProjectOption {
  final int idProject;
  final String projectName;

  CBProjectOption({required this.idProject, required this.projectName});

  factory CBProjectOption.fromJson(Map<String, dynamic> j) => CBProjectOption(
        idProject:   _pi(j['id_project']),
        projectName: _ps(j['project_name']),
      );

  @override bool operator ==(Object o) => o is CBProjectOption && o.idProject == idProject;
  @override int get hashCode => idProject.hashCode;
}

class CashBankFormOptions {
  final List<CoaOption> coaList;
  final List<CBProjectOption> projects;
  final List<String> noteTypes;
  final String? suggestedReference;

  CashBankFormOptions({
    required this.coaList,
    required this.projects,
    this.noteTypes = const ['BANK_DEBIT', 'BANK_CREDIT', 'CASH_DEBIT', 'CASH_CREDIT'],
    this.suggestedReference,
  });

  factory CashBankFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CashBankFormOptions(
      coaList:  (data['coa_list'] as List? ?? []).map((e) => CoaOption.fromJson(e)).toList(),
      projects: (data['projects'] as List? ?? []).map((e) => CBProjectOption.fromJson(e)).toList(),
      noteTypes: (data['note_types'] as List?)?.map((e) => e.toString()).toList() ??
          ['BANK_DEBIT', 'BANK_CREDIT', 'CASH_DEBIT', 'CASH_CREDIT'],
      suggestedReference: data['reference']?.toString(),
    );
  }
}

class CashBankDetailItem {
  final int? idCashBankDetail;
  final int idCoa;
  final String? coaNumber;
  final String? coaName;
  final String type;
  final double amount;
  final String? description;

  CashBankDetailItem({
    this.idCashBankDetail,
    required this.idCoa,
    this.coaNumber,
    this.coaName,
    required this.type,
    required this.amount,
    this.description,
  });

  factory CashBankDetailItem.fromJson(Map<String, dynamic> j) {
    final coa = j['coa'] as Map<String, dynamic>?;
    return CashBankDetailItem(
      idCashBankDetail: j['id_cash_bank_detail'] == null ? null : _pi(j['id_cash_bank_detail']),
      idCoa:            _pi(j['id_coa']),
      coaNumber:        coa?['coa_number']?.toString(),
      coaName:          coa?['coa_name']?.toString(),
      type:             _ps(j['type']),
      amount:           _pd(j['amount']),
      description:      j['description']?.toString(),
    );
  }

  bool get isDebit => type == 'DEBIT';
}

class CashBankAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  CashBankAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory CashBankAuditTrail.fromJson(Map<String, dynamic> j) => CashBankAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class CashBankDetailModel {
  final int idCashBank;
  final String encryption;
  final String? reference;
  final String? cashbankCoaNumber;
  final String? cashbankCoaName;
  final String? transactionDate;
  final String? description;
  final String? notes;
  final String noteType;
  final int? cashbankCoaId;
  final int? projectId;
  final String status;
  final double totalDebit;
  final double totalCredit;
  final String? unpostDate;
  final String? createdDate;
  final String? updatedDate;
  final String? createdByName;
  final String? updatedByName;
  final String? unpostByName;
  final List<CashBankDetailItem> details;
  final List<CashBankAuditTrail> auditTrails;

  CashBankDetailModel({
    required this.idCashBank,
    required this.encryption,
    this.reference,
    this.transactionDate,
    this.description,
    this.notes,
    required this.noteType,
    this.cashbankCoaId,
    this.projectId,
    required this.status,
    this.totalDebit = 0,
    this.totalCredit = 0,
    this.unpostDate,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
    this.unpostByName,
    this.cashbankCoaNumber,
    this.cashbankCoaName,
    required this.details,
    required this.auditTrails,
  });

  factory CashBankDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CashBankDetailModel(
      idCashBank:      _pi(data['id_cash_bank']),
      encryption:      _ps(data['encryption']),
      reference:       data['reference']?.toString(),
      transactionDate: data['transaction_date']?.toString(),
      description:     data['description']?.toString(),
      notes:           data['notes']?.toString(),
      noteType:        _ps(data['note_type']),
      cashbankCoaId:   data['cashbank_coa_id'] == null ? null : _pi(data['cashbank_coa_id']),
      projectId:       data['project_id'] == null ? null : _pi(data['project_id']),
      status:          _ps(data['status']),
      totalDebit:      _pd(data['total_debit']),
      totalCredit:     _pd(data['total_credit']),
      unpostDate:      data['unpost_date']?.toString(),
      createdDate:     data['created_date']?.toString(),
      updatedDate:     data['updated_date']?.toString(),
      createdByName:   data['created_by_name']?.toString(),
      updatedByName:   data['updated_by_name']?.toString(),
      unpostByName:   data['unpost_by_name']?.toString(),
      cashbankCoaNumber: data['cashbank_coa_number']?.toString(),
      cashbankCoaName:   data['cashbank_coa_name']?.toString(),
      details:      (data['details'] as List? ?? []).map((e) => CashBankDetailItem.fromJson(e)).toList(),
      auditTrails:  (data['audit_trails'] as List? ?? []).map((e) => CashBankAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft  => status == 'Draft';
  bool get isPosted => status == 'Posted';
  bool get canEdit   => isDraft;
  bool get canDelete => isDraft;
  bool get canPost   => isDraft;
  bool get canUnpost => isPosted;

  double get detailDebitSum  => details.where((d) => d.isDebit).fold(0.0, (s, d) => s + d.amount);
  double get detailCreditSum => details.where((d) => !d.isDebit).fold(0.0, (s, d) => s + d.amount);

  double get headerDebit {
    if (noteType.endsWith('_DEBIT')) return (detailCreditSum - detailDebitSum).clamp(0, double.infinity);
    return 0;
  }

  double get headerCredit {
    if (noteType.endsWith('_CREDIT')) return (detailDebitSum - detailCreditSum).clamp(0, double.infinity);
    return 0;
  }
}

class CashBankFormDetail {
  int? idCoa;
  String? coaNumber;
  String? coaName;
  String type;
  double amount;
  String? description;

  CashBankFormDetail({
    this.idCoa,
    this.coaNumber,
    this.coaName,
    this.type = 'DEBIT',
    this.amount = 0,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'id_coa':      idCoa,
        'type':        type,
        'amount':      amount,
        'description': description,
      };

  factory CashBankFormDetail.fromItem(CashBankDetailItem i) => CashBankFormDetail(
        idCoa:       i.idCoa,
        coaNumber:   i.coaNumber,
        coaName:     i.coaName,
        type:        i.type,
        amount:      i.amount,
        description: i.description,
      );
}

class CashBankFormModel {
  int? idCashBank;
  String? encryption;
  DateTime? transactionDate;
  String noteType;
  int? cashbankCoaId;
  int? projectId;
  String? description;
  String? notes;
  List<CashBankFormDetail> details;

  CashBankFormModel({
    this.idCashBank,
    this.encryption,
    this.transactionDate,
    this.noteType = 'CASH_DEBIT',
    this.cashbankCoaId,
    this.projectId,
    this.description,
    this.notes,
    List<CashBankFormDetail>? details,
  }) : details = details ?? [];

  bool get isEditMode => encryption != null;

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String action) => {
        'transaction_date': transactionDate != null ? _fmtDate(transactionDate!) : null,
        'note_type':        noteType,
        'cashbank_coa_id':  cashbankCoaId,
        'project_id':       projectId,
        'description':      description,
        'notes':            notes,
        'details':          details.map((d) => d.toJson()).toList(),
        'action':           action,
      };

  factory CashBankFormModel.fromDetail(CashBankDetailModel d) => CashBankFormModel(
        idCashBank:      d.idCashBank,
        encryption:      d.encryption,
        transactionDate: d.transactionDate != null ? DateTime.tryParse(d.transactionDate!) : null,
        noteType:        d.noteType,
        cashbankCoaId:   d.cashbankCoaId,
        projectId:       d.projectId,
        description:     d.description,
        notes:           d.notes,
        details: d.details.map((i) => CashBankFormDetail.fromItem(i)).toList(),
      );
}

class BulkPostFailure {
  final String reference;
  final String error;
  BulkPostFailure({required this.reference, required this.error});
  factory BulkPostFailure.fromJson(Map<String, dynamic> j) =>
      BulkPostFailure(reference: _ps(j['reference']), error: _ps(j['error']));
}

class BulkPostResult {
  final bool success;
  final String status;
  final int successful;
  final int failed;
  final int total;
  final List<String> successfulItems;
  final List<BulkPostFailure> failedItems;

  BulkPostResult({
    required this.success,
    required this.status,
    required this.successful,
    required this.failed,
    required this.total,
    required this.successfulItems,
    required this.failedItems,
  });

  factory BulkPostResult.fromJson(Map<String, dynamic> j) {
    final summary = j['summary'] as Map<String, dynamic>? ?? {};
    return BulkPostResult(
      success:    j['success'] == true,
      status:     _ps(j['status']),
      successful: _pi(j['successful']),
      failed:     _pi(j['failed']),
      total:      _pi(j['total']),
      successfulItems: (summary['successful_items'] as List? ?? []).map((e) => e.toString()).toList(),
      failedItems: (summary['failed_items'] as List? ?? []).map((e) => BulkPostFailure.fromJson(e)).toList(),
    );
  }
}