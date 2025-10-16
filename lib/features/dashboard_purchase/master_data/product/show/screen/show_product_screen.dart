import 'package:flutter/material.dart';
import '../widget/show_product_widget.dart';
import '../../update/screen/update_product_screen.dart'; // Add this import

class ProductShowScreen extends StatelessWidget {
  final int productId;

  const ProductShowScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: ProductShowWidget(productId: productId),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductUpdateScreen(id: productId),
            ),
          );

          // If update was successful, pop back to refresh list
          if (result == true) {
            Navigator.pop(context, true);
          }
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
