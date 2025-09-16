import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../../warehouse_master/models/warehouse_show_models.dart';

class WarehouseShowWidget extends StatefulWidget {
  final int warehouseId;

  const WarehouseShowWidget({super.key, required this.warehouseId});

  @override
  State<WarehouseShowWidget> createState() => _WarehouseShowWidgetState();
}

class _WarehouseShowWidgetState extends State<WarehouseShowWidget> {
  WarehouseShowModel? warehouse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWarehouse();
  }

  Future<void> fetchWarehouse() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token == null || token.isEmpty) {
        throw Exception("Token tidak ditemukan. Silakan login ulang.");
      }

      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/${widget.warehouseId}"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final warehouseData = (data is Map<String, dynamic> && data.containsKey("warehouse"))
            ? data["warehouse"]
            : data;

        setState(() {
          warehouse = WarehouseShowModel.fromJson(warehouseData);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load warehouse detail: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget _buildTile(String title, String? value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value ?? "-"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (warehouse == null) {
      return const Center(child: Text("No data found"));
    }

    return RefreshIndicator(
      onRefresh: () async => fetchWarehouse(),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTile("ID Warehouse", warehouse!.idWarehouse.toString()),
          _buildTile("Warehouse Name", warehouse!.warehouseName),
          _buildTile("Warehouse Code", warehouse!.warehouseCode),
          _buildTile("Branch", warehouse!.branch),
          _buildTile("Address", warehouse!.address),
          _buildTile("Length", warehouse!.length?.toString()),
          _buildTile("Width", warehouse!.width?.toString()),
          _buildTile("Height", warehouse!.height?.toString()),
          _buildTile("Volume", warehouse!.volume?.toString()),
          _buildTile("Description", warehouse!.description),
          _buildTile("Created Date", warehouse!.createdDate),
          _buildTile("Created By", warehouse!.createdBy?.toString()),
        ],
      ),
    );
  }
}
