import 'package:flutter/material.dart'; // <-- Pastikan import ini ada

class ProductType {
  final int id;
  final String name;
  final String encryption;
  final String createdDate;
  final int? iconCodePoint; // <-- Tambahkan field ini

  ProductType({
    required this.id,
    required this.name,
    required this.encryption,
    required this.createdDate,
    this.iconCodePoint, // <-- Tambahkan di constructor
  });

  // <-- Tambahkan getter ini -->
  // Ini adalah bagian yang hilang dan menyebabkan error.
  IconData get displayIcon {
    if (iconCodePoint != null) {
      return IconData(iconCodePoint!, fontFamily: 'MaterialIcons');
    }
    // Ikon default jika data dari API null
    return Icons.category_outlined;
  }

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id_product_type'] ?? 0,
      name: json['product_type_name'] ?? '',
      encryption: json['encryption'] ?? '',
      createdDate: json['created_date'] ?? '',
      iconCodePoint: json['icon_code_point'], // <-- Tambahkan parsing ini
    );
  }
}