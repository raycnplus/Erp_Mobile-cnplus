import 'package:flutter/material.dart';
import './chart_data_model.dart'; 

/// Model utama yang membungkus seluruh respons data dari API dashboard.
/// Tujuannya adalah untuk memberikan type-safety dan kemudahan akses data.
class DashboardData {
  final SummaryData summary;
  final ChartCollection charts;
  final List<TopProductData> topProducts;

  DashboardData({
    required this.summary,
    required this.charts,
    required this.topProducts,
  });

  /// Factory constructor untuk membuat instance DashboardData dari JSON Map.
  factory DashboardData.fromJson(Map<String, dynamic> json) {
    // Mengambil list 'top_products' dan mengubahnya menjadi List<TopProductData>
    final topProductsList = (json['top_products'] as List<dynamic>?)
            ?.map((item) => TopProductData.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return DashboardData(
      summary: SummaryData.fromJson(json['summary'] ?? {}),
      charts: ChartCollection.fromJson(json['charts'] ?? {}),
      topProducts: topProductsList,
    );
  }
}

/// Model untuk objek 'summary' dalam respons API.
/// Berisi semua data statistik dalam bentuk kartu.
class SummaryData {
  final String receiptNote;
  final String deliveryNote;
  final String internalTransfer;
  final String stockCount;
  final String productTotal;
  final String onHandStock;
  final String lowStockAlert;
  final String expiringSoon;

  SummaryData({
    required this.receiptNote,
    required this.deliveryNote,
    required this.internalTransfer,
    required this.stockCount,
    required this.productTotal,
    required this.onHandStock,
    required this.lowStockAlert,
    required this.expiringSoon,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    // Menggunakan 'toString()' dan '??' untuk keamanan jika data null atau bukan string
    return SummaryData(
      receiptNote: json['receipt_note']?.toString() ?? '0',
      deliveryNote: json['delivery_note']?.toString() ?? '0',
      internalTransfer: json['internal_transfer']?.toString() ?? '0',
      stockCount: json['stock_count']?.toString() ?? '0',
      productTotal: json['product_total']?.toString() ?? '0',
      onHandStock: json['on_hand_stock']?.toString() ?? '0',
      lowStockAlert: json['low_stock_alert']?.toString() ?? '0',
      expiringSoon: json['expiring_soon']?.toString() ?? '0',
    );
  }
}

/// Model untuk objek 'charts' dalam respons API.
/// Mengubah setiap data chart menjadi List<ChartData> yang siap pakai.
class ChartCollection {
  final List<ChartData> productsByCategory;
  final List<ChartData> stockMovesByProduct;
  final List<ChartData> stockMovesByLocation;
  final List<ChartData> stockByWarehouse;
  final List<ChartData> stockByLocation;

  ChartCollection({
    required this.productsByCategory,
    required this.stockMovesByProduct,
    required this.stockMovesByLocation,
    required this.stockByWarehouse,
    required this.stockByLocation,
  });

  factory ChartCollection.fromJson(Map<String, dynamic> json) {
    return ChartCollection(
      productsByCategory: ChartData.fromChartMap(
        json['products_by_category'],
        color: Colors.cyan,
      ),
      stockMovesByProduct: ChartData.fromChartMap(
        json['stock_moves_by_product'],
        color: Colors.green,
      ),
      stockMovesByLocation: ChartData.fromChartMap(
        json['stock_moves_by_location'],
        color: Colors.amber,
      ),
      stockByWarehouse: ChartData.fromChartMap(
        json['stock_per_warehouse'],
        color: Colors.teal,
      ),
      stockByLocation: ChartData.fromChartMap(
        json['stock_per_location'],
        color: Colors.blue,
      ),
    );
  }
}

/// Model untuk setiap item dalam list 'top_products'.
class TopProductData {
  final String productName;
  final dynamic total; // Bisa int atau double, jadi gunakan dynamic atau num

  TopProductData({required this.productName, required this.total});

  factory TopProductData.fromJson(Map<String, dynamic> json) {
    return TopProductData(
      productName: json['product_name'] ?? '-',
      total: json['total'] ?? 0,
    );
  }
}