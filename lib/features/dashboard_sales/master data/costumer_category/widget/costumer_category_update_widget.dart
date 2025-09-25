import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_category_update_models.dart';
import '../models/costumer_category_index_models.dart';

class CustomerCategoryUpdateWidget extends StatefulWidget {
  final int id;

  const CustomerCategoryUpdateWidget({super.key, required this.id});

  @override
  State<CustomerCategoryUpdateWidget> createState() =>
      _CustomerCategoryUpdateWidgetState();
}

class _CustomerCategoryUpdateWidgetState
    extends State<CustomerCategoryUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _descController;

  bool isLoading = true;
  bool isSubmitting = false;
  CustomerCategoryModel? category;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _descController = TextEditingController();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}/sales/customer-category/${widget.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          category = CustomerCategoryModel.fromJson(data);
          _codeController.text = category?.customerCategoryCode ?? '';
          _nameController.text = category?.customerCategoryName ?? '';
          _descController.text = category?.description ?? '';
          isLoading = false;
        });
      } else {
        debugPrint("Failed fetch: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetch: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> updateCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    try {
      final token = await storage.read(key: 'token');
      final model = CustomerCategoryUpdateModel(
        idCustomerCategory: widget.id,
        customerCategoryCode: _codeController.text,
        customerCategoryName: _nameController.text,
        description: _descController.text,
      );

      final response = await http.put(
        Uri.parse('${ApiBase.baseUrl}/sales/customer-category/${widget.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category updated successfully")),
        );
        Navigator.pop(context, true);
      } else {
        debugPrint("Failed update: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update category")),
        );
      }
    } catch (e) {
      debugPrint("Error update: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error occurred while updating")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: "Code"),
            validator: (val) =>
                val == null || val.isEmpty ? "Code is required" : null,
          ),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name"),
            validator: (val) =>
                val == null || val.isEmpty ? "Name is required" : null,
          ),
          TextFormField(
            controller: _descController,
            decoration: const InputDecoration(labelText: "Description"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSubmitting ? null : updateCategory,
            child: isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Update"),
          ),
        ],
      ),
    );
  }
}
