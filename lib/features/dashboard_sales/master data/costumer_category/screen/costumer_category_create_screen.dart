import 'package:flutter/material.dart';
import '../widget/costumer_category_create_widget.dart';

class CustomerCategoryCreateScreen extends StatelessWidget {
  const CustomerCategoryCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Customer Category"),
      ),
      body: const CustomerCategoryCreateWidget(),
    );
  }
}
