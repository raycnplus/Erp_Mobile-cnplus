import 'package:flutter/material.dart';
import '../widget/show_product_widget.dart';
import '../../create/screen/create_product_screen.dart'; // pastikan path-nya sesuai dengan project kamu

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
          // Navigasi ke halaman create product
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductCreateScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
