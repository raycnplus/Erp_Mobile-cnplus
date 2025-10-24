// warehouse_index_widget.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../../services/api_base.dart';
import '../models/warehouse_index_models.dart';
import 'warehouse_list_shimmer.dart'; //

class WarehouseListWidget extends StatefulWidget {
  final void Function(WarehouseIndexModel warehouse)? onTap;
  final void Function(WarehouseIndexModel warehouse) onEdit;
  final Function(String name)? onDeleteSuccess;

  const WarehouseListWidget({
    super.key,
    this.onTap,
    required this.onEdit,
    this.onDeleteSuccess,
  });

  @override
  State<WarehouseListWidget> createState() => WarehouseListWidgetState();
}

class WarehouseListWidgetState extends State<WarehouseListWidget> {
  bool _isLoading = true;
  List<WarehouseIndexModel> _warehouses = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final data = await fetchWarehouses();
      if (mounted)
        setState(() {
          _warehouses = data;
          _error = null;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString().replaceFirst("Exception: ", "");
        });
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  void reloadData() {
    _loadData();
  }

  Future<List<WarehouseIndexModel>> fetchWarehouses() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception("Token tidak ditemukan.");

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/");
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (decoded['data'] is List) {
        final List<dynamic> dataList = decoded['data'];
        return dataList
            .map((item) => WarehouseIndexModel.fromJson(item))
            .toList();
      } else {
        throw Exception(
          "Kunci 'data' tidak ditemukan atau bukan sebuah list di dalam JSON.",
        );
      }
    } else {
      throw Exception("Gagal memuat data: Status ${response.statusCode}");
    }
  }

  Future<bool> _deleteWarehouse(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/$id");
    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isNotEmpty)
        return jsonDecode(response.body)['status'] == true;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _warehouses.isEmpty) {
      return const WarehouseListShimmer();
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Error: $_error", textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: reloadData,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }
    if (_warehouses.isEmpty) {
      return const Center(child: Text("Tidak ada data warehouse"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _warehouses.length,
      itemBuilder: (context, index) {
        final warehouse = _warehouses[index];
        return _buildWarehouseCard(warehouse);
      },
    );
  }

  Widget _buildWarehouseCard(WarehouseIndexModel warehouse) {
    final cardBorderRadius = BorderRadius.circular(12);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: cardBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(warehouse.id.toString()),
        background: _buildSwipeActionContainer(
          color: const Color(0xFF4A90E2),
          icon: Icons.edit,
          text: 'Edit',
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeActionContainer(
          color: Colors.redAccent,
          icon: Icons.delete,
          text: 'Delete',
          alignment: Alignment.centerRight,
        ),

        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            widget.onEdit(warehouse);
            return false;
          } else {
            return await _showDeleteConfirmationDialog(warehouse);
          }
        },
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            try {
              final success = await _deleteWarehouse(warehouse.id);
              if (mounted) {
                if (success) {
                  widget.onDeleteSuccess?.call(warehouse.warehouseName);
                  setState(() {
                    _warehouses.remove(warehouse);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Gagal menghapus ${warehouse.warehouseName}',
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  reloadData();
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
                reloadData();
              }
            }
          }
        },
        child: ClipRRect(
          borderRadius: cardBorderRadius,
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => widget.onTap?.call(warehouse),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      warehouse.warehouseName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Code: ${warehouse.warehouseCode}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Branch: ${warehouse.branch ?? '-'}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildSwipeActionContainer({
    required Color color,
    required IconData icon,
    required String text,
    required Alignment alignment,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (alignment == Alignment.centerRight) ...[
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(WarehouseIndexModel warehouse) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(102),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white.withAlpha(230),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFF35D5D),
                    size: 50.0,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    "Are you sure you want to delete ${warehouse.warehouseName}?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF35D5D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      "Yes, Delete",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      "Keep It",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
