import 'package:flutter/material.dart';
import '../widget/costumer_category_show_widget.dart';

class CustomerCategoryShowScreen extends StatelessWidget {
  final int id;

  const CustomerCategoryShowScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Category Detail"),
      ),
      body: CustomerCategoryShowWidget(id: id),
    );
  }
}
