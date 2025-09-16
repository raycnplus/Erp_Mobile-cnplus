import 'package:flutter/material.dart';
import '../widget/product_category_create_form_widget.dart';

class ProductCategoryCreateScreen extends StatelessWidget {
  const ProductCategoryCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProductCategoryCreateWidget(),
    );
  }
}
