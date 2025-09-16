import 'package:flutter/material.dart';
import '../../product_category/models/product_category_update_models.dart';
import '../widget/product_category_update_widget.dart';

class ProductCategoryUpdateScreen extends StatelessWidget {
  final int id;
  final ProductCategoryUpdateModel data;

  const ProductCategoryUpdateScreen({
    super.key,
    required this.id,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Product Category")),
      body: ProductCategoryUpdateWidget(
        id: id,
        initialData: data,
      ),
    );
  }
}
