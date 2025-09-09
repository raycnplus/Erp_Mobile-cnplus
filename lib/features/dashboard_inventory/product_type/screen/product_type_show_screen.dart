import 'package:flutter/material.dart';

class ProductTypeShowScreen extends StatelessWidget {
  final int productTypeId;

  const ProductTypeShowScreen({
    super.key,
    required this.productTypeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Type Detail")),
      body: ProductTypeShowScreen(productTypeId: productTypeId),
    );
  }
}

