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

class RfqModel {
  final int idRfq;
  final String encryption;
  final String status;
  final String? reference;
  final String? createdDate;
  final String? vendorName;
  final String? warehouseName;
  final String? locationName;

  RfqModel({
    required this.idRfq,
    required this.encryption,
    required this.status,
    this.reference,
    this.createdDate,
    this.vendorName,
    this.warehouseName,
    this.locationName,
  });

  factory RfqModel.fromJson(Map<String, dynamic> j) => RfqModel(
        idRfq:         _pi(j['id_rfq']),
        encryption:    _ps(j['encryption']),
        status:        _ps(j['status']),
        reference:     j['reference']?.toString(),
        createdDate:   j['created_date']?.toString(),
        vendorName:    j['vendor_name']?.toString(),
        warehouseName: j['warehouse_name']?.toString(),
        locationName:  j['location_name']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed':        0xFF1565C0,
    'Done':             0xFF2E7D32,
    'Cancelled':        0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class RfqPaginationMeta {
  final int currentPage, lastPage, perPage, total;

  RfqPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class RfqItem {
  final int idRfqItem;
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
  final double lastPurchasedPrice;
  final double vendorLastPrice;
  final double amount;

  RfqItem({
    required this.idRfqItem,
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
    required this.lastPurchasedPrice,
    required this.vendorLastPrice,
    required this.amount,
  });

  factory RfqItem.fromJson(Map<String, dynamic> j) => RfqItem(
        idRfqItem:         _pi(j['id_rfq_item']),
        idProduct:         _pi(j['id_product']),
        unitOfMeasure:     _pi(j['unit_of_measure']),
        productName:       j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        description:       j['description']?.toString(),
        uomName:           j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        demandQty:         _pd(j['demand_qty']),
        unitPrice:         _pd(j['unit_price']),
        discountRate:      _pd(j['discount_rate']),
        discountAmount:    _pd(j['discount_amount']),
        taxRate:           _pd(j['tax_rate']),
        taxAmount:         _pd(j['tax_amount']),
        lastPurchasedPrice:_pd(j['last_purchased_price']),
        vendorLastPrice:   _pd(j['vendor_last_price']),
        amount:            _pd(j['amount']),
      );

  double get taxedAmount => amount + taxAmount;
}

class RfqPaymentSchedule {
  final int idRfqPaymentSchedule;
  final String termName;
  final String? dueDate;
  final double amount;
  final double taxRate;
  final double taxAmount;
  final double percentage;
  final String? description;
  final String status;

  RfqPaymentSchedule({
    required this.idRfqPaymentSchedule,
    required this.termName,
    this.dueDate,
    required this.amount,
    required this.taxRate,
    required this.taxAmount,
    required this.percentage,
    this.description,
    required this.status,
  });

  factory RfqPaymentSchedule.fromJson(Map<String, dynamic> j) => RfqPaymentSchedule(
        idRfqPaymentSchedule: _pi(j['id_rfq_payment_schedule']),
        termName:             _ps(j['term_name']),
        dueDate:              j['due_date']?.toString(),
        amount:               _pd(j['amount']),
        taxRate:              _pd(j['tax_rate']),
        taxAmount:            _pd(j['tax_amount']),
        percentage:           _pd(j['percentage']),
        description:          j['description']?.toString(),
        status:               _ps(j['status']),
      );

  bool get isPending => status == 'Pending';
}

class RfqAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? image;
  final String? description;
  final String? type;
  final String? date;

  RfqAuditTrail({
    this.actionByName,
    this.actionById,
    this.image,
    this.description,
    this.type,
    this.date,
  });

  factory RfqAuditTrail.fromJson(Map<String, dynamic> j) => RfqAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        image:        j['image']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class RfqDetailModel {
  final int idRfq;
  final String encryption;
  final String status;
  final String? reference;
  final String? prReference;
  final String? prEncryption;
  final String? poEncryption;
  final int? idPurchaseOrder;
  final int? idVendor;
  final String? vendorName;
  final int? purchaseTeam;
  final String? purchaseTeamName;
  final int? purchasePerson;
  final String? purchasePersonName;
  final int? destinationWarehouse;
  final int? destinationLocation;
  final String? destinationWarehouseName;
  final String? destinationLocationName;
  final int? idPriceList;
  final String? priceListName;
  final int? idPaymentTerm;
  final String? paymentTermName;
  final String? requestedDate;
  final String? expectedArrival;
  final String? expirationDate;
  final String? discountType;
  final String? isTax;
  final String paymentType;
  final double subtotal;
  final double totalDiscount;
  final double totalTaxes;
  final double totalAmount;
  final double defaultTaxRate;
  final String? note;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? cancelReason;
  final List<RfqItem> items;
  final List<RfqAuditTrail> auditTrails;
  final List<RfqPaymentSchedule> paymentSchedules;

  RfqDetailModel({
    required this.idRfq,
    required this.encryption,
    required this.status,
    this.reference,
    this.prReference,
    this.prEncryption,
    this.poEncryption,
    this.idPurchaseOrder,
    this.idVendor,
    this.vendorName,
    this.purchaseTeam,
    this.purchaseTeamName,
    this.purchasePerson,
    this.purchasePersonName,
    this.destinationWarehouse,
    this.destinationLocation,
    this.destinationWarehouseName,
    this.destinationLocationName,
    this.idPriceList,
    this.priceListName,
    this.idPaymentTerm,
    this.paymentTermName,
    this.requestedDate,
    this.expectedArrival,
    this.expirationDate,
    this.discountType,
    this.isTax,
    this.paymentType = 'Full',
    required this.subtotal,
    required this.totalDiscount,
    required this.totalTaxes,
    required this.totalAmount,
    this.defaultTaxRate = 11.0,
    this.note,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.cancelReason,
    required this.items,
    required this.auditTrails,
    required this.paymentSchedules,
  });

  factory RfqDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return RfqDetailModel(
      idRfq:                    _pi(data['id_rfq']),
      encryption:                _ps(data['encryption']),
      status:                    _ps(data['status']),
      reference:                 data['reference']?.toString(),
      prReference:               data['pr_reference']?.toString(),
      prEncryption:              data['pr_encryption']?.toString(),
      poEncryption:              data['po_encryption']?.toString(),
      idPurchaseOrder:           _pi(data['id_purchase_order']) == 0 ? null : _pi(data['id_purchase_order']),
      idVendor:                  _pi(data['id_vendor']) == 0 ? null : _pi(data['id_vendor']),
      vendorName:                data['vendor_name']?.toString() ?? data['vendor']?['vendor_name']?.toString(),
      purchaseTeam:              _pi(data['purchase_team']) == 0 ? null : _pi(data['purchase_team']),
      purchaseTeamName:          data['purchase_team_name']?.toString(),
      purchasePerson:            _pi(data['purchase_person']) == 0 ? null : _pi(data['purchase_person']),
      purchasePersonName:        data['purchase_person_name']?.toString(),
      destinationWarehouse:      _pi(data['destination_warehouse']) == 0 ? null : _pi(data['destination_warehouse']),
      destinationLocation:       _pi(data['destination_location']) == 0 ? null : _pi(data['destination_location']),
      destinationWarehouseName:  data['destination_warehouse_name']?.toString(),
      destinationLocationName:   data['destination_location_name']?.toString(),
      idPriceList:               _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      priceListName:             data['pprice_list_name']?.toString(),
      idPaymentTerm:             _pi(data['id_payment_term']) == 0 ? null : _pi(data['id_payment_term']),
      paymentTermName:           data['payment_term_name']?.toString(),
      requestedDate:             data['requested_date']?.toString(),
      expectedArrival:           data['expected_arrival']?.toString(),
      expirationDate:            data['expiration_date']?.toString(),
      discountType:              data['discount_type']?.toString(),
      isTax:                     data['is_tax']?.toString(),
      paymentType:               data['payment_type']?.toString() ?? 'Full',
      subtotal:                  _pd(data['subtotal']),
      totalDiscount:             _pd(data['total_discount']),
      totalTaxes:                _pd(data['total_taxes']),
      totalAmount:               _pd(data['total_amount']),
      defaultTaxRate:            _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
      note:                      data['note']?.toString(),
      createdByName:             data['created_by_name']?.toString(),
      updatedByName:             data['updated_by_name']?.toString(),
      cancelledByName:           data['cancelled_by_name']?.toString(),
      createdDate:               data['created_date']?.toString(),
      updatedDate:               data['updated_date']?.toString(),
      cancelledDate:             data['cancelled_date']?.toString(),
      cancelReason:              data['cancel_reason']?.toString(),
      items:            (data['items']            as List? ?? []).map((e) => RfqItem.fromJson(e)).toList(),
      auditTrails:      (data['audit_trails']     as List? ?? []).map((e) => RfqAuditTrail.fromJson(e)).toList(),
      paymentSchedules: (data['payment_schedules'] as List? ?? []).map((e) => RfqPaymentSchedule.fromJson(e)).toList(),
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isDone            => status == 'Done';
  bool get isCancelled       => status == 'Cancelled';
  bool get isTaxEnabled      => isTax == 'Y';
  bool get isMultiPayment    => paymentType == 'Multi';
  bool get canEdit           => isDraft;
  bool get canConfirm        => isDraft;
  bool get canValidate       => isConfirmed;
  bool get canCancel         => isConfirmed;
  bool get canDelete         => isDraft;
  bool get canCreatePO       => isDone && idPurchaseOrder == null;
  bool get hasPr             => prEncryption != null && prEncryption!.isNotEmpty;
  bool get hasPo             => poEncryption != null && poEncryption!.isNotEmpty;
}

class RfqVendorOption {
  final int id;
  final String name;

  RfqVendorOption({required this.id, required this.name});

  factory RfqVendorOption.fromJson(Map<String, dynamic> j) =>
      RfqVendorOption(id: _pi(j['id_vendor']), name: _ps(j['vendor_name']));

  @override bool operator ==(Object o) => o is RfqVendorOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqWarehouseOption {
  final int id;
  final String name;

  RfqWarehouseOption({required this.id, required this.name});

  factory RfqWarehouseOption.fromJson(Map<String, dynamic> j) =>
      RfqWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));

  @override bool operator ==(Object o) => o is RfqWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqLocationOption {
  final int id;
  final int warehouseId;
  final String name;

  RfqLocationOption({required this.id, required this.warehouseId, required this.name});

  factory RfqLocationOption.fromJson(Map<String, dynamic> j) => RfqLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );

  @override bool operator ==(Object o) => o is RfqLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqPaymentTermOption {
  final int id;
  final String name;

  RfqPaymentTermOption({required this.id, required this.name});

  factory RfqPaymentTermOption.fromJson(Map<String, dynamic> j) =>
      RfqPaymentTermOption(id: _pi(j['id_payment_term']), name: _ps(j['payment_term_name']));

  @override bool operator ==(Object o) => o is RfqPaymentTermOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqPriceListOption {
  final int id;
  final String name;

  RfqPriceListOption({required this.id, required this.name});

  factory RfqPriceListOption.fromJson(Map<String, dynamic> j) =>
      RfqPriceListOption(id: _pi(j['id_price_list']), name: _ps(j['price_list_name']));

  @override bool operator ==(Object o) => o is RfqPriceListOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqPurchaseTeamOption {
  final int id;
  final String name;

  RfqPurchaseTeamOption({required this.id, required this.name});

  factory RfqPurchaseTeamOption.fromJson(Map<String, dynamic> j) =>
      RfqPurchaseTeamOption(id: _pi(j['id_purchase_team']), name: _ps(j['team_name']));

  @override bool operator ==(Object o) => o is RfqPurchaseTeamOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqPurchasePersonOption {
  final int id;
  final String name;

  RfqPurchasePersonOption({required this.id, required this.name});

  factory RfqPurchasePersonOption.fromJson(Map<String, dynamic> j) =>
      RfqPurchasePersonOption(id: _pi(j['id_user']), name: _ps(j['nama_lengkap']));

  @override bool operator ==(Object o) => o is RfqPurchasePersonOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqProductOption {
  final int idProduct;
  final String productName;
  final String? description;

  RfqProductOption({
    required this.idProduct,
    required this.productName,
    this.description,
  });

  factory RfqProductOption.fromJson(Map<String, dynamic> j) => RfqProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
      );

  @override bool operator ==(Object o) => o is RfqProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class RfqUomOption {
  final int id;
  final String name;

  RfqUomOption({required this.id, required this.name});

  factory RfqUomOption.fromJson(Map<String, dynamic> j) =>
      RfqUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));

  @override bool operator ==(Object o) => o is RfqUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class RfqFormOptions {
  final List<RfqVendorOption> vendors;
  final List<RfqWarehouseOption> warehouses;
  final List<RfqLocationOption> locations;
  final List<RfqPaymentTermOption> paymentTerms;
  final List<RfqPriceListOption> priceLists;
  final List<RfqPurchaseTeamOption> purchaseTeams;
  final List<RfqPurchasePersonOption> purchasePersons;
  final List<RfqProductOption> products;
  final List<RfqUomOption> uoms;
  final double defaultTaxRate;

  RfqFormOptions({
    required this.vendors,
    required this.warehouses,
    required this.locations,
    required this.paymentTerms,
    required this.priceLists,
    required this.purchaseTeams,
    required this.purchasePersons,
    required this.products,
    required this.uoms,
    this.defaultTaxRate = 11.0,
  });

  factory RfqFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return RfqFormOptions(
      vendors:         (data['vendors']          as List? ?? []).map((e) => RfqVendorOption.fromJson(e)).toList(),
      warehouses:      (data['warehouses']       as List? ?? []).map((e) => RfqWarehouseOption.fromJson(e)).toList(),
      locations:       (data['locations']        as List? ?? []).map((e) => RfqLocationOption.fromJson(e)).toList(),
      paymentTerms:    (data['payment_terms']    as List? ?? []).map((e) => RfqPaymentTermOption.fromJson(e)).toList(),
      priceLists:      (data['price_lists']      as List? ?? []).map((e) => RfqPriceListOption.fromJson(e)).toList(),
      purchaseTeams:   (data['purchase_teams']   as List? ?? []).map((e) => RfqPurchaseTeamOption.fromJson(e)).toList(),
      purchasePersons: (data['purchase_persons'] as List? ?? []).map((e) => RfqPurchasePersonOption.fromJson(e)).toList(),
      products:        (data['products']         as List? ?? []).map((e) => RfqProductOption.fromJson(e)).toList(),
      uoms:            (data['uoms']              as List? ?? []).map((e) => RfqUomOption.fromJson(e)).toList(),
      defaultTaxRate:  _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
    );
  }

  List<RfqLocationOption> locationsForWarehouse(int warehouseId) =>
      locations.where((l) => l.warehouseId == warehouseId).toList();
}

class RfqFormItem {
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

  RfqFormItem({
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
        'last_purchased_price': lastPurchasedPrice,
        'vendor_last_price':    vendorLastPrice,
        'amount':               untaxedAmount,
      };
}

class RfqScheduleItem {
  String termName;
  DateTime? dueDate;
  double amount;
  double percentage;
  String? description;

  RfqScheduleItem({
    this.termName = '',
    this.dueDate,
    this.amount = 0,
    this.percentage = 0,
    this.description,
  });

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'term_name':   termName,
        'due_date':    dueDate != null ? _fmtDate(dueDate!) : null,
        'amount':      amount,
        'percentage':  percentage,
        'description': description,
      };
}

class RfqFormModel {
  int? idRfq;
  String? encryption;
  String? reference;
  String? prReference;
  DateTime? requestedDate;
  int? idVendor;
  int? purchaseTeam;
  int? purchasePerson;
  int? destinationWarehouse;
  int? destinationLocation;
  DateTime? expectedArrival;
  DateTime? expirationDate;
  int? idPriceList;
  int? idPaymentTerm;
  bool isTax;
  String? discountType;
  String paymentType;
  String? note;
  List<RfqFormItem> items;
  List<RfqScheduleItem> schedules;

  RfqFormModel({
    this.idRfq,
    this.encryption,
    this.reference,
    this.prReference,
    this.requestedDate,
    this.idVendor,
    this.purchaseTeam,
    this.purchasePerson,
    this.destinationWarehouse,
    this.destinationLocation,
    this.expectedArrival,
    this.expirationDate,
    this.idPriceList,
    this.idPaymentTerm,
    this.isTax = false,
    this.discountType,
    this.paymentType = 'Full',
    this.note,
    List<RfqFormItem>? items,
    List<RfqScheduleItem>? schedules,
  })  : items     = items ?? [],
        schedules = schedules ?? [];

  bool get isEditMode     => idRfq != null;
  bool get isMultiPayment => paymentType == 'Multi';

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get subtotal    => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes  => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount => items.fold(0, (s, i) => s + i.discountAmount);
  double get totalAmount => subtotal + totalTaxes;
  double get totalSchedulePercentage => schedules.fold(0, (s, i) => s + i.percentage);

  void recalcAll(double defaultTaxRate) {
    for (final item in items) {
      item.recalculate(isTaxEnabled: isTax, defaultTaxRate: defaultTaxRate, discountType: discountType);
    }
  }

  Map<String, dynamic> toJson(String status, {double defaultTaxRate = 11.0}) {
    recalcAll(defaultTaxRate);
    return {
      if (idRfq != null) 'id_rfq': idRfq,
      if (reference != null) 'reference': reference,
      'pr_reference':          prReference,
      'requested_date':        requestedDate != null ? _fmtDate(requestedDate!) : null,
      'id_vendor':              idVendor,
      'purchase_team':          purchaseTeam,
      'purchase_person':        purchasePerson,
      'destination_warehouse':  destinationWarehouse,
      'destination_location':   destinationLocation,
      'expected_arrival':       expectedArrival != null ? _fmtDate(expectedArrival!) : null,
      'expiration_date':        expirationDate != null ? _fmtDate(expirationDate!) : null,
      if (idPriceList   != null) 'id_price_list':   idPriceList,
      if (idPaymentTerm != null) 'id_payment_term': idPaymentTerm,
      'is_tax':          isTax ? 'Y' : 'N',
      'discount_type':   discountType ?? '',
      'payment_type':    paymentType,
      'total_amount':    totalAmount,
      if (note != null && note!.isNotEmpty) 'note': note,
      'status':          status,
      'products':        items.map((i) => i.toJson()).toList(),
      if (isMultiPayment && schedules.isNotEmpty)
        'schedules': schedules.map((s) => s.toJson()).toList(),
    };
  }

  factory RfqFormModel.fromDetail(RfqDetailModel d) => RfqFormModel(
        idRfq:                d.idRfq,
        encryption:           d.encryption,
        reference:            d.reference,
        prReference:          d.prReference,
        requestedDate:        d.requestedDate != null ? DateTime.tryParse(d.requestedDate!) : null,
        idVendor:             d.idVendor,
        purchaseTeam:         d.purchaseTeam,
        purchasePerson:       d.purchasePerson,
        destinationWarehouse: d.destinationWarehouse,
        destinationLocation:  d.destinationLocation,
        expectedArrival:      d.expectedArrival != null ? DateTime.tryParse(d.expectedArrival!) : null,
        expirationDate:       d.expirationDate != null ? DateTime.tryParse(d.expirationDate!) : null,
        idPriceList:          d.idPriceList,
        idPaymentTerm:        d.idPaymentTerm,
        isTax:                d.isTaxEnabled,
        discountType:         d.discountType == '' ? null : d.discountType,
        paymentType:          d.paymentType,
        note:                 d.note,
        items: d.items.map((i) => RfqFormItem(
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
        schedules: d.paymentSchedules.map((s) => RfqScheduleItem(
          termName:    s.termName,
          dueDate:     s.dueDate != null ? DateTime.tryParse(s.dueDate!) : null,
          amount:      s.amount,
          percentage:  s.percentage,
          description: s.description,
        )).toList(),
      );
}