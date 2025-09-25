import 'package:flutter/material.dart';
import '../widget/costumer_category_update_widget.dart';

class CustomerCategoryUpdateScreen extends StatelessWidget {
  final int id;

  const CustomerCategoryUpdateScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Customer Category"),
      ),
      body: CustomerCategoryUpdateWidget(id: id),
    );
  }
}
