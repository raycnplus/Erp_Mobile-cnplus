import 'dart:ui';

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

class ServiceInvoiceModel {
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final String? invoiceDate;
  final String? termName;
  final double grandTotal;

  ServiceInvoiceModel({
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.invoiceDate,
    this.termName,
    this.grandTotal = 0,
  });

  factory ServiceInvoiceModel.fromJson(Map<String, dynamic> j) =>
      ServiceInvoiceModel(
        encryption: _ps(j['encryption']),
        status: _ps(j['status']),
        reference: j['reference']?.toString(),
        customerName: j['customer_name']?.toString(),
        invoiceDate: j['invoice_date']?.toString(),
        termName: j['term_name']?.toString(),
        grandTotal: _pd(j['grand_total']),
      );

  static const _statusColors = <String, int>{
    'Draft': 0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed': 0xFF1565C0,
    'Posted': 0xFF2E7D32,
    'Cancelled': 0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class ServiceInvoicePaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ServiceInvoicePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class ServiceInvoiceItem {
  final int idServiceInvoiceItem;
  final int idService;
  final String? serviceName;
  final String? description;
  final double qty;
  final double unitPrice;
  final double discountRate;
  final double discountAmount;
  final double taxRate;
  final double taxAmount;
  final double pph23Rate;
  final double pph23Amount;
  final double subtotal;

  ServiceInvoiceItem({
    required this.idServiceInvoiceItem,
    required this.idService,
    this.serviceName,
    this.description,
    required this.qty,
    required this.unitPrice,
    required this.discountRate,
    required this.discountAmount,
    required this.taxRate,
    required this.taxAmount,
    this.pph23Rate = 0,
    this.pph23Amount = 0,
    required this.subtotal,
  });

  factory ServiceInvoiceItem.fromJson(Map<String, dynamic> j) =>
      ServiceInvoiceItem(
        idServiceInvoiceItem: _pi(j['id_service_invoice_item']),
        idService: _pi(j['id_service']),
        serviceName: j['service']?['product_name']?.toString() ??
            j['service_name']?.toString(),
        description: j['description']?.toString(),
        qty: _pd(j['qty']),
        unitPrice: _pd(j['unit_price']),
        discountRate: _pd(j['discount_rate']),
        discountAmount: _pd(j['discount_amount']),
        taxRate: _pd(j['tax_rate']),
        taxAmount: _pd(j['tax_amount']),
        pph23Rate: _pd(j['pph_23_rate']),
        pph23Amount: _pd(j['pph_23_amount']),
        subtotal: _pd(j['subtotal']),
      );

  double get untaxedAmount => subtotal - taxAmount;
}

class ServiceInvoiceAccountingEntry {
  final int idEntryDetail;
  final String coaNumber;
  final String coaName;
  final String type;
  final double amount;
  final String? reference;
  final String? description;
  final String? transactionDate;

  ServiceInvoiceAccountingEntry({
    required this.idEntryDetail,
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.amount,
    this.reference,
    this.description,
    this.transactionDate,
  });

  factory ServiceInvoiceAccountingEntry.fromJson(Map<String, dynamic> j) =>
      ServiceInvoiceAccountingEntry(
        idEntryDetail: _pi(j['id_entry_detail']),
        coaNumber: j['coa_number']?.toString() ?? '',     
        coaName: j['coa_name']?.toString() ?? '',
        type: j['type']?.toString() ?? 'debit',
        amount: _pd(j['amount']),
        reference: j['reference']?.toString(),
        description: j['entry_description']?.toString() ??
            j['description']?.toString(),
        transactionDate: j['transaction_date']?.toString(),
      );
}

class ServiceInvoiceAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  ServiceInvoiceAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory ServiceInvoiceAuditTrail.fromJson(Map<String, dynamic> j) =>
      ServiceInvoiceAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById: j['action_by']?.toString(),
        description: j['description']?.toString(),
        type: j['type']?.toString(),
        date: j['date']?.toString(),
      );
}

class ServiceInvoicePaymentDetail {
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final double grandTotal;
  final double paymentAmount;
  final String? paymentDate;
  final String? paymentEncryption;

  ServiceInvoicePaymentDetail({
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    required this.grandTotal,
    required this.paymentAmount,
    this.paymentDate,
    this.paymentEncryption,
  });

  factory ServiceInvoicePaymentDetail.fromJson(Map<String, dynamic> j) =>
      ServiceInvoicePaymentDetail(
        bankName: j['bank_name']?.toString(),
        bankAccountName: j['bank_account_name']?.toString(),
        bankAccountNumber: j['bank_account_number']?.toString(),
        grandTotal: _pd(j['grand_total']),
        paymentAmount: _pd(j['payment_amount']),
        paymentDate: j['payment_date']?.toString(),
        paymentEncryption: j['payment_encryption']?.toString(),
      );
}

class ServiceInvoiceDetailModel {
  final int idServiceInvoice;
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final int? idCustomer;
  final int? salesPerson;
  final int? idPaymentTerm;
  final String? salesPersonName;
  final String? paymentTermName;
  final String? invoiceDate;
  final String? dueDate;
  final String? note;
  final String? discountType;
  final String? isTax;
  final double untaxedAmount;
  final double totalTaxes;
  final double totalDiscount;
  final double grandTotal;
  final double defaultTaxRate;
  final String? eBupot;
  final String? paymentInfo;
  final String? paymentInfoClass;
  final String? paymentScheduleName;
  final String? serviceSalesOrderEncryption;
  final String? serviceSalesOrderReference;
  final String? serviceDirectSalesEncryption;
  final String? serviceDirectSalesReference;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelledReason;
  final String? postedDate;
  final List<ServiceInvoiceItem> items;
  final List<ServiceInvoiceAuditTrail> auditTrails;
  final List<ServiceInvoiceAccountingEntry> accountingEntries;
  final ServiceInvoicePaymentDetail? paymentDetails;

  ServiceInvoiceDetailModel({
    required this.idServiceInvoice,
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.idCustomer,
    this.salesPerson,
    this.idPaymentTerm,
    this.salesPersonName,
    this.paymentTermName,
    this.invoiceDate,
    this.dueDate,
    this.note,
    this.discountType,
    this.isTax,
    required this.untaxedAmount,
    required this.totalTaxes,
    required this.totalDiscount,
    required this.grandTotal,
    this.defaultTaxRate = 11.0,
    this.eBupot,
    this.paymentInfo,
    this.paymentInfoClass,
    this.paymentScheduleName,
    this.serviceSalesOrderEncryption,
    this.serviceSalesOrderReference,
    this.serviceDirectSalesEncryption,
    this.serviceDirectSalesReference,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelledReason,
    this.postedDate,
    required this.items,
    required this.auditTrails,
    required this.accountingEntries,
    this.paymentDetails,
  });

  factory ServiceInvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final pdRaw = data['payment_details'];
    return ServiceInvoiceDetailModel(
      idServiceInvoice: _pi(data['id_service_invoice']),
      encryption: _ps(data['encryption']),
      status: _ps(data['status']),
      reference: data['reference']?.toString(),
      customerName: data['customer_name']?.toString(),
      idCustomer:
          _pi(data['id_customer']) == 0 ? null : _pi(data['id_customer']),
      salesPerson:
          _pi(data['sales_person']) == 0 ? null : _pi(data['sales_person']),
      idPaymentTerm: _pi(data['id_payment_term']) == 0
          ? null
          : _pi(data['id_payment_term']),
      salesPersonName: data['sales_person_name']?.toString(),
      paymentTermName: data['payment_term_name']?.toString(),
      invoiceDate: data['invoice_date']?.toString(),
      dueDate: data['due_date']?.toString(),
      note: data['note']?.toString(),
      discountType: data['discount_type']?.toString(),
      isTax: data['is_tax']?.toString(),
      untaxedAmount: _pd(data['untaxed_amount']),
      totalTaxes: _pd(data['total_taxes']),
      totalDiscount: _pd(data['total_discount']),
      grandTotal: _pd(data['grand_total']),
      defaultTaxRate: _pd(data['default_tax_rate']) == 0
          ? 11.0
          : _pd(data['default_tax_rate']),
      eBupot: data['e_bupot']?.toString(),
      paymentInfo: data['payment_info']?.toString(),
      paymentInfoClass: data['payment_info_class']?.toString(),
      paymentScheduleName: data['payment_schedule_name']?.toString(),
      serviceSalesOrderEncryption:
          data['service_sales_order_encryption']?.toString(),
      serviceSalesOrderReference:
          data['service_sales_order_reference']?.toString(),
      serviceDirectSalesEncryption:
          data['service_direct_sales_encryption']?.toString(),
      serviceDirectSalesReference:
          data['service_direct_sales_reference']?.toString(),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      cancelledByName: data['cancelled_by_name']?.toString(),
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      cancelledDate: data['cancelled_date']?.toString(),
      cancelledReason: data['cancel_reason']?.toString(),
      postedDate: data['posted_date']?.toString(),
      items: (data['items'] as List? ?? [])
          .map((e) => ServiceInvoiceItem.fromJson(e))
          .toList(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => ServiceInvoiceAuditTrail.fromJson(e))
          .toList(),
      accountingEntries: (data['accounting_entries'] as List? ?? [])
          .map((e) => ServiceInvoiceAccountingEntry.fromJson(e))
          .toList(),
      paymentDetails: pdRaw is Map
          ? ServiceInvoicePaymentDetail.fromJson(
              Map<String, dynamic>.from(pdRaw),
            )
          : null,
    );
  }

  bool get isDraft => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed => status == 'Confirmed';
  bool get isPosted => status == 'Posted';
  bool get isCancelled => status == 'Cancelled';
  bool get isTaxEnabled => isTax == 'Y';
  bool get canEdit => isDraft;
  bool get canConfirm => isDraft;
  bool get canPost => isConfirmed;
  bool get canCancel => isConfirmed;
  bool get canDelete => isDraft;
  bool get hasPayment => paymentDetails != null;
  bool get hasJournal => accountingEntries.isNotEmpty;
  bool get hasLinkedDoc =>
      (serviceSalesOrderEncryption?.isNotEmpty ?? false) ||
      (serviceDirectSalesEncryption?.isNotEmpty ?? false);

  Color get paymentInfoColor {
    switch (paymentInfoClass) {
      case 'text-success':
        return const Color(0xFF2E7D32);
      case 'text-warning':
        return const Color(0xFFF57F17);
      case 'text-danger':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF757575);
    }
  }
}

class SICustomerOption {
  final int id;
  final String name;

  SICustomerOption({required this.id, required this.name});

  factory SICustomerOption.fromJson(Map<String, dynamic> j) =>
      SICustomerOption(
        id: _pi(j['id_customer']),
        name: _ps(j['customer_name']),
      );

  @override
  bool operator ==(Object o) => o is SICustomerOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SISalesPersonOption {
  final int id;
  final String name;

  SISalesPersonOption({required this.id, required this.name});

  factory SISalesPersonOption.fromJson(Map<String, dynamic> j) =>
      SISalesPersonOption(
        id: _pi(j['id_user']),
        name: _ps(j['nama_lengkap']),
      );

  @override
  bool operator ==(Object o) => o is SISalesPersonOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SIPaymentTermOption {
  final int id;
  final String name;

  SIPaymentTermOption({required this.id, required this.name});

  factory SIPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      SIPaymentTermOption(
        id: _pi(j['id_payment_term']),
        name: _ps(j['payment_term_name']),
      );

  @override
  bool operator ==(Object o) => o is SIPaymentTermOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SIServiceOption {
  final int idService;
  final String serviceName;
  final String? description;

  SIServiceOption({
    required this.idService,
    required this.serviceName,
    this.description,
  });

  factory SIServiceOption.fromJson(Map<String, dynamic> j) =>
      SIServiceOption(
        idService: _pi(j['id_service']),
        serviceName: _ps(j['service_name'] ?? j['product_name']),
        description: j['description']?.toString(),
      );

  @override
  bool operator ==(Object o) =>
      o is SIServiceOption && o.idService == idService;

  @override
  int get hashCode => idService.hashCode;
}

class SIUomOption {
  final int id;
  final String name;

  SIUomOption({required this.id, required this.name});

  factory SIUomOption.fromJson(Map<String, dynamic> j) =>
      SIUomOption(
        id: _pi(j['id_unit_of_measure']),
        name: _ps(j['unit_of_measure_name']),
      );

  @override
  bool operator ==(Object o) => o is SIUomOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ServiceInvoiceFormOptions {
  final List<SICustomerOption> customers;
  final List<SISalesPersonOption> salesPersons;
  final List<SIPaymentTermOption> paymentTerms;
  final List<SIServiceOption> services;
  final List<SIUomOption> uoms;
  final double defaultTaxRate;
  final bool autoCreateJournal;
  final int? currentUserId;

  ServiceInvoiceFormOptions({
    required this.customers,
    required this.salesPersons,
    required this.paymentTerms,
    required this.services,
    required this.uoms,
    this.defaultTaxRate = 11.0,
    this.autoCreateJournal = false,
    this.currentUserId,
  });

  factory ServiceInvoiceFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ServiceInvoiceFormOptions(
      customers: (data['customers'] as List? ?? [])
          .map((e) => SICustomerOption.fromJson(e))
          .toList(),
      salesPersons: (data['sales_persons'] as List? ?? [])
          .map((e) => SISalesPersonOption.fromJson(e))
          .toList(),
      paymentTerms: (data['payment_terms'] as List? ?? [])
          .map((e) => SIPaymentTermOption.fromJson(e))
          .toList(),
      services: (data['services'] as List? ?? [])
          .map((e) => SIServiceOption.fromJson(e))
          .toList(),
      uoms: (data['uoms'] as List? ?? [])
          .map((e) => SIUomOption.fromJson(e))
          .toList(),
      defaultTaxRate: _pd(data['default_tax_rate']) == 0
          ? 11.0
          : _pd(data['default_tax_rate']),
      autoCreateJournal: data['auto_create_journal'] == true ||
          data['auto_create_journal'] == 1,
      currentUserId: _pi(data['current_user_id']) == 0
          ? null
          : _pi(data['current_user_id']),
    );
  }
}

class ServiceInvoiceFormItem {
  int? idService;
  String? serviceName;
  String? description;
  double qty;
  double unitPrice;
  double discountRate;
  double discountAmount;
  double taxRate;
  double taxAmount;
  double pph23Rate;

  ServiceInvoiceFormItem({
    this.idService,
    this.serviceName,
    this.description,
    this.qty = 0,
    this.unitPrice = 0,
    this.discountRate = 0,
    this.discountAmount = 0,
    this.taxRate = 0,
    this.taxAmount = 0,
    this.pph23Rate = 0,
  });

  double get subtotalBeforeDiscount => qty * unitPrice;
  double get subtotalAfterDiscount => subtotalBeforeDiscount - discountAmount;
  double get untaxedAmount => subtotalAfterDiscount;
  double get taxedAmount => subtotalAfterDiscount + taxAmount;

  void recalculate({
    required bool isTaxEnabled,
    required double defaultTaxRate,
    required String? discountType,
  }) {
    if (discountType == 'Percentage') {
      discountAmount = subtotalBeforeDiscount * (discountRate / 100);
    } else if (discountType == 'Nominal') {
      discountRate = subtotalBeforeDiscount > 0
          ? (discountAmount / subtotalBeforeDiscount * 100)
          : 0;
    } else {
      discountRate = 0;
      discountAmount = 0;
    }
    taxRate = isTaxEnabled ? defaultTaxRate : 0;
    taxAmount = subtotalAfterDiscount * (taxRate / 100);
  }

  Map<String, dynamic> toJson() => {
        'id_service': idService,
        'description': description ?? '',
        'qty': qty,
        'unit_price': unitPrice,
        'discount_rate': discountRate,
        'discount_amount': discountAmount,
        'tax_rate': taxRate,
        'pph_23_rate': pph23Rate,
        'amount': untaxedAmount,
      };
}

class ServiceInvoiceFormModel {
  int? idServiceInvoice;
  String? encryption;
  String? reference;
  int? idCustomer;
  int? salesPerson;
  int? idPaymentTerm;
  DateTime? invoiceDate;
  String? note;
  bool isTax;
  String? discountType;
  DateTime? journalTransactionDate;
  List<ServiceInvoiceFormItem> items;

  ServiceInvoiceFormModel({
    this.idServiceInvoice,
    this.encryption,
    this.reference,
    this.idCustomer,
    this.salesPerson,
    this.idPaymentTerm,
    this.invoiceDate,
    this.note,
    this.isTax = false,
    this.discountType,
    this.journalTransactionDate,
    List<ServiceInvoiceFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idServiceInvoice != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get untaxedAmount => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount => items.fold(0, (s, i) => s + i.discountAmount);
  double get grandTotal => untaxedAmount + totalTaxes;

  void recalcAll(double defaultTaxRate) {
    for (final item in items) {
      item.recalculate(
        isTaxEnabled: isTax,
        defaultTaxRate: defaultTaxRate,
        discountType: discountType,
      );
    }
  }

  Map<String, dynamic> toJson(String status, {double defaultTaxRate = 11.0}) {
    recalcAll(defaultTaxRate);
    return {
      if (idServiceInvoice != null) 'id_service_invoice': idServiceInvoice,
      if (reference != null) 'reference': reference,
      'id_customer': idCustomer,
      'sales_person': salesPerson,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      'invoice_date':
          invoiceDate != null ? _fmtDate(invoiceDate!) : null,
      if (note?.isNotEmpty == true) 'note': note,
      'is_tax': isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'grand_total': grandTotal,
      'status': status,
      'services': items.map((i) => i.toJson()).toList(),
      if (status == 'validate' && journalTransactionDate != null)
        'journal_transaction_date': _fmtDate(journalTransactionDate!),
    };
  }

  factory ServiceInvoiceFormModel.fromDetail(ServiceInvoiceDetailModel d) =>
      ServiceInvoiceFormModel(
        idServiceInvoice: d.idServiceInvoice,
        encryption: d.encryption,
        reference: d.reference,
        idCustomer: d.idCustomer,
        salesPerson: d.salesPerson,
        idPaymentTerm: d.idPaymentTerm,
        invoiceDate: d.invoiceDate != null
            ? DateTime.tryParse(d.invoiceDate!)
            : null,
        note: d.note,
        isTax: d.isTaxEnabled,
        discountType: d.discountType == '' ? null : d.discountType,
        items: d.items
            .map(
              (i) => ServiceInvoiceFormItem(
                idService: i.idService,
                serviceName: i.serviceName,
                description: i.description,
                qty: i.qty,
                unitPrice: i.unitPrice,
                discountRate: i.discountRate,
                discountAmount: i.discountAmount,
                taxRate: i.taxRate,
                taxAmount: i.taxAmount,
                pph23Rate: i.pph23Rate,
              ),
            )
            .toList(),
      );
}