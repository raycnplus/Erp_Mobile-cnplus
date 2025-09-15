import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../services/api_base.dart';
import '../models/product_type_create_model.dart';

class ProductTypeCreateWidget extends StatefulWidget {
  const ProductTypeCreateWidget({super.key});

  @override
  State<ProductTypeCreateWidget> createState() => _ProductTypeCreateWidgetState();
}

class _ProductTypeCreateWidgetState extends State<ProductTypeCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _createProductType() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _storage.read(key: "token");

      final model = ProductTypeCreateModel(
        productTypeName: _nameController.text,
      );

      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}/inventory/product-type"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Type berhasil dibuat")),
        );
        Navigator.pop(context, true); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membuat Product Type: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
            onPressed: _isLoading ? null : _createProductType,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
