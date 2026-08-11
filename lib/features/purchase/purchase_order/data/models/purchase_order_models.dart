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

class PurchaseOrderModel {
  final int idPurchaseOrder;
  final String encryption;
  final String status;
  final String? reference;
  final String? vendorName;
  final String? warehouseName;
  final String? locationName;
  final String? createdDate;
  final double totalAmount;

  PurchaseOrderModel({
    required this.idPurchaseOrder,
    required this.encryption,
    required this.status,
    this.reference,
    this.vendorName,
    this.warehouseName,
    this.locationName,
    this.createdDate,
    this.totalAmount = 0,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> j) => PurchaseOrderModel(
        idPurchaseOrder: _pi(j['id_purchase_order']),
        encryption:      _ps(j['encryption']),
        status:          _ps(j['status']),
        reference:       j['reference']?.toString(),
        vendorName:      j['vendor_name']?.toString(),
        warehouseName:   j['warehouse_name']?.toString(),
        locationName:    j['location_name']?.toString(),
        createdDate:     j['created_date']?.toString(),
        totalAmount:     _pd(j['total_amount']),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed':        0xFF1565C0,
    'Done':             0xFF2E7D32,
    'Cancelled':        0xFFC62828,
    'Closed':           0xFF546E7A,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class PurchaseOrderPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  PurchaseOrderPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class PurchaseOrderItem {
  final int idPurchaseOrderItem;
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
  final double amount;
  final double lastPurchasedPrice;
  final double vendorLastPrice;

  PurchaseOrderItem({
    required this.idPurchaseOrderItem,
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
    required this.amount,
    this.lastPurchasedPrice = 0,
    this.vendorLastPrice = 0,
  });

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> j) => PurchaseOrderItem(
        idPurchaseOrderItem: _pi(j['id_purchase_order_item']),
        idProduct:           _pi(j['id_product']),
        unitOfMeasure:       _pi(j['unit_of_measure']),
        productName:         j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        description:         j['description']?.toString(),
        uomName:             j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        demandQty:           _pd(j['demand_qty']),
        unitPrice:           _pd(j['unit_price']),
        discountRate:        _pd(j['discount_rate']),
        discountAmount:      _pd(j['discount_amount']),
        taxRate:             _pd(j['tax_rate']),
        taxAmount:           _pd(j['tax_amount']),
        amount:              _pd(j['amount']),
        lastPurchasedPrice:  _pd(j['last_purchased_price']),
        vendorLastPrice:     _pd(j['vendor_last_price']),
      );

  double get untaxedAmount => amount;
  double get subtotal      => amount + taxAmount;
}

class PurchaseOrderPaymentSchedule {
  final int idPaymentSchedule;
  final String termName;
  final String? dueDate;
  final double amount;
  final double taxAmount;
  final double percentage;
  final String status;
  final int? idBill;

  PurchaseOrderPaymentSchedule({
    required this.idPaymentSchedule,
    required this.termName,
    this.dueDate,
    required this.amount,
    this.taxAmount = 0,
    required this.percentage,
    required this.status,
    this.idBill,
  });

  factory PurchaseOrderPaymentSchedule.fromJson(Map<String, dynamic> j) => PurchaseOrderPaymentSchedule(
        idPaymentSchedule: _pi(j['id_payment_schedule']),
        termName:          _ps(j['term_name']),
        dueDate:           j['due_date']?.toString(),
        amount:            _pd(j['amount']),
        taxAmount:         _pd(j['tax_amount']),
        percentage:        _pd(j['percentage']),
        status:            _ps(j['status']),
        idBill:            j['id_bill'] == null ? null : _pi(j['id_bill']),
      );

  bool get isPending        => status == 'Pending';
  bool get isWaitingPayment => status == 'Waiting Payment';
  bool get isPaid           => status == 'Paid';
  bool get isCancelled      => status == 'Cancelled';
  bool get canCreateBill    => isPending;
}

class PurchaseOrderAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? description;
  final String? type;
  final String? date;

  PurchaseOrderAuditTrail({
    this.actionByName,
    this.actionById,
    this.description,
    this.type,
    this.date,
  });

  factory PurchaseOrderAuditTrail.fromJson(Map<String, dynamic> j) => PurchaseOrderAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class PurchaseOrderBill {
  final int idBill;
  final String? encryption;
  final String? reference;
  final String status;
  final double grandTotal;

  PurchaseOrderBill({
    required this.idBill,
    this.encryption,
    this.reference,
    required this.status,
    required this.grandTotal,
  });

  factory PurchaseOrderBill.fromJson(Map<String, dynamic> j) => PurchaseOrderBill(
        idBill:     _pi(j['id_bill']),
        encryption: j['encryption']?.toString(),
        reference:  j['reference']?.toString(),
        status:     _ps(j['status']),
        grandTotal: _pd(j['grand_total']),
      );
}

class PurchaseOrderReceiptNote {
  final int idReceiptNote;
  final String? encryption;
  final String? reference;
  final String status;

  PurchaseOrderReceiptNote({
    required this.idReceiptNote,
    this.encryption,
    this.reference,
    required this.status,
  });

  factory PurchaseOrderReceiptNote.fromJson(Map<String, dynamic> j) => PurchaseOrderReceiptNote(
        idReceiptNote: _pi(j['id_receipt_note']),
        encryption:    j['encryption']?.toString(),
        reference:     j['reference']?.toString(),
        status:        _ps(j['status']),
      );
}

class PurchaseOrderDetailModel {
  final int idPurchaseOrder;
  final String encryption;
  final String status;
  final String? reference;
  final String? rfqReference;
  final String? vendorName;
  final String? destinationWarehouseName;
  final String? destinationLocationName;
  final int? idVendor;
  final int? destinationWarehouse;
  final int? destinationLocation;
  final int? purchaseTeam;
  final String? purchaseTeamName;
  final int? purchasePerson;
  final int? idPaymentTerm;
  final int? idPriceList;
  final String? purchasePersonName;
  final String? paymentTermName;
  final String? priceListName;
  final String? requestedDate;
  final String? expectedArrival;
  final String? expirationDate;
  final String? note;
  final String? discountType;
  final String? isTax;
  final String paymentType;
  final double subtotal;
  final double totalTaxes;
  final double totalDiscount;
  final double totalAmount;
  final double defaultTaxRate;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? closedByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelReason;
  final String? closedDate;
  final String? validatedDate;
  final String? rfqEncryption;
  final String? billEncryption;
  final String? receiptNoteEncryption;
  final int receiptNoteCount;
  final int billCount;
  final List<PurchaseOrderItem> items;
  final List<PurchaseOrderAuditTrail> auditTrails;
  final List<PurchaseOrderPaymentSchedule> paymentSchedules;
  final List<PurchaseOrderReceiptNote> receiptNotes;
  final List<PurchaseOrderBill> bills;

  PurchaseOrderDetailModel({
    required this.idPurchaseOrder,
    required this.encryption,
    required this.status,
    this.reference,
    this.rfqReference,
    this.vendorName,
    this.destinationWarehouseName,
    this.destinationLocationName,
    this.idVendor,
    this.destinationWarehouse,
    this.destinationLocation,
    this.purchaseTeam,
    this.purchaseTeamName,
    this.purchasePerson,
    this.idPaymentTerm,
    this.idPriceList,
    this.purchasePersonName,
    this.paymentTermName,
    this.priceListName,
    this.requestedDate,
    this.expectedArrival,
    this.expirationDate,
    this.note,
    this.discountType,
    this.isTax,
    this.paymentType = 'Full',
    required this.subtotal,
    required this.totalTaxes,
    required this.totalDiscount,
    required this.totalAmount,
    this.defaultTaxRate = 11.0,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.closedByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelReason,
    this.closedDate,
    this.validatedDate,
    this.rfqEncryption,
    this.billEncryption,
    this.receiptNoteEncryption,
    this.receiptNoteCount = 0,
    this.billCount = 0,
    required this.items,
    required this.auditTrails,
    required this.paymentSchedules,
    required this.receiptNotes,
    required this.bills,
  });

  factory PurchaseOrderDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PurchaseOrderDetailModel(
      idPurchaseOrder:           _pi(data['id_purchase_order']),
      encryption:                _ps(data['encryption']),
      status:                    _ps(data['status']),
      reference:                 data['reference']?.toString(),
      rfqReference:              data['rfq_reference']?.toString(),
      vendorName:                data['vendor_name']?.toString() ?? data['vendor']?['vendor_name']?.toString(),
      destinationWarehouseName:  data['destination_warehouse_name']?.toString() ?? data['warehouse']?['warehouse_name']?.toString(),
      destinationLocationName:   data['destination_location_name']?.toString() ?? data['location']?['location_name']?.toString(),
      idVendor:                  _pi(data['id_vendor']) == 0 ? null : _pi(data['id_vendor']),
      destinationWarehouse:      _pi(data['destination_warehouse']) == 0 ? null : _pi(data['destination_warehouse']),
      destinationLocation:       _pi(data['destination_location']) == 0 ? null : _pi(data['destination_location']),
      purchaseTeam:              _pi(data['purchase_team']) == 0 ? null : _pi(data['purchase_team']),
      purchasePerson:            _pi(data['purchase_person']) == 0 ? null : _pi(data['purchase_person']),
      idPaymentTerm:             _pi(data['id_payment_term']) == 0 ? null : _pi(data['id_payment_term']),
      idPriceList:               _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      purchasePersonName:        data['purchase_person_name']?.toString(),
      paymentTermName:           data['payment_term_name']?.toString(),
      priceListName:             data['price_list_name']?.toString(),
      purchaseTeamName:          data['purchase_team_name']?.toString(),
      requestedDate:             data['requested_date']?.toString(),
      expectedArrival:           data['expected_arrival']?.toString(),
      expirationDate:            data['expiration_date']?.toString(),
      note:                      data['note']?.toString(),
      discountType:              data['discount_type']?.toString(),
      isTax:                     data['is_tax']?.toString(),
      paymentType:               data['payment_type']?.toString() ?? 'Full',
      subtotal:                  _pd(data['subtotal']),
      totalTaxes:                _pd(data['total_taxes']),
      totalDiscount:             _pd(data['total_discount']),
      totalAmount:               _pd(data['total_amount']),
      defaultTaxRate:            _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
      createdByName:             data['created_by_name']?.toString(),
      updatedByName:             data['updated_by_name']?.toString(),
      cancelledByName:           data['cancelled_by_name']?.toString(),
      closedByName:              data['closed_by_name']?.toString(),
      createdDate:               data['created_date']?.toString(),
      updatedDate:               data['updated_date']?.toString(),
      cancelledDate:             data['cancelled_date']?.toString(),
      cancelReason:              data['cancel_reason']?.toString(),
      closedDate:                data['closed_date']?.toString(),
      validatedDate:             data['validated_date']?.toString(),
      rfqEncryption:             data['rfq_encryption']?.toString(),
      billEncryption:            data['bill_encryption']?.toString(),
      receiptNoteEncryption:     data['receipt_note_encryption']?.toString(),
      receiptNoteCount:          _pi(data['receipt_note_count']),
      billCount:                 _pi(data['bill_count']),
      items:            (data['items']            as List? ?? []).map((e) => PurchaseOrderItem.fromJson(e)).toList(),
      auditTrails:      (data['audit_trails']     as List? ?? []).map((e) => PurchaseOrderAuditTrail.fromJson(e)).toList(),
      paymentSchedules: (data['payment_schedules'] as List? ?? []).map((e) => PurchaseOrderPaymentSchedule.fromJson(e)).toList(),
      receiptNotes:     (data['receipt_notes']     as List? ?? []).map((e) => PurchaseOrderReceiptNote.fromJson(e)).toList(),
      bills:            (data['bills']             as List? ?? []).map((e) => PurchaseOrderBill.fromJson(e)).toList(),
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isDone            => status == 'Done';
  bool get isCancelled       => status == 'Cancelled';
  bool get isClosed          => status == 'Closed';
  bool get isTaxEnabled      => isTax == 'Y';
  bool get isMultiPayment    => paymentType == 'Multi';
  bool get canEdit           => isDraft;
  bool get canConfirm        => isDraft;
  bool get canValidate       => isConfirmed;
  bool get canCancel         => isConfirmed;
  bool get canClose          => isDone;
  bool get canDelete         => isDraft;
  bool get canCreateBill     => isDone && !isMultiPayment && !hasBill;
  bool get hasRfq            => rfqEncryption != null && rfqEncryption!.isNotEmpty;
  bool get hasBill           => billEncryption != null && billEncryption!.isNotEmpty;
  bool get hasReceiptNote    => receiptNoteEncryption != null && receiptNoteEncryption!.isNotEmpty;
}

class POVendorOption {
  final int id;
  final String name;

  POVendorOption({required this.id, required this.name});

  factory POVendorOption.fromJson(Map<String, dynamic> j) =>
      POVendorOption(id: _pi(j['id_vendor']), name: _ps(j['vendor_name']));

  @override bool operator ==(Object o) => o is POVendorOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class POWarehouseOption {
  final int id;
  final String name;

  POWarehouseOption({required this.id, required this.name});

  factory POWarehouseOption.fromJson(Map<String, dynamic> j) =>
      POWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));

  @override bool operator ==(Object o) => o is POWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class POLocationOption {
  final int id;
  final int warehouseId;
  final String name;

  POLocationOption({required this.id, required this.warehouseId, required this.name});

  factory POLocationOption.fromJson(Map<String, dynamic> j) => POLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );

  @override bool operator ==(Object o) => o is POLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class POPurchaseTeamOption {
  final int id;
  final String name;

  POPurchaseTeamOption({required this.id, required this.name});

  factory POPurchaseTeamOption.fromJson(Map<String, dynamic> j) =>
      POPurchaseTeamOption(id: _pi(j['id_purchase_team']), name: _ps(j['team_name']));

  @override bool operator ==(Object o) => o is POPurchaseTeamOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class POPurchasePersonOption {
  final int id;
  final String name;

  POPurchasePersonOption({required this.id, required this.name});

  factory POPurchasePersonOption.fromJson(Map<String, dynamic> j) =>
      POPurchasePersonOption(id: _pi(j['id_user']), name: _ps(j['nama_lengkap']));

  @override bool operator ==(Object o) => o is POPurchasePersonOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class POPaymentTermOption {
  final int id;
  final String name;

  POPaymentTermOption({required this.id, required this.name});

  factory POPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      POPaymentTermOption(id: _pi(j['id_payment_term']), name: _ps(j['payment_term_name']));

  @override bool operator ==(Object o) => o is POPaymentTermOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class POPriceListOption {
  final int id;
  final String name;

  POPriceListOption({required this.id, required this.name});

  factory POPriceListOption.fromJson(Map<String, dynamic> j) =>
      POPriceListOption(id: _pi(j['id_price_list']), name: _ps(j['price_list_name']));

  @override bool operator ==(Object o) => o is POPriceListOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class POProductOption {
  final int idProduct;
  final String productName;
  final String? description;

  POProductOption({
    required this.idProduct,
    required this.productName,
    this.description,
  });

  factory POProductOption.fromJson(Map<String, dynamic> j) => POProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
      );

  @override bool operator ==(Object o) => o is POProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class POUomOption {
  final int id;
  final String name;

  POUomOption({required this.id, required this.name});

  factory POUomOption.fromJson(Map<String, dynamic> j) =>
      POUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));

  @override bool operator ==(Object o) => o is POUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class PurchaseOrderFormOptions {
  final List<POVendorOption> vendors;
  final List<POWarehouseOption> warehouses;
  final List<POLocationOption> locations;
  final List<POPurchaseTeamOption> purchaseTeams;
  final List<POPurchasePersonOption> purchasePersons;
  final List<POPaymentTermOption> paymentTerms;
  final List<POPriceListOption> priceLists;
  final List<POProductOption> products;
  final List<POUomOption> uoms;
  final double defaultTaxRate;

  PurchaseOrderFormOptions({
    required this.vendors,
    required this.warehouses,
    required this.locations,
    required this.purchaseTeams,
    required this.purchasePersons,
    required this.paymentTerms,
    required this.priceLists,
    required this.products,
    required this.uoms,
    this.defaultTaxRate = 11.0,
  });

  factory PurchaseOrderFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return PurchaseOrderFormOptions(
      vendors:         (data['vendors']          as List? ?? []).map((e) => POVendorOption.fromJson(e)).toList(),
      warehouses:      (data['warehouses']        as List? ?? []).map((e) => POWarehouseOption.fromJson(e)).toList(),
      locations:       (data['locations']         as List? ?? []).map((e) => POLocationOption.fromJson(e)).toList(),
      purchaseTeams:   (data['purchase_teams']    as List? ?? []).map((e) => POPurchaseTeamOption.fromJson(e)).toList(),
      purchasePersons: (data['purchase_persons']  as List? ?? []).map((e) => POPurchasePersonOption.fromJson(e)).toList(),
      paymentTerms:    (data['payment_terms']     as List? ?? []).map((e) => POPaymentTermOption.fromJson(e)).toList(),
      priceLists:      (data['price_lists']       as List? ?? []).map((e) => POPriceListOption.fromJson(e)).toList(),
      products:        (data['products']          as List? ?? []).map((e) => POProductOption.fromJson(e)).toList(),
      uoms:            (data['uoms']               as List? ?? []).map((e) => POUomOption.fromJson(e)).toList(),
      defaultTaxRate:  _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
    );
  }

  List<POLocationOption> locationsForWarehouse(int warehouseId) =>
      locations.where((l) => l.warehouseId == warehouseId).toList();
}

class PurchaseOrderFormItem {
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
  double lastPurchasedPrice;
  double vendorLastPrice;

  PurchaseOrderFormItem({
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
    this.lastPurchasedPrice = 0,
    this.vendorLastPrice = 0,
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
      discountRate = subtotalBeforeDiscount > 0
          ? (discountAmount / subtotalBeforeDiscount * 100)
          : 0;
    } else {
      discountRate   = 0;
      discountAmount = 0;
    }
    taxRate   = isTaxEnabled ? defaultTaxRate : 0;
    taxAmount = subtotalAfterDiscount * (taxRate / 100);
  }

  Map<String, dynamic> toJson() => {
        'id_product':           idProduct,
        'description':          description ?? '',
        'demand_qty':           demandQty,
        'unit_of_measure':      uomId,
        'unit_price':           unitPrice,
        'discount_rate':        discountRate,
        'discount_amount':      discountAmount,
        'tax_rate':             taxRate,
        'amount':               untaxedAmount,
        'last_purchased_price': lastPurchasedPrice,
        'vendor_last_price':    vendorLastPrice,
      };
}

class PurchaseOrderScheduleItem {
  String termName;
  DateTime? dueDate;
  double amount;
  double percentage;
  String? description;

  PurchaseOrderScheduleItem({
    this.termName = '',
    this.dueDate,
    this.amount = 0,
    this.percentage = 0,
    this.description,
  });

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'term_name':  termName,
        'due_date':   dueDate != null ? _fmtDate(dueDate!) : null,
        'amount':     amount,
        'percentage': percentage,
        if (description != null && description!.isNotEmpty) 'description': description,
      };
}

class PurchaseOrderFormModel {
  int? idPurchaseOrder;
  String? encryption;
  String? reference;
  String? rfqReference;
  int? idVendor;
  int? purchaseTeam;
  int? purchasePerson;
  int? destinationWarehouse;
  int? destinationLocation;
  int? idPaymentTerm;
  int? idPriceList;
  DateTime? requestedDate;
  DateTime? expectedArrival;
  DateTime? expirationDate;
  String? note;
  bool isTax;
  String? discountType;
  String paymentType;
  List<PurchaseOrderFormItem> items;
  List<PurchaseOrderScheduleItem> schedules;

  PurchaseOrderFormModel({
    this.idPurchaseOrder,
    this.encryption,
    this.reference,
    this.rfqReference,
    this.idVendor,
    this.purchaseTeam,
    this.purchasePerson,
    this.destinationWarehouse,
    this.destinationLocation,
    this.idPaymentTerm,
    this.idPriceList,
    this.requestedDate,
    this.expectedArrival,
    this.expirationDate,
    this.note,
    this.isTax = false,
    this.discountType,
    this.paymentType = 'Full',
    List<PurchaseOrderFormItem>? items,
    List<PurchaseOrderScheduleItem>? schedules,
  })  : items     = items ?? [],
        schedules = schedules ?? [];

  bool get isEditMode     => idPurchaseOrder != null;
  bool get isMultiPayment => paymentType == 'Multi';

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get untaxedAmount           => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes              => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount           => items.fold(0, (s, i) => s + i.discountAmount);
  double get grandTotal              => untaxedAmount + totalTaxes;
  double get totalSchedulePercentage => schedules.fold(0, (s, i) => s + i.percentage);

  void recalcAll(double defaultTaxRate) {
    for (final item in items) {
      item.recalculate(isTaxEnabled: isTax, defaultTaxRate: defaultTaxRate, discountType: discountType);
    }
  }

  Map<String, dynamic> toJson(String status, {double defaultTaxRate = 11.0}) {
    recalcAll(defaultTaxRate);
    return {
      if (idPurchaseOrder != null) 'id_purchase_order': idPurchaseOrder,
      if (reference != null) 'reference': reference,
      if (rfqReference != null && rfqReference!.isNotEmpty) 'rfq_reference': rfqReference,
      'id_vendor':              idVendor,
      'purchase_team':          purchaseTeam,
      'purchase_person':        purchasePerson,
      'destination_warehouse':  destinationWarehouse,
      'destination_location':   destinationLocation,
      'requested_date':         requestedDate != null ? _fmtDate(requestedDate!) : null,
      'expected_arrival':       expectedArrival != null ? _fmtDate(expectedArrival!) : null,
      'expiration_date':        expirationDate != null ? _fmtDate(expirationDate!) : null,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      if (idPriceList   != null) 'id_price_list':   idPriceList,
      if (note != null && note!.isNotEmpty) 'note': note,
      'is_tax':        isTax ? 'Y' : 'N',
      'discount_type': discountType ?? '',
      'payment_type':  paymentType,
      'total_amount':  grandTotal,
      'status':        status,
      'products':      items.map((i) => i.toJson()).toList(),
      if (isMultiPayment && schedules.isNotEmpty)
        'schedules': schedules.map((s) => s.toJson()).toList(),
    };
  }

  factory PurchaseOrderFormModel.fromDetail(PurchaseOrderDetailModel d) =>
    PurchaseOrderFormModel(
      idPurchaseOrder:      d.idPurchaseOrder,
      encryption:           d.encryption,
      reference:            d.reference,
      rfqReference:         d.rfqReference,
      idVendor:             d.idVendor,
      purchaseTeam:         d.purchaseTeam,
      purchasePerson:       d.purchasePerson,
      destinationWarehouse: d.destinationWarehouse,
      destinationLocation:  d.destinationLocation,
      idPaymentTerm:        d.idPaymentTerm,
      idPriceList:          d.idPriceList,
      requestedDate:        d.requestedDate != null ? DateTime.tryParse(d.requestedDate!) : null,
      expectedArrival:      d.expectedArrival != null ? DateTime.tryParse(d.expectedArrival!) : null,
      expirationDate:       d.expirationDate != null ? DateTime.tryParse(d.expirationDate!) : null,
      note:                 d.note,
      isTax:                d.isTaxEnabled,
      discountType:         d.discountType == '' ? null : d.discountType,
      paymentType:          d.paymentType,
      items: d.items.map((i) => PurchaseOrderFormItem(
        idProduct:          i.idProduct,
        productName:        i.productName,
        description:        i.description,
        uomId:              i.unitOfMeasure,
        uomName:            i.uomName,
        demandQty:          i.demandQty,
        unitPrice:          i.unitPrice,
        discountRate:       i.discountRate,
        discountAmount:     i.discountAmount,
        taxRate:            i.taxRate,
        taxAmount:          i.taxAmount,
        lastPurchasedPrice: i.lastPurchasedPrice,
        vendorLastPrice:    i.vendorLastPrice,
      )).toList(),
      schedules: d.paymentSchedules.map((s) => PurchaseOrderScheduleItem(
        termName:   s.termName,
        dueDate:    s.dueDate != null ? DateTime.tryParse(s.dueDate!) : null,
        amount:     s.amount,
        percentage: s.percentage,
      )).toList(),
    );
}