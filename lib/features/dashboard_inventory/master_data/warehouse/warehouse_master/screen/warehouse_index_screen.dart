import 'package:flutter/material.dart';
import '../models/warehouse_index_models.dart';
import '../widget/warehouse_index_widget.dart';

class WarehouseIndexScreen extends StatelessWidget {
  const WarehouseIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouse Index")),
      body: WarehouseListWidget(
        onTap: (WarehouseIndexModel warehouse) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Dipilih: ${warehouse.warehouseName}")),
          );
        },
      ),
    );
  }
}
