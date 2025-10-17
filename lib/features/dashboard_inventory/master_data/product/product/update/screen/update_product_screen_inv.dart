import 'package:flutter/material.dart';
import '../widget/update_product_widget_inv.dart';

class ProductUpdateScreen extends StatelessWidget {
  final int id;
  const ProductUpdateScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Product")),
      body: ProductUpdateWidget(id: id),
    );
  }
}
