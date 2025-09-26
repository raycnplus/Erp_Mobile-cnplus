import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/warehouse_create_models.dart';

class WarehouseCreateWidget extends StatefulWidget {
  const WarehouseCreateWidget({super.key});

  @override
  State<WarehouseCreateWidget> createState() => _WarehouseCreateWidgetState();
}

class _WarehouseCreateWidgetState extends State<WarehouseCreateWidget> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController(); 
  final _branchController = TextEditingController();
  final _addressController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final model = WarehouseCreateModel(
      warehouseName: _nameController.text,
      warehouseCode: _codeController.text,
      branch: _branchController.text.isNotEmpty ? _branchController.text : null,
      address: _addressController.text.isNotEmpty ? _addressController.text : null,
      length: _lengthController.text.isNotEmpty ? int.tryParse(_lengthController.text) : null,
      width: _widthController.text.isNotEmpty ? int.tryParse(_widthController.text) : null,
      height: _heightController.text.isNotEmpty ? int.tryParse(_heightController.text) : null,
      volume: _volumeController.text.isNotEmpty ? int.tryParse(_volumeController.text) : null,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
    );

    try {
      setState(() => _isLoading = true);

      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}/inventory/warehouse"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Warehouse created successfully")),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("Failed to create warehouse: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
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
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Warehouse Name"),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: "Warehouse Code",
            ),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _branchController,
            decoration: const InputDecoration(labelText: "Branch"),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: "Address"),
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _lengthController,
                  decoration: const InputDecoration(labelText: "Length"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _widthController,
                  decoration: const InputDecoration(labelText: "Width"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: "Height"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _volumeController,
                  decoration: const InputDecoration(labelText: "Volume"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
            maxLines: 2,
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Save Warehouse"),
          ),
        ],
      ),
    );
  }
}
