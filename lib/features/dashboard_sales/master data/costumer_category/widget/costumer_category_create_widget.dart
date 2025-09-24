import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_category_create_models.dart';

class CustomerCategoryCreateWidget extends StatefulWidget {
  const CustomerCategoryCreateWidget({super.key});

  @override
  State<CustomerCategoryCreateWidget> createState() => _CustomerCategoryCreateWidgetState();
}

class _CustomerCategoryCreateWidgetState extends State<CustomerCategoryCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool isSubmitting = false;

  Future<void> createCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    try {
      final token = await storage.read(key: 'token');
      final model = CustomerCategoryCreateModel(
        customerCategoryCode: _codeController.text,
        customerCategoryName: _nameController.text,
        description: _descController.text,
      );

      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/sales/customer-category/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category created successfully")),
        );
        Navigator.pop(context, true); // return success ke screen sebelumnya
      } else {
        debugPrint("Failed: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create category")),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error occurred while creating")),
      );
    } finally {
      setState(() => isSubmitting = false);
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
            controller: _codeController,
            decoration: const InputDecoration(labelText: "Code"),
            validator: (val) => val == null || val.isEmpty ? "Code is required" : null,
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name"),
            validator: (val) => val == null || val.isEmpty ? "Name is required" : null,
          ),
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(labelText: "Description"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSubmitting ? null : createCategory,
            child: isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Create"),
          ),
        ],
      ),
    );
  }
}
