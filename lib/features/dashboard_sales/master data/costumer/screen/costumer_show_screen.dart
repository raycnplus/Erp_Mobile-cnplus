import 'package:flutter/material.dart';
import '../widget/costumer_show_widget.dart';

class CustomerShowScreen extends StatelessWidget {
  final int id;

  const CustomerShowScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Show")),
      body: CustomerShowWidget(id: id),
    );
  }
}
