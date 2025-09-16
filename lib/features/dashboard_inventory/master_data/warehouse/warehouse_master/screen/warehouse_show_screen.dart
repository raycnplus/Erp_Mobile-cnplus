import 'package:flutter/material.dart';
import '../widget/warehouse_show_widget.dart';

import '../models/warehouse_index_models.dart'; 
import 'warehouse_update_screen.dart'; 

class WarehouseShowScreen extends StatelessWidget {
  final WarehouseIndexModel warehouse;

  const WarehouseShowScreen({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warehouse Detail"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WarehouseEditScreen(warehouse: warehouse),
                ),
              );
            },
            child: const Text("Edit"),
          ),
        ],
      ),
      body: WarehouseShowWidget(warehouseId: warehouse.id),
    );
  }
}