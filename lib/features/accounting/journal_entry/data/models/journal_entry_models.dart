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

class JournalEntryModel {
  final int idJurnalManual;
  final String encryption;
  final String? reference;
  final String? journalDate;
  final String? description;
  final double totalDebit;
  final double totalCredit;
  final String status;
  final String? createdDate;

  JournalEntryModel({
    required this.idJurnalManual,
    required this.encryption,
    this.reference,
    this.journalDate,
    this.description,
    this.totalDebit = 0,
    this.totalCredit = 0,
    required this.status,
    this.createdDate,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> j) => JournalEntryModel(
        idJurnalManual: _pi(j['id_jurnal_manual']),
        encryption:     _ps(j['encryption']),
        reference:      j['reference']?.toString(),
        journalDate:    j['journal_date']?.toString(),
        description:    j['description']?.toString(),
        totalDebit:     _pd(j['total_debit']),
        totalCredit:    _pd(j['total_credit']),
        status:         _ps(j['status']),
        createdDate:    j['created_date']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':  0xFF757575,
    'Posted': 0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class JournalEntryPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  JournalEntryPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class JECoaOption {
  final int idCoa;
  final String? coaNumber;
  final String coaName;

  JECoaOption({required this.idCoa, this.coaNumber, required this.coaName});

  factory JECoaOption.fromJson(Map<String, dynamic> j) => JECoaOption(
        idCoa:     _pi(j['id_coa']),
        coaNumber: j['coa_number']?.toString(),
        coaName:   _ps(j['coa_name']),
      );

  String get display => coaNumber?.isNotEmpty == true ? '$coaNumber - $coaName' : coaName;

  @override bool operator ==(Object o) => o is JECoaOption && o.idCoa == idCoa;
  @override int get hashCode => idCoa.hashCode;
}

class JournalEntryFormOptions {
  final List<JECoaOption> coaList;
  final String? suggestedReference;

  JournalEntryFormOptions({required this.coaList, this.suggestedReference});

  factory JournalEntryFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return JournalEntryFormOptions(
      coaList: (data['coa_list'] as List? ?? []).map((e) => JECoaOption.fromJson(e)).toList(),
      suggestedReference: data['reference']?.toString(),
    );
  }
}

class JournalEntryDetailItem {
  final int? idJurnalManualDetail;
  final int idCoa;
  final String? coaNumber;
  final String? coaName;
  final String type;
  final double amount;

  JournalEntryDetailItem({
    this.idJurnalManualDetail,
    required this.idCoa,
    this.coaNumber,
    this.coaName,
    required this.type,
    required this.amount,
  });

  factory JournalEntryDetailItem.fromJson(Map<String, dynamic> j) {
    final coa = j['coa'] as Map<String, dynamic>?;
    return JournalEntryDetailItem(
      idJurnalManualDetail: j['id_jurnal_manual_detail'] == null ? null : _pi(j['id_jurnal_manual_detail']),
      idCoa:                _pi(j['id_coa']),
      coaNumber:            coa?['coa_number']?.toString(),
      coaName:              coa?['coa_name']?.toString(),
      type:                 _ps(j['type']),
      amount:               _pd(j['amount']),
    );
  }

  bool get isDebit => type == 'DEBIT';
}

class JournalEntryAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  JournalEntryAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory JournalEntryAuditTrail.fromJson(Map<String, dynamic> j) => JournalEntryAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class JournalEntryDetailModel {
  final int idJurnalManual;
  final String encryption;
  final String? reference;
  final String? journalDate;
  final String? description;
  final String? pph25BillingNumber;
  final String? pph25PaymentDate;
  final String? pph25SignerName;
  final double totalDebit;
  final double totalCredit;
  final String status;
  final String? unpostDate;
  final String? createdDate;
  final String? updatedDate;
  final String? createdByName;
  final String? updatedByName;
  final String? unpostByName;
  final List<JournalEntryDetailItem> details;
  final List<JournalEntryAuditTrail> auditTrails;

  JournalEntryDetailModel({
    required this.idJurnalManual,
    required this.encryption,
    this.reference,
    this.journalDate,
    this.description,
    this.pph25BillingNumber,
    this.pph25PaymentDate,
    this.pph25SignerName,
    this.totalDebit = 0,
    this.totalCredit = 0,
    required this.status,
    this.unpostDate,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
    this.unpostByName,
    required this.details,
    required this.auditTrails,
  });

  factory JournalEntryDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return JournalEntryDetailModel(
      idJurnalManual:      _pi(data['id_jurnal_manual']),
      encryption:          _ps(data['encryption']),
      reference:           data['reference']?.toString(),
      journalDate:         data['journal_date']?.toString(),
      description:         data['description']?.toString(),
      pph25BillingNumber:  data['pph25_billing_number']?.toString(),
      pph25PaymentDate:    data['pph25_payment_date']?.toString(),
      pph25SignerName:     data['pph25_signer_name']?.toString(),
      totalDebit:          _pd(data['total_debit']),
      totalCredit:         _pd(data['total_credit']),
      status:              _ps(data['status']),
      unpostDate:          data['unpost_date']?.toString(),
      createdDate:         data['created_date']?.toString(),
      updatedDate:         data['updated_date']?.toString(),
      createdByName:       data['created_by_name']?.toString(),
      updatedByName:       data['updated_by_name']?.toString(),
      unpostByName:        data['unpost_by_name']?.toString(),
      details:      (data['details'] as List? ?? []).map((e) => JournalEntryDetailItem.fromJson(e)).toList(),
      auditTrails:  (data['audit_trails'] as List? ?? []).map((e) => JournalEntryAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft  => status == 'Draft';
  bool get isPosted => status == 'Posted';
  bool get canEdit   => isDraft;
  bool get canDelete => isDraft;
  bool get canPost   => isDraft;
  bool get canUnpost => isPosted;

  bool get isBalanced => (totalDebit - totalCredit).abs() < 0.01;
}

class JournalEntryFormDetail {
  int? idCoa;
  String? coaNumber;
  String? coaName;
  double debit;
  double credit;

  JournalEntryFormDetail({
    this.idCoa,
    this.coaNumber,
    this.coaName,
    this.debit = 0,
    this.credit = 0,
  });

  Map<String, dynamic> toJson() => {
        'id_coa': idCoa,
        'debit':  debit > 0 ? debit : null,
        'credit': credit > 0 ? credit : null,
      };

  factory JournalEntryFormDetail.fromItem(JournalEntryDetailItem i) => JournalEntryFormDetail(
        idCoa:     i.idCoa,
        coaNumber: i.coaNumber,
        coaName:   i.coaName,
        debit:     i.isDebit ? i.amount : 0,
        credit:    !i.isDebit ? i.amount : 0,
      );
}

class JournalEntryFormModel {
  int? idJurnalManual;
  String? encryption;
  DateTime? journalDate;
  String? description;
  String? pph25BillingNumber;
  DateTime? pph25PaymentDate;
  String? pph25SignerName;
  List<JournalEntryFormDetail> details;

  JournalEntryFormModel({
    this.idJurnalManual,
    this.encryption,
    this.journalDate,
    this.description,
    this.pph25BillingNumber,
    this.pph25PaymentDate,
    this.pph25SignerName,
    List<JournalEntryFormDetail>? details,
  }) : details = details ?? [];

  bool get isEditMode => encryption != null;

  double get totalDebit  => details.fold(0.0, (s, d) => s + d.debit);
  double get totalCredit => details.fold(0.0, (s, d) => s + d.credit);
  bool get isBalanced => (totalDebit - totalCredit).abs() < 0.01;

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson(String action) => {
        'journal_date':          journalDate != null ? _fmtDate(journalDate!) : null,
        'description':           description,
        'pph25_billing_number':  pph25BillingNumber,
        'pph25_payment_date':    pph25PaymentDate != null ? _fmtDate(pph25PaymentDate!) : null,
        'pph25_signer_name':     pph25SignerName,
        'details':               details.map((d) => d.toJson()).toList(),
        'action':                action,
      };

  factory JournalEntryFormModel.fromDetail(JournalEntryDetailModel d) => JournalEntryFormModel(
        idJurnalManual:      d.idJurnalManual,
        encryption:          d.encryption,
        journalDate:         d.journalDate != null ? DateTime.tryParse(d.journalDate!) : null,
        description:         d.description,
        pph25BillingNumber:  d.pph25BillingNumber,
        pph25PaymentDate:    d.pph25PaymentDate != null ? DateTime.tryParse(d.pph25PaymentDate!) : null,
        pph25SignerName:     d.pph25SignerName,
        details: d.details.map((i) => JournalEntryFormDetail.fromItem(i)).toList(),
      );
}