int _parseInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

double _parseDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

class ManufacturingFilterInfo {
  final String startDate;
  final String endDate;

  ManufacturingFilterInfo({required this.startDate, required this.endDate});

  factory ManufacturingFilterInfo.fromJson(Map<String, dynamic> json) =>
      ManufacturingFilterInfo(
        startDate: json['start_date']?.toString() ?? '',
        endDate: json['end_date']?.toString() ?? '',
      );
}

class ManufacturingSummary {
  final int manufacturingOrders;
  final int unbuildOrders;
  final int bom;
  final int activeOperations;

  ManufacturingSummary({
    required this.manufacturingOrders,
    required this.unbuildOrders,
    required this.bom,
    required this.activeOperations,
  });

  factory ManufacturingSummary.fromJson(Map<String, dynamic> json) =>
      ManufacturingSummary(
        manufacturingOrders: _parseInt(json['manufacturing_orders']),
        unbuildOrders: _parseInt(json['unbuild_orders']),
        bom: _parseInt(json['bom']),
        activeOperations: _parseInt(json['active_operations']),
      );
}

class ManufacturingChartItem {
  final String productName;
  final double totalQty;

  ManufacturingChartItem({required this.productName, required this.totalQty});

  factory ManufacturingChartItem.fromJson(Map<String, dynamic> json) =>
      ManufacturingChartItem(
        productName: json['product_name']?.toString() ?? '',
        totalQty: _parseDouble(json['total_qty'] ?? json['total_used']),
      );
}

class ManufacturingCharts {
  final List<ManufacturingChartItem> finishedProducts;
  final List<ManufacturingChartItem> usedMaterials;

  ManufacturingCharts({required this.finishedProducts, required this.usedMaterials});

  factory ManufacturingCharts.fromJson(Map<String, dynamic> json) =>
      ManufacturingCharts(
        finishedProducts: (json['finished_products'] as List? ?? [])
            .map((e) => ManufacturingChartItem.fromJson(e))
            .toList(),
        usedMaterials: (json['used_materials'] as List? ?? [])
            .map((e) => ManufacturingChartItem.fromJson(e))
            .toList(),
      );
}

class WorkInProgressItem {
  final String reference;
  final String productName;
  final double plannedQty;
  final String? scheduledDate;
  final String status;

  WorkInProgressItem({
    required this.reference,
    required this.productName,
    required this.plannedQty,
    this.scheduledDate,
    required this.status,
  });

  factory WorkInProgressItem.fromJson(Map<String, dynamic> json) =>
      WorkInProgressItem(
        reference: json['reference']?.toString() ?? '',
        productName: json['product_name']?.toString() ?? '',
        plannedQty: _parseDouble(json['planned_qty']),
        scheduledDate: json['scheduled_date']?.toString(),
        status: json['status']?.toString() ?? '',
      );
}

class ManufacturingDashboardResponse {
  final ManufacturingFilterInfo filter;
  final ManufacturingSummary summary;
  final ManufacturingCharts charts;
  final List<WorkInProgressItem> workInProgress;

  ManufacturingDashboardResponse({
    required this.filter,
    required this.summary,
    required this.charts,
    required this.workInProgress,
  });

  factory ManufacturingDashboardResponse.fromJson(Map<String, dynamic> json) =>
      ManufacturingDashboardResponse(
        filter: ManufacturingFilterInfo.fromJson(json['filter'] ?? {}),
        summary: ManufacturingSummary.fromJson(json['summary'] ?? {}),
        charts: ManufacturingCharts.fromJson(json['charts'] ?? {}),
        workInProgress: (json['work_in_progress'] as List? ?? [])
            .map((e) => WorkInProgressItem.fromJson(e))
            .toList(),
      );
}