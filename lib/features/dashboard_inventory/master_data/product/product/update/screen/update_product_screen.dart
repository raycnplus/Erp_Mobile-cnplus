import 'package:flutter/material.dart';
import '../widget/update_product_widget.dart';

class ProductUpdateScreen extends StatelessWidget {
  final int productId;
  const ProductUpdateScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Product')),
      body: ProductUpdateWidget(productId: productId),
    );
  }
}
