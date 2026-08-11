import 'package:flutter/material.dart';

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

class PurchaseChartData {
  final String label;
  final double value;
  final Color? color;

  PurchaseChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class TopListData {
  final String title;
  final String value;

  TopListData({required this.title, required this.value});

  factory TopListData.fromJson(Map<String, dynamic> json) {
    return TopListData(
      title: json['title']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

class MonthlyPurchaseData {
  final int month;
  final int year; 
  final double amount;

  MonthlyPurchaseData({required this.month, required this.year, required this.amount});
}

class TopProduct {
  final String productName;
  final double totalSpent;

  TopProduct({required this.productName, required this.totalSpent});

  factory TopProduct.fromJson(Map<String, dynamic> json) => TopProduct(
        productName: json['product_name']?.toString() ?? '',
        totalSpent:  _parseDouble(json['total_spent']),
      );
}

class TopVendor {
  final String vendorName;
  final double totalSpent;

  TopVendor({required this.vendorName, required this.totalSpent});

  factory TopVendor.fromJson(Map<String, dynamic> json) => TopVendor(
        vendorName: json['vendor_name']?.toString() ?? '',
        totalSpent: _parseDouble(json['total_spent']),
      );
}

class TopPurchaseOrder {
  final String reference;
  final double totalAmount;

  TopPurchaseOrder({required this.reference, required this.totalAmount});

  factory TopPurchaseOrder.fromJson(Map<String, dynamic> json) => TopPurchaseOrder(
        reference:   json['reference']?.toString() ?? '',
        totalAmount: _parseDouble(json['total_amount']),
      );
}

class TopCategory {
  final String productCategoryName;
  final double totalAmount;

  TopCategory({required this.productCategoryName, required this.totalAmount});

  factory TopCategory.fromJson(Map<String, dynamic> json) => TopCategory(
        productCategoryName: json['product_category_name']?.toString() ?? '',
        totalAmount:         _parseDouble(json['total_amount']),
      );
}

class PurchaseSummary {
  final int purchaseRequest;
  final int rfq;
  final int purchaseOrder;
  final int directPurchase;

  PurchaseSummary({
    required this.purchaseRequest,
    required this.rfq,
    required this.purchaseOrder,
    required this.directPurchase,
  });

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) => PurchaseSummary(
        purchaseRequest: _parseInt(json['purchase_request']),
        rfq:             _parseInt(json['rfq']),
        purchaseOrder:   _parseInt(json['purchase_order']),
        directPurchase:  _parseInt(json['direct_purchase']),
      );
}

class SpendingByMonth {
  final List<String> labels;
  final List<double> data;

  SpendingByMonth({required this.labels, required this.data});

  factory SpendingByMonth.fromJson(Map<String, dynamic> json) => SpendingByMonth(
        labels: List<String>.from(json['labels'] ?? []),
        data:   (json['data'] as List? ?? [])
            .map((e) => _parseDouble(e))
            .toList(),
      );
}

class PurchaseCharts {
  final SpendingByMonth spendingByMonth;

  PurchaseCharts({required this.spendingByMonth});

  factory PurchaseCharts.fromJson(Map<String, dynamic> json) => PurchaseCharts(
        spendingByMonth: SpendingByMonth.fromJson(json['spending_by_month'] ?? {}),
      );
}

class PurchaseDashboardResponse {
  final PurchaseSummary        summary;
  final PurchaseCharts         charts;
  final List<TopProduct>       topProducts;
  final List<TopVendor>        topVendors;
  final List<TopPurchaseOrder> topPurchaseOrders;
  final List<TopCategory>      topCategories;

  PurchaseDashboardResponse({
    required this.summary,
    required this.charts,
    required this.topProducts,
    required this.topVendors,
    required this.topPurchaseOrders,
    required this.topCategories,
  });

  factory PurchaseDashboardResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseDashboardResponse(
      summary: PurchaseSummary.fromJson(json['summary'] ?? {}),
      charts:  PurchaseCharts.fromJson(json['charts']  ?? {}),
      topProducts: (json['top_products'] as List? ?? [])
          .map((e) => TopProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      topVendors: (json['top_vendors'] as List? ?? [])
          .map((e) => TopVendor.fromJson(e as Map<String, dynamic>))
          .toList(),
      topPurchaseOrders: (json['top_purchase_orders'] as List? ?? [])
          .map((e) => TopPurchaseOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCategories: (json['top_categories'] as List? ?? [])
          .map((e) => TopCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}