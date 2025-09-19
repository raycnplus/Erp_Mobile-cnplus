import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';

class BrandDeleteWidget extends StatefulWidget {
  final int brandId;
  final VoidCallback onDeleted;

  const BrandDeleteWidget({
    super.key,
    required this.brandId,
    required this.onDeleted,
  });

  @override
  State<BrandDeleteWidget> createState() => _BrandDeleteWidgetState();
}

class _BrandDeleteWidgetState extends State<BrandDeleteWidget> {
  final _storage = const FlutterSecureStorage();
  bool _loading = false;

  Future<void> _deleteBrand() async {
    setState(() => _loading = true);

    try {
      final token = await _storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse('${ApiBase.baseUrl}/brands/${widget.brandId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Brand deleted successfully")),
        );
        widget.onDeleted();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _loading
          ? const CircularProgressIndicator()
          : const Icon(Icons.delete, color: Colors.red),
      onPressed: _loading
          ? null
          : () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Confirm Delete"),
                  content: const Text("Are you sure you want to delete this brand?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // tutup dialog
                        await _deleteBrand();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
            },
    );
  }
}
