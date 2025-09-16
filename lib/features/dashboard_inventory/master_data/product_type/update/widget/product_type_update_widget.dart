import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/product_type_update_models.dart';

class ProductTypeUpdateWidget extends StatefulWidget {
  final int id;
  final ProductTypeUpdateModel initialData;

  const ProductTypeUpdateWidget({
    super.key,
    required this.id,
    required this.initialData,
  });

  @override
  State<ProductTypeUpdateWidget> createState() =>
      _ProductTypeUpdateWidgetState();
}

class _ProductTypeUpdateWidgetState extends State<ProductTypeUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData.productTypeName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateProductType() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _storage.read(key: "token");
      final model =
      ProductTypeUpdateModel(productTypeName: _nameController.text);

      final url = Uri.parse("${ApiBase.baseUrl}/inventory/product-type/${widget.id}");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(model.toJson()),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Type berhasil diupdate")),
        );
        Navigator.pop(context, true); // Kirim 'true' sebagai sinyal sukses
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar dialog tidak memakan banyak tempat
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _updateProductType,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white),
            )
                : const Text("Update"),
          ),
        ],
      ),
    );
  }
}