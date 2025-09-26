import 'package:flutter/material.dart';
import '../widget/warehouse_create_widget.dart';

class WarehouseCreateScreen extends StatelessWidget {
  const WarehouseCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Warehouse"),
      ),
      body: const WarehouseCreateWidget(),
    );
  }
}
