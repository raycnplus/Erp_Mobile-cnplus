import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/warehouse_show_widget.dart';
import '../../index/models/warehouse_index_models.dart';
import '../../update/widget/warehouse_update_widget.dart';

class WarehouseShowScreen extends StatefulWidget {
  final WarehouseIndexModel warehouse;

  const WarehouseShowScreen({super.key, required this.warehouse});

  @override
  State<WarehouseShowScreen> createState() => _WarehouseShowScreenState();
}

class _WarehouseShowScreenState extends State<WarehouseShowScreen> {
  // [PERBAIKAN] Menggunakan nama State class yang sudah public
  final GlobalKey<WarehouseShowWidgetInternalState> _showWidgetKey = GlobalKey<WarehouseShowWidgetInternalState>();

  Future<void> _showEditModal(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Text(
                      "Edit Warehouse",
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: WarehouseEditWidget(warehouse: widget.warehouse),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result == true) {
      _showWidgetKey.currentState?.refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Warehouse Detail",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        elevation: 1.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () => _showEditModal(context),
            tooltip: "Edit Warehouse",
          ),
        ],
      ),
      body: WarehouseShowWidget(
        key: _showWidgetKey,
        warehouseId: widget.warehouse.id,
      ),
    );
  }
}