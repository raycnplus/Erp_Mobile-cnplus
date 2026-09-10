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

class BpeModel {
  final int idBpe;
  final String encryption;
  final String bpeNumber;
  final String? bpeDate;
  final int periodMonth;
  final int periodYear;
  final String? periodLabel;
  final String status;
  final int transactionCount;
  final String? createdDate;
  final String? updatedDate;

  BpeModel({
    required this.idBpe,
    required this.encryption,
    required this.bpeNumber,
    this.bpeDate,
    required this.periodMonth,
    required this.periodYear,
    this.periodLabel,
    required this.status,
    this.transactionCount = 0,
    this.createdDate,
    this.updatedDate,
  });

  factory BpeModel.fromJson(Map<String, dynamic> j) => BpeModel(
    idBpe:            _pi(j['id_bpe']),
    encryption:       _ps(j['encryption']),
    bpeNumber:        _ps(j['bpe_number']),
    bpeDate:          j['bpe_date']?.toString(),
    periodMonth:      _pi(j['period_month']),
    periodYear:       _pi(j['period_year']),
    periodLabel:      j['period_label']?.toString(),
    status:           _ps(j['status']),
    transactionCount: _pi(j['transaction_count']),
    createdDate:      j['created_date']?.toString(),
    updatedDate:      j['updated_date']?.toString(),
  );

  bool get isDraft     => status == 'Draft';
  bool get isConfirmed => status == 'Confirmed';
  bool get isValidated => status == 'Validated';

  bool get canEdit    => isDraft || isConfirmed;
  bool get canConfirm => isDraft;
  bool get canValidate => isConfirmed;
  bool get canDelete  => isDraft;

  static const _statusColors = <String, int>{
    'Draft':     0xFF757575,
    'Confirmed': 0xFF1565C0,
    'Validated': 0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class BpeTransactionModel {
  final int? idBpeTransaction;
  final String transactionType;
  final int idInvoice;
  final String? invoiceNumber;
  final String? invoiceDate;
  final int? idCustomer;
  final String? customerName;
  final double grandTotal;

  BpeTransactionModel({
    this.idBpeTransaction,
    required this.transactionType,
    required this.idInvoice,
    this.invoiceNumber,
    this.invoiceDate,
    this.idCustomer,
    this.customerName,
    this.grandTotal = 0,
  });

  factory BpeTransactionModel.fromJson(Map<String, dynamic> j) => BpeTransactionModel(
    idBpeTransaction: j['id_bpe_transaction'] == null ? null : _pi(j['id_bpe_transaction']),
    transactionType:  _ps(j['transaction_type']),
    idInvoice:        _pi(j['id_invoice']),
    invoiceNumber:    j['invoice_number']?.toString(),
    invoiceDate:      j['invoice_date']?.toString(),
    idCustomer:       j['id_customer'] == null ? null : _pi(j['id_customer']),
    customerName:     j['customer_name']?.toString(),
    grandTotal:       _pd(j['grand_total']),
  );

  bool get isServiceInvoice => transactionType == 'Service_Invoice';

  Map<String, dynamic> toJson() => {
    'transaction_type': transactionType,
    'id_invoice':        idInvoice,
  };
}

class BpeAuditTrail {
  final String? type;
  final String? description;
  final String? actionByName;
  final String? actionById;
  final String? image;
  final String? date;

  BpeAuditTrail({
    this.type,
    this.description,
    this.actionByName,
    this.actionById,
    this.image,
    this.date,
  });

  factory BpeAuditTrail.fromJson(Map<String, dynamic> j) => BpeAuditTrail(
    type:         j['type']?.toString(),
    description:  j['description']?.toString(),
    actionByName: j['action_by_name']?.toString(),
    actionById:   j['action_by']?.toString(),
    image:        j['image']?.toString(),
    date:         j['date']?.toString(),
  );
}

class BpeDetailModel {
  final int idBpe;
  final String encryption;
  final String bpeNumber;
  final String? bpeDate;
  final int periodMonth;
  final int periodYear;
  final String? note;
  final String status;
  final String? createdByName;
  final String? updatedByName;
  final String? createdDate;
  final String? updatedDate;
  final List<BpeTransactionModel> transactions;
  final List<BpeAuditTrail> auditTrails;

  BpeDetailModel({
    required this.idBpe,
    required this.encryption,
    required this.bpeNumber,
    this.bpeDate,
    required this.periodMonth,
    required this.periodYear,
    this.note,
    required this.status,
    this.createdByName,
    this.updatedByName,
    this.createdDate,
    this.updatedDate,
    required this.transactions,
    required this.auditTrails,
  });

  factory BpeDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BpeDetailModel(
      idBpe:         _pi(data['id_bpe']),
      encryption:    _ps(data['encryption']),
      bpeNumber:     _ps(data['bpe_number']),
      bpeDate:       data['bpe_date']?.toString(),
      periodMonth:   _pi(data['period_month']),
      periodYear:    _pi(data['period_year']),
      note:          data['note']?.toString(),
      status:        _ps(data['status']),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      createdDate:   data['created_date']?.toString(),
      updatedDate:   data['updated_date']?.toString(),
      transactions: (data['transactions'] as List? ?? [])
          .map((e) => BpeTransactionModel.fromJson(e))
          .toList(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => BpeAuditTrail.fromJson(e))
          .toList(),
    );
  }

  bool get isDraft      => status == 'Draft';
  bool get isConfirmed  => status == 'Confirmed';
  bool get isValidated  => status == 'Validated';
  bool get canEdit      => isDraft;
  bool get canConfirm   => isDraft;
  bool get canValidate  => isConfirmed;
  bool get canDelete    => isDraft;

  double get totalAmount => transactions.fold(0, (s, t) => s + t.grandTotal);
}

class BpeAvailableInvoice {
  final String transactionType;
  final int idInvoice;
  final String? invoiceNumber;
  final String? invoiceDate;
  final int? idCustomer;
  final String? customerName;
  final double grandTotal;

  BpeAvailableInvoice({
    required this.transactionType,
    required this.idInvoice,
    this.invoiceNumber,
    this.invoiceDate,
    this.idCustomer,
    this.customerName,
    this.grandTotal = 0,
  });

  factory BpeAvailableInvoice.fromJson(Map<String, dynamic> j) => BpeAvailableInvoice(
    transactionType: _ps(j['transaction_type']),
    idInvoice:        _pi(j['id_invoice']),
    invoiceNumber:    j['invoice_number']?.toString(),
    invoiceDate:      j['invoice_date']?.toString(),
    idCustomer:       j['id_customer'] == null ? null : _pi(j['id_customer']),
    customerName:     j['customer_name']?.toString(),
    grandTotal:       _pd(j['grand_total']),
  );

  bool get isServiceInvoice => transactionType == 'Service_Invoice';

  BpeTransactionModel toTransaction() => BpeTransactionModel(
    transactionType: transactionType,
    idInvoice:        idInvoice,
    invoiceNumber:    invoiceNumber,
    invoiceDate:      invoiceDate,
    idCustomer:       idCustomer,
    customerName:     customerName,
    grandTotal:       grandTotal,
  );

  @override
  bool operator ==(Object o) =>
      o is BpeAvailableInvoice && o.transactionType == transactionType && o.idInvoice == idInvoice;
  @override
  int get hashCode => Object.hash(transactionType, idInvoice);
}

class BpeFormModel {
  int? idBpe;
  String? encryption;
  String bpeNumber;
  DateTime? bpeDate;
  int? periodMonth;
  int? periodYear;
  String? note;
  List<BpeTransactionModel> transactions;

  BpeFormModel({
    this.idBpe,
    this.encryption,
    this.bpeNumber = '',
    this.bpeDate,
    this.periodMonth,
    this.periodYear,
    this.note,
    List<BpeTransactionModel>? transactions,
  }) : transactions = transactions ?? [];

  bool get isEditMode => encryption != null && encryption!.isNotEmpty;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  factory BpeFormModel.fromDetail(BpeDetailModel d) => BpeFormModel(
    idBpe:      d.idBpe,
    encryption: d.encryption,
    bpeNumber:  d.bpeNumber,
    bpeDate:    d.bpeDate != null ? DateTime.tryParse(d.bpeDate!) : null,
    periodMonth: d.periodMonth,
    periodYear:  d.periodYear,
    note:        d.note,
    transactions: List.of(d.transactions),
  );

  Map<String, dynamic> toJson(String status) => {
    if (idBpe != null) 'id_bpe': idBpe,
    'status':       status,
    'bpe_number':   bpeNumber,
    if (bpeDate != null) 'bpe_date': _fmtDate(bpeDate!),
    'period_month': periodMonth,
    'period_year':  periodYear,
    if (note != null && note!.isNotEmpty) 'note': note,
    'transactions': transactions.map((t) => t.toJson()).toList(),
  };

  Map<String, dynamic> toValidateJson() => {
    'id_bpe': idBpe,
    'status': 'validate',
  };
}