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

String taxTransactionTypeLabel(String? t) =>
    (t == null || t.isEmpty) ? '-' : t.replaceAll('_', ' ');

class TaxPaymentModel {
  final int idTaxPayment;
  final String encryption;
  final String status;
  final String? transactionType;
  final String? transactionNumber;
  final String? taxReferenceNumber;
  final String? paymentDate;
  final double amount;
  final String? customerName;
  final String? invoicePaymentStatus;

  TaxPaymentModel({
    required this.idTaxPayment,
    required this.encryption,
    required this.status,
    this.transactionType,
    this.transactionNumber,
    this.taxReferenceNumber,
    this.paymentDate,
    this.amount = 0,
    this.customerName,
    this.invoicePaymentStatus,
  });

  factory TaxPaymentModel.fromJson(Map<String, dynamic> j) => TaxPaymentModel(
        idTaxPayment:         _pi(j['id_tax_payment']),
        encryption:           _ps(j['encryption']),
        status:               _ps(j['status']),
        transactionType:      j['transaction_type']?.toString(),
        transactionNumber:    j['transaction_number']?.toString(),
        taxReferenceNumber:   j['tax_reference_number']?.toString(),
        paymentDate:          j['payment_date']?.toString(),
        amount:               _pd(j['amount']),
        customerName:         j['customer_name']?.toString(),
        invoicePaymentStatus: j['invoice_payment_status']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':  0xFF757575,
    'Posted': 0xFF2E7D32,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
  String get typeLabel => taxTransactionTypeLabel(transactionType);
}

class TaxPaymentPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  TaxPaymentPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class TaxTransactionOption {
  final String transactionType;
  final int idTransaction;
  final String transactionNumber;
  final int? idCustomer;
  final String? customerName;
  final double amount;
  final String? paymentStatus;

  TaxTransactionOption({
    required this.transactionType,
    required this.idTransaction,
    required this.transactionNumber,
    this.idCustomer,
    this.customerName,
    this.amount = 0,
    this.paymentStatus,
  });

  factory TaxTransactionOption.fromJson(Map<String, dynamic> j) => TaxTransactionOption(
        transactionType:   _ps(j['transaction_type']),
        idTransaction:     _pi(j['id_transaction']),
        transactionNumber: _ps(j['transaction_number']),
        idCustomer:        _pin(j['id_customer']),
        customerName:      j['customer_name']?.toString(),
        amount:            _pd(j['amount']),
        paymentStatus:     j['payment_status']?.toString(),
      );

  String get typeLabel => taxTransactionTypeLabel(transactionType);
}

class TaxPaymentAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  TaxPaymentAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory TaxPaymentAuditTrail.fromJson(Map<String, dynamic> j) => TaxPaymentAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class TaxPaymentDetailModel {
  final int idTaxPayment;
  final String encryption;
  final String status;
  final String? transactionType;
  final int? idTransaction;
  final String? transactionNumber;
  final int? idCustomer;
  final String? customerName;
  final String? taxReferenceNumber;
  final String? paymentDate;
  final String? signerName;
  final double amount;
  final String? note;
  final String? invoicePaymentStatus;
  final bool invoicePaymentIsPaid;
  final String? unpostDate;
  final String? createdDate;
  final String? updatedDate;
  final String? createdByName;
  final String? updatedByName;
  final String? unpostedByName;
  final List<TaxPaymentAuditTrail> auditTrails;

  TaxPaymentDetailModel({
    required this.idTaxPayment,
    required this.encryption,
    required this.status,
    this.transactionType,
    this.idTransaction,
    this.transactionNumber,
    this.idCustomer,
    this.customerName,
    this.taxReferenceNumber,
    this.paymentDate,
    this.signerName,
    this.amount = 0,
    this.note,
    this.invoicePaymentStatus,
    this.invoicePaymentIsPaid = false,
    this.unpostDate,
    this.createdDate,
    this.updatedDate,
    this.createdByName,
    this.updatedByName,
    this.unpostedByName,
    required this.auditTrails,
  });

  factory TaxPaymentDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return TaxPaymentDetailModel(
      idTaxPayment:         _pi(data['id_tax_payment']),
      encryption:           _ps(data['encryption']),
      status:               _ps(data['status']),
      transactionType:      data['transaction_type']?.toString(),
      idTransaction:        _pin(data['id_transaction']),
      transactionNumber:    data['transaction_number']?.toString(),
      idCustomer:           _pin(data['id_customer']),
      customerName:         data['customer_name']?.toString(),
      taxReferenceNumber:   data['tax_reference_number']?.toString(),
      paymentDate:          data['payment_date']?.toString(),
      signerName:           data['signer_name']?.toString(),
      amount:               _pd(data['amount']),
      note:                 data['note']?.toString(),
      invoicePaymentStatus: data['invoice_payment_status']?.toString(),
      invoicePaymentIsPaid: data['invoice_payment_is_paid'] == true || data['invoice_payment_is_paid'] == 1,
      unpostDate:           data['unpost_date']?.toString(),
      createdDate:          data['created_date']?.toString(),
      updatedDate:          data['updated_date']?.toString(),
      createdByName:        data['created_by_name']?.toString(),
      updatedByName:        data['updated_by_name']?.toString(),
      unpostedByName:       data['unposted_by_name']?.toString(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => TaxPaymentAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft    => status == 'Draft';
  bool get isPosted   => status == 'Posted';
  bool get canEdit    => isDraft;
  bool get canPost    => isDraft;
  bool get canUnpost  => isPosted;
  bool get canDelete  => isDraft;

  bool get isReadyToPost => taxReferenceNumber?.isNotEmpty == true && paymentDate?.isNotEmpty == true;

  String get typeLabel => taxTransactionTypeLabel(transactionType);
}

class TaxPaymentFormModel {
  int? idTaxPayment;
  String? encryption;
  String? transactionType;
  int? idTransaction;
  String? transactionNumber;
  int? idCustomer;
  String? customerName;
  String? paymentStatus;
  String? taxReferenceNumber;
  DateTime? paymentDate;
  String? signerName;
  double amount;
  String? note;

  TaxPaymentFormModel({
    this.idTaxPayment,
    this.encryption,
    this.transactionType,
    this.idTransaction,
    this.transactionNumber,
    this.idCustomer,
    this.customerName,
    this.paymentStatus,
    this.taxReferenceNumber,
    this.paymentDate,
    this.signerName,
    this.amount = 0,
    this.note,
  });

  bool get isEditMode => idTaxPayment != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        if (idTaxPayment != null) 'id_tax_payment': idTaxPayment,
        'transaction_type':     transactionType,
        'id_transaction':       idTransaction,
        'transaction_number':   transactionNumber,
        'id_customer':          idCustomer,
        'tax_reference_number': taxReferenceNumber,
        'payment_date':         paymentDate != null ? _fmtDate(paymentDate!) : null,
        'signer_name':          signerName,
        'amount':               amount,
        'note':                 note,
        'status':               'save',
      };

  factory TaxPaymentFormModel.fromDetail(TaxPaymentDetailModel d) => TaxPaymentFormModel(
        idTaxPayment:       d.idTaxPayment,
        encryption:         d.encryption,
        transactionType:    d.transactionType,
        idTransaction:      d.idTransaction,
        transactionNumber:  d.transactionNumber,
        idCustomer:         d.idCustomer,
        customerName:       d.customerName,
        paymentStatus:      d.invoicePaymentStatus,
        taxReferenceNumber: d.taxReferenceNumber,
        paymentDate:        d.paymentDate != null ? DateTime.tryParse(d.paymentDate!) : null,
        signerName:         d.signerName,
        amount:             d.amount,
        note:               d.note,
      );
}