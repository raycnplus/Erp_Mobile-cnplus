

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widget/warehouse_show_widget.dart';
import '../../index/models/warehouse_index_models.dart';
import '../../update/widget/warehouse_update_widget.dart';
import '../../../../../../../services/api_base.dart';
import '../../../../../../../shared/widgets/success_bottom_sheet.dart';

class WarehouseShowScreen extends StatefulWidget {
  final WarehouseIndexModel warehouse;

  const WarehouseShowScreen({super.key, required this.warehouse});

  @override
  State<WarehouseShowScreen> createState() => _WarehouseShowScreenState();
}

class _WarehouseShowScreenState extends State<WarehouseShowScreen> {
  final GlobalKey<WarehouseShowWidgetInternalState> _showWidgetKey =
      GlobalKey<WarehouseShowWidgetInternalState>();
  bool _hasBeenUpdated = false;

  void _triggerRefresh() {
    _showWidgetKey.currentState?.refreshData();
    setState(() {
      _hasBeenUpdated = true;
    });
  }

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
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
      _triggerRefresh();
      if (mounted) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => const SuccessBottomSheet(
            title: "Successfully Updated!",
            message: "The warehouse data has been updated.",
            themeColor: Color(0xFF4A90E2),
          ),
        );
      }
    }
  }

  Future<bool> _deleteWarehouse(int id) async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('${ApiBase.baseUrl}/inventory/warehouse/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if(response.statusCode == 200 || response.statusCode == 204) {
      // Tandai bahwa ada perubahan (delete)
      setState(() { _hasBeenUpdated = true; });
      return true;
    }
    return false;
  }

  Future<void> _confirmAndDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete "${widget.warehouse.warehouseName}"? This action cannot be undone.', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final success = await _deleteWarehouse(widget.warehouse.id);
        if (mounted) Navigator.pop(context); // Tutup loading

        if (success) {
          if (mounted) Navigator.pop(context, true); // Kembali ke halaman index
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to delete warehouse."), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Tutup loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ▼▼▼ PERBAIKAN 1: Mengganti WillPopScope dengan PopScope ▼▼▼
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        Navigator.pop(context, _hasBeenUpdated);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(_hasBeenUpdated),
          ),
          title: Text(
            "Warehouse Detail",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          elevation: 1.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _confirmAndDelete();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: WarehouseShowWidget(
          key: _showWidgetKey,
          warehouseId: widget.warehouse.id,
        ),
        // ▼▼▼ PERBAIKAN 2: Mengganti nama widget yang salah ▼▼▼
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showEditModal(context),
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          label: Text('Edit Warehouse', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}