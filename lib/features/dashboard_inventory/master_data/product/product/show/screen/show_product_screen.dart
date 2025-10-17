import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/product/product/update/screen/update_product_screen_inv.dart';
import 'package:flutter/material.dart';
import '../widget/show_product_widget.dart';

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
              builder: (context) => ProductUpdateScreen(id: productId),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
