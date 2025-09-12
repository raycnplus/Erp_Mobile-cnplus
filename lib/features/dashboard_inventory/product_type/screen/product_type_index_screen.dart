import '../../product_type/widget/product_type_show_widget.dart';
import '../../product_type/widget/product_type_index_widget.dart';
import 'package:flutter/material.dart';
import '../screen/product_type_create_screen.dart'; 

class ProductTypeIndexScreen extends StatefulWidget {
  const ProductTypeIndexScreen({super.key});

  @override
  State<ProductTypeIndexScreen> createState() => _ProductTypeIndexScreenState();
}

class _ProductTypeIndexScreenState extends State<ProductTypeIndexScreen> {
  Future<void> _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductTypeCreateScreen(),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

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
                id: productType.id,
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
