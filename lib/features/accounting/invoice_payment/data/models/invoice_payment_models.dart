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

class InvoicePaymentModel {
  final int idPayment;
  final String encryption;
  final String? paymentNumber;
  final String? customerName;
  final String? invoiceNumber;
  final String invoiceType; 
  final String? paymentDate;
  final double amountPaid;
  final String status;

  InvoicePaymentModel({
    required this.idPayment,
    required this.encryption,
    this.paymentNumber,
    this.customerName,
    this.invoiceNumber,
    required this.invoiceType,
    this.paymentDate,
    this.amountPaid = 0,
    required this.status,
  });

  factory InvoicePaymentModel.fromJson(Map<String, dynamic> j) => InvoicePaymentModel(
        idPayment:     _pi(j['id_payment']),
        encryption:    _ps(j['encryption']),
        paymentNumber: j['payment_number']?.toString(),
        customerName:  j['customer_name']?.toString(),
        invoiceNumber: j['invoice_number']?.toString(),
        invoiceType:   _ps(j['invoice_type']),
        paymentDate:   j['payment_date']?.toString(),
        amountPaid:    _pd(j['amount_paid']),
        status:        _ps(j['status']),
      );

  static const _statusColors = <String, int>{
    'Draft':     0xFF757575,
    'Confirmed': 0xFF1565C0,
    'Posted':    0xFF2E7D32,
    'Cancelled': 0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class InvoicePaymentPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  InvoicePaymentPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class IPCustomerOption {
  final int idCustomer;
  final String customerName;
  final String? customerCode;

  IPCustomerOption({required this.idCustomer, required this.customerName, this.customerCode});

  factory IPCustomerOption.fromJson(Map<String, dynamic> j) => IPCustomerOption(
        idCustomer:   _pi(j['id_customer']),
        customerName: _ps(j['customer_name']),
        customerCode: j['customer_code']?.toString(),
      );

  @override bool operator ==(Object o) => o is IPCustomerOption && o.idCustomer == idCustomer;
  @override int get hashCode => idCustomer.hashCode;
}

class IPBankAccountOption {
  final int idBankAccount;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;

  IPBankAccountOption({required this.idBankAccount, this.bankName, this.bankAccountName, this.bankAccountNumber});

  factory IPBankAccountOption.fromJson(Map<String, dynamic> j) => IPBankAccountOption(
        idBankAccount:     _pi(j['id_bank_account']),
        bankName:          j['bank_name']?.toString(),
        bankAccountName:   j['bank_account_name']?.toString(),
        bankAccountNumber: j['bank_account_number']?.toString(),
      );

  String get display {
    final parts = [bankName, bankAccountNumber].where((s) => s?.isNotEmpty == true).toList();
    return parts.isNotEmpty ? parts.join(' - ') : 'Bank Account #$idBankAccount';
  }

  @override bool operator ==(Object o) => o is IPBankAccountOption && o.idBankAccount == idBankAccount;
  @override int get hashCode => idBankAccount.hashCode;
}

class IPCashRoundingSettings {
  final bool cashRoundingEnabled;
  final int cashRoundingValue;
  final String cashRoundingMethod;
  final bool decimalRoundingEnabled;

  IPCashRoundingSettings({
    this.cashRoundingEnabled = false,
    this.cashRoundingValue = 100,
    this.cashRoundingMethod = 'nearest',
    this.decimalRoundingEnabled = false,
  });

  factory IPCashRoundingSettings.fromJson(Map<String, dynamic>? j) {
    if (j == null) return IPCashRoundingSettings();
    return IPCashRoundingSettings(
      cashRoundingEnabled:    j['cash_rounding_enabled'] == true,
      cashRoundingValue:      _pi(j['cash_rounding_value']) == 0 ? 100 : _pi(j['cash_rounding_value']),
      cashRoundingMethod:     j['cash_rounding_method']?.toString() ?? 'nearest',
      decimalRoundingEnabled: j['decimal_rounding_enabled'] == true,
    );
  }
}

class InvoicePaymentFormOptions {
  final List<IPCustomerOption> customers;
  final List<IPBankAccountOption> bankAccounts;
  final List<String> paymentMethods;
  final List<String> invoiceTypes;
  final bool autoCreateJournal;
  final IPCashRoundingSettings cashRounding;

  InvoicePaymentFormOptions({
    required this.customers,
    required this.bankAccounts,
    this.paymentMethods = const [
      'Bank_Transfer', 'Cash', 'Check', 'Giro', 'Credit_Card', 'Debit_Card', 'Virtual_Account', 'E-Wallet', 'Other',
    ],
    this.invoiceTypes = const ['Product', 'Service'],
    this.autoCreateJournal = false,
    required this.cashRounding,
  });

  factory InvoicePaymentFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return InvoicePaymentFormOptions(
      customers:    (data['customers'] as List? ?? []).map((e) => IPCustomerOption.fromJson(e)).toList(),
      bankAccounts: (data['bank_accounts'] as List? ?? []).map((e) => IPBankAccountOption.fromJson(e)).toList(),
      paymentMethods: (data['payment_methods'] as List?)?.map((e) => e.toString()).toList() ??
          ['Bank_Transfer', 'Cash', 'Check', 'Giro', 'Credit_Card', 'Debit_Card', 'Virtual_Account', 'E-Wallet', 'Other'],
      invoiceTypes: (data['invoice_types'] as List?)?.map((e) => e.toString()).toList() ?? ['Product', 'Service'],
      autoCreateJournal: data['auto_create_journal'] == true,
      cashRounding: IPCashRoundingSettings.fromJson(data['cash_rounding'] as Map<String, dynamic>?),
    );
  }
}

class InvoiceOption {
  final int id;
  final String reference;
  final String? invoiceDate;
  final double grandTotal;
  final double untaxedAmount;

  InvoiceOption({
    required this.id,
    required this.reference,
    this.invoiceDate,
    required this.grandTotal,
    required this.untaxedAmount,
  });

  factory InvoiceOption.fromJson(Map<String, dynamic> j) => InvoiceOption(
        id:            _pi(j['id']),
        reference:     _ps(j['reference']),
        invoiceDate:   j['invoice_date']?.toString(),
        grandTotal:    _pd(j['grand_total']),
        untaxedAmount: _pd(j['untaxed_amount']),
      );

  @override bool operator ==(Object o) => o is InvoiceOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class IPAccountingEntryLine {
  final String? coaNumber;
  final String? coaName;
  final String type;
  final double amount;
  final String? reference;
  final String? entryDescription;
  final String? transactionDate;

  IPAccountingEntryLine({
    this.coaNumber,
    this.coaName,
    required this.type,
    required this.amount,
    this.reference,
    this.entryDescription,
    this.transactionDate,
  });

  factory IPAccountingEntryLine.fromJson(Map<String, dynamic> j) => IPAccountingEntryLine(
        coaNumber:        j['coa_number']?.toString(),
        coaName:          j['coa_name']?.toString(),
        type:             _ps(j['type']),
        amount:           _pd(j['amount']),
        reference:        j['reference']?.toString(),
        entryDescription: j['entry_description']?.toString(),
        transactionDate:  j['transaction_date']?.toString(),
      );

  bool get isDebit => type == 'DEBIT';
}

class InvoicePaymentAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;
  final String? image;

  InvoicePaymentAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date, this.image});

  factory InvoicePaymentAuditTrail.fromJson(Map<String, dynamic> j) => InvoicePaymentAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
        image:        j['image']?.toString(),
      );
}

class PaymentInvoiceInfo {
  final int? id;
  final String? reference;
  final double untaxedAmount;
  final double grandTotal;
  final double ppnAmount;

  PaymentInvoiceInfo({this.id, this.reference, this.untaxedAmount = 0, this.grandTotal = 0, this.ppnAmount = 0});

  factory PaymentInvoiceInfo.fromJson(Map<String, dynamic>? j) {
    if (j == null) return PaymentInvoiceInfo();
    return PaymentInvoiceInfo(
      id:            j['id'] == null ? null : _pi(j['id']),
      reference:     j['reference']?.toString(),
      untaxedAmount: _pd(j['untaxed_amount']),
      grandTotal:    _pd(j['grand_total']),
      ppnAmount:     _pd(j['ppn_amount']),
    );
  }
}

class InvoicePaymentDetailModel {
  final int idPayment;
  final String encryption;
  final String? paymentNumber;
  final int? idCustomer;
  final String? customerName;
  final String? customerCode;
  final String invoiceType;
  final int? idInvoice;
  final String? invoiceNumber;
  final String? invoiceEncryption;
  final PaymentInvoiceInfo paymentInvoice;
  final double invoiceTotal;
  final String? paymentDate;
  final String paymentMethod;
  final int? idBankAccount;
  final String? bankName;
  final String? bankAccountNumber;
  final String? attachment;
  final String? attachmentUrl;
  final bool applyPph23;
  final double pph23Amount;
  final bool applyPpn;
  final double ppnAmount;
  final double amountPaid;
  final String? memo;
  final String status;
  final String? cancelReason;
  final String? cancelledDate;
  final String? validatedDate;
  final String? unpostDate;
  final String? createdDate;
  final String? updatedDate;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? unpostByName;
  final bool autoCreateJournal;
  final IPCashRoundingSettings cashRounding;
  final List<IPAccountingEntryLine> accountingEntries;
  final List<InvoicePaymentAuditTrail> auditTrails;

  InvoicePaymentDetailModel({
    required this.idPayment,
    required this.encryption,
    this.paymentNumber,
    this.idCustomer,
    this.customerName,
    this.customerCode,
    required this.invoiceType,
    this.idInvoice,
    this.invoiceNumber,
    this.invoiceEncryption,
    required this.paymentInvoice,
    this.invoiceTotal = 0,
    this.paymentDate,
    required this.paymentMethod,
    this.idBankAccount,
    this.bankName,
    this.bankAccountNumber,
    this.attachment,
    this.attachmentUrl,
    this.applyPph23 = false,
    this.pph23Amount = 0,
    this.applyPpn = false,
    this.ppnAmount = 0,
    this.amountPaid = 0,
    this.memo,
    required this.status,
    this.cancelReason,
    this.cancelledDate,
    this.validatedDate,
    this.createdDate,
    this.updatedDate,
    this.unpostDate,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.unpostByName,
    this.autoCreateJournal = false,
    required this.cashRounding,
    required this.accountingEntries,
    required this.auditTrails,
  });

  factory InvoicePaymentDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final invoiceType = _ps(data['invoice_type']);
    final invoiceEncryption = invoiceType == 'Product'
        ? data['invoice_encryption']?.toString()
        : data['service_invoice_encryption']?.toString();

    return InvoicePaymentDetailModel(
      idPayment:         _pi(data['id_payment']),
      encryption:        _ps(data['encryption']),
      paymentNumber:     data['payment_number']?.toString(),
      idCustomer:        data['id_customer'] == null ? null : _pi(data['id_customer']),
      customerName:      data['customer_name']?.toString(),
      customerCode:      data['customer_code']?.toString(),
      invoiceType:       invoiceType,
      idInvoice:         data['id_invoice'] == null ? null : _pi(data['id_invoice']),
      invoiceNumber:     data['invoice_number']?.toString(),
      invoiceEncryption: invoiceEncryption,
      paymentInvoice:    PaymentInvoiceInfo.fromJson(data['payment_invoice'] as Map<String, dynamic>?),
      invoiceTotal:      _pd(data['invoice_total']),
      paymentDate:       data['payment_date']?.toString(),
      paymentMethod:     _ps(data['payment_method']),
      idBankAccount:     data['id_bank_account'] == null ? null : _pi(data['id_bank_account']),
      bankName:          data['bank_name']?.toString(),
      bankAccountNumber: data['bank_account_number']?.toString(),
      attachment:        data['attachment']?.toString(),
      attachmentUrl:     data['attachment_url']?.toString(),
      applyPph23:        data['apply_pph23'] == 'Y',
      pph23Amount:       _pd(data['pph23_amount']),
      applyPpn:          data['apply_ppn'] == 'Y',
      ppnAmount:         _pd(data['ppn_amount']),
      amountPaid:        _pd(data['amount_paid']),
      memo:              data['memo']?.toString(),
      status:            _ps(data['status']),
      cancelReason:      data['cancel_reason']?.toString(),
      cancelledDate:     data['cancelled_date']?.toString(),
      validatedDate:     data['validated_date']?.toString(),
      createdDate:       data['created_date']?.toString(),
      updatedDate:       data['updated_date']?.toString(),
      unpostDate:        data['unpost_date']?.toString(),
      createdByName:     data['created_by_name']?.toString(),
      updatedByName:     data['updated_by_name']?.toString(),
      cancelledByName:   data['cancelled_by_name']?.toString(),
      unpostByName:      data['unposted_by_name']?.toString(),
      autoCreateJournal: data['auto_create_journal'] == true,
      cashRounding:      IPCashRoundingSettings.fromJson(data['cash_rounding'] as Map<String, dynamic>?),
      accountingEntries: (data['accounting_entries'] as List? ?? []).map((e) => IPAccountingEntryLine.fromJson(e)).toList(),
      auditTrails:       (data['audit_trails'] as List? ?? []).map((e) => InvoicePaymentAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft     => status == 'Draft';
  bool get isConfirmed => status == 'Confirmed';
  bool get isPosted    => status == 'Posted';
  bool get isCancelled => status == 'Cancelled';

  bool get canEdit    => isDraft;
  bool get canDelete  => isDraft;
  bool get canConfirm => isDraft;
  bool get canPost    => isConfirmed;
  bool get canCancel  => isConfirmed;
  bool get canUnpost  => isPosted;
}

class InvoicePaymentFormModel {
  int? idPayment;
  String? encryption;
  int? idCustomer;
  String invoiceType;
  int? idInvoice;
  String? invoiceReference;
  double invoiceUntaxedAmount;
  double invoiceGrandTotal;
  DateTime? paymentDate;
  double amount;
  String paymentMethod;
  int? idBankAccount;
  bool applyPph23;
  bool applyPpn;
  String? memo;
  String? attachmentPath;

  InvoicePaymentFormModel({
    this.idPayment,
    this.encryption,
    this.idCustomer,
    this.invoiceType = 'Product',
    this.idInvoice,
    this.invoiceReference,
    this.invoiceUntaxedAmount = 0,
    this.invoiceGrandTotal = 0,
    this.paymentDate,
    this.amount = 0,
    this.paymentMethod = 'Bank_Transfer',
    this.idBankAccount,
    this.applyPph23 = false,
    this.applyPpn = false,
    this.memo,
    this.attachmentPath,
  });

  bool get isEditMode => encryption != null;

  String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toFieldsMap() => {
        if (idPayment != null) 'id_payment': idPayment.toString(),
        'id_customer':     idCustomer?.toString(),
        'invoice_type':    invoiceType,
        'id_invoice':      idInvoice?.toString(),
        'payment_date':    paymentDate != null ? _fmtDate(paymentDate!) : null,
        'amount':          amount.toString(),
        'payment_method':  paymentMethod,
        'id_bank_account': idBankAccount?.toString(),
        'apply_pph23':     applyPph23 ? 'Y' : 'N',
        'apply_ppn':       applyPpn ? 'Y' : 'N',
        if (memo != null) 'memo': memo,
      };

  factory InvoicePaymentFormModel.fromDetail(InvoicePaymentDetailModel d) => InvoicePaymentFormModel(
        idPayment:             d.idPayment,
        encryption:            d.encryption,
        idCustomer:            d.idCustomer,
        invoiceType:           d.invoiceType,
        idInvoice:             d.idInvoice,
        invoiceReference:      d.invoiceNumber,
        invoiceGrandTotal:     d.invoiceTotal,
        paymentDate:           d.paymentDate != null ? DateTime.tryParse(d.paymentDate!) : null,
        amount:                d.amountPaid,
        paymentMethod:         d.paymentMethod,
        idBankAccount:         d.idBankAccount,
        applyPph23:            d.applyPph23,
        applyPpn:              d.applyPpn,
        memo:                  d.memo,
      );
}