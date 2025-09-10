import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widget/product_category_index_widget.dart';
import '../../product_category/screen/product_category_show_screen.dart'; // pastikan path sesuai

class ProductCategoryScreen extends StatelessWidget {
  const ProductCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Category")),
      body: ProductCategoryListWidget(
        onTap: (id) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductCategoryShowScreen(id: id),
            ),
          );
        },
      ),
    );
  }
}
