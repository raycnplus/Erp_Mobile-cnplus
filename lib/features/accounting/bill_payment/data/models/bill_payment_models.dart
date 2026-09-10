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

class BillPaymentModel {
  final int idPayment;
  final String encryption;
  final String? paymentNumber;
  final String? vendorName;
  final String? billNumber;
  final String? paymentDate;
  final double amountPaid;
  final String status;

  BillPaymentModel({
    required this.idPayment,
    required this.encryption,
    this.paymentNumber,
    this.vendorName,
    this.billNumber,
    this.paymentDate,
    this.amountPaid = 0,
    required this.status,
  });

  factory BillPaymentModel.fromJson(Map<String, dynamic> j) => BillPaymentModel(
        idPayment:     _pi(j['id_payment']),
        encryption:    _ps(j['encryption']),
        paymentNumber: j['payment_number']?.toString(),
        vendorName:    j['vendor_name']?.toString(),
        billNumber:    j['bill_number']?.toString(),
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

class BillPaymentPaginationMeta {
  final int currentPage, lastPage, perPage, total;
  BillPaymentPaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});
}

class BPVendorOption {
  final int idVendor;
  final String vendorName;
  final String? vendorCode;

  BPVendorOption({required this.idVendor, required this.vendorName, this.vendorCode});

  factory BPVendorOption.fromJson(Map<String, dynamic> j) => BPVendorOption(
        idVendor:   _pi(j['id_vendor']),
        vendorName: _ps(j['vendor_name']),
        vendorCode: j['vendor_code']?.toString(),
      );

  @override bool operator ==(Object o) => o is BPVendorOption && o.idVendor == idVendor;
  @override int get hashCode => idVendor.hashCode;
}

class BPBankAccountOption {
  final int idBankAccount;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;

  BPBankAccountOption({required this.idBankAccount, this.bankName, this.bankAccountName, this.bankAccountNumber});

  factory BPBankAccountOption.fromJson(Map<String, dynamic> j) => BPBankAccountOption(
        idBankAccount:     _pi(j['id_bank_account']),
        bankName:          j['bank_name']?.toString(),
        bankAccountName:   j['bank_account_name']?.toString(),
        bankAccountNumber: j['bank_account_number']?.toString(),
      );

  String get display {
    final parts = [bankName, bankAccountNumber].where((s) => s?.isNotEmpty == true).toList();
    return parts.isNotEmpty ? parts.join(' - ') : 'Bank Account #$idBankAccount';
  }

  @override bool operator ==(Object o) => o is BPBankAccountOption && o.idBankAccount == idBankAccount;
  @override int get hashCode => idBankAccount.hashCode;
}

class CashRoundingSettings {
  final bool cashRoundingEnabled;
  final int cashRoundingValue;
  final String cashRoundingMethod;
  final bool decimalRoundingEnabled;

  CashRoundingSettings({
    this.cashRoundingEnabled = false,
    this.cashRoundingValue = 100,
    this.cashRoundingMethod = 'nearest',
    this.decimalRoundingEnabled = false,
  });

  factory CashRoundingSettings.fromJson(Map<String, dynamic>? j) {
    if (j == null) return CashRoundingSettings();
    return CashRoundingSettings(
      cashRoundingEnabled:    j['cash_rounding_enabled'] == true,
      cashRoundingValue:      _pi(j['cash_rounding_value']) == 0 ? 100 : _pi(j['cash_rounding_value']),
      cashRoundingMethod:     j['cash_rounding_method']?.toString() ?? 'nearest',
      decimalRoundingEnabled: j['decimal_rounding_enabled'] == true,
    );
  }
}

class BillPaymentFormOptions {
  final List<BPVendorOption> vendors;
  final List<BPBankAccountOption> bankAccounts;
  final List<String> paymentMethods;
  final bool autoCreateJournal;
  final CashRoundingSettings cashRounding;

  BillPaymentFormOptions({
    required this.vendors,
    required this.bankAccounts,
    this.paymentMethods = const [
      'Bank_Transfer', 'Cash', 'Check', 'Giro', 'Credit_Card', 'Debit_Card', 'Virtual_Account', 'E-Wallet', 'Other',
    ],
    this.autoCreateJournal = false,
    required this.cashRounding,
  });

  factory BillPaymentFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BillPaymentFormOptions(
      vendors:      (data['vendors'] as List? ?? []).map((e) => BPVendorOption.fromJson(e)).toList(),
      bankAccounts: (data['bank_accounts'] as List? ?? []).map((e) => BPBankAccountOption.fromJson(e)).toList(),
      paymentMethods: (data['payment_methods'] as List?)?.map((e) => e.toString()).toList() ??
          ['Bank_Transfer', 'Cash', 'Check', 'Giro', 'Credit_Card', 'Debit_Card', 'Virtual_Account', 'E-Wallet', 'Other'],
      autoCreateJournal: data['auto_create_journal'] == true,
      cashRounding: CashRoundingSettings.fromJson(data['cash_rounding'] as Map<String, dynamic>?),
    );
  }
}

class BillOption {
  final int id;
  final String reference;
  final String? billDate;
  final double grandTotal;
  final double untaxedAmount;

  BillOption({
    required this.id,
    required this.reference,
    this.billDate,
    required this.grandTotal,
    required this.untaxedAmount,
  });

  factory BillOption.fromJson(Map<String, dynamic> j) => BillOption(
        id:            _pi(j['id']),
        reference:     _ps(j['reference']),
        billDate:      j['bill_date']?.toString(),
        grandTotal:    _pd(j['grand_total']),
        untaxedAmount: _pd(j['untaxed_amount']),
      );

  @override bool operator ==(Object o) => o is BillOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class AccountingEntryLine {
  final String? coaNumber;
  final String? coaName;
  final String type;
  final double amount;
  final String? reference;
  final String? entryDescription;
  final String? transactionDate;

  AccountingEntryLine({
    this.coaNumber,
    this.coaName,
    required this.type,
    required this.amount,
    this.reference,
    this.entryDescription,
    this.transactionDate,
  });

  factory AccountingEntryLine.fromJson(Map<String, dynamic> j) => AccountingEntryLine(
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

class BillPaymentAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  BillPaymentAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory BillPaymentAuditTrail.fromJson(Map<String, dynamic> j) => BillPaymentAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class BillPaymentDetailModel {
  final int idPayment;
  final String encryption;
  final String? paymentNumber;
  final int? idVendor;
  final String? vendorName;
  final String? vendorCode;
  final int? idBill;
  final String? billNumber;
  final String? billEncryption;
  final double billTotal;
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
  final CashRoundingSettings cashRounding;
  final List<AccountingEntryLine> accountingEntries;
  final List<BillPaymentAuditTrail> auditTrails;

  BillPaymentDetailModel({
    required this.idPayment,
    required this.encryption,
    this.paymentNumber,
    this.idVendor,
    this.vendorName,
    this.vendorCode,
    this.idBill,
    this.billNumber,
    this.billEncryption,
    this.billTotal = 0,
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

  factory BillPaymentDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BillPaymentDetailModel(
      idPayment:         _pi(data['id_payment']),
      encryption:        _ps(data['encryption']),
      paymentNumber:     data['payment_number']?.toString(),
      idVendor:          data['id_vendor'] == null ? null : _pi(data['id_vendor']),
      vendorName:        data['vendor_name']?.toString(),
      vendorCode:        data['vendor_code']?.toString(),
      idBill:            data['id_bill'] == null ? null : _pi(data['id_bill']),
      billNumber:        data['bill_number']?.toString(),
      billEncryption:    data['bill_encryption']?.toString(),
      billTotal:         _pd(data['bill_total']),
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
      cashRounding:      CashRoundingSettings.fromJson(data['cash_rounding'] as Map<String, dynamic>?),
      accountingEntries: (data['accounting_entries'] as List? ?? []).map((e) => AccountingEntryLine.fromJson(e)).toList(),
      auditTrails:       (data['audit_trails'] as List? ?? []).map((e) => BillPaymentAuditTrail.fromJson(e)).toList(),
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

class BillPaymentFormModel {
  int? idPayment;
  String? encryption;
  int? idVendor;
  int? idBill;
  String? billReference;
  double billUntaxedAmount;
  double billGrandTotal;
  DateTime? paymentDate;
  double amount;
  String paymentMethod;
  int? idBankAccount;
  bool applyPph23;
  bool applyPpn;
  String? memo;
  String? attachmentPath; 

  BillPaymentFormModel({
    this.idPayment,
    this.encryption,
    this.idVendor,
    this.idBill,
    this.billReference,
    this.billUntaxedAmount = 0,
    this.billGrandTotal = 0,
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
        'id_vendor':       idVendor?.toString(),
        'id_bill':         idBill?.toString(),
        'payment_date':    paymentDate != null ? _fmtDate(paymentDate!) : null,
        'amount':          amount.toString(),
        'payment_method':  paymentMethod,
        'id_bank_account': idBankAccount?.toString(),
        'apply_pph23':     applyPph23 ? 'Y' : 'N',
        'apply_ppn':       applyPpn ? 'Y' : 'N',
        if (memo != null) 'memo': memo,
      };

  factory BillPaymentFormModel.fromDetail(BillPaymentDetailModel d) => BillPaymentFormModel(
        idPayment:         d.idPayment,
        encryption:        d.encryption,
        idVendor:          d.idVendor,
        idBill:            d.idBill,
        billReference:     d.billNumber,
        billGrandTotal:    d.billTotal,
        paymentDate:       d.paymentDate != null ? DateTime.tryParse(d.paymentDate!) : null,
        amount:            d.amountPaid,
        paymentMethod:     d.paymentMethod,
        idBankAccount:     d.idBankAccount,
        applyPph23:        d.applyPph23,
        applyPpn:          d.applyPpn,
        memo:              d.memo,
      );
}