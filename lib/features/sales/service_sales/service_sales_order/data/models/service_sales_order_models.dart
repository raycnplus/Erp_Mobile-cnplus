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

class ServiceSalesOrderModel {
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final String? orderDate;
  final double grandTotal;

  ServiceSalesOrderModel({
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.orderDate,
    this.grandTotal = 0,
  });

  factory ServiceSalesOrderModel.fromJson(Map<String, dynamic> j) =>
      ServiceSalesOrderModel(
        encryption: _ps(j['encryption']),
        status: _ps(j['status']),
        reference: j['reference']?.toString(),
        customerName: j['customer_name']?.toString(),
        orderDate: j['order_date']?.toString(),
        grandTotal: _pd(j['grand_total']),
      );

  static const _statusColors = <String, int>{
    'Draft': 0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed': 0xFF1565C0,
    'Done': 0xFF2E7D32,
    'Cancelled': 0xFFC62828,
    'Closed': 0xFF546E7A,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class ServiceSalesOrderPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  ServiceSalesOrderPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class ServiceSalesOrderItem {
  final int idServiceSalesOrderItem;
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

  ServiceSalesOrderItem({
    required this.idServiceSalesOrderItem,
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

  factory ServiceSalesOrderItem.fromJson(Map<String, dynamic> j) =>
      ServiceSalesOrderItem(
        idServiceSalesOrderItem: _pi(j['id_service_sales_order_item']),
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

class ServiceSalesOrderPaymentSchedule {
  final int idPaymentSchedule;
  final String termName;
  final String? dueDate;
  final double amount;
  final double taxAmount;
  final double percentage;
  final String status;
  final String? idServiceInvoice;

  ServiceSalesOrderPaymentSchedule({
    required this.idPaymentSchedule,
    required this.termName,
    this.dueDate,
    required this.amount,
    this.taxAmount = 0,
    required this.percentage,
    required this.status,
    this.idServiceInvoice,
  });

  factory ServiceSalesOrderPaymentSchedule.fromJson(
    Map<String, dynamic> j,
  ) =>
      ServiceSalesOrderPaymentSchedule(
        idPaymentSchedule: _pi(j['id_payment_schedule']),
        termName: _ps(j['term_name']),
        dueDate: j['due_date']?.toString(),
        amount: _pd(j['amount']),
        taxAmount: _pd(j['tax_amount']),
        percentage: _pd(j['percentage']),
        status: _ps(j['status']),
        idServiceInvoice: j['id_service_invoice']?.toString(),
      );

  double get totalAmount => amount + taxAmount;
  bool get isPaid => status == 'Paid';
  bool get isInvoiced => status == 'Invoiced';
  bool get isPending => status == 'Pending';
  bool get canInvoice => isPending;
}

class ServiceSalesOrderAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  ServiceSalesOrderAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory ServiceSalesOrderAuditTrail.fromJson(Map<String, dynamic> j) =>
      ServiceSalesOrderAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById: j['action_by']?.toString(),
        description: j['description']?.toString(),
        type: j['type']?.toString(),
        date: j['date']?.toString(),
      );
}

class ServiceSalesOrderInvoice {
  final int idServiceInvoice;
  final String? encryption;
  final String? reference;
  final String status;
  final double grandTotal;

  ServiceSalesOrderInvoice({
    required this.idServiceInvoice,
    this.encryption,
    this.reference,
    required this.status,
    required this.grandTotal,
  });

  factory ServiceSalesOrderInvoice.fromJson(Map<String, dynamic> j) =>
      ServiceSalesOrderInvoice(
        idServiceInvoice: _pi(j['id_service_invoice']),
        encryption: j['encryption']?.toString(),
        reference: j['reference']?.toString(),
        status: _ps(j['status']),
        grandTotal: _pd(j['grand_total']),
      );
}

class ServiceSalesOrderDetailModel {
  final int idServiceSalesOrder;
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
  final String? orderDate;
  final String? validityDate;
  final String? poNumber;
  final String? sourceDocument;
  final String? note;
  final String? discountType;
  final String? isTax;
  final String paymentType;
  final double untaxedAmount;
  final double totalTaxes;
  final double totalDiscount;
  final double grandTotal;
  final double defaultTaxRate;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? closedByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelledReason;
  final String? closedDate;
  final String? eBupot;
  final String? quotationEncryption;
  final String? invoiceEncryption;
  final List<ServiceSalesOrderItem> items;
  final List<ServiceSalesOrderAuditTrail> auditTrails;
  final List<ServiceSalesOrderPaymentSchedule> paymentSchedules;
  final List<ServiceSalesOrderInvoice> invoices;

  ServiceSalesOrderDetailModel({
    required this.idServiceSalesOrder,
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
    this.orderDate,
    this.validityDate,
    this.poNumber,
    this.sourceDocument,
    this.note,
    this.discountType,
    this.isTax,
    this.paymentType = 'Full',
    required this.untaxedAmount,
    required this.totalTaxes,
    required this.totalDiscount,
    required this.grandTotal,
    this.defaultTaxRate = 11.0,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.closedByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelledReason,
    this.closedDate,
    this.eBupot,
    this.quotationEncryption,
    this.invoiceEncryption,
    required this.items,
    required this.auditTrails,
    required this.paymentSchedules,
    required this.invoices,
  });

  factory ServiceSalesOrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ServiceSalesOrderDetailModel(
      idServiceSalesOrder: _pi(data['id_service_sales_order']),
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
      orderDate: data['order_date']?.toString(),
      validityDate: data['validity_date']?.toString(),
      poNumber: data['po_number']?.toString(),
      sourceDocument: data['source_document']?.toString(),
      note: data['note']?.toString(),
      discountType: data['discount_type']?.toString(),
      isTax: data['is_tax']?.toString(),
      paymentType: data['payment_type']?.toString() ?? 'Full',
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
      closedByName: data['closed_by_name']?.toString(),
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      cancelledDate: data['cancelled_date']?.toString(),
      cancelledReason: data['cancel_reason']?.toString(),
      closedDate: data['closed_date']?.toString(),
      eBupot: data['e_bupot']?.toString(),
      quotationEncryption: data['quotation_encryption']?.toString(),
      invoiceEncryption: data['invoice_encryption']?.toString(),
      items: (data['items'] as List? ?? [])
          .map((e) => ServiceSalesOrderItem.fromJson(e))
          .toList(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => ServiceSalesOrderAuditTrail.fromJson(e))
          .toList(),
      paymentSchedules: (data['payment_schedules'] as List? ?? [])
          .map((e) => ServiceSalesOrderPaymentSchedule.fromJson(e))
          .toList(),
      invoices: (data['invoices'] as List? ?? [])
          .map((e) => ServiceSalesOrderInvoice.fromJson(e))
          .toList(),
    );
  }

  bool get isDraft => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed => status == 'Confirmed';
  bool get isDone => status == 'Done';
  bool get isCancelled => status == 'Cancelled';
  bool get isClosed => status == 'Closed';
  bool get isTaxEnabled => isTax == 'Y';
  bool get isMultiPayment => paymentType == 'Multi';
  bool get canEdit => isDraft;
  bool get canConfirm => isDraft;
  bool get canValidate => isConfirmed;
  bool get canCancel => isConfirmed;
  bool get canClose => isDone;
  bool get canDelete => isDraft;
  bool get hasInvoice =>
      invoiceEncryption != null && invoiceEncryption!.isNotEmpty;
  bool get hasQuotation =>
      quotationEncryption != null && quotationEncryption!.isNotEmpty;
  bool get canCreateInvoice => isDone && !isMultiPayment && !hasInvoice;
}

class SSOCustomerOption {
  final int id;
  final String name;

  SSOCustomerOption({required this.id, required this.name});

  factory SSOCustomerOption.fromJson(Map<String, dynamic> j) =>
      SSOCustomerOption(
        id: _pi(j['id_customer']),
        name: _ps(j['customer_name']),
      );

  @override
  bool operator ==(Object o) => o is SSOCustomerOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SSOSalesPersonOption {
  final int id;
  final String name;

  SSOSalesPersonOption({required this.id, required this.name});

  factory SSOSalesPersonOption.fromJson(Map<String, dynamic> j) =>
      SSOSalesPersonOption(
        id: _pi(j['id_user']),
        name: _ps(j['nama_lengkap']),
      );

  @override
  bool operator ==(Object o) => o is SSOSalesPersonOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SSOPaymentTermOption {
  final int id;
  final String name;

  SSOPaymentTermOption({required this.id, required this.name});

  factory SSOPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      SSOPaymentTermOption(
        id: _pi(j['id_payment_term']),
        name: _ps(j['payment_term_name']),
      );

  @override
  bool operator ==(Object o) => o is SSOPaymentTermOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SSOPriceListOption {
  final int id;
  final String name;

  SSOPriceListOption({required this.id, required this.name});

  factory SSOPriceListOption.fromJson(Map<String, dynamic> j) =>
      SSOPriceListOption(
        id: _pi(j['id_price_list']),
        name: _ps(j['price_list_name']),
      );

  @override
  bool operator ==(Object o) => o is SSOPriceListOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SSOServiceOption {
  final int idService;
  final String serviceName;
  final String? description;
  final double unitPrice;

  SSOServiceOption({
    required this.idService,
    required this.serviceName,
    this.description,
    this.unitPrice = 0,
  });

  factory SSOServiceOption.fromJson(Map<String, dynamic> j) =>
      SSOServiceOption(
        idService: _pi(j['id_service']),
        serviceName: _ps(j['service_name'] ?? j['product_name']),
        description: j['description']?.toString(),
        unitPrice: _pd(j['unit_price'] ?? j['sales_price'] ?? 0),
      );

  @override
  bool operator ==(Object o) =>
      o is SSOServiceOption && o.idService == idService;

  @override
  int get hashCode => idService.hashCode;
}

class ServiceSalesOrderFormOptions {
  final List<SSOCustomerOption> customers;
  final List<SSOSalesPersonOption> salesPersons;
  final List<SSOPaymentTermOption> paymentTerms;
  final List<SSOPriceListOption> priceLists;
  final List<SSOServiceOption> services;
  final double defaultTaxRate;
  final int? currentUserId;

  ServiceSalesOrderFormOptions({
    required this.customers,
    required this.salesPersons,
    required this.paymentTerms,
    required this.priceLists,
    required this.services,
    this.defaultTaxRate = 11.0,
    this.currentUserId,
  });

  factory ServiceSalesOrderFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ServiceSalesOrderFormOptions(
      customers: (data['customers'] as List? ?? [])
          .map((e) => SSOCustomerOption.fromJson(e))
          .toList(),
      salesPersons: (data['sales_persons'] as List? ?? [])
          .map((e) => SSOSalesPersonOption.fromJson(e))
          .toList(),
      paymentTerms: (data['payment_terms'] as List? ?? [])
          .map((e) => SSOPaymentTermOption.fromJson(e))
          .toList(),
      priceLists: (data['price_lists'] as List? ?? [])
          .map((e) => SSOPriceListOption.fromJson(e))
          .toList(),
      services: (data['services'] as List? ?? [])
          .map((e) => SSOServiceOption.fromJson(e))
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

class ServiceSalesOrderFormItem {
  int? idService;
  String? serviceName;
  String? description;
  double qty;
  double unitPrice;
  double discountRate;
  double discountAmount;
  double taxRate;
  double taxAmount;

  ServiceSalesOrderFormItem({
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

class ServiceSalesOrderScheduleItem {
  String termName;
  DateTime? dueDate;
  double amount;
  double percentage;

  ServiceSalesOrderScheduleItem({
    this.termName = '',
    this.dueDate,
    this.amount = 0,
    this.percentage = 0,
  });

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'term_name': termName,
        'due_date': dueDate != null ? _fmtDate(dueDate!) : null,
        'amount': amount,
        'percentage': percentage,
      };
}

class ServiceSalesOrderFormModel {
  int? idServiceSalesOrder;
  String? encryption;
  String? reference;
  int? idCustomer;
  int? salesPerson;
  int? idPaymentTerm;
  int? idPriceList;
  DateTime? orderDate;
  DateTime? validityDate;
  String? poNumber;
  String? sourceDocument;
  String? note;
  bool isTax;
  String? discountType;
  String paymentType;
  List<ServiceSalesOrderFormItem> items;
  List<ServiceSalesOrderScheduleItem> schedules;

  ServiceSalesOrderFormModel({
    this.idServiceSalesOrder,
    this.encryption,
    this.reference,
    this.idCustomer,
    this.salesPerson,
    this.idPaymentTerm,
    this.idPriceList,
    this.orderDate,
    this.validityDate,
    this.poNumber,
    this.sourceDocument,
    this.note,
    this.isTax = false,
    this.discountType,
    this.paymentType = 'Full',
    List<ServiceSalesOrderFormItem>? items,
    List<ServiceSalesOrderScheduleItem>? schedules,
  })  : items = items ?? [],
        schedules = schedules ?? [];

  bool get isEditMode => idServiceSalesOrder != null;
  bool get isMultiPayment => paymentType == 'Multi';

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get untaxedAmount => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount => items.fold(0, (s, i) => s + i.discountAmount);
  double get grandTotal => untaxedAmount + totalTaxes;
  double get totalSchedulePercentage =>
      schedules.fold(0, (s, i) => s + i.percentage);
  double get totalScheduleAmount =>
      schedules.fold(0, (s, i) => s + i.amount);

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
      if (idServiceSalesOrder != null)
        'id_service_sales_order': idServiceSalesOrder,
      if (reference != null) 'reference': reference,
      'id_customer': idCustomer,
      'sales_person': salesPerson,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      if (idPriceList != null) 'id_price_list': idPriceList,
      'order_date': orderDate != null ? _fmtDate(orderDate!) : null,
      'validity_date':
          validityDate != null ? _fmtDate(validityDate!) : null,
      if (poNumber?.isNotEmpty == true) 'po_number': poNumber,
      if (sourceDocument?.isNotEmpty == true)
        'source_document': sourceDocument,
      if (note?.isNotEmpty == true) 'note': note,
      'is_tax': isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'payment_type': paymentType,
      'grand_total': grandTotal,
      'status': status,
      'services': items.map((i) => i.toJson()).toList(),
      if (isMultiPayment && schedules.isNotEmpty)
        'schedules': schedules.map((s) => s.toJson()).toList(),
    };
  }

  factory ServiceSalesOrderFormModel.fromDetail(
    ServiceSalesOrderDetailModel d,
  ) =>
      ServiceSalesOrderFormModel(
        idServiceSalesOrder: d.idServiceSalesOrder,
        encryption: d.encryption,
        reference: d.reference,
        idCustomer: d.idCustomer,
        salesPerson: d.salesPerson,
        idPaymentTerm: d.idPaymentTerm,
        idPriceList: d.idPriceList,
        orderDate:
            d.orderDate != null ? DateTime.tryParse(d.orderDate!) : null,
        validityDate: d.validityDate != null
            ? DateTime.tryParse(d.validityDate!)
            : null,
        poNumber: d.poNumber,
        sourceDocument: d.sourceDocument,
        note: d.note,
        isTax: d.isTaxEnabled,
        discountType: d.discountType == '' ? null : d.discountType,
        paymentType: d.paymentType,
        items: d.items
            .map(
              (i) => ServiceSalesOrderFormItem(
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
        schedules: d.paymentSchedules
            .map(
              (s) => ServiceSalesOrderScheduleItem(
                termName: s.termName,
                dueDate:
                    s.dueDate != null ? DateTime.tryParse(s.dueDate!) : null,
                amount: s.amount,
                percentage: s.percentage,
              ),
            )
            .toList(),
      );
}