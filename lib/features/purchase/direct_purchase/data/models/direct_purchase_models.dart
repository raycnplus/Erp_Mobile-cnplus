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

class DirectPurchaseModel {
  final int idDirectPurchase;
  final String encryption;
  final String status;
  final String? reference;
  final String? createdDate;
  final String? vendorName;
  final String? warehouseName;
  final String? locationName;

  DirectPurchaseModel({
    required this.idDirectPurchase,
    required this.encryption,
    required this.status,
    this.reference,
    this.createdDate,
    this.vendorName,
    this.warehouseName,
    this.locationName,
  });

  factory DirectPurchaseModel.fromJson(Map<String, dynamic> j) => DirectPurchaseModel(
        idDirectPurchase: _pi(j['id_direct_purchase']),
        encryption:       _ps(j['encryption']),
        status:           _ps(j['status']),
        reference:        j['reference']?.toString(),
        createdDate:      j['created_date']?.toString(),
        vendorName:       j['vendor_name']?.toString(),
        warehouseName:    j['warehouse_name']?.toString(),
        locationName:     j['location_name']?.toString(),
      );

  static const _statusColors = <String, int>{
    'Draft':            0xFF757575,
    'Waiting Approval': 0xFFFFA500,
    'Confirmed':        0xFF1565C0,
    'Done':             0xFF2E7D32,
    'Closed':           0xFF00695C,
    'Cancelled':        0xFFC62828,
  };

  int get statusColor => _statusColors[status] ?? 0xFF757575;
}

class DirectPurchasePaginationMeta {
  final int currentPage, lastPage, perPage, total;

  DirectPurchasePaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}

class DirectPurchaseItem {
  final int idDirectPurchaseItem;
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

  DirectPurchaseItem({
    required this.idDirectPurchaseItem,
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

  factory DirectPurchaseItem.fromJson(Map<String, dynamic> j) => DirectPurchaseItem(
        idDirectPurchaseItem: _pi(j['id_direct_purchase_item']),
        idProduct:            _pi(j['id_product']),
        unitOfMeasure:        _pi(j['unit_of_measure']),
        productName:          j['product']?['product_name']?.toString() ?? j['product_name']?.toString(),
        description:          j['description']?.toString(),
        uomName:              j['uom']?['unit_of_measure_name']?.toString() ?? j['uom_name']?.toString(),
        demandQty:            _pd(j['demand_qty']),
        unitPrice:            _pd(j['unit_price']),
        discountRate:         _pd(j['discount_rate']),
        discountAmount:       _pd(j['discount_amount']),
        taxRate:              _pd(j['tax_rate']),
        taxAmount:            _pd(j['tax_amount']),
        lastPurchasedPrice:   _pd(j['last_purchased_price']),
        vendorLastPrice:      _pd(j['vendor_last_price']),
        amount:               _pd(j['amount']),
      );

  double get taxedAmount => amount + taxAmount;
}

class DirectPurchaseAuditTrail {
  final String? actionByName;
  final String? actionById;
  final String? image;
  final String? description;
  final String? type;
  final String? date;

  DirectPurchaseAuditTrail({
    this.actionByName,
    this.actionById,
    this.image,
    this.description,
    this.type,
    this.date,
  });

  factory DirectPurchaseAuditTrail.fromJson(Map<String, dynamic> j) => DirectPurchaseAuditTrail(
        actionByName: j['action_by_name']?.toString(),
        actionById:   j['action_by']?.toString(),
        image:        j['image']?.toString(),
        description:  j['description']?.toString(),
        type:         j['type']?.toString(),
        date:         j['date']?.toString(),
      );
}

class DirectPurchaseReceiptNote {
  final int idReceiptNote;
  final String? reference;
  final String status;
  final String? scheduledDate;

  DirectPurchaseReceiptNote({
    required this.idReceiptNote,
    this.reference,
    required this.status,
    this.scheduledDate,
  });

  factory DirectPurchaseReceiptNote.fromJson(Map<String, dynamic> j) => DirectPurchaseReceiptNote(
        idReceiptNote:  _pi(j['id_receipt_note']),
        reference:      j['reference']?.toString(),
        status:         _ps(j['status']),
        scheduledDate:  j['scheduled_date']?.toString(),
      );
}

class DirectPurchaseDetailModel {
  final int idDirectPurchase;
  final String encryption;
  final String status;
  final String? reference;
  final String? prReference;
  final String? prEncryption;
  final int? idPr;
  final String? requestedDate;
  final int? idVendor;
  final String? vendorName;
  final int? destinationWarehouse;
  final int? destinationLocation;
  final String? destinationWarehouseName;
  final String? destinationLocationName;
  final String? expectedArrival;
  final int? idPriceList;
  final String? priceListName;
  final String? discountType;
  final String? isTax;
  final double subtotal;
  final double totalDiscount;
  final double totalTaxes;
  final double totalAmount;
  final double defaultTaxRate;
  final String? note;
  final String? createdByName;
  final String? updatedByName;
  final String? cancelledByName;
  final String? closedByName;
  final String? createdDate;
  final String? updatedDate;
  final String? cancelledDate;
  final String? closedDate;
  final String? cancelReason;
  final int? idReceiptNote;
  final List<DirectPurchaseItem> items;
  final List<DirectPurchaseAuditTrail> auditTrails;
  final List<DirectPurchaseReceiptNote> receiptNotes;
  final int receiptNoteCount;

  DirectPurchaseDetailModel({
    required this.idDirectPurchase,
    required this.encryption,
    required this.status,
    this.reference,
    this.prReference,
    this.prEncryption,
    this.idPr,
    this.requestedDate,
    this.idVendor,
    this.vendorName,
    this.destinationWarehouse,
    this.destinationLocation,
    this.destinationWarehouseName,
    this.destinationLocationName,
    this.expectedArrival,
    this.idPriceList,
    this.priceListName,
    this.discountType,
    this.isTax,
    required this.subtotal,
    required this.totalDiscount,
    required this.totalTaxes,
    required this.totalAmount,
    this.defaultTaxRate = 11.0,
    this.note,
    this.createdByName,
    this.updatedByName,
    this.cancelledByName,
    this.closedByName,
    this.createdDate,
    this.updatedDate,
    this.cancelledDate,
    this.closedDate,
    this.cancelReason,
    this.idReceiptNote,
    required this.items,
    required this.auditTrails,
    required this.receiptNotes,
    this.receiptNoteCount = 0,
  });

  factory DirectPurchaseDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DirectPurchaseDetailModel(
      idDirectPurchase:          _pi(data['id_direct_purchase']),
      encryption:                _ps(data['encryption']),
      status:                    _ps(data['status']),
      reference:                 data['reference']?.toString(),
      prReference:               data['pr_reference']?.toString(),
      prEncryption:              data['pr_encryption']?.toString(),
      idPr:                      _pi(data['id_pr']) == 0 ? null : _pi(data['id_pr']),
      requestedDate:             data['requested_date']?.toString(),
      idVendor:                  _pi(data['id_vendor']) == 0 ? null : _pi(data['id_vendor']),
      vendorName:                data['vendor_name']?.toString() ?? data['vendor']?['vendor_name']?.toString(),
      destinationWarehouse:      _pi(data['destination_warehouse']) == 0 ? null : _pi(data['destination_warehouse']),
      destinationLocation:       _pi(data['destination_location']) == 0 ? null : _pi(data['destination_location']),
      destinationWarehouseName:  data['destination_warehouse_name']?.toString(),
      destinationLocationName:   data['destination_location_name']?.toString(),
      expectedArrival:           data['expected_arrival']?.toString(),
      idPriceList:               _pi(data['id_price_list']) == 0 ? null : _pi(data['id_price_list']),
      priceListName:             data['price_list_name']?.toString(),
      discountType:              data['discount_type']?.toString(),
      isTax:                     data['is_tax']?.toString(),
      subtotal:                  _pd(data['subtotal']),
      totalDiscount:             _pd(data['total_discount']),
      totalTaxes:                _pd(data['total_taxes']),
      totalAmount:               _pd(data['total_amount']),
      defaultTaxRate:            _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
      note:                      data['note']?.toString(),
      createdByName:             data['created_by_name']?.toString(),
      updatedByName:             data['updated_by_name']?.toString(),
      cancelledByName:           data['cancelled_by_name']?.toString(),
      closedByName:              data['closed_by_name']?.toString(),
      createdDate:               data['created_date']?.toString(),
      updatedDate:               data['updated_date']?.toString(),
      cancelledDate:             data['cancelled_date']?.toString(),
      closedDate:                data['closed_date']?.toString(),
      cancelReason:              data['cancel_reason']?.toString(),
      idReceiptNote:             _pi(data['id_receipt_note']) == 0 ? null : _pi(data['id_receipt_note']),
      items:         (data['items']         as List? ?? []).map((e) => DirectPurchaseItem.fromJson(e)).toList(),
      auditTrails:   (data['audit_trails']  as List? ?? []).map((e) => DirectPurchaseAuditTrail.fromJson(e)).toList(),
      receiptNotes:  (data['receipt_notes'] as List? ?? []).map((e) => DirectPurchaseReceiptNote.fromJson(e)).toList(),
      receiptNoteCount: _pi(data['receipt_note_count']),
    );
  }

  bool get isDraft           => status == 'Draft';
  bool get isWaitingApproval => status == 'Waiting Approval';
  bool get isConfirmed       => status == 'Confirmed';
  bool get isDone            => status == 'Done';
  bool get isClosed          => status == 'Closed';
  bool get isCancelled       => status == 'Cancelled';
  bool get isTaxEnabled      => isTax == 'Y';
  bool get canEdit           => isDraft;
  bool get canConfirm        => isDraft;
  bool get canValidate       => isConfirmed;
  bool get canCancel         => isConfirmed;
  bool get canClose          => isDone;
  bool get canDelete         => isDraft;
  bool get hasPr             => prEncryption != null && prEncryption!.isNotEmpty;
}

class DirectPurchaseVendorOption {
  final int id;
  final String name;

  DirectPurchaseVendorOption({required this.id, required this.name});

  factory DirectPurchaseVendorOption.fromJson(Map<String, dynamic> j) =>
      DirectPurchaseVendorOption(id: _pi(j['id_vendor']), name: _ps(j['vendor_name']));

  @override bool operator ==(Object o) => o is DirectPurchaseVendorOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DirectPurchaseWarehouseOption {
  final int id;
  final String name;

  DirectPurchaseWarehouseOption({required this.id, required this.name});

  factory DirectPurchaseWarehouseOption.fromJson(Map<String, dynamic> j) =>
      DirectPurchaseWarehouseOption(id: _pi(j['id_warehouse']), name: _ps(j['warehouse_name']));

  @override bool operator ==(Object o) => o is DirectPurchaseWarehouseOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DirectPurchaseLocationOption {
  final int id;
  final int warehouseId;
  final String name;

  DirectPurchaseLocationOption({required this.id, required this.warehouseId, required this.name});

  factory DirectPurchaseLocationOption.fromJson(Map<String, dynamic> j) => DirectPurchaseLocationOption(
        id:          _pi(j['id_location']),
        warehouseId: _pi(j['warehouse'] ?? j['id_warehouse']),
        name:        _ps(j['location_name']),
      );

  @override bool operator ==(Object o) => o is DirectPurchaseLocationOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DirectPurchasePriceListOption {
  final int id;
  final String name;

  DirectPurchasePriceListOption({required this.id, required this.name});

  factory DirectPurchasePriceListOption.fromJson(Map<String, dynamic> j) =>
      DirectPurchasePriceListOption(id: _pi(j['id_price_list']), name: _ps(j['price_list_name']));

  @override bool operator ==(Object o) => o is DirectPurchasePriceListOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DirectPurchasePurchaseTeamOption {
  final int id;
  final String name;

  DirectPurchasePurchaseTeamOption({required this.id, required this.name});

  factory DirectPurchasePurchaseTeamOption.fromJson(Map<String, dynamic> j) =>
      DirectPurchasePurchaseTeamOption(id: _pi(j['id_purchase_team']), name: _ps(j['team_name']));

  @override bool operator ==(Object o) => o is DirectPurchasePurchaseTeamOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DirectPurchasePurchasePersonOption {
  final int id;
  final String name;

  DirectPurchasePurchasePersonOption({required this.id, required this.name});

  factory DirectPurchasePurchasePersonOption.fromJson(Map<String, dynamic> j) =>
      DirectPurchasePurchasePersonOption(id: _pi(j['id_user']), name: _ps(j['nama_lengkap']));

  @override bool operator ==(Object o) => o is DirectPurchasePurchasePersonOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DirectPurchaseProductOption {
  final int idProduct;
  final String productName;
  final String? description;

  DirectPurchaseProductOption({
    required this.idProduct,
    required this.productName,
    this.description,
  });

  factory DirectPurchaseProductOption.fromJson(Map<String, dynamic> j) => DirectPurchaseProductOption(
        idProduct:   _pi(j['id_product']),
        productName: _ps(j['product_name']),
        description: j['description']?.toString(),
      );

  @override bool operator ==(Object o) => o is DirectPurchaseProductOption && o.idProduct == idProduct;
  @override int get hashCode => idProduct.hashCode;
}

class DirectPurchaseUomOption {
  final int id;
  final String name;

  DirectPurchaseUomOption({required this.id, required this.name});

  factory DirectPurchaseUomOption.fromJson(Map<String, dynamic> j) =>
      DirectPurchaseUomOption(id: _pi(j['id_unit_of_measure']), name: _ps(j['unit_of_measure_name']));

  @override bool operator ==(Object o) => o is DirectPurchaseUomOption && o.id == id;
  @override int get hashCode => id.hashCode;
}

class DirectPurchaseFormOptions {
  final List<DirectPurchaseVendorOption> vendors;
  final List<DirectPurchaseWarehouseOption> warehouses;
  final List<DirectPurchaseLocationOption> locations;
  final List<DirectPurchasePriceListOption> priceLists;
  final List<DirectPurchasePurchaseTeamOption> purchaseTeams;
  final List<DirectPurchasePurchasePersonOption> purchasePersons;
  final List<DirectPurchaseProductOption> products;
  final List<DirectPurchaseUomOption> uoms;
  final double defaultTaxRate;

  DirectPurchaseFormOptions({
    required this.vendors,
    required this.warehouses,
    required this.locations,
    required this.priceLists,
    required this.purchaseTeams,
    required this.purchasePersons,
    required this.products,
    required this.uoms,
    this.defaultTaxRate = 11.0,
  });

  factory DirectPurchaseFormOptions.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DirectPurchaseFormOptions(
      vendors:         (data['vendors']          as List? ?? []).map((e) => DirectPurchaseVendorOption.fromJson(e)).toList(),
      warehouses:      (data['warehouses']       as List? ?? []).map((e) => DirectPurchaseWarehouseOption.fromJson(e)).toList(),
      locations:       (data['locations']        as List? ?? []).map((e) => DirectPurchaseLocationOption.fromJson(e)).toList(),
      priceLists:      (data['price_lists']      as List? ?? []).map((e) => DirectPurchasePriceListOption.fromJson(e)).toList(),
      purchaseTeams:   (data['purchase_teams']   as List? ?? []).map((e) => DirectPurchasePurchaseTeamOption.fromJson(e)).toList(),
      purchasePersons: (data['purchase_persons'] as List? ?? []).map((e) => DirectPurchasePurchasePersonOption.fromJson(e)).toList(),
      products:        (data['products']         as List? ?? []).map((e) => DirectPurchaseProductOption.fromJson(e)).toList(),
      uoms:            (data['uoms']              as List? ?? []).map((e) => DirectPurchaseUomOption.fromJson(e)).toList(),
      defaultTaxRate:  _pd(data['default_tax_rate']) == 0 ? 11.0 : _pd(data['default_tax_rate']),
    );
  }

  List<DirectPurchaseLocationOption> locationsForWarehouse(int warehouseId) =>
      locations.where((l) => l.warehouseId == warehouseId).toList();
}

class DirectPurchaseFormItem {
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

  DirectPurchaseFormItem({
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
        'last_purchased_price': lastPurchasedPrice,
        'vendor_last_price':    vendorLastPrice,
        'amount':               untaxedAmount,
      };
}

class DirectPurchaseFormModel {
  int? idDirectPurchase;
  String? encryption;
  String? reference;
  String? prReference;
  DateTime? requestedDate;
  int? idVendor;
  int? destinationWarehouse;
  int? destinationLocation;
  DateTime? expectedArrival;
  int? idPriceList;
  bool isTax;
  String? discountType;
  String? note;
  List<DirectPurchaseFormItem> items;

  DirectPurchaseFormModel({
    this.idDirectPurchase,
    this.encryption,
    this.reference,
    this.prReference,
    this.requestedDate,
    this.idVendor,
    this.destinationWarehouse,
    this.destinationLocation,
    this.expectedArrival,
    this.idPriceList,
    this.isTax = false,
    this.discountType,
    this.note,
    List<DirectPurchaseFormItem>? items,
  }) : items = items ?? [];

  bool get isEditMode => idDirectPurchase != null;

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  double get subtotal      => items.fold(0, (s, i) => s + i.untaxedAmount);
  double get totalTaxes    => items.fold(0, (s, i) => s + i.taxAmount);
  double get totalDiscount => items.fold(0, (s, i) => s + i.discountAmount);
  double get totalAmount   => subtotal + totalTaxes;

  void recalcAll(double defaultTaxRate) {
    for (final item in items) {
      item.recalculate(isTaxEnabled: isTax, defaultTaxRate: defaultTaxRate, discountType: discountType);
    }
  }

  Map<String, dynamic> toJson(String status, {double defaultTaxRate = 11.0}) {
    recalcAll(defaultTaxRate);
    return {
      if (idDirectPurchase != null) 'id_direct_purchase': idDirectPurchase,
      if (reference != null) 'reference': reference,
      'pr_reference':          prReference,
      'requested_date':        requestedDate != null ? _fmtDate(requestedDate!) : null,
      'id_vendor':              idVendor,
      'destination_warehouse':  destinationWarehouse,
      'destination_location':   destinationLocation,
      'expected_arrival':       expectedArrival != null ? _fmtDate(expectedArrival!) : null,
      if (idPriceList != null) 'id_price_list': idPriceList,
      'discount_type':   discountType ?? '',
      'is_tax':          isTax ? 'Y' : 'N',
      'total_amount':    totalAmount,
      if (note != null && note!.isNotEmpty) 'note': note,
      'status':          status,
      'products':        items.map((i) => i.toJson()).toList(),
    };
  }

  factory DirectPurchaseFormModel.fromDetail(DirectPurchaseDetailModel d) => DirectPurchaseFormModel(
        idDirectPurchase:     d.idDirectPurchase,
        encryption:           d.encryption,
        reference:            d.reference,
        prReference:          d.prReference,
        requestedDate:        d.requestedDate != null ? DateTime.tryParse(d.requestedDate!) : null,
        idVendor:             d.idVendor,
        destinationWarehouse: d.destinationWarehouse,
        destinationLocation:  d.destinationLocation,
        expectedArrival:      d.expectedArrival != null ? DateTime.tryParse(d.expectedArrival!) : null,
        idPriceList:          d.idPriceList,
        isTax:                d.isTaxEnabled,
        discountType:         d.discountType == '' ? null : d.discountType,
        note:                 d.note,
        items: d.items.map((i) => DirectPurchaseFormItem(
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
      );
}