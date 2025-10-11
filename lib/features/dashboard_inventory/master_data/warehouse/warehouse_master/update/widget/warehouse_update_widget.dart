// warehouse_update_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // --- Warna dan Style ---
  final softGreen = const Color(0xFF679436);
  final lightGreen = const Color(0xFFC8E6C9);
  final borderRadius = BorderRadius.circular(16.0);

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
    _nameController.dispose(); _codeController.dispose(); _branchController.dispose(); _addressController.dispose(); _lengthController.dispose(); _widthController.dispose(); _heightController.dispose(); _volumeController.dispose(); _descriptionController.dispose();
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

      final url = Uri.parse("${ApiBase.baseUrl}/inventory/warehouse/${widget.warehouse.id}");
      final response = await http.put(
        url,
        headers: { "Authorization": "Bearer $token", "Content-Type": "application/json", "Accept": "application/json" },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        final parsed = jsonDecode(response.body);
        final message = parsed['message'] ?? 'An unknown error occurred.';
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update Failed: $message"), backgroundColor: Colors.red));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper untuk styling input field
  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: softGreen.withOpacity(0.8), size: 20) : null,
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      filled: true,
      fillColor: lightGreen.withOpacity(0.3),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen.withOpacity(0.5), width: 1.0)),
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen, width: 2.0)),
      errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: _getInputDecoration("Warehouse Name", prefixIcon: Icons.warehouse_outlined),
            validator: (v) => v == null || v.isEmpty ? "Name is required" : null,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _codeController,
            decoration: _getInputDecoration("Warehouse Code", prefixIcon: Icons.qr_code_2_outlined),
            validator: (v) => v == null || v.isEmpty ? "Code is required" : null,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _branchController,
            decoration: _getInputDecoration("Branch", prefixIcon: Icons.store_mall_directory_outlined),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _addressController,
            decoration: _getInputDecoration("Address", prefixIcon: Icons.location_on_outlined),
            maxLines: 3,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: TextFormField(controller: _lengthController, decoration: _getInputDecoration("Length"), keyboardType: TextInputType.number, style: GoogleFonts.poppins())),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _widthController, decoration: _getInputDecoration("Width"), keyboardType: TextInputType.number, style: GoogleFonts.poppins())),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: TextFormField(controller: _heightController, decoration: _getInputDecoration("Height"), keyboardType: TextInputType.number, style: GoogleFonts.poppins())),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _volumeController, decoration: _getInputDecoration("Volume"), keyboardType: TextInputType.number, style: GoogleFonts.poppins())),
            ],
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _descriptionController,
            decoration: _getInputDecoration("Description", prefixIcon: Icons.notes_outlined),
            maxLines: 2,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 32),

          // Tombol Submit yang sudah diperbarui
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [BoxShadow(color: softGreen.withOpacity(0.4), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: softGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                elevation: 0,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : Text("Update Warehouse", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}