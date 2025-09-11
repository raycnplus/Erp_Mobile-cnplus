
import '../../product_type/widget/product_type_show_widget.dart'; 

import '../../product_type/widget/product_type_index_widget.dart';
import 'package:flutter/material.dart';

class ProductTypeIndexScreen extends StatelessWidget {
  const ProductTypeIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Type")),
      body: ProductTypeScreen(
        onTap: (productType) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductTypeShowScreen(
                id: productType.id, // <-- Ganti dari 'productTypeId' menjadi 'id'
              ),
            ),
          );
        },
      ),
    );
  }
}