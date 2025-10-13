// lib/features/dashboard_sales/master data/costumer_category/widget/costumer_category_create_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _createCategory() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    try {
      final token = await _storage.read(key: "token");
      final model = CustomerCategoryCreateModel(
        customerCategoryName: _nameController.text,
        customerCategoryCode: _codeController.text,
      );

      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}/sales/customer-category"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(model.toJson()),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to create category');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const softGreen = Color(0xFF679436);
    final borderRadius = BorderRadius.circular(16.0);
    const lightText = Color(0xFF4A5568);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== BAGIAN FORM INPUT ======
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    "Create New Category",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Category Name *",
                      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: softGreen, width: 2.0)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a category name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: "Category Code *",
                      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: softGreen, width: 2.0)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter a category code' : null,
                  ),
                ],
              ),
            ),
            
            // ====== BAGIAN TOMBOL (TERPISAH) ======
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 3, blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: borderRadius),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Batal", style: GoogleFonts.poppins(color: lightText, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        boxShadow: [BoxShadow(color: softGreen.withOpacity(0.4), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          backgroundColor: softGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: borderRadius),
                          elevation: 0,
                        ),
                        onPressed: _isLoading ? null : _createCategory,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            : Text("Save", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}