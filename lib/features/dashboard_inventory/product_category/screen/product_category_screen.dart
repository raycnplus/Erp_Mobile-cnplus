import 'package:flutter/material.dart';
import '../widget/product_category_index.dart'; 

class ProductCategoryScreen extends StatelessWidget {
  const ProductCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Category")),
      body: const ProductCategoryListWidget(), 
    );
  }
}