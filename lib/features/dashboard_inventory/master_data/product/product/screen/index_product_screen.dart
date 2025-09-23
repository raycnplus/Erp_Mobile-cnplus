import 'package:flutter/material.dart';
import '../models/index_product_models.dart';
import '../widget/index_product_widget.dart';
import '../screen/show_product_screen.dart';

class ProductIndexScreen extends StatelessWidget {
  const ProductIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Index")),
      body: ProductListWidget(
        onTap: (ProductIndexModel product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductShowScreen(productId: product.idProduct),
            ),
          );
        },
      ),
    );
  }
}
