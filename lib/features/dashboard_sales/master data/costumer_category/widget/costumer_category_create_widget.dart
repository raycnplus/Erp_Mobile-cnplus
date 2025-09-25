import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_category_create_models.dart';

class CustomerCategoryCreateWidget extends StatefulWidget {
  const CustomerCategoryCreateWidget({super.key});

  @override
  State<CustomerCategoryCreateWidget> createState() =>
      _CustomerCategoryCreateWidgetState();
}

class _CustomerCategoryCreateWidgetState
    extends State<CustomerCategoryCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool isSubmitting = false;

  String _snippet(String s, [int max = 400]) {
    if (s.isEmpty) return s;
    return s.length <= max ? s : s.substring(0, max);
  }

  Future<void> createCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    try {
      final token = await storage.read(key: 'token');
      if (token == null || token.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token not found. Please login.")),
        );
        setState(() => isSubmitting = false);
        return;
      }

      final model = CustomerCategoryCreateModel(
        customerCategoryCode: _codeController.text.trim(),
        customerCategoryName: _nameController.text.trim(),
        description: _descController.text.trim(),
      );

      final uri = Uri.parse(
        '${ApiBase.baseUrl}/sales/customer-category',
      ); // tanpa trailing slash
      debugPrint('POST $uri');
      debugPrint('body: ${_snippet(jsonEncode(model.toJson()), 300)}');

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );

      debugPrint('status: ${response.statusCode}');
      debugPrint('response snippet: ${_snippet(response.body, 800)}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category created successfully")),
        );
        // pop after current frame to avoid pointer assertion
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pop(context, true);
        });
        return;
      }

      // non-2xx -> tampilkan pesan detail
      String message;
      try {
        final parsed = jsonDecode(response.body);
        message = parsed is Map && parsed['message'] != null
            ? parsed['message'].toString()
            : jsonEncode(parsed);
      } catch (_) {
        message = response.body;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to create: ${response.statusCode} - ${_snippet(message, 200)}",
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('create error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
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
