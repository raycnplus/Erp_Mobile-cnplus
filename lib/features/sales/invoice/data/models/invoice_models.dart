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

class InvoiceModel {
  final String encryption;
  final String status;
  final String? reference;
  final String? customerName;
  final String? invoiceDate;
  final String? termName;

  InvoiceModel({
    required this.encryption,
    required this.status,
    this.reference,
    this.customerName,
    this.invoiceDate,
    this.termName,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> j) => InvoiceModel(
        encryption:   _ps(j['encryption']),
        status:       _ps(j['status']),
        reference:    j['reference']?.toString(),
        customerName: j['customer_name']?.toString(),
        invoiceDate:  j['invoice_date']?.toString(),
        termName:     j['term_name']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed':        0xFF1565C0,
    'Posted':           0xFF2E7D32,
    'Cancelled':        0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class InvoicePaginationMeta {
  final int currentPage, lastPage, perPage, total;

  InvoicePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class InvoiceItem {
  final int idInvoiceItem;
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
  final double pph23Rate;
  final double pph23Amount;
  final double subtotal;
  double onHand;

  InvoiceItem({
    required this.idInvoiceItem,
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
    required this.pph23Rate,
    required this.pph23Amount,
    required this.subtotal,
    this.onHand = 0,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> j) => InvoiceItem(
        idInvoiceItem:  _pi(j['id_invoice_item']),
        idProduct:      _pi(j['id_product']),
        unitOfMeasure:  _pi(j['unit_of_measure']),
        productName:    j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        description:    j['description']?.toString(),
        uomName:        j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        demandQty:      _pd(j['demand_qty']),
        unitPrice:      _pd(j['unit_price']),
        discountRate:   _pd(j['discount_rate']),
        discountAmount: _pd(j['discount_amount']),
        taxRate:        _pd(j['tax_rate']),
        taxAmount:      _pd(j['tax_amount']),
        pph23Rate:      _pd(j['pph_23_rate']),
        pph23Amount:    _pd(j['pph_23_amount']),
        subtotal:       _pd(j['subtotal']),
        onHand:         _pd(j['on_hand']),
      );

  double get untaxedAmount => subtotal - taxAmount;
}

class InvoiceAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  InvoiceAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory InvoiceAuditTrail.fromJson(Map<String, dynamic> j) => InvoiceAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class AccountingEntryDetail {
  final int idEntryDetail;
  final String coaNumber;
  final String coaName;
  final String type;
  final double amount;
  final String? reference;
  final String? description;
  final String? transactionDate;

  AccountingEntryDetail({
    required this.idEntryDetail,
    required this.coaNumber,
    required this.coaName,
    required this.type,
    required this.amount,
    this.reference,
    this.description,
    this.transactionDate,
  });

  factory AccountingEntryDetail.fromJson(Map<String, dynamic> j) => AccountingEntryDetail(
        idEntryDetail:   _pi(j['id_entry_detail']),
        coaNumber:       _ps(j['coa_number']),
        coaName:         _ps(j['coa_name']),
        type:            _ps(j['type']),
        amount:          _pd(j['amount']),
        reference:       j['reference']?.toString(),
        description:     j['entry_description']?.toString(),
        transactionDate: j['transaction_date']?.toString(),
      );

  bool get isDebit  => type.toLowerCase() == 'debit';
  bool get isCredit => type.toLowerCase() == 'credit';
}

class InvoicePaymentDetail {
  final int? idPayment;
  final String? paymentEncryption;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final double? grandTotal;
  final double? paymentAmount;
  final String? paymentDate;
  final String? paymentMethod;

  InvoicePaymentDetail({
    this.idPayment,
    this.paymentEncryption,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.grandTotal,
    this.paymentAmount,
    this.paymentDate,
    this.paymentMethod,
  });

  factory InvoicePaymentDetail.fromJson(Map<String, dynamic> j) => InvoicePaymentDetail(
        idPayment:         j['id_payment'] != null ? _pi(j['id_payment']) : null,
        paymentEncryption: j['payment_encryption']?.toString(),
        bankName:          j['bank_name']?.toString(),
        bankAccountName:   j['bank_account_name']?.toString(),
        bankAccountNumber: j['bank_account_number']?.toString(),
        grandTotal:        j['grand_total'] != null ? _pd(j['grand_total']) : null,
        paymentAmount:     j['payment_amount'] != null ? _pd(j['payment_amount']) : null,
        paymentDate:       j['payment_date']?.toString(),
        paymentMethod:     j['payment_method']?.toString(),
      );
}

class InvoiceDetailModel {
  final int idInvoice;
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
  final String? invoiceDate;
  final String? dueDate;
  final String? deliveryAddress;
  final String? poNumber;
  final String? note;
  final String? discountType;
  final String? isTax;
  final String? termName;
  final double untaxedAmount;
  final double totalTaxes;
  final double totalDiscount;
  final double grandTotal;
  final double defaultTaxRate;
  final String? paymentInfo;
  final String? paymentInfoClass;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelledReason;
  final String? eBupot;
  final String? salesOrderEncryption;
  final String? directSalesEncryption;
  final String? quotationEncryption;
  final String? salesOrderReference;
  final String? directSalesReference;
  final String? quotationReference;
  final String? paymentScheduleName;
  final List<InvoiceItem> items;
  final List<InvoiceAuditTrail> auditTrails;
  final List<AccountingEntryDetail> accountingEntries;
  final InvoicePaymentDetail? paymentDetails;

  InvoiceDetailModel({
    required this.idInvoice,
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
    this.invoiceDate,
    this.dueDate,
    this.deliveryAddress,
    this.poNumber,
    this.note,
    this.discountType,
    this.isTax,
    this.termName,
    required this.untaxedAmount,
    required this.totalTaxes,
    required this.totalDiscount,
    required this.grandTotal,
    this.defaultTaxRate = 11.0,
    this.paymentInfo,
    this.paymentInfoClass,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelledReason,
    this.eBupot,
    this.salesOrderEncryption,
    this.directSalesEncryption,
    this.quotationEncryption,
    this.salesOrderReference,
    this.directSalesReference,
    this.quotationReference,
    this.paymentScheduleName,
    required this.items,
    required this.auditTrails,
    required this.accountingEntries,
    this.paymentDetails,
  });

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return InvoiceDetailModel(
      idInvoice:           _pi(data['id_invoice']),
      encryption:          _ps(data['encryption']),
      status:              _ps(data['status']),
      reference:           data['reference']?.toString(),
      customerName:        data['customer_name']?.toString() ?? data['customer_data']?['customer_name']?.toString(),
      idCustomer:          _pi(data['id_customer']) == 0 ? null : _pi(data['id_customer']),
      salesPerson:         _pi(data['sales_person']) == 0 ? null : _pi(data['sales_person']),
      idPaymentTerm:       _pi(data['id_payment_term']) == 0 ? null : _pi(data['id_payment_term']),
      idPriceList:         _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      salesPersonName:     data['sales_person_name']?.toString(),
      paymentTermName:     data['payment_term_name']?.toString(),
      priceListName:       data['price_list_name']?.toString(),
      invoiceDate:         data['invoice_date']?.toString(),
      dueDate:             data['due_date']?.toString(),
      deliveryAddress:     data['delivery_address']?.toString(),
      poNumber:            data['po_number']?.toString(),
      note:                data['note']?.toString(),
      discountType:        data['discount_type']?.toString(),
      isTax:               data['is_tax']?.toString(),
      termName:            data['term_name']?.toString(),
      untaxedAmount:       _pd(data['untaxed_amount']),
      totalTaxes:          _pd(data['total_taxes']),
      totalDiscount:       _pd(data['total_discount']),
      grandTotal:          _pd(data['grand_total']),
      defaultTaxRate:      _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
      paymentInfo:         data['payment_info']?.toString(),
      paymentInfoClass:    data['payment_info_class']?.toString(),
      createdByName:       data['created_by_name']?.toString(),
      updatedByName:       data['updated_by_name']?.toString(),
      cancelledByName:     data['cancelled_by_name']?.toString(),
      createdDate:         data['created_date']?.toString(),
      updatedDate:         data['updated_date']?.toString(),
      cancelledDate:       data['cancelled_date']?.toString(),
      cancelledReason:     data['cancel_reason']?.toString(),
      eBupot:              data['e_bupot']?.toString(),
      salesOrderEncryption:  data['sales_order_encryption']?.toString(),
      directSalesEncryption: data['direct_sales_encryption']?.toString(),
      quotationEncryption:   data['quotation_encryption']?.toString(),
      salesOrderReference:   data['sales_order_reference']?.toString(),
      directSalesReference:  data['direct_sales_reference']?.toString(),
      quotationReference:    data['quotation_reference']?.toString(),
      paymentScheduleName:   data['payment_schedule_name']?.toString(),
      items:             (data['items']               as List? ?? []).map((e) => InvoiceItem.fromJson(e)).toList(),
      auditTrails:       (data['audit_trails']         as List? ?? []).map((e) => InvoiceAuditTrail.fromJson(e)).toList(),
      accountingEntries: (data['accounting_entries']   as List? ?? []).map((e) => AccountingEntryDetail.fromJson(e)).toList(),
      paymentDetails: data['payment_details'] != null && data['payment_details'] is Map
          ? InvoicePaymentDetail.fromJson(data['payment_details'])
          : null,
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isPosted          => status == 'Posted';
  bool get isCancelled       => status == 'Cancelled';
  bool get isTaxEnabled      => isTax == 'Y';
  bool get canEdit           => isDraft;
  bool get canConfirm        => isDraft;
  bool get canValidate       => isConfirmed;
  bool get canCancel         => isConfirmed;
  bool get canDelete         => isDraft;
  bool get canCreatePayment  => isPosted;
  bool get hasPayment        => paymentDetails?.idPayment != null;
  bool get isOverdue         => paymentInfoClass == 'text-danger';
  bool get hasSalesOrder     => salesOrderEncryption?.isNotEmpty == true;
  bool get hasDirectSales    => directSalesEncryption?.isNotEmpty == true;
  bool get hasQuotation      => quotationEncryption?.isNotEmpty == true;
  bool get hasJournal        => accountingEntries.isNotEmpty;
  bool get isPaymentTerm     => paymentScheduleName?.isNotEmpty == true;
}

class InvCustomerOption {
  final int id;
  final String name;

  InvCustomerOption({required this.id, required this.name});

  factory InvCustomerOption.fromJson(Map<String, dynamic> j) =>
      InvCustomerOption(id: _pi(j['id_customer']), name: _ps(j['customer_name']));

  @override
  bool operator ==(Object o) => o is InvCustomerOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class InvSalesPersonOption {
  final int id;
  final String name;

  InvSalesPersonOption({required this.id, required this.name});

  factory InvSalesPersonOption.fromJson(Map<String, dynamic> j) =>
      InvSalesPersonOption(id: _pi(j['id_user']), name: _ps(j['nama_lengkap']));

  @override
  bool operator ==(Object o) => o is InvSalesPersonOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class InvPaymentTermOption {
  final int id;
  final String name;

  InvPaymentTermOption({required this.id, required this.name});

  factory InvPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      InvPaymentTermOption(id: _pi(j['id_payment_term']), name: _ps(j['payment_term_name']));

  @override
  bool operator ==(Object o) => o is InvPaymentTermOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class InvPriceListOption {
  final int id;
  final String name;

  InvPriceListOption({required this.id, required this.name});

  factory InvPriceListOption.fromJson(Map<String, dynamic> j) =>
      InvPriceListOption(id: _pi(j['id_price_list']), name: _ps(j['price_list_name']));

  @override
  bool operator ==(Object o) => o is InvPriceListOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class InvBankAccountOption {
  final int id;
  final String name;
  final String? bankName;

  InvBankAccountOption({required this.id, required this.name, this.bankName});

  factory InvBankAccountOption.fromJson(Map<String, dynamic> j) => InvBankAccountOption(
        id:       _pi(j['id_bank_account']),
        name:     _ps(j['bank_account_name']),
        bankName: j['bank_name']?.toString(),
      );

  @override
  bool operator ==(Object o) => o is InvBankAccountOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class InvProductOption {
  final int idProduct;
  final String productName;
  final String? description;
  final double unitPrice;

  InvProductOption({
    required this.idProduct,
    required this.productName,
    this.description,
    this.unitPrice = 0,
  });

  factory InvProductOption.fromJson(Map<String, dynamic> j) => InvProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
        unitPrice:   _pd(j['unit_price'] ?? j['sales_price'] ?? 0),
      );

  @override
  bool operator ==(Object o) => o is InvProductOption && o.idProduct == idProduct;

  @override
  int get hashCode => idProduct.hashCode;
}

class InvUomOption {
  final int id;
  final String name;

  InvUomOption({required this.id, required this.name});

  factory InvUomOption.fromJson(Map<String, dynamic> j) =>
      InvUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));

  @override
  bool operator ==(Object o) => o is InvUomOption && o.id == id;

  @override
  int get hashCode => id.hashCode;
}

class InvoiceFormOptions {
  final List<InvCustomerOption> customers;
  final List<InvSalesPersonOption> salesPersons;
  final List<InvPaymentTermOption> paymentTerms;
  final List<InvPriceListOption> priceLists;
  final List<InvBankAccountOption> bankAccounts;
  final List<InvUomOption> uoms;
  final List<InvProductOption> products;
  final double defaultTaxRate;
  final bool autoCreateJournal;
  final int? currentUserId;

  InvoiceFormOptions({
    required this.customers,
    required this.salesPersons,
    required this.paymentTerms,
    required this.priceLists,
    required this.bankAccounts,
    required this.uoms,
    required this.products,
    this.defaultTaxRate = 11.0,
    this.autoCreateJournal = false,
    this.currentUserId,
  });

  factory InvoiceFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return InvoiceFormOptions(
      customers:    (data['customers']     as List? ?? []).map((e) => InvCustomerOption.fromJson(e)).toList(),
      salesPersons: (data['sales_persons'] as List? ?? []).map((e) => InvSalesPersonOption.fromJson(e)).toList(),
      paymentTerms: (data['payment_terms'] as List? ?? []).map((e) => InvPaymentTermOption.fromJson(e)).toList(),
      priceLists:   (data['price_lists']   as List? ?? []).map((e) => InvPriceListOption.fromJson(e)).toList(),
      bankAccounts: (data['bank_accounts'] as List? ?? []).map((e) => InvBankAccountOption.fromJson(e)).toList(),
      uoms:         (data['uoms']          as List? ?? []).map((e) => InvUomOption.fromJson(e)).toList(),
      products:     (data['products']      as List? ?? []).map((e) => InvProductOption.fromJson(e)).toList(),
      defaultTaxRate:    _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
      autoCreateJournal: data['auto_create_journal'] == true || data['auto_create_journal'] == 1,
      currentUserId:     _pi(data['current_user_id']) == 0 ? null : _pi(data['current_user_id']),
    );
  }
}

class InvoiceFormItem {
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
  double pph23Rate;
  double pph23Amount;
  double onHand;

  InvoiceFormItem({
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
    this.pph23Rate = 0,
    this.pph23Amount = 0,
    this.onHand = 0,
  });

  double get subtotalBeforeDiscount => demandQty * unitPrice;
  double get subtotalAfterDiscount  => subtotalBeforeDiscount - discountAmount;
  double get untaxedAmount          => subtotalAfterDiscount;
  double get taxedAmount            => subtotalAfterDiscount + taxAmount;

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
      discountRate   = 0;
      discountAmount = 0;
    }
    taxRate     = isTaxEnabled ? defaultTaxRate : 0;
    taxAmount   = subtotalAfterDiscount * (taxRate / 100);
    pph23Amount = subtotalAfterDiscount * (pph23Rate / 100);
  }

  Map<String, dynamic> toJson() => {
        'id_product':      idProduct,
        'description':     description ?? '',
        'demand_qty':      demandQty,
        'unit_of_measure': uomId,
        'unit_price':      unitPrice,
        'discount_rate':   discountRate,
        'discount_amount': discountAmount,
        'tax_rate':        taxRate,
        'amount':          untaxedAmount,
        'pph_23_rate':     pph23Rate,
      };
}

class InvoiceFormModel {
  int? idInvoice;
  String? encryption;
  String? reference;
  int? idCustomer;
  int? salesPerson;
  int? idPaymentTerm;
  int? idPriceList;
  DateTime? invoiceDate;
  String deliveryAddress;
  String? poNumber;
  String? note;
  bool isTax;
  String? discountType;
  DateTime? journalTransactionDate;
  List<InvoiceFormItem> items;

  InvoiceFormModel({
    this.idInvoice,
    this.encryption,
    this.reference,
    this.idCustomer,
    this.salesPerson,
    this.idPaymentTerm,
    this.idPriceList,
    this.invoiceDate,
    this.deliveryAddress = '',
    this.poNumber,
    this.note,
    this.isTax = false,
    this.discountType,
    this.journalTransactionDate,
    List<InvoiceFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idInvoice != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get untaxedAmount => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes    => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount => items.fold(0, (s, i) => s + i.discountAmount);
  double get grandTotal    => untaxedAmount + totalTaxes;

  void recalcAll(double defaultTaxRate) {
    for (final item in items) {
      item.recalculate(
        isTaxEnabled:   isTax,
        defaultTaxRate: defaultTaxRate,
        discountType:   discountType,
      );
    }
  }

  Map<String, dynamic> toJson(String status, {double defaultTaxRate = 11.0}) {
    recalcAll(defaultTaxRate);
    return {
      if (idInvoice != null) 'id_invoice': idInvoice,
      if (reference != null) 'reference':  reference,
      'id_customer':      idCustomer,
      'sales_person':     salesPerson,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      if (idPriceList   != null) 'id_price_list':   idPriceList,
      'invoice_date':     invoiceDate != null ? _fmtDate(invoiceDate!) : null,
      'delivery_address': deliveryAddress,
      if (poNumber != null && poNumber!.isNotEmpty) 'po_number': poNumber,
      if (note != null && note!.isNotEmpty) 'note': note,
      'is_tax':        isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'grand_total':   grandTotal,
      'status':        status,
      'products':      items.map((i) => i.toJson()).toList(),
      if (status == 'validate' && journalTransactionDate != null)
        'journal_transaction_date': _fmtDate(journalTransactionDate!),
    };
  }

  factory InvoiceFormModel.fromDetail(InvoiceDetailModel d) => InvoiceFormModel(
        idInvoice:       d.idInvoice,
        encryption:      d.encryption,
        reference:       d.reference,
        idCustomer:      d.idCustomer,
        salesPerson:     d.salesPerson,
        idPaymentTerm:   d.idPaymentTerm,
        idPriceList:     d.idPriceList,
        invoiceDate:     d.invoiceDate != null ? DateTime.tryParse(d.invoiceDate!) : null,
        deliveryAddress: d.deliveryAddress ?? '',
        poNumber:        d.poNumber,
        note:            d.note,
        isTax:           d.isTaxEnabled,
        discountType:    d.discountType == '' ? null : d.discountType,
        items: d.items.map((i) => InvoiceFormItem(
          idProduct:      i.idProduct,
          productName:    i.productName,
          description:    i.description,
          uomId:          i.unitOfMeasure,
          uomName:        i.uomName,
          demandQty:      i.demandQty,
          unitPrice:      i.unitPrice,
          discountRate:   i.discountRate,
          discountAmount: i.discountAmount,
          taxRate:        i.taxRate,
          taxAmount:      i.taxAmount,
          pph23Rate:      i.pph23Rate,
          onHand:         i.onHand,
        )).toList(),
      );
}