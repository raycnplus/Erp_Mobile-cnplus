import 'package:flutter/material.dart';
import '../widget/costumer_update_widget.dart';

class CustomerUpdateScreen extends StatelessWidget {
  final int id;

  const CustomerUpdateScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomerUpdateWidget(id: id),
      ),
    );
  }
}
