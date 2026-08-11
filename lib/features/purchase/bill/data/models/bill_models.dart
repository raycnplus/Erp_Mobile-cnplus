import 'package:flutter/material.dart';

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

class BillModel {
  final int idBill;
  final String encryption;
  final String status;
  final String? reference;
  final String? vendorName;
  final String? createdDate;

  BillModel({
    required this.idBill,
    required this.encryption,
    required this.status,
    this.reference,
    this.vendorName,
    this.createdDate,
  });

  factory BillModel.fromJson(Map<String, dynamic> j) => BillModel(
        idBill: _pi(j['id_bill']),
        encryption: _ps(j['encryption']),
        status: _ps(j['status']),
        reference: j['reference']?.toString(),
        vendorName: j['vendor_name']?.toString(),
        createdDate: j['created_date']?.toString(),
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

class BillPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  BillPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class BillItem {
  final int idBillItem;
  final int idProduct;
  final String? productName;
  final String? description;
  final double demandQty;
  final int unitOfMeasure;
  final String? uomName;
  final double unitPrice;
  final double discountRate;
  final double discountAmount;
  final double taxRate;
  final double taxAmount;
  final double lastPurchasedPrice;
  final double vendorLastPrice;
  final double amount;
  final double subtotal;

  BillItem({
    required this.idBillItem,
    required this.idProduct,
    this.productName,
    this.description,
    required this.demandQty,
    required this.unitOfMeasure,
    this.uomName,
    required this.unitPrice,
    required this.discountRate,
    required this.discountAmount,
    required this.taxRate,
    required this.taxAmount,
    this.lastPurchasedPrice = 0,
    this.vendorLastPrice = 0,
    required this.amount,
    required this.subtotal,
  });

  factory BillItem.fromJson(Map<String, dynamic> j) => BillItem(
        idBillItem: _pi(j['id_bill_item']),
        idProduct: _pi(j['id_product']),
        productName: j['product']?['product_name']?.toString() ??
            j['product_name']?.toString(),
        description: j['description']?.toString(),
        demandQty: _pd(j['demand_qty']),
        unitOfMeasure: _pi(j['unit_of_measure']),
        uomName: j['uom']?['unit_of_measure_name']?.toString(),
        unitPrice: _pd(j['unit_price']),
        discountRate: _pd(j['discount_rate']),
        discountAmount: _pd(j['discount_amount']),
        taxRate: _pd(j['tax_rate']),
        taxAmount: _pd(j['tax_amount']),
        lastPurchasedPrice: _pd(j['last_purchased_price']),
        vendorLastPrice: _pd(j['vendor_last_price']),
        amount: _pd(j['amount']),
        subtotal: _pd(j['subtotal']),
      );

  double get untaxedAmount => subtotal - taxAmount;
}

class BillAccountingEntry {
  final int idEntryDetail;
  final String coaNumber;
  final String coaName;
  final String type;
  final double amount;

  BillAccountingEntry({
    required this.idEntryDetail,
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.amount,
  });

  factory BillAccountingEntry.fromJson(Map<String, dynamic> j) =>
      BillAccountingEntry(
        idEntryDetail: _pi(j['id_entry_detail']),
        coaNumber: j['coa_number']?.toString() ?? '',
        coaName: j['coa_name']?.toString() ?? '',
        type: j['type']?.toString() ?? 'debit',
        amount: _pd(j['amount']),
      );
}

class BillAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;
  final String? image;

  BillAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
    this.image,
  });

  factory BillAuditTrail.fromJson(Map<String, dynamic> j) => BillAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById: j['action_by']?.toString(),
        description: j['description']?.toString(),
        type: j['type']?.toString(),
        date: j['date']?.toString(),
        image: j['image']?.toString(),
      );
}

class BillPaymentDetail {
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final double grandTotal;
  final double paymentAmount;
  final String? paymentDate;
  final String? paymentEncryption;

  BillPaymentDetail({
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    required this.grandTotal,
    required this.paymentAmount,
    this.paymentDate,
    this.paymentEncryption,
  });

  factory BillPaymentDetail.fromJson(Map<String, dynamic> j) =>
      BillPaymentDetail(
        bankName: j['bank_name']?.toString(),
        bankAccountName: j['bank_account_name']?.toString(),
        bankAccountNumber: j['bank_account_number']?.toString(),
        grandTotal: _pd(j['grand_total']),
        paymentAmount: _pd(j['payment_amount']),
        paymentDate: j['payment_date']?.toString(),
        paymentEncryption: j['payment_encryption']?.toString(),
      );
}

class BillDetailModel {
  final int idBill;
  final String encryption;
  final String status;
  final String? reference;
  final int? idVendor;
  final String? vendorName;
  final String? billDate;
  final String? orderDeadline;
  final String? expectedArrival;
  final int? idPriceList;
  final String? priceListName;
  final int? idPaymentTerm;
  final String? paymentTermName;
  final String? dueDate;
  final String? note;
  final String? discountType;
  final String? isTax;
  final double untaxedAmount;
  final double totalTaxes;
  final double totalDiscount;
  final double grandTotal;
  final double defaultTaxRate;
  final int? idPurchaseOrder;
  final String? poEncryption;
  final String? poReference;
  final String? paymentInfo;
  final String? paymentInfoClass;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelReason;
  final String? validatedDate;
  final List<BillItem> items;
  final List<BillAuditTrail> auditTrails;
  final List<BillAccountingEntry> accountingEntries;
  final BillPaymentDetail? paymentDetails;

  BillDetailModel({
    required this.idBill,
    required this.encryption,
    required this.status,
    this.reference,
    this.idVendor,
    this.vendorName,
    this.billDate,
    this.orderDeadline,
    this.expectedArrival,
    this.idPriceList,
    this.priceListName,
    this.idPaymentTerm,
    this.paymentTermName,
    this.dueDate,
    this.note,
    this.discountType,
    this.isTax,
    required this.untaxedAmount,
    required this.totalTaxes,
    required this.totalDiscount,
    required this.grandTotal,
    this.defaultTaxRate = 11.0,
    this.idPurchaseOrder,
    this.poEncryption,
    this.poReference,
    this.paymentInfo,
    this.paymentInfoClass,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelReason,
    this.validatedDate,
    required this.items,
    required this.auditTrails,
    required this.accountingEntries,
    this.paymentDetails,
  });

  factory BillDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final pdRaw = data['payment_details'];
    return BillDetailModel(
      idBill: _pi(data['id_bill']),
      encryption: _ps(data['encryption']),
      status: _ps(data['status']),
      reference: data['reference']?.toString(),
      idVendor: _pi(data['id_vendor']) == 0 ? null : _pi(data['id_vendor']),
      vendorName: data['vendor']?['vendor_name']?.toString() ?? data['vendor_name']?.toString(),
      billDate: data['bill_date']?.toString(),
      orderDeadline: data['order_deadline']?.toString(),
      expectedArrival: data['expected_arrival']?.toString(),
      idPriceList: _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      priceListName: data['price_list_name']?.toString(),
      idPaymentTerm: _pi(data['id_payment_term']) == 0 ? null : _pi(data['id_payment_term']),
      paymentTermName: data['payment_term_name']?.toString(),
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
      idPurchaseOrder: _pi(data['id_purchase_order']) == 0
          ? null
          : _pi(data['id_purchase_order']),
      poEncryption: data['po_encryption']?.toString(),
      poReference: data['po_reference']?.toString(),
      paymentInfo: data['payment_info']?.toString(),
      paymentInfoClass: data['payment_info_class']?.toString(),
      createdByName: data['created_by_name']?.toString(),
      updatedByName: data['updated_by_name']?.toString(),
      cancelledByName: data['cancelled_by_name']?.toString(),
      createdDate: data['created_date']?.toString(),
      updatedDate: data['updated_date']?.toString(),
      cancelledDate: data['cancelled_date']?.toString(),
      cancelReason: data['cancel_reason']?.toString(),
      validatedDate: data['validated_date']?.toString(),
      items: (data['items'] as List? ?? [])
          .map((e) => BillItem.fromJson(e))
          .toList(),
      auditTrails: (data['audit_trails'] as List? ?? [])
          .map((e) => BillAuditTrail.fromJson(e))
          .toList(),
      accountingEntries: (data['accounting_entries'] as List? ?? [])
          .map((e) => BillAccountingEntry.fromJson(e))
          .toList(),
      paymentDetails: pdRaw is Map
          ? BillPaymentDetail.fromJson(Map<String, dynamic>.from(pdRaw))
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
  bool get hasPurchaseOrder =>
      idPurchaseOrder != null && (poEncryption?.isNotEmpty ?? false);

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

class BillVendorOption {
  final int id;
  final String name;

  BillVendorOption({required this.id, required this.name});

  factory BillVendorOption.fromJson(Map<String, dynamic> j) =>
      BillVendorOption(id: _pi(j['id_vendor']), name: _ps(j['vendor_name']));

  @override
  bool operator ==(Object o) => o is BillVendorOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BillPaymentTermOption {
  final int id;
  final String name;

  BillPaymentTermOption({required this.id, required this.name});

  factory BillPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      BillPaymentTermOption(
        id: _pi(j['id_payment_term']),
        name: _ps(j['payment_term_name']),
      );

  @override
  bool operator ==(Object o) => o is BillPaymentTermOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BillPriceListOption {
  final int id;
  final String name;

  BillPriceListOption({required this.id, required this.name});

  factory BillPriceListOption.fromJson(Map<String, dynamic> j) =>
      BillPriceListOption(
        id: _pi(j['id_price_list']),
        name: _ps(j['price_list_name']),
      );

  @override
  bool operator ==(Object o) => o is BillPriceListOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BillProductOption {
  final int idProduct;
  final String productName;
  final String? description;

  BillProductOption({
    required this.idProduct,
    required this.productName,
    this.description,
  });

  factory BillProductOption.fromJson(Map<String, dynamic> j) =>
      BillProductOption(
        idProduct: _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
      );

  @override
  bool operator ==(Object o) => o is BillProductOption && o.idProduct == idProduct;

  @override
  int get hashCode => idProduct.hashCode;
}

class BillUomOption {
  final int id;
  final String name;

  BillUomOption({required this.id, required this.name});

  factory BillUomOption.fromJson(Map<String, dynamic> j) => BillUomOption(
        id: _pi(j['id_unit_of_measure']),
        name: _ps(j['unit_of_measure_name']),
      );

  @override
  bool operator ==(Object o) => o is BillUomOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BillFormOptions {
  final List<BillVendorOption> vendors;
  final List<BillPaymentTermOption> paymentTerms;
  final List<BillPriceListOption> priceLists;
  final List<BillProductOption> products;
  final List<BillUomOption> uoms;
  final double defaultTaxRate;
  final bool autoCreateJournal;

  BillFormOptions({
    required this.vendors,
    required this.paymentTerms,
    required this.priceLists,
    required this.products,
    required this.uoms,
    this.defaultTaxRate = 11.0,
    this.autoCreateJournal = false,
  });

  factory BillFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return BillFormOptions(
      vendors: (data['vendors'] as List? ?? [])
          .map((e) => BillVendorOption.fromJson(e))
          .toList(),
      paymentTerms: (data['payment_terms'] as List? ?? [])
          .map((e) => BillPaymentTermOption.fromJson(e))
          .toList(),
      priceLists: (data['price_lists'] as List? ?? [])
          .map((e) => BillPriceListOption.fromJson(e))
          .toList(),
      products: (data['products'] as List? ?? [])
          .map((e) => BillProductOption.fromJson(e))
          .toList(),
      uoms: (data['uoms'] as List? ?? [])
          .map((e) => BillUomOption.fromJson(e))
          .toList(),
      defaultTaxRate: _pd(data['default_tax_rate']) == 0
          ? 11.0
          : _pd(data['default_tax_rate']),
      autoCreateJournal:
          data['auto_create_journal'] == true || data['auto_create_journal'] == 1,
    );
  }
}

class BillFormItem {
  int? idProduct;
  String? productName;
  String? description;
  double demandQty;
  int? unitOfMeasure;
  String? uomName;
  double unitPrice;
  double discountRate;
  double discountAmount;
  double taxRate;
  double taxAmount;
  double lastPurchasedPrice;
  double vendorLastPrice;

  BillFormItem({
    this.idProduct,
    this.productName,
    this.description,
    this.demandQty = 0,
    this.unitOfMeasure,
    this.uomName,
    this.unitPrice = 0,
    this.discountRate = 0,
    this.discountAmount = 0,
    this.taxRate = 0,
    this.taxAmount = 0,
    this.lastPurchasedPrice = 0,
    this.vendorLastPrice = 0,
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
        'unit_of_measure': unitOfMeasure,
        'unit_price': unitPrice,
        'discount_rate': discountRate,
        'discount_amount': discountAmount,
        'last_purchased_price': lastPurchasedPrice,
        'vendor_last_price': vendorLastPrice,
        'amount': untaxedAmount,
      };
}

class BillFormModel {
  int? idBill;
  String? encryption;
  String? reference;
  int? idVendor;
  DateTime? billDate;
  DateTime? orderDeadline;
  DateTime? expectedArrival;
  int? idPriceList;
  int? idPaymentTerm;
  String? note;
  bool isTax;
  String? discountType;
  DateTime? journalTransactionDate;
  List<BillFormItem> items;

  BillFormModel({
    this.idBill,
    this.encryption,
    this.reference,
    this.idVendor,
    this.billDate,
    this.orderDeadline,
    this.expectedArrival,
    this.idPriceList,
    this.idPaymentTerm,
    this.note,
    this.isTax = false,
    this.discountType,
    this.journalTransactionDate,
    List<BillFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idBill != null;

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
      if (idBill != null) 'id_bill': idBill,
      if (reference != null) 'reference': reference,
      'id_vendor': idVendor,
      'bill_date': billDate != null ? _fmtDate(billDate!) : null,
      'order_deadline':
          orderDeadline != null ? _fmtDate(orderDeadline!) : null,
      'expected_arrival':
          expectedArrival != null ? _fmtDate(expectedArrival!) : null,
      if (idPriceList != null) 'id_price_list': idPriceList,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      if (note?.isNotEmpty == true) 'note': note,
      'is_tax': isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'grand_total': grandTotal,
      'status': status,
      'products': items.map((i) => i.toJson()).toList(),
      if (status == 'validate' && journalTransactionDate != null)
        'journal_transaction_date': _fmtDate(journalTransactionDate!),
    };
  }

  factory BillFormModel.fromDetail(BillDetailModel d) => BillFormModel(
        idBill: d.idBill,
        encryption: d.encryption,
        reference: d.reference,
        idVendor: d.idVendor,
        billDate: d.billDate != null ? DateTime.tryParse(d.billDate!) : null,
        orderDeadline: d.orderDeadline != null
            ? DateTime.tryParse(d.orderDeadline!)
            : null,
        expectedArrival: d.expectedArrival != null
            ? DateTime.tryParse(d.expectedArrival!)
            : null,
        idPriceList: d.idPriceList,
        idPaymentTerm: d.idPaymentTerm,
        note: d.note,
        isTax: d.isTaxEnabled,
        discountType: d.discountType == '' ? null : d.discountType,
        items: d.items
            .map(
              (i) => BillFormItem(
                idProduct: i.idProduct,
                productName: i.productName,
                description: i.description,
                demandQty: i.demandQty,
                unitOfMeasure: i.unitOfMeasure,
                uomName: i.uomName,
                unitPrice: i.unitPrice,
                discountRate: i.discountRate,
                discountAmount: i.discountAmount,
                taxRate: i.taxRate,
                taxAmount: i.taxAmount,
                lastPurchasedPrice: i.lastPurchasedPrice,
                vendorLastPrice: i.vendorLastPrice,
              ),
            )
            .toList(),
      );
}