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

class ServiceQuotationModel {
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final String? createdDate;

  ServiceQuotationModel({
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.createdDate,
  });

  factory ServiceQuotationModel.fromJson(Map<String, dynamic> j) =>
      ServiceQuotationModel(
        encryption: _ps(j['encryption']),
        status: _ps(j['status']),
        reference: j['reference']?.toString(),
        customerName: j['customer_name']?.toString(),
        createdDate: j['created_date']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft': 0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed': 0xFF1565C0,
    'Done': 0xFF2E7D32,
    'Cancelled': 0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class ServiceQuotationPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ServiceQuotationPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class ServiceQuotationItem {
  final int idServiceQuotationItem;
  final int idService;
  final String? serviceName;
  final String? description;
  final double qty;
  final double unitPrice;
  final double discountRate;
  final double discountAmount;
  final double taxRate;
  final double taxAmount;
  final double subtotal;

  ServiceQuotationItem({
    required this.idServiceQuotationItem,
    required this.idService,
    this.serviceName,
    this.description,
    required this.qty,
    required this.unitPrice,
    required this.discountRate,
    required this.discountAmount,
    required this.taxRate,
    required this.taxAmount,
    required this.subtotal,
  });

  factory ServiceQuotationItem.fromJson(Map<String, dynamic> j) =>
      ServiceQuotationItem(
        idServiceQuotationItem: _pi(j['id_service_quotation_item']),
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
        subtotal: _pd(j['subtotal']),
      );

  double get untaxedAmount => subtotal - taxAmount;
}

class ServiceQuotationAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  ServiceQuotationAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory ServiceQuotationAuditTrail.fromJson(Map<String, dynamic> j) =>
      ServiceQuotationAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById: j['action_by']?.toString(),
        description: j['description']?.toString(),
        type: j['type']?.toString(),
        date: j['date']?.toString(),
      );
}

class ServiceQuotationDetailModel {
  final int idServiceQuotation;
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final int? idCustomer;
  final int? salesPerson;
  final int? idPaymentTerm;
  final int? idPriceList;
  final String? salesPersonName;
  final String? paymentTermName;
  final String? priceListName;
  final String? validityDate;
  final String? note;
  final String? discountType;
  final String? isTax;
  final double untaxedAmount;
  final double totalTaxes;
  final double totalDiscount;
  final double grandTotal;
  final double defaultTaxRate;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelledReason;
  final String? serviceSalesOrderEncryption;
  final List<ServiceQuotationItem> items;
  final List<ServiceQuotationAuditTrail> auditTrails;

  ServiceQuotationDetailModel({
    required this.idServiceQuotation,
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.idCustomer,
    this.salesPerson,
    this.idPaymentTerm,
    this.idPriceList,
    this.salesPersonName,
    this.paymentTermName,
    this.priceListName,
    this.validityDate,
    this.note,
    this.discountType,
    this.isTax,
    required this.untaxedAmount,
    required this.totalTaxes,
    required this.totalDiscount,
    required this.grandTotal,
    this.defaultTaxRate = 11.0,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelledReason,
    this.serviceSalesOrderEncryption,
    required this.items,
    required this.auditTrails,
  });

  factory ServiceQuotationDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ServiceQuotationDetailModel(
      idServiceQuotation: _pi(data['id_service_quotation']),
      encryption: _ps(data['encryption']),
      status: _ps(data['status']),
      reference: data['reference']?.toString(),
      customerName: data['customer_name']?.toString() ??
          data['customer']?['customer_name']?.toString(),
      idCustomer:
          _pi(data['id_customer']) == 0 ? null : _pi(data['id_customer']),
      salesPerson:
          _pi(data['sales_person']) == 0 ? null : _pi(data['sales_person']),
      idPaymentTerm: _pi(data['id_payment_term']) == 0
          ? null
          : _pi(data['id_payment_term']),
      idPriceList:
          _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      salesPersonName: data['sales_person_name']?.toString(),
      paymentTermName: data['payment_term_name']?.toString(),
      priceListName: data['price_list_name']?.toString(),
      validityDate: data['validity_date']?.toString(),
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
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      cancelledByName: data['cancelled_by_name']?.toString(),
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      cancelledDate: data['cancelled_date']?.toString(),
      cancelledReason: data['cancel_reason']?.toString(),
      serviceSalesOrderEncryption:
          data['service_sales_order_encryption']?.toString(),
      items: (data['items'] as List? ?? [])
          .map((e) => ServiceQuotationItem.fromJson(e))
          .toList(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => ServiceQuotationAuditTrail.fromJson(e))
          .toList(),
    );
  }

  bool get isDraft => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed => status == 'Confirmed';
  bool get isDone => status == 'Done';
  bool get isCancelled => status == 'Cancelled';
  bool get isTaxEnabled => isTax == 'Y';
  bool get canEdit => isDraft;
  bool get canConfirm => isDraft;
  bool get canValidate => isConfirmed;
  bool get canCancel => isConfirmed;
  bool get canDelete => isDraft;
  bool get hasSSO =>
      serviceSalesOrderEncryption != null &&
      serviceSalesOrderEncryption!.isNotEmpty;
  bool get canCreateSSO => isDone && !hasSSO;
}

class SQCustomerOption {
  final int id;
  final String name;

  SQCustomerOption({required this.id, required this.name});

  factory SQCustomerOption.fromJson(Map<String, dynamic> j) =>
      SQCustomerOption(
        id: _pi(j['id_customer']),
        name: _ps(j['customer_name']),
      );

  @override
  bool operator ==(Object o) => o is SQCustomerOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SQSalesPersonOption {
  final int id;
  final String name;

  SQSalesPersonOption({required this.id, required this.name});

  factory SQSalesPersonOption.fromJson(Map<String, dynamic> j) =>
      SQSalesPersonOption(id: _pi(j['id_user']), name: _ps(j['nama_lengkap']));

  @override bool operator ==(Object o) => o is SQSalesPersonOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class SQPaymentTermOption {
  final int id;
  final String name;

  SQPaymentTermOption({required this.id, required this.name});

  factory SQPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      SQPaymentTermOption(
        id: _pi(j['id_payment_term']),
        name: _ps(j['payment_term_name']),
      );

  @override
  bool operator ==(Object o) => o is SQPaymentTermOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SQPriceListOption {
  final int id;
  final String name;

  SQPriceListOption({required this.id, required this.name});

  factory SQPriceListOption.fromJson(Map<String, dynamic> j) =>
      SQPriceListOption(
        id: _pi(j['id_price_list']),
        name: _ps(j['price_list_name']),
      );

  @override
  bool operator ==(Object o) => o is SQPriceListOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SQServiceOption {
  final int idService;
  final String serviceName;
  final String? description;
  final double unitPrice;

  SQServiceOption({
    required this.idService,
    required this.serviceName,
    this.description,
    this.unitPrice = 0,
  });

  factory SQServiceOption.fromJson(Map<String, dynamic> j) =>
      SQServiceOption(
        idService: _pi(j['id_service']),
        serviceName: _ps(j['service_name'] ?? j['product_name']),
        description: j['description']?.toString(),
        unitPrice: _pd(j['unit_price'] ?? j['sales_price'] ?? 0),
      );

  @override
  bool operator ==(Object o) =>
      o is SQServiceOption && o.idService == idService;

  @override
  int get hashCode => idService.hashCode;
}

class ServiceQuotationFormOptions {
  final List<SQCustomerOption> customers;
  final List<SQSalesPersonOption> salesPersons;
  final List<SQPaymentTermOption> paymentTerms;
  final List<SQPriceListOption> priceLists;
  final List<SQServiceOption> services;
  final double defaultTaxRate;
  final int? currentUserId;

  ServiceQuotationFormOptions({
    required this.customers,
    required this.salesPersons,
    required this.paymentTerms,
    required this.priceLists,
    required this.services,
    this.defaultTaxRate = 11.0,
    this.currentUserId,
  });

  factory ServiceQuotationFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ServiceQuotationFormOptions(
      customers: (data['customers'] as List? ?? [])
          .map((e) => SQCustomerOption.fromJson(e))
          .toList(),
      salesPersons: (data['sales_persons'] as List? ?? [])
          .map((e) => SQSalesPersonOption.fromJson(e))
          .toList(),
      paymentTerms: (data['payment_terms'] as List? ?? [])
          .map((e) => SQPaymentTermOption.fromJson(e))
          .toList(),
      priceLists: (data['price_lists'] as List? ?? [])
          .map((e) => SQPriceListOption.fromJson(e))
          .toList(),
      services: (data['services'] as List? ?? [])
          .map((e) => SQServiceOption.fromJson(e))
          .toList(),
      defaultTaxRate: _pd(data['default_tax_rate']) == 0
          ? 11.0
          : _pd(data['default_tax_rate']),
      currentUserId: _pi(data['current_user_id']) == 0
          ? null
          : _pi(data['current_user_id']),
    );
  }
}

class ServiceQuotationFormItem {
  int? idService;
  String? serviceName;
  String? description;
  double qty;
  double unitPrice;
  double discountRate;
  double discountAmount;
  double taxRate;
  double taxAmount;

  ServiceQuotationFormItem({
    this.idService,
    this.serviceName,
    this.description,
    this.qty = 0,
    this.unitPrice = 0,
    this.discountRate = 0,
    this.discountAmount = 0,
    this.taxRate = 0,
    this.taxAmount = 0,
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
        'amount': untaxedAmount,
      };
}

class ServiceQuotationFormModel {
  int? idServiceQuotation;
  String? encryption;
  String? reference;
  int? idCustomer;
  int? salesPerson;
  int? idPaymentTerm;
  int? idPriceList;
  DateTime? validityDate;
  String? note;
  bool isTax;
  String? discountType;
  List<ServiceQuotationFormItem> items;

  ServiceQuotationFormModel({
    this.idServiceQuotation,
    this.encryption,
    this.reference,
    this.idCustomer,
    this.salesPerson,
    this.idPaymentTerm,
    this.idPriceList,
    this.validityDate,
    this.note,
    this.isTax = false,
    this.discountType,
    List<ServiceQuotationFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idServiceQuotation != null;

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
      if (idServiceQuotation != null)
        'id_service_quotation': idServiceQuotation,
      if (reference != null) 'reference': reference,
      'id_customer': idCustomer,
      'sales_person': salesPerson,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      if (idPriceList != null) 'id_price_list': idPriceList,
      'validity_date':
          validityDate != null ? _fmtDate(validityDate!) : null,
      if (note?.isNotEmpty == true) 'note': note,
      'is_tax': isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'grand_total': grandTotal,
      'status': status,
      'services': items.map((i) => i.toJson()).toList(),
    };
  }

  factory ServiceQuotationFormModel.fromDetail(
    ServiceQuotationDetailModel d,
  ) =>
      ServiceQuotationFormModel(
        idServiceQuotation: d.idServiceQuotation,
        encryption: d.encryption,
        reference: d.reference,
        idCustomer: d.idCustomer,
        salesPerson: d.salesPerson,
        idPaymentTerm: d.idPaymentTerm,
        idPriceList: d.idPriceList,
        validityDate: d.validityDate != null
            ? DateTime.tryParse(d.validityDate!)
            : null,
        note: d.note,
        isTax: d.isTaxEnabled,
        discountType: d.discountType == '' ? null : d.discountType,
        items: d.items
            .map(
              (i) => ServiceQuotationFormItem(
                idService: i.idService,
                serviceName: i.serviceName,
                description: i.description,
                qty: i.qty,
                unitPrice: i.unitPrice,
                discountRate: i.discountRate,
                discountAmount: i.discountAmount,
                taxRate: i.taxRate,
                taxAmount: i.taxAmount,
              ),
            )
            .toList(),
      );
}