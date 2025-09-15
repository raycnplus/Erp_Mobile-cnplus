import 'package:flutter/material.dart';
import '../widget/product_type_create_form_widget.dart';

class ProductTypeCreateScreen extends StatelessWidget {
  const ProductTypeCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Product Type"),
      ),
      body: const ProductTypeCreateWidget(),
    );
  }
}
