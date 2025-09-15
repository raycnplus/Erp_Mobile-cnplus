import 'package:flutter/material.dart';
import '../models/product_category_show_models.dart';

class ProductCategoryShowScreen extends StatelessWidget {
  final ProductCategoryShowModels id;

  const ProductCategoryShowScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Category Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("ID: ${id.id}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("Category Product Name: ${id.productCategoryName}",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("Created On: ${id.createdOn}",
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text("Created By: ${id.createdBy ?? '-'}",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
