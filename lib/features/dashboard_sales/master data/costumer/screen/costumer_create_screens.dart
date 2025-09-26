import 'package:flutter/material.dart';
import '../widget/costumer_create_widget.dart';

class CustomerCreateScreen extends StatelessWidget {
  const CustomerCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Customer"),
      ),
      body: const CustomerCreateWidget(),
    );
  }
}
