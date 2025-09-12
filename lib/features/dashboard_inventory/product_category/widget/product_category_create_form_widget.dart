import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../services/api_base.dart';

class ProductCategoryCreateWidget extends StatefulWidget {
  const ProductCategoryCreateWidget({super.key});

  @override
  State<ProductCategoryCreateWidget> createState() => _ProductCategoryCreateWidgetState();
}

class _ProductCategoryCreateWidgetState extends State<ProductCategoryCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token == null || token.isEmpty) {
        throw Exception("Token tidak ditemukan. Silakan login ulang.");
      }

      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}/inventory/product-category"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "product_category_name": _nameController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Category created successfully!")),
        );
        Navigator.pop(context, true); // kembali ke index & trigger refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.body}")),
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
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Category Name"),
            validator: (value) => value == null || value.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _createCategory,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Save"),
          ),
        ],
      ),
    );
  }
}
