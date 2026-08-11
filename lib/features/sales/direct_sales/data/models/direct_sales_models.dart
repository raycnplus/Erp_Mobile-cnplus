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

class DirectSalesModel {
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final String? createdDate;
  final double grandTotal;

  DirectSalesModel({
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.createdDate,
    this.grandTotal = 0,
  });

  factory DirectSalesModel.fromJson(Map<String, dynamic> j) =>
      DirectSalesModel(
        encryption: _ps(j['encryption']),
        status: _ps(j['status']),
        reference: j['reference']?.toString(),
        customerName: j['customer_name']?.toString(),
        createdDate: j['created_date']?.toString(),
        grandTotal: _pd(j['grand_total']),
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

class DirectSalesPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  DirectSalesPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class DirectSalesItem {
  final int idDirectSalesItem;
  final int idProduct;
  final int unitOfMeasure;
  final String? productName;
  final String? description;
  final String? uomName;
  final double demandQty;
  final double unitPrice;
  final double discountRate;
  final double discountAmount;
  final double taxRate;
  final double taxAmount;
  final double subtotal;
  double onHand;

  DirectSalesItem({
    required this.idDirectSalesItem,
    required this.idProduct,
    required this.unitOfMeasure,
    this.productName,
    this.description,
    this.uomName,
    required this.demandQty,
    required this.unitPrice,
    required this.discountRate,
    required this.discountAmount,
    required this.taxRate,
    required this.taxAmount,
    required this.subtotal,
    this.onHand = 0,
  });

  factory DirectSalesItem.fromJson(Map<String, dynamic> j) =>
      DirectSalesItem(
        idDirectSalesItem: _pi(j['id_direct_sales_item']),
        idProduct: _pi(j['id_product']),
        unitOfMeasure: _pi(j['unit_of_measure']),
        productName: j['product']?['product_name']?.toString() ??
            j['product_name']?.toString(),
        description: j['description']?.toString(),
        uomName: j['uom']?['unit_of_measure_name']?.toString() ??
            j['uom_name']?.toString(),
        demandQty: _pd(j['demand_qty']),
        unitPrice: _pd(j['unit_price']),
        discountRate: _pd(j['discount_rate']),
        discountAmount: _pd(j['discount_amount']),
        taxRate: _pd(j['tax_rate']),
        taxAmount: _pd(j['tax_amount']),
        subtotal: _pd(j['subtotal']),
        onHand: _pd(j['on_hand']),
      );

  double get untaxedAmount => subtotal - taxAmount;
}

class DirectSalesPaymentSchedule {
  final int idPaymentSchedule;
  final String termName;
  final String? dueDate;
  final double amount;
  final double percentage;
  final String status;
  final String? idInvoice;

  DirectSalesPaymentSchedule({
    required this.idPaymentSchedule,
    required this.termName,
    this.dueDate,
    required this.amount,
    required this.percentage,
    required this.status,
    this.idInvoice,
  });

  factory DirectSalesPaymentSchedule.fromJson(Map<String, dynamic> j) =>
      DirectSalesPaymentSchedule(
        idPaymentSchedule: _pi(j['id_payment_schedule']),
        termName: _ps(j['term_name']),
        dueDate: j['due_date']?.toString(),
        amount: _pd(j['amount']),
        percentage: _pd(j['percentage']),
        status: _ps(j['status']),
        idInvoice: j['id_invoice']?.toString(),
      );

  bool get isPaid => status == 'Paid';
  bool get isInvoiced => status == 'Invoiced';
  bool get isPending => status == 'Pending';
  bool get canInvoice => isPending;
}

class DirectSalesAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  DirectSalesAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory DirectSalesAuditTrail.fromJson(Map<String, dynamic> j) =>
      DirectSalesAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById: j['action_by']?.toString(),
        description: j['description']?.toString(),
        type: j['type']?.toString(),
        date: j['date']?.toString(),
      );
}

class DirectSalesInvoice {
  final int idInvoice;
  final String? encryption;
  final String? reference;
  final String status;
  final double grandTotal;

  DirectSalesInvoice({
    required this.idInvoice,
    this.encryption,
    this.reference,
    required this.status,
    required this.grandTotal,
  });

  factory DirectSalesInvoice.fromJson(Map<String, dynamic> j) =>
      DirectSalesInvoice(
        idInvoice: _pi(j['id_invoice']),
        encryption: j['encryption']?.toString(),
        reference: j['reference']?.toString(),
        status: _ps(j['status']),
        grandTotal: _pd(j['grand_total']),
      );
}

class DirectSalesDetailModel {
  final int idDirectSales;
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final String? sourceWarehouseName;
  final String? sourceLocationName;
  final int? idCustomer;
  final int? sourceWarehouse;
  final int? sourceLocation;
  final int? salesPerson;
  final int? idPaymentTerm;
  final int? idPriceList;
  final String? salesPersonName;
  final String? paymentTermName;
  final String? priceListName;
  final String? validityDate;
  final String? deliveryAddress;
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
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelledReason;
  final String? eBupot;
  final String? invoiceEncryption;
  final String? deliveryNoteEncryption;
  final List<DirectSalesItem> items;
  final List<DirectSalesAuditTrail> auditTrails;
  final List<DirectSalesPaymentSchedule> paymentSchedules;
  final List<DirectSalesInvoice> invoices;

  DirectSalesDetailModel({
    required this.idDirectSales,
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.sourceWarehouseName,
    this.sourceLocationName,
    this.idCustomer,
    this.sourceWarehouse,
    this.sourceLocation,
    this.salesPerson,
    this.idPaymentTerm,
    this.idPriceList,
    this.salesPersonName,
    this.paymentTermName,
    this.priceListName,
    this.validityDate,
    this.deliveryAddress,
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
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelledReason,
    this.eBupot,
    this.invoiceEncryption,
    this.deliveryNoteEncryption,
    required this.items,
    required this.auditTrails,
    required this.paymentSchedules,
    required this.invoices,
  });

  factory DirectSalesDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DirectSalesDetailModel(
      idDirectSales: _pi(data['id_direct_sales']),
      encryption: _ps(data['encryption']),
      status: _ps(data['status']),
      reference: data['reference']?.toString(),
      customerName: data['customer_name']?.toString() ??
          data['customer']?['customer_name']?.toString(),
      sourceWarehouseName: data['source_warehouse_name']?.toString() ??
          data['warehouse']?['warehouse_name']?.toString(),
      sourceLocationName: data['source_location_name']?.toString() ??
          data['location']?['location_name']?.toString(),
      idCustomer:
          _pi(data['id_customer']) == 0 ? null : _pi(data['id_customer']),
      sourceWarehouse: _pi(data['source_warehouse']) == 0
          ? null
          : _pi(data['source_warehouse']),
      sourceLocation: _pi(data['source_location']) == 0
          ? null
          : _pi(data['source_location']),
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
      deliveryAddress: data['delivery_address']?.toString(),
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
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      cancelledDate: data['cancelled_date']?.toString(),
      cancelledReason: data['cancel_reason']?.toString(),
      eBupot: data['e_bupot']?.toString(),
      invoiceEncryption: data['invoice_encryption']?.toString(),
      deliveryNoteEncryption: data['delivery_note_encryption']?.toString(),
      items: (data['items'] as List? ?? [])
          .map((e) => DirectSalesItem.fromJson(e))
          .toList(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => DirectSalesAuditTrail.fromJson(e))
          .toList(),
      paymentSchedules: (data['payment_schedules'] as List? ?? [])
          .map((e) => DirectSalesPaymentSchedule.fromJson(e))
          .toList(),
      invoices: (data['invoices'] as List? ?? [])
          .map((e) => DirectSalesInvoice.fromJson(e))
          .toList(),
    );
  }

  bool get isDraft => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed => status == 'Confirmed';
  bool get isDone => status == 'Done';
  bool get isCancelled => status == 'Cancelled';
  bool get isTaxEnabled => isTax == 'Y';
  bool get isMultiPayment => paymentType == 'Multi';
  bool get canEdit => isDraft;
  bool get canConfirm => isDraft;
  bool get canValidate => isConfirmed;
  bool get canCancel => isConfirmed;
  bool get canDelete => isDraft;
  bool get hasInvoice =>
      invoiceEncryption != null && invoiceEncryption!.isNotEmpty;
  bool get hasDeliveryNote =>
      deliveryNoteEncryption != null && deliveryNoteEncryption!.isNotEmpty;
  bool get canCreateInvoice => isDone && !isMultiPayment && !hasInvoice;
}

class DSCustomerOption {
  final int id;
  final String name;

  DSCustomerOption({required this.id, required this.name});

  factory DSCustomerOption.fromJson(Map<String, dynamic> j) =>
      DSCustomerOption(
        id: _pi(j['id_customer']),
        name: _ps(j['customer_name']),
      );

  @override
  bool operator ==(Object o) => o is DSCustomerOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DSWarehouseOption {
  final int id;
  final String name;

  DSWarehouseOption({required this.id, required this.name});

  factory DSWarehouseOption.fromJson(Map<String, dynamic> j) =>
      DSWarehouseOption(
        id: _pi(j['id_warehouse']),
        name: _ps(j['warehouse_name']),
      );

  @override
  bool operator ==(Object o) => o is DSWarehouseOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DSLocationOption {
  final int id;
  final int warehouseId;
  final String name;

  DSLocationOption({
    required this.id,
    required this.warehouseId,
    required this.name,
  });

  factory DSLocationOption.fromJson(Map<String, dynamic> j) =>
      DSLocationOption(
        id: _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name: _ps(j['location_name']),
      );

  @override
  bool operator ==(Object o) => o is DSLocationOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DSSalesPersonOption {
  final int id;
  final String name;

  DSSalesPersonOption({required this.id, required this.name});

  factory DSSalesPersonOption.fromJson(Map<String, dynamic> j) =>
      DSSalesPersonOption(
        id: _pi(j['id_user']),
        name: _ps(j['nama_lengkap']),
      );

  @override
  bool operator ==(Object o) => o is DSSalesPersonOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DSPaymentTermOption {
  final int id;
  final String name;

  DSPaymentTermOption({required this.id, required this.name});

  factory DSPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      DSPaymentTermOption(
        id: _pi(j['id_payment_term']),
        name: _ps(j['payment_term_name']),
      );

  @override
  bool operator ==(Object o) => o is DSPaymentTermOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DSPriceListOption {
  final int id;
  final String name;

  DSPriceListOption({required this.id, required this.name});

  factory DSPriceListOption.fromJson(Map<String, dynamic> j) =>
      DSPriceListOption(
        id: _pi(j['id_price_list']),
        name: _ps(j['price_list_name']),
      );

  @override
  bool operator ==(Object o) => o is DSPriceListOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DSProductOption {
  final int idProduct;
  final String productName;
  final String? description;
  final double stockQty;

  DSProductOption({
    required this.idProduct,
    required this.productName,
    this.description,
    this.stockQty = 0,
  });

  factory DSProductOption.fromJson(Map<String, dynamic> j) =>
      DSProductOption(
        idProduct: _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
        stockQty: _pd(j['stock_qty'] ?? j['on_hand'] ?? 0),
      );

  @override
  bool operator ==(Object o) =>
      o is DSProductOption && o.idProduct == idProduct;

  @override
  int get hashCode => idProduct.hashCode;
}

class DSUomOption {
  final int id;
  final String name;

  DSUomOption({required this.id, required this.name});

  factory DSUomOption.fromJson(Map<String, dynamic> j) =>
      DSUomOption(
        id: _pi(j['id_unit_of_measure']),
        name: _ps(j['unit_of_measure_name']),
      );

  @override
  bool operator ==(Object o) => o is DSUomOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class DirectSalesFormOptions {
  final List<DSCustomerOption> customers;
  final List<DSWarehouseOption> warehouses;
  final List<DSLocationOption> locations;
  final List<DSSalesPersonOption> salesPersons;
  final List<DSPaymentTermOption> paymentTerms;
  final List<DSPriceListOption> priceLists;
  final List<DSUomOption> uoms;
  final double defaultTaxRate;
  final int? currentUserId;

  DirectSalesFormOptions({
    required this.customers,
    required this.warehouses,
    required this.locations,
    required this.salesPersons,
    required this.paymentTerms,
    required this.priceLists,
    required this.uoms,
    this.defaultTaxRate = 11.0,
    this.currentUserId,
  });

  factory DirectSalesFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DirectSalesFormOptions(
      customers: (data['customers'] as List? ?? [])
          .map((e) => DSCustomerOption.fromJson(e))
          .toList(),
      warehouses: (data['warehouses'] as List? ?? [])
          .map((e) => DSWarehouseOption.fromJson(e))
          .toList(),
      locations: (data['locations'] as List? ?? [])
          .map((e) => DSLocationOption.fromJson(e))
          .toList(),
      salesPersons: (data['sales_persons'] as List? ?? [])
          .map((e) => DSSalesPersonOption.fromJson(e))
          .toList(),
      paymentTerms: (data['payment_terms'] as List? ?? [])
          .map((e) => DSPaymentTermOption.fromJson(e))
          .toList(),
      priceLists: (data['price_lists'] as List? ?? [])
          .map((e) => DSPriceListOption.fromJson(e))
          .toList(),
      uoms: (data['uoms'] as List? ?? [])
          .map((e) => DSUomOption.fromJson(e))
          .toList(),
      defaultTaxRate: _pd(data['default_tax_rate']) == 0
          ? 11.0
          : _pd(data['default_tax_rate']),
      currentUserId: _pi(data['current_user_id']) == 0
          ? null
          : _pi(data['current_user_id']),
    );
  }

  List<DSLocationOption> locationsForWarehouse(int warehouseId) =>
      locations.where((l) => l.warehouseId == warehouseId).toList();
}

class DirectSalesFormItem {
  int? idProduct;
  String? productName;
  String? description;
  int? uomId;
  String? uomName;
  double demandQty;
  double unitPrice;
  double discountRate;
  double discountAmount;
  double taxRate;
  double taxAmount;
  double onHand;

  DirectSalesFormItem({
    this.idProduct,
    this.productName,
    this.description,
    this.uomId,
    this.uomName,
    this.demandQty = 0,
    this.unitPrice = 0,
    this.discountRate = 0,
    this.discountAmount = 0,
    this.taxRate = 0,
    this.taxAmount = 0,
    this.onHand = 0,
  });

  double get subtotalBeforeDiscount => demandQty * unitPrice;
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
        'id_product': idProduct,
        'description': description ?? '',
        'demand_qty': demandQty,
        'unit_of_measure': uomId,
        'unit_price': unitPrice,
        'discount_rate': discountRate,
        'discount_amount': discountAmount,
        'tax_rate': taxRate,
        'amount': untaxedAmount,
      };
}

class DirectSalesScheduleItem {
  String termName;
  DateTime? dueDate;
  double amount;
  double percentage;

  DirectSalesScheduleItem({
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

class DirectSalesFormModel {
  int? idDirectSales;
  String? encryption;
  String? reference;
  int? idCustomer;
  int? sourceWarehouse;
  int? sourceLocation;
  int? salesPerson;
  int? idPaymentTerm;
  int? idPriceList;
  DateTime? validityDate;
  String deliveryAddress;
  String? note;
  bool isTax;
  String? discountType;
  String paymentType;
  List<DirectSalesFormItem> items;
  List<DirectSalesScheduleItem> schedules;

  DirectSalesFormModel({
    this.idDirectSales,
    this.encryption,
    this.reference,
    this.idCustomer,
    this.sourceWarehouse,
    this.sourceLocation,
    this.salesPerson,
    this.idPaymentTerm,
    this.idPriceList,
    this.validityDate,
    this.deliveryAddress = '',
    this.note,
    this.isTax = false,
    this.discountType,
    this.paymentType = 'Full',
    List<DirectSalesFormItem>? items,
    List<DirectSalesScheduleItem>? schedules,
  })  : items = items ?? [],
        schedules = schedules ?? [];

  bool get isEditMode => idDirectSales != null;
  bool get isMultiPayment => paymentType == 'Multi';

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get untaxedAmount => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount => items.fold(0, (s, i) => s + i.discountAmount);
  double get grandTotal => untaxedAmount + totalTaxes;
  double get totalSchedulePercentage =>
      schedules.fold(0, (s, i) => s + i.percentage);

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
      if (idDirectSales != null) 'id_direct_sales': idDirectSales,
      if (reference != null) 'reference': reference,
      'id_customer': idCustomer,
      'source_warehouse': sourceWarehouse,
      'source_location': sourceLocation,
      'sales_person': salesPerson,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      if (idPriceList != null) 'id_price_list': idPriceList,
      'validity_date':
          validityDate != null ? _fmtDate(validityDate!) : null,
      'delivery_address': deliveryAddress,
      if (note != null && note!.isNotEmpty) 'note': note,
      'is_tax': isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'payment_type': paymentType,
      'grand_total': grandTotal,
      'status': status,
      'products': items.map((i) => i.toJson()).toList(),
      if (isMultiPayment && schedules.isNotEmpty)
        'schedules': schedules.map((s) => s.toJson()).toList(),
    };
  }

  factory DirectSalesFormModel.fromDetail(DirectSalesDetailModel d) =>
      DirectSalesFormModel(
        idDirectSales: d.idDirectSales,
        encryption: d.encryption,
        reference: d.reference,
        idCustomer: d.idCustomer,
        sourceWarehouse: d.sourceWarehouse,
        sourceLocation: d.sourceLocation,
        salesPerson: d.salesPerson,
        idPaymentTerm: d.idPaymentTerm,
        idPriceList: d.idPriceList,
        validityDate: d.validityDate != null
            ? DateTime.tryParse(d.validityDate!)
            : null,
        deliveryAddress: d.deliveryAddress ?? '',
        note: d.note,
        isTax: d.isTaxEnabled,
        discountType: d.discountType == '' ? null : d.discountType,
        paymentType: d.paymentType,
        items: d.items
            .map(
              (i) => DirectSalesFormItem(
                idProduct: i.idProduct,
                productName: i.productName,
                description: i.description,
                uomId: i.unitOfMeasure,
                uomName: i.uomName,
                demandQty: i.demandQty,
                unitPrice: i.unitPrice,
                discountRate: i.discountRate,
                discountAmount: i.discountAmount,
                taxRate: i.taxRate,
                taxAmount: i.taxAmount,
                onHand: i.onHand,
              ),
            )
            .toList(),
        schedules: d.paymentSchedules
            .map(
              (s) => DirectSalesScheduleItem(
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