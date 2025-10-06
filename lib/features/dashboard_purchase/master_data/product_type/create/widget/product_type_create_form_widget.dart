import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../services/api_base.dart';
import '../models/product_type_create_model.dart';

class ProductTypeCreateWidget extends StatefulWidget {
  const ProductTypeCreateWidget({super.key});

  @override
  State<ProductTypeCreateWidget> createState() =>
      _ProductTypeCreateWidgetState();
}

class _ProductTypeCreateWidgetState extends State<ProductTypeCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _createProductType() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final token = await _storage.read(key: "token");
      final model = ProductTypeCreateModel(
        productTypeName: _nameController.text,
      );
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}/purchase/product-type"),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create Product Type: ${response.body}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final softGreen = const Color(0xFF679436);
    final lightGreen = const Color(0xFFC8E6C9);
    final borderRadius = BorderRadius.circular(16.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create New Product Type",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                // ## PERUBAHAN UTAMA ADA DI SINI ##
                // Bungkus TextFormField dengan widget Theme
                Theme(
                  data: Theme.of(context).copyWith(
                    // Terapkan tema seleksi teks khusus di sini (HIJAU)
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: softGreen,
                      selectionColor: softGreen.withOpacity(0.4),
                      selectionHandleColor: softGreen, // <-- Warna handle diubah di sini
                    ),
                  ),
                  child: TextFormField(
                    // cursorColor sekarang diatur oleh Theme di atas
                    controller: _nameController,
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      labelText: "Product Type Name",
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                      filled: true,
                      fillColor: lightGreen.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide(
                          color: softGreen.withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide(
                          color: softGreen,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "This field is required"
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: softGreen.withOpacity(0.4),
                        blurRadius: 18,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: softGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius,
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _createProductType,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            "Save type",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}