import 'package:flutter/material.dart';
import '../widget/warehouse_show_widget.dart';

class WarehouseShowScreen extends StatelessWidget {
  final int warehouseId;

  const WarehouseShowScreen({super.key, required this.warehouseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Warehouse Detail"),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: navigasi ke edit screen
            },
            child: const Text("Edit"),
          ),
        ],
      ),
      body: WarehouseShowWidget(warehouseId: warehouseId),
    );
  }
}
