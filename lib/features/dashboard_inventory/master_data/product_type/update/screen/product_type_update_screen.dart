import 'package:flutter/material.dart';
import '../../../product_type/update/models/product_type_update_models.dart';
import '../widget/product_type_update_widget.dart';

class ProductTypeUpdateScreen extends StatelessWidget {
  final int id;
  final ProductTypeUpdateModel data;

  const ProductTypeUpdateScreen({
    super.key,
    required this.id,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Product Type")),
      body: ProductTypeUpdateWidget(
        id: id,
        initialData: data,
      ),
    );
  }
}
