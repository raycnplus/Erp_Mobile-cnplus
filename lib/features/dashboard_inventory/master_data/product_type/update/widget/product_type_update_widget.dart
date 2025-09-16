import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../services/api_base.dart';
import '../../../product_type/update/models/product_type_update_models.dart';

class ProductTypeUpdateWidget extends StatefulWidget {
  final int id;
  final ProductTypeUpdateModel initialData;

  const ProductTypeUpdateWidget({
    super.key,
    required this.id,
    required this.initialData,
  });

  @override
  State<ProductTypeUpdateWidget> createState() => _ProductTypeUpdateWidgetState();
}

class _ProductTypeUpdateWidgetState extends State<ProductTypeUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  late TextEditingController _nameController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData.productTypeName);
  }

  Future<void> _updateProductType() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final token = await _storage.read(key: "token");

      final model = ProductTypeUpdateModel(
        productTypeName: _nameController.text,
      );

      final response = await http.put(
        Uri.parse("${ApiBase.baseUrl}/product-type/${widget.id}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Type berhasil diupdate")),
        );
        Navigator.pop(context, true); // kirim true supaya index bisa refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Product Type Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateProductType,
                    child: const Text("Update"),
                  ),
                ],
              ),
            ),
          );
  }
}
