import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';

class WarehouseDeleteWidget extends StatelessWidget {
  final int warehouseId;
  final VoidCallback onDelete;

  const WarehouseDeleteWidget({
    super.key,
    required this.warehouseId,
    required this.onDelete,
  });

  /// Fungsi untuk hapus warehouse
  Future<bool> _deleteWarehouse(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan. Silakan login ulang.");
    }

    final response = await http.delete(
      Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Gagal hapus warehouse: ${response.body}");
    }
  }

  /// Handler ketika tombol hapus ditekan
  Future<void> _handleDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus warehouse ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final result = await _deleteWarehouse(warehouseId);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Warehouse berhasil dihapus")),
        );
        onDelete();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () => _handleDelete(context),
    );
  }
}
