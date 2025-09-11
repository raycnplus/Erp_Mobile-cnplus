import 'package:flutter/material.dart';
import '../../product_category/widget/product_category_show_widget.dart';
import '../widget/product_category_index_widget.dart';
import '../../product_category/models/product_category_index.dart';

class ProductCategoryScreen extends StatelessWidget {
  const ProductCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Category")),
      body: ProductCategoryListWidget(
        onTap: (ProductCategory category) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductCategoryShowScreen(
                id: category.id,
              ),
            ),
          );
        },
      ),
    );
  }
}