import 'package:flutter/material.dart';
import '../widget/create_product_widget.dart';

class ProductCreateScreen extends StatelessWidget {
  const ProductCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Product")),
      body: const ProductCreateWidget(),
    );
  }
}
