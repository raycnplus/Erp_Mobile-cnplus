int _pi(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

double _pd(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

String _ps(dynamic v) => v?.toString() ?? '';

class PeriodClosingModel {
  final int idClosingEntries;
  final String encryption;
  final String type;
  final int? month;
  final int year;
  final String status;
  final String? createdDate;
  final String? updatedDate;
  final String? postingDate;
  final String? createdByName;
  final String? updatedByName;
  final String? postingByName;
  final String? periodLabel;

  PeriodClosingModel({
    required this.idClosingEntries,
    required this.encryption,
    required this.type,
    this.month,
    required this.year,
    required this.status,
    this.createdDate,
    this.updatedDate,
    this.postingDate,
    this.createdByName,
    this.updatedByName,
    this.postingByName,
    this.periodLabel,
  });

  factory PeriodClosingModel.fromJson(Map<String, dynamic> j) => PeriodClosingModel(
        idClosingEntries: _pi(j['id_closing_entries']),
        encryption:       _ps(j['encryption']),
        type:             _ps(j['type']),
        month:            j['month'] == null ? null : _pi(j['month']),
        year:             _pi(j['year']),
        status:           _ps(j['status']),
        createdDate:      j['created_date']?.toString(),
        updatedDate:      j['updated_date']?.toString(),
        postingDate:      j['posting_date']?.toString(),
        createdByName:    j['created_by_name']?.toString(),
        postingByName:    j['posting_by_name']?.toString(),
        periodLabel:      j['period_label']?.toString(),
      );

  bool get isMonthly => type == 'MONTHLY';
  bool get isYearly  => type == 'YEARLY';
  bool get isDraft   => status == 'DRAFT';
  bool get isPosted  => status == 'POSTING';

  bool get canEdit   => isDraft;
  bool get canPost   => isDraft;
  bool get canDelete => isDraft;

  static const _statusColors = <String, int>{
    'DRAFT':   0xFF757575,
    'POSTING': 0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class PeriodClosingPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  PeriodClosingPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class PeriodClosingAuditTrail {
  final int idAuditTrail;
  final String? type;
  final String? description;
  final String? actionByName;
  final String? actionById;
  final String? image;
  final String? date;

  PeriodClosingAuditTrail({
    required this.idAuditTrail,
    this.type,
    this.description,
    this.actionByName,
    this.actionById,
    this.image,
    this.date,
  });

  factory PeriodClosingAuditTrail.fromJson(Map<String, dynamic> j) => PeriodClosingAuditTrail(
        idAuditTrail: _pi(j['id_closing_entries_audit_trail']),
        type:         j['type']?.toString(),
        description:  j['description']?.toString(),
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        image:        j['image']?.toString(),
        date:         j['date']?.toString(),
      );
}

class PeriodClosingDetailModel {
  final int idClosingEntries;
  final String encryption;
  final String type;
  final int? month;
  final int year;
  final String status;
  final String? createdDate;
  final String? updatedDate;
  final String? postingDate;
  final String? createdByName;
  final String? updatedByName;
  final String? postingByName;
  final String? periodLabel;
  final List<PeriodClosingAuditTrail> auditTrails;

  PeriodClosingDetailModel({
    required this.idClosingEntries,
    required this.encryption,
    required this.type,
    this.month,
    required this.year,
    required this.status,
    this.createdDate,
    this.updatedDate,
    this.postingDate,
    this.createdByName,
    this.updatedByName,
    this.postingByName,
    this.periodLabel,
    required this.auditTrails,
  });

  factory PeriodClosingDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PeriodClosingDetailModel(
      idClosingEntries: _pi(data['id_closing_entries']),
      encryption:       _ps(data['encryption']),
      type:             _ps(data['type']),
      month:            data['month'] == null ? null : _pi(data['month']),
      year:             _pi(data['year']),
      status:           _ps(data['status']),
      createdDate:      data['created_date']?.toString(),
      updatedDate:      data['updated_date']?.toString(),
      postingDate:      data['posting_date']?.toString(),
      createdByName:    data['created_by_name']?.toString(),
      updatedByName:    data['updated_by_name']?.toString(),
      postingByName:    data['posting_by_name']?.toString(),
      periodLabel:      data['period_label']?.toString(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => PeriodClosingAuditTrail.fromJson(e))
          .toList(),
    );
  }

  bool get isMonthly => type == 'MONTHLY';
  bool get isDraft   => status == 'DRAFT';
  bool get isPosted  => status == 'POSTING';
  bool get canEdit   => isDraft;
  bool get canPost   => isDraft;
  bool get canDelete => isDraft;
}

class PeriodClosingFormModel {
  int? idClosingEntries;
  String? encryption;
  String type;
  int? month;
  int? year;

  PeriodClosingFormModel({
    this.idClosingEntries,
    this.encryption,
    this.type = 'MONTHLY',
    this.month,
    this.year,
  });

  bool get isEditMode => encryption != null && encryption!.isNotEmpty;
  bool get isMonthly  => type == 'MONTHLY';

  factory PeriodClosingFormModel.fromDetail(PeriodClosingDetailModel d) => PeriodClosingFormModel(
        idClosingEntries: d.idClosingEntries,
        encryption:       d.encryption,
        type:             d.type,
        month:            d.month,
        year:             d.year,
      );

  Map<String, dynamic> toJson() => {
        'type':  type,
        'month': isMonthly ? month : null,
        'year':  year,
      };
}

class PeriodClosingBalanceRow {
  final String? transactionDate;
  final String sourceType;
  final String reference;
  final String description;
  final double debit;
  final double credit;
  final bool notPosted;
  final bool notBalanced;

  PeriodClosingBalanceRow({
    this.transactionDate,
    required this.sourceType,
    required this.reference,
    required this.description,
    required this.debit,
    required this.credit,
    required this.notPosted,
    required this.notBalanced,
  });

  factory PeriodClosingBalanceRow.fromJson(Map<String, dynamic> j) => PeriodClosingBalanceRow(
        transactionDate: j['transaction_date']?.toString(),
        sourceType:      _ps(j['source_type']),
        reference:       _ps(j['reference']),
        description:     _ps(j['description']),
        debit:           _pd(j['debit']),
        credit:          _pd(j['credit']),
        notPosted:       j['not_posted'] == true,
        notBalanced:     j['not_balanced'] == true,
      );

  double get diff => debit - credit;
}