import 'package:flutter/material.dart';
import '../models/warehouse_index_models.dart';
import '../widget/warehouse_index_widget.dart';
import '../../warehouse_master/screen/warehouse_show_screen.dart';

class WarehouseIndexScreen extends StatelessWidget {
  const WarehouseIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouse Index")),
      body: WarehouseListWidget(
        onTap: (WarehouseIndexModel warehouse) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WarehouseShowScreen(warehouseId: warehouse.id),
            ),
          );
        },
      ),
    );
  }
}
