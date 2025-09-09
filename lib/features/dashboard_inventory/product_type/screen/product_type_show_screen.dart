import 'package:flutter/material.dart';
import '../models/product_type_show_model.dart'; // ✅ pastikan path sesuai

class ProductTypeShowScreen extends StatelessWidget {
  final ProductTypeDetail detail;

  const ProductTypeShowScreen({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Type Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow("Product Type Name", detail.productCategoryName),
                const SizedBox(height: 12),
                _buildRow("Created On", detail.createdDate ?? "-"),
                const SizedBox(height: 12),
                _buildRow("Created By", detail.createdBy ?? "-"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// helper buat row
  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
