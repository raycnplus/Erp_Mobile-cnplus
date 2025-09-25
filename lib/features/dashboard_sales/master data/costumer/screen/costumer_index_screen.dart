import 'package:flutter/material.dart';
import '../models/costumer_index_models.dart';
import '../widget/costumer_index_widget.dart';

class CustomerIndexScreen extends StatelessWidget {
  const CustomerIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer")),
      body: CustomerIndexWidget(
        onTap: (CustomerIndexModel customer) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Tapped: ${customer.customerName}")),
          );
        },
      ),
    );
  }
}
