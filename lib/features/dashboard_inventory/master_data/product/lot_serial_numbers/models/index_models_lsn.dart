class LotSerialIndexModel {
  final int idProductLotSerial;
  final String sourceType;
  final int sourceId;
  final String lotSerialNumber;
  final String productName;
  final String trackingMethod;
  final String initialQuantity;
  final String remainingQuantity;
  final String status;
  final String usedQuantity;
  final String createdDate;

  LotSerialIndexModel({
    required this.idProductLotSerial,
    required this.sourceType,
    required this.sourceId,
    required this.lotSerialNumber,
    required this.productName,
    required this.trackingMethod,
    required this.initialQuantity,
    required this.remainingQuantity,
    required this.status,
    required this.usedQuantity,
    required this.createdDate,
  });

  factory LotSerialIndexModel.fromJson(Map<String, dynamic> json) {
    return LotSerialIndexModel(
      idProductLotSerial: json['id_product_lot_serial'] ?? 0,
      sourceType: json['source_type'] ?? '-',
      sourceId: json['source_id'] ?? 0,
      lotSerialNumber: json['lot_serial_number'] ?? '-',
      productName: json['product_name'] ?? '-',
      trackingMethod: json['tracking_method'] ?? '-',
      initialQuantity: json['initial_quantity'] ?? '-',
      remainingQuantity: json['remaining_quantity'] ?? '-',
      status: json['status'] ?? '-',
      usedQuantity: json['used_quantity'] ?? '-',
      createdDate: json['created_date'] ?? '-',
    );
  }
}
