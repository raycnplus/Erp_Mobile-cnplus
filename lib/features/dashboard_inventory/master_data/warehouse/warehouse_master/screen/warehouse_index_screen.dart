import 'package:flutter/material.dart';
import '../models/warehouse_index_models.dart';
import '../widget/warehouse_index_widget.dart';
import '../../warehouse_master/screen/warehouse_show_screen.dart';
import '../../warehouse_master/screen/warehouse_create_screen.dart';
import '../../warehouse_master/widget/warehouse_delete_widget.dart';

class WarehouseIndexScreen extends StatelessWidget {
  const WarehouseIndexScreen({super.key});

  void _handleDelete(BuildContext context, WarehouseIndexModel warehouse, VoidCallback refresh) {
    showDialog(
      context: context,
      builder: (context) => WarehouseDeleteWidget(
        warehouseId: warehouse.id,
        onDelete: () {
          Navigator.pop(context);
          refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Warehouse ${warehouse.warehouseName} berhasil dihapus")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Warehouse")),
      body: WarehouseListWidget(
        onTap: (WarehouseIndexModel warehouse) async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WarehouseShowScreen(warehouse: warehouse),
            ),
          );
        },
        onDelete: (warehouse, refresh) => _handleDelete(context, warehouse, refresh),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WarehouseCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
