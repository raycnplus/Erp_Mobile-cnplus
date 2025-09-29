import 'package:flutter/material.dart';
import '../widget/show_product_widget.dart';

class ProductShowScreen extends StatelessWidget {
  final int productId;

  const ProductShowScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductShowWidget(productId: productId),
    );
  }
}
