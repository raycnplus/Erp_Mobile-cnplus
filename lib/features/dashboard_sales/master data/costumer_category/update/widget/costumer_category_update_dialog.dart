// lib/features/dashboard_sales/master data/costumer_category/widget/costumer_category_update_dialog.dart

import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_category_update_models.dart';

Future<bool?> showUpdateCustomerCategoryDialog(
  BuildContext context, {
  required int id,
  required CustomerCategoryUpdateModel initialData,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Update Category",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                CustomerCategoryUpdateWidget(id: id, initialData: initialData),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CustomerCategoryUpdateWidget extends StatefulWidget {
  final int id;
  final CustomerCategoryUpdateModel initialData;

  const CustomerCategoryUpdateWidget({
    super.key,
    required this.id,
    required this.initialData,
  });

  @override
  State<CustomerCategoryUpdateWidget> createState() =>
      _CustomerCategoryUpdateWidgetState();
}

class _CustomerCategoryUpdateWidgetState
    extends State<CustomerCategoryUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData.customerCategoryName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final url = Uri.parse('${ApiBase.baseUrl}/sales/customer-category/${widget.id}');

      final body = CustomerCategoryUpdateModel(
        customerCategoryName: _nameController.text,
      ).toJson();

      try {
        final response = await http.put(
          url,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode(body),
        );
        if (response.statusCode == 200 && mounted) {
          Navigator.of(context).pop(true); // Kirim 'true' jika berhasil
        } else {
          throw Exception('Failed to update: ${response.body}');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF4A90E2);
    final borderRadius = BorderRadius.circular(16.0);
    const lightText = Color(0xFF4A5568);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Category Name",
              labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: primaryBlue, width: 2.0)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category name';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Batal", style: GoogleFonts.poppins(color: lightText, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 48),
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  elevation: 4,
                  shadowColor: primaryBlue.withOpacity(0.4),
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : Text("Update", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}