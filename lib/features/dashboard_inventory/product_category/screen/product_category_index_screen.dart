import 'package:flutter/material.dart';
import '../../product_category/widget/product_category_show_widget.dart';
import '../widget/product_category_index_widget.dart';
import '../../product_category/models/product_category_index.dart';
import 'product_category_create_screen.dart'; // 👉 import screen create

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  Future<void> _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductCategoryCreateScreen(),
      ),
    );

    if (result == true) {
      setState(() {}); 
    }
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        child: const Icon(Icons.add),
      ),
    );
  }
}
