import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/warehouse_index_models.dart';

List<WarehouseIndexModel> _parseWarehouses(String responseBody) {
  final dynamic parsed = jsonDecode(responseBody);

  if (parsed is Map<String, dynamic> && parsed.containsKey('data')) {
    final data = parsed['data'];
    if (data is List) {
      return data.map((e) => WarehouseIndexModel.fromJson(e)).toList();
    } else {
      throw Exception("Field 'data' bukan berupa List");
    }
  } else if (parsed is List) {
    return parsed.map((e) => WarehouseIndexModel.fromJson(e)).toList();
  } else {
    throw Exception("Format response warehouse tidak sesuai");
  }
}

class WarehouseListWidget extends StatefulWidget {
  final ValueChanged<WarehouseIndexModel> onTap;
  final void Function(WarehouseIndexModel, VoidCallback)? onDelete;

  const WarehouseListWidget({
    super.key,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<WarehouseListWidget> createState() => _WarehouseListWidgetState();
}

class _WarehouseListWidgetState extends State<WarehouseListWidget> {
  late Future<List<WarehouseIndexModel>> futureWarehouses;

  @override
  void initState() {
    super.initState();
    futureWarehouses = fetchWarehouses();
  }

  void _reloadData() {
    setState(() {
      futureWarehouses = fetchWarehouses();
    });
  }

  Future<List<WarehouseIndexModel>> fetchWarehouses() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return compute(_parseWarehouses, response.body);
    } else {
      throw Exception("Gagal memuat data: Status code ${response.statusCode}");
    }
  }

  Future<void> _deleteWarehouse(BuildContext context, int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Token tidak ditemukan")));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Warehouse"),
        content: const Text("Apakah Anda yakin ingin menghapus warehouse ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final url = Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/$id");

    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Warehouse berhasil dihapus")),
      );
      _reloadData();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal hapus: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WarehouseIndexModel>>(
      future: futureWarehouses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Error: ${snapshot.error}"),
                ),
                ElevatedButton(
                  onPressed: _reloadData,
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data warehouse"));
        }

        final warehouses = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _reloadData(),
          child: ListView.builder(
            itemCount: warehouses.length,
            itemBuilder: (context, index) {
              final warehouse = warehouses[index];
              return ListTile(
                leading: Text("${index + 1}"),
                title: Text(warehouse.warehouseName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Code: ${warehouse.warehouseCode}"),
                    Text("Branch: ${warehouse.branch ?? '-'}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    if (widget.onDelete != null) {
                      widget.onDelete!(warehouse, _reloadData);
                    }
                  },
                ),
                onTap: () => widget.onTap(warehouse),
              );
            },
          ),
        );
      },
    );
  }
}
