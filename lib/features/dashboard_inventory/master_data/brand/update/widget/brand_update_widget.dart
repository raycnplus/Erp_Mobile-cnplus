import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../../show/models/brand_show_models.dart';

class BrandUpdateWidget extends StatefulWidget {
  final int brandId;

  const BrandUpdateWidget({super.key, required this.brandId});

  @override
  State<BrandUpdateWidget> createState() => _BrandUpdateWidgetState();
}

class _BrandUpdateWidgetState extends State<BrandUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  late TextEditingController _nameController;
  late TextEditingController _codeController;

  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _codeController = TextEditingController();
    _fetchBrand();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _fetchBrand() async {
    try {
      final token = await _storage.read(key: "token");

      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/brand/${widget.brandId}"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final brand = BrandShowModel.fromJson(jsonDecode(response.body));
        setState(() {
          _nameController.text = brand.brandName;
          _codeController.text = brand.brandCode;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load brand: ${response.body}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  Future<void> _updateBrand() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _storage.read(key: "token");

      final response = await http.put(
        Uri.parse("${ApiBase.baseUrl}/inventory/brand/${widget.brandId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "brand_name": _nameController.text,
          "brand_code": _codeController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Brand updated successfully!")),
          );
          // balik ke screen sebelumnya & trigger refresh
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${response.body}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Brand Name"),
            validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: "Brand Code"),
            validator: (value) =>
                value == null || value.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _updateBrand,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Update"),
          ),
        ],
      ),
    );
  }
}
