// lib/features/inventory/dashboard/data/models/inventory_dashboard_model.dart

import 'package:flutter/material.dart';

class InventoryDashboardData {
  final InventorySummary summary;
  final InventoryCharts charts;
  final List<InventoryTopProduct> topProducts;

  InventoryDashboardData({
    required this.summary,
    required this.charts,
    required this.topProducts,
  });

  factory InventoryDashboardData.fromJson(Map<String, dynamic> json) {
    return InventoryDashboardData(
      summary:     InventorySummary.fromJson(json['summary'] ?? {}),
      charts:      InventoryCharts.fromJson(json['charts'] ?? {}),
      topProducts: (json['top_products'] as List? ?? [])
          .map((e) => InventoryTopProduct.fromJson(e))
          .toList(),
    );
  }
}

class InventorySummary {
  final String receiptNote;
  final String deliveryNote;
  final String internalTransfer;
  final String stockCount;
  final String productTotal;
  final String onHandStock;
  final String lowStockAlert;
  final String expiringSoon;

  InventorySummary({
    required this.receiptNote,
    required this.deliveryNote,
    required this.internalTransfer,
    required this.stockCount,
    required this.productTotal,
    required this.onHandStock,
    required this.lowStockAlert,
    required this.expiringSoon,
  });

  factory InventorySummary.fromJson(Map<String, dynamic> json) {
    return InventorySummary(
      receiptNote:      json['receipt_note']?.toString()      ?? '0',
      deliveryNote:     json['delivery_note']?.toString()     ?? '0',
      internalTransfer: json['internal_transfer']?.toString() ?? '0',
      stockCount:       json['stock_count']?.toString()       ?? '0',
      productTotal:     json['product_total']?.toString()     ?? '0',
      onHandStock:      json['on_hand_stock']?.toString()     ?? '0',
      lowStockAlert:    json['low_stock_alert']?.toString()   ?? '0',
      expiringSoon:     json['expiring_soon']?.toString()     ?? '0',
    );
  }
}

class InventoryCharts {
  final List<ChartItem> productsByCategory;
  final List<ChartItem> stockMovesByProduct;
  final List<ChartItem> stockMovesByLocation;
  final List<ChartItem> stockByWarehouse;
  final List<ChartItem> stockByLocation;

  InventoryCharts({
    required this.productsByCategory,
    required this.stockMovesByProduct,
    required this.stockMovesByLocation,
    required this.stockByWarehouse,
    required this.stockByLocation,
  });

  factory InventoryCharts.fromJson(Map<String, dynamic> json) {
    return InventoryCharts(
      productsByCategory:   ChartItem.fromChartMap(json['products_by_category'],    color: Colors.cyan),
      stockMovesByProduct:  ChartItem.fromChartMap(json['stock_moves_by_product'],  color: Colors.green),
      stockMovesByLocation: ChartItem.fromChartMap(json['stock_moves_by_location'], color: Colors.amber),
      stockByWarehouse:     ChartItem.fromChartMap(json['stock_per_warehouse'],     color: Colors.teal),
      stockByLocation:      ChartItem.fromChartMap(json['stock_per_location'],      color: Colors.blue),
    );
  }
}

class ChartItem {
  final String label;
  final double value;
  final Color  color;

  ChartItem({
    required this.label,
    required this.value,
    required this.color,
  });

  static List<ChartItem> fromChartMap(Map? chart, {Color color = Colors.blue}) {
    if (chart == null ||
        chart['labels'] == null ||
        chart['data'] == null ||
        (chart['labels'] as List).isEmpty) {
      return [];
    }

    final labels = chart['labels'] as List;
    final data   = chart['data']   as List;

    return List.generate(labels.length, (i) {
      final val = data[i];
      final double value = val is num
          ? val.toDouble()
          : double.tryParse(val.toString()) ?? 0;

      return ChartItem(
        label: labels[i].toString(),
        value: value,
        color: color.withOpacity(0.7 + 0.3 * (i % 2)),
      );
    });
  }
}

class InventoryTopProduct {
  final String productName;
  final num total;

  InventoryTopProduct({required this.productName, required this.total});

  factory InventoryTopProduct.fromJson(Map<String, dynamic> json) {
    return InventoryTopProduct(
      productName: json['product_name']?.toString() ?? '-',
      total: _parseNum(json['total']),
    );
  }

  static num _parseNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }
}