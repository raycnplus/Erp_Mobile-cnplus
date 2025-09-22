import 'package:flutter/material.dart';
import '../models/index_product_models.dart';
import '../widget/index_product_widget.dart';

class ProductIndexScreen extends StatelessWidget {
  const ProductIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Index")),
      body: ProductListWidget(
        onTap: (ProductIndexModel product) {
          // Navigasi ke detail/edit
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Tapped: ${product.productName}")),
          );
        },
      ),
    );
  }
}
