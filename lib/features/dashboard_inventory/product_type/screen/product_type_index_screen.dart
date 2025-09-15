// product_type_index_screen.dart

import 'package:flutter/material.dart';
import '../../product_type/widget/product_type_index_widget.dart';
import '../../product_type/widget/product_type_show_widget.dart';

class ProductTypeIndexScreen extends StatelessWidget {
  const ProductTypeIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Types"),
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black87,
      ),
      body: ProductTypeScreen(
        onTap: (productType) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductTypeShowScreen(
                id: productType.id,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  Tambahkan logika untuk navigasi ke halaman Tambah Product Type
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigasi ke halaman Tambah Data')),
          );
        },
        tooltip: 'Add Product Type',
        child: const Icon(Icons.add),
      ),
    );
  }
}