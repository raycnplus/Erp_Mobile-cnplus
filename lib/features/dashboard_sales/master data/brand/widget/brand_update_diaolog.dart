import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/update_models_brand.dart';

// Fungsi untuk menampilkan dialog
Future<bool?> showUpdateBrandDialog(
  BuildContext context, {
  required int id,
  required BrandUpdateModel initialData,
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
                  "Update Brand",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                BrandUpdateForm(id: id, initialData: initialData),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Widget Form Internal
class BrandUpdateForm extends StatefulWidget {
  final int id;
  final BrandUpdateModel initialData;

  const BrandUpdateForm({
    super.key,
    required this.id,
    required this.initialData,
  });

  @override
  State<BrandUpdateForm> createState() => _BrandUpdateFormState();
}

class _BrandUpdateFormState extends State<BrandUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  bool _isLoading = false;

  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color darkText = Color(0xFF2D3748);
  static const Color lightText = Color(0xFF718096);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData.brandName);
    _codeController = TextEditingController(text: widget.initialData.brandCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _updateBrand() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final token = await _storage.read(key: "token");
      final body = jsonEncode({
        "brand_name": _nameController.text,
        "brand_code": _codeController.text,
      });

      final url = Uri.parse("${ApiBase.baseUrl}/inventory/brand/${widget.id}");
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Kirim sinyal sukses
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal update: ${response.body}"), backgroundColor: Colors.redAccent));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16.0);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Brand Name Field
          _buildTextFormField(
            controller: _nameController,
            labelText: "Brand Name",
            validator: (value) => value == null || value.isEmpty ? "Nama wajib diisi" : null,
          ),
          const SizedBox(height: 16),
          // Brand Code Field
          _buildTextFormField(
            controller: _codeController,
            labelText: "Brand Code",
            validator: (value) => value == null || value.isEmpty ? "Kode wajib diisi" : null,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Batal", style: GoogleFonts.poppins(color: lightText, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateBrand,
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
  
  // Helper widget untuk membuat TextFormField agar tidak duplikat kode
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required FormFieldValidator<String> validator,
  }) {
    final borderRadius = BorderRadius.circular(16.0);
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryBlue,
          selectionColor: primaryBlue.withOpacity(0.4),
          selectionHandleColor: primaryBlue,
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(color: darkText),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(color: lightText),
          filled: true,
          fillColor: primaryBlue.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: primaryBlue.withOpacity(0.5), width: 1.0)),
          focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: primaryBlue, width: 2.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }
}