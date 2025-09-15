// product_type_index_screen.dart
import '../../create/screen/product_type_create_screen.dart';
import 'package:flutter/material.dart';
import '../widget/product_type_index_widget.dart';
import '../../show/widget/product_type_show_widget.dart';

class ProductTypeIndexScreen extends StatelessWidget {
  const ProductTypeIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Types"),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,



      ),
      body: ProductTypeScreen(
        onTap: (productType) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductTypeShowScreen(id: productType.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductTypeCreateScreen(),
            ),
          );
        },
        tooltip: 'Add Product Type',
        child: const Icon(Icons.add),
      ),
    );
  }
}
