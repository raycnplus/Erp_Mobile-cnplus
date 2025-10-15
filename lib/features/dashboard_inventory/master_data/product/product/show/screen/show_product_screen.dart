import 'package:flutter/material.dart';
import '../widget/show_product_widget.dart';
import '../../update/screen/update_product_screen.dart'; // pastikan path-nya sesuai dengan project kamu

class ProductShowScreen extends StatelessWidget {
  final int productId;

  const ProductShowScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductShowWidget(productId: productId),

      // Tambahkan FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman update product
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductUpdateScreen(productId: productId),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
