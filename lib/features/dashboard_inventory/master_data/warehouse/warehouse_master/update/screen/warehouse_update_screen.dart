import 'package:flutter/material.dart';
import '../../index/models/warehouse_index_models.dart';
import '../widget/warehouse_update_widget.dart';

class WarehouseEditScreen extends StatelessWidget {
  final WarehouseIndexModel warehouse;

  const WarehouseEditScreen({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Warehouse")),
      body: WarehouseEditWidget(warehouse: warehouse),
    );
  }
}
