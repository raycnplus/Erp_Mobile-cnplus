import '../../product_type/widget/product_type_index_widget.dart';
import 'package:flutter/material.dart';

class ProductTypeIndexScreen extends StatelessWidget {
  const ProductTypeIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Type")),
      body: const ProductTypeScreen(),
    );
  }
}