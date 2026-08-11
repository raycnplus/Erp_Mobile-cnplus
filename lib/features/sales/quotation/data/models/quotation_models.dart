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

class QuotationModel {
  final String encryption;
  final String status;
  final String? reference;
  final String? customer;
  final String? createdDate;

  QuotationModel({
    required this.encryption,
    required this.status,
    this.reference,
    this.customer,
    this.createdDate,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> j) => QuotationModel(
        encryption: _ps(j['encryption']),
        status: _ps(j['status']),
        reference: j['reference']?.toString(),
        customer: j['customer']?.toString(),
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

class QuotationPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  QuotationPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class QuotationItem {
  final int idQuotationItem;
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

  QuotationItem({
    required this.idQuotationItem,
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

  factory QuotationItem.fromJson(Map<String, dynamic> j) => QuotationItem(
        idQuotationItem: _pi(j['id_quotation_item']),
        idProduct: _pi(j['id_product']),
        unitOfMeasure: _pi(j['unit_of_measure']),
        productName: j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        description: j['description']?.toString(),
        uomName: j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
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

class QuotationAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  QuotationAuditTrail({this.actionByName, this.actionById, this.description, this.type, this.date});

  factory QuotationAuditTrail.fromJson(Map<String, dynamic> j) => QuotationAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById: j['action_by']?.toString(),
        description: j['description']?.toString(),
        type: j['type']?.toString(),
        date: j['date']?.toString(),
      );
}

class QuotationDetailModel {
  final int idQuotation;
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
  final String? salesOrderEncryption;
  final List<QuotationItem> items;
  final List<QuotationAuditTrail> auditTrails;

  QuotationDetailModel({
    required this.idQuotation,
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
    this.salesOrderEncryption,
    required this.items,
    required this.auditTrails,
  });

  factory QuotationDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return QuotationDetailModel(
      idQuotation: _pi(data['id_quotation']),
      encryption: _ps(data['encryption']),
      status: _ps(data['status']),
      reference: data['reference']?.toString(),
      customerName: data['customer_name']?.toString() ?? data['customer_data']?['customer_name']?.toString(),
      sourceWarehouseName: data['source_warehouse_name']?.toString() ??
          data['source_warehouse_data']?['warehouse_name']?.toString(),
      sourceLocationName: data['source_location_name']?.toString() ??
          data['source_location_data']?['location_name']?.toString(),
      idCustomer: _pi(data['id_customer']) == 0 ? null : _pi(data['id_customer']),
      sourceWarehouse: _pi(data['source_warehouse']) == 0 ? null : _pi(data['source_warehouse']),
      sourceLocation: _pi(data['source_location']) == 0 ? null : _pi(data['source_location']),
      salesPerson: _pi(data['sales_person']) == 0 ? null : _pi(data['sales_person']),
      idPaymentTerm: _pi(data['id_payment_term']) == 0 ? null : _pi(data['id_payment_term']),
      idPriceList: _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      salesPersonName:
          data['sales_person_name']?.toString() ?? data['sales_person_data']?['nama_lengkap']?.toString(),
      paymentTermName: data['payment_term_name']?.toString() ??
          data['payment_term_data']?['payment_term_name']?.toString(),
      priceListName: data['price_list_name']?.toString() ?? data['price_list_data']?['price_list_name']?.toString(),
      validityDate: data['validity_date']?.toString(),
      deliveryAddress: data['delivery_address']?.toString(),
      note: data['note']?.toString(),
      discountType: data['discount_type']?.toString(),
      isTax: data['is_tax']?.toString(),
      untaxedAmount: _pd(data['untaxed_amount']),
      totalTaxes: _pd(data['total_taxes']),
      totalDiscount: _pd(data['total_discount']),
      grandTotal: _pd(data['grand_total']),
      defaultTaxRate: _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      cancelledByName: data['cancelled_by_name']?.toString(),
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      cancelledDate: data['cancelled_date']?.toString(),
      cancelledReason: data['cancel_reason']?.toString(),
      salesOrderEncryption: data['sales_order_encryption']?.toString(),
      items: (data['items'] as List? ?? []).map((e) => QuotationItem.fromJson(e)).toList(),
      auditTrails: (data['audit_trails'] as List? ?? []).map((e) => QuotationAuditTrail.fromJson(e)).toList(),
    );
  }

  bool get isDraft => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed => status == 'Confirmed';
  bool get isDone => status == 'Done';
  bool get isCancelled => status == 'Cancelled';
  bool get isTaxEnabled => isTax == 'Y';
  bool get hasDiscountRate => discountType == 'Percentage';
  bool get hasDiscountNominal => discountType == 'Nominal';
  bool get canEdit => isDraft;
  bool get canConfirm => isDraft;
  bool get canValidate => isConfirmed;
  bool get canCancel => isConfirmed;
  bool get canDelete => isDraft;
  bool get canCreateSO => isDone && (salesOrderEncryption == null || salesOrderEncryption!.isEmpty);
  bool get hasSalesOrder => salesOrderEncryption != null && salesOrderEncryption!.isNotEmpty;
}

class CustomerOption {
  final int id;
  final String name;

  CustomerOption({required this.id, required this.name});

  factory CustomerOption.fromJson(Map<String, dynamic> j) =>
      CustomerOption(id: _pi(j['id_customer']), name: _ps(j['customer_name']));

  @override
  bool operator ==(Object o) => o is CustomerOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class WarehouseOption {
  final int id;
  final String name;

  WarehouseOption({required this.id, required this.name});

  factory WarehouseOption.fromJson(Map<String, dynamic> j) =>
      WarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));

  @override
  bool operator ==(Object o) => o is WarehouseOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class LocationOption {
  final int id;
  final int warehouseId;
  final String name;

  LocationOption({required this.id, required this.warehouseId, required this.name});

  factory LocationOption.fromJson(Map<String, dynamic> j) => LocationOption(
        id: _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name: _ps(j['location_name']),
      );

  @override
  bool operator ==(Object o) => o is LocationOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class SalesPersonOption {
  final int id;
  final String name;

  SalesPersonOption({required this.id, required this.name});

  factory SalesPersonOption.fromJson(Map<String, dynamic> j) =>
      SalesPersonOption(id: _pi(j['id_user']), name: _ps(j['nama_lengkap']));

  @override
  bool operator ==(Object o) => o is SalesPersonOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PaymentTermOption {
  final int id;
  final String name;

  PaymentTermOption({required this.id, required this.name});

  factory PaymentTermOption.fromJson(Map<String, dynamic> j) =>
      PaymentTermOption(id: _pi(j['id_payment_term']), name: _ps(j['payment_term_name']));

  @override
  bool operator ==(Object o) => o is PaymentTermOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class PriceListOption {
  final int id;
  final String name;

  PriceListOption({required this.id, required this.name});

  factory PriceListOption.fromJson(Map<String, dynamic> j) =>
      PriceListOption(id: _pi(j['id_price_list']), name: _ps(j['price_list_name']));

  @override
  bool operator ==(Object o) => o is PriceListOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ProductOption {
  final int idProduct;
  final String productName;
  final String? description;
  final double stockQty;

  ProductOption({
    required this.idProduct,
    required this.productName,
    this.description,
    this.stockQty = 0,
  });

  factory ProductOption.fromJson(Map<String, dynamic> j) => ProductOption(
        idProduct: _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
        stockQty: _pd(j['stock_qty'] ?? j['on_hand'] ?? 0),
      );

  @override
  bool operator ==(Object o) => o is ProductOption && o.idProduct == idProduct;

  @override
  int get hashCode => idProduct.hashCode;
}

class UomOption {
  final int id;
  final String name;

  UomOption({required this.id, required this.name});

  factory UomOption.fromJson(Map<String, dynamic> j) =>
      UomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));

  @override
  bool operator ==(Object o) => o is UomOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class QuotationFormOptions {
  final List<CustomerOption> customers;
  final List<WarehouseOption> warehouses;
  final List<LocationOption> locations;
  final List<SalesPersonOption> salesPersons;
  final List<PaymentTermOption> paymentTerms;
  final List<PriceListOption> priceLists;
  final List<UomOption> uoms;
  final double defaultTaxRate;
  final int? currentUserId;

  QuotationFormOptions({
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

  factory QuotationFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return QuotationFormOptions(
      customers: (data['customers'] as List? ?? []).map((e) => CustomerOption.fromJson(e)).toList(),
      warehouses: (data['warehouses'] as List? ?? []).map((e) => WarehouseOption.fromJson(e)).toList(),
      locations: (data['locations'] as List? ?? []).map((e) => LocationOption.fromJson(e)).toList(),
      salesPersons:
          (data['sales_persons'] as List? ?? []).map((e) => SalesPersonOption.fromJson(e)).toList(),
      paymentTerms:
          (data['payment_terms'] as List? ?? []).map((e) => PaymentTermOption.fromJson(e)).toList(),
      priceLists: (data['price_lists'] as List? ?? []).map((e) => PriceListOption.fromJson(e)).toList(),
      uoms: (data['uoms'] as List? ?? []).map((e) => UomOption.fromJson(e)).toList(),
      defaultTaxRate: _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
      currentUserId: _pi(data['current_user_id']) == 0 ? null : _pi(data['current_user_id']),
    );
  }

  List<LocationOption> locationsForWarehouse(int warehouseId) =>
      locations.where((l) => l.warehouseId == warehouseId).toList();
}

class QuotationFormItem {
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

  QuotationFormItem({
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
      discountRate = subtotalBeforeDiscount > 0 ? (discountAmount / subtotalBeforeDiscount * 100) : 0;
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

  QuotationFormItem clone() => QuotationFormItem(
        idProduct: idProduct,
        productName: productName,
        description: description,
        uomId: uomId,
        uomName: uomName,
        demandQty: demandQty,
        unitPrice: unitPrice,
        discountRate: discountRate,
        discountAmount: discountAmount,
        taxRate: taxRate,
        taxAmount: taxAmount,
        onHand: onHand,
      );
}

class QuotationFormModel {
  int? idQuotation;
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
  List<QuotationFormItem> items;

  QuotationFormModel({
    this.idQuotation,
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
    List<QuotationFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idQuotation != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get untaxedAmount => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount => items.fold(0, (s, i) => s + i.discountAmount);
  double get grandTotal => untaxedAmount + totalTaxes;

  void recalcAll(double defaultTaxRate) {
    for (final item in items) {
      item.recalculate(isTaxEnabled: isTax, defaultTaxRate: defaultTaxRate, discountType: discountType);
    }
  }

  bool isValid() =>
      idCustomer != null &&
      sourceWarehouse != null &&
      sourceLocation != null &&
      salesPerson != null &&
      validityDate != null &&
      deliveryAddress.isNotEmpty &&
      items.isNotEmpty;

  Map<String, dynamic> toJson(String status, {double defaultTaxRate = 11.0}) {
    recalcAll(defaultTaxRate);
    return {
      if (idQuotation != null) 'id_quotation': idQuotation,
      if (reference != null) 'reference': reference,
      'id_customer': idCustomer,
      'source_warehouse': sourceWarehouse,
      'source_location': sourceLocation,
      'sales_person': salesPerson,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      if (idPriceList != null) 'id_price_list': idPriceList,
      'validity_date': validityDate != null ? _fmtDate(validityDate!) : null,
      'delivery_address': deliveryAddress,
      if (note != null && note!.isNotEmpty) 'note': note,
      'is_tax': isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'grand_total': grandTotal,
      'status': status,
      'products': items.map((i) => i.toJson()).toList(),
    };
  }
}