import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/warehouse_update_models.dart';
import '../../index/models/warehouse_index_models.dart';

class WarehouseEditWidget extends StatefulWidget {
  final WarehouseIndexModel warehouse;

  const WarehouseEditWidget({super.key, required this.warehouse});

  @override
  State<WarehouseEditWidget> createState() => _WarehouseEditWidgetState();
}

class _WarehouseEditWidgetState extends State<WarehouseEditWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _branchController;
  late TextEditingController _addressController;
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _volumeController;
  late TextEditingController _descriptionController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final w = widget.warehouse;
    _nameController = TextEditingController(text: w.warehouseName);
    _codeController = TextEditingController(text: w.warehouseCode);
    _branchController = TextEditingController(text: w.branch ?? "");
    _addressController = TextEditingController(text: w.address ?? "");
    _lengthController = TextEditingController(text: w.length?.toString() ?? "");
    _widthController = TextEditingController(text: w.width?.toString() ?? "");
    _heightController = TextEditingController(text: w.height?.toString() ?? "");
    _volumeController = TextEditingController(text: w.volume?.toString() ?? "");
    _descriptionController = TextEditingController(text: w.description ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _branchController.dispose();
    _addressController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _volumeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final model = WarehouseUpdateModel(
      warehouseName: _nameController.text.trim(),
      warehouseCode: _codeController.text.trim(),
      branch: _branchController.text.trim().isNotEmpty ? _branchController.text.trim() : null,
      address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
      length: _lengthController.text.trim().isNotEmpty ? int.tryParse(_lengthController.text.trim()) : null,
      width: _widthController.text.trim().isNotEmpty ? int.tryParse(_widthController.text.trim()) : null,
      height: _heightController.text.trim().isNotEmpty ? int.tryParse(_heightController.text.trim()) : null,
      volume: _volumeController.text.trim().isNotEmpty ? int.tryParse(_volumeController.text.trim()) : null,
      description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
    );

    setState(() => _isLoading = true);

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token == null || token.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token not found. Please login again.")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final url = Uri.parse(
        "${ApiBase.baseUrl}/inventory/warehouse/${widget.warehouse.id}",
      );

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(model.toJson()),
      );

      String message;
      try {
        final parsed = jsonDecode(response.body);
        message = parsed is Map && parsed['message'] != null
            ? parsed['message'].toString()
            : jsonEncode(parsed);
      } catch (_) {
        message = response.body;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Warehouse updated successfully")),
        );
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Update failed"),
            content: SingleChildScrollView(
              child: Text("Status: ${response.statusCode}\n\n$message"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e, st) {
      debugPrint("update error: $e\n$st");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            decoration: const InputDecoration(labelText: "Warehouse Code"),
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
                : const Text("Update Warehouse"),
          ),
        ],
      ),
    );
  }
}
