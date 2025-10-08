// customer_update_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/costumer_update_models.dart';

class CustomerUpdateWidget extends StatefulWidget {
  final int id; // ID customer yang akan diupdate

  const CustomerUpdateWidget({super.key, required this.id});

  @override
  State<CustomerUpdateWidget> createState() => _CustomerUpdateWidgetState();
}

class _CustomerUpdateWidgetState extends State<CustomerUpdateWidget> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _websiteController = TextEditingController();
  final _picNameController = TextEditingController();
  final _picPhoneController = TextEditingController();
  final _picEmailController = TextEditingController();

  // State
  bool _isLoading = true; // Satu state untuk semua loading awal
  bool _isSubmitting = false;

  // Dropdown data
  List<CustomerCategoryDropdownModel> _categories = [];
  List<CountryModel> _countries = [];
  CustomerCategoryDropdownModel? _selectedCategory;
  CustomerTypeDropdownModel? _selectedType;
  int? _selectedCountryId;
  
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _websiteController.dispose();
    _picNameController.dispose();
    _picPhoneController.dispose();
    _picEmailController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final categories = await _fetchCategories();
      final countries = await _fetchCountries();
      
      if (!mounted) return;

      setState(() {
        _categories = categories;
        _countries = countries;
      });

      await _fetchCustomerDetail();

    } catch (e) {
      if(mounted) {
        setState(() {
          _error = "Failed to load initial data: $e";
        });
      }
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchCustomerDetail() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/${widget.id}'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200 && mounted) {
      final data = jsonDecode(response.body);

      _nameController.text = data["customer_name"] ?? "";
      _codeController.text = data["customer_code"] ?? "";
      _phoneController.text = data["phone_no"] ?? "";
      _emailController.text = data["email"] ?? "";
      _addressController.text = data["address"] ?? "";
      _provinceController.text = data["province"] ?? "";
      _cityController.text = data["city"] ?? "";
      _postalCodeController.text = data["postal_code"] ?? "";
      _websiteController.text = data["website"] ?? "";
      _picNameController.text = data["pic_name"] ?? "";
      _picPhoneController.text = data["pic_phone"] ?? "";
      _picEmailController.text = data["pic_email"] ?? "";

      final countryIdRaw = data["id_country"];
      if (countryIdRaw != null) {
        _selectedCountryId = int.tryParse(countryIdRaw.toString());
      }
      
      final categoryIdRaw = data["customer_category"];
      int? categoryId;
      if (categoryIdRaw != null) {
        categoryId = int.tryParse(categoryIdRaw.toString());
      }

      _selectedType = CustomerTypeDropdownModel.types.firstWhere(
        (t) => t.value == data["customer_type"],
        orElse: () => CustomerTypeDropdownModel.types.first,
      );

      // ▼▼▼ PERBAIKAN 1: Memperbaiki error 'return_of_invalid_type' ▼▼▼
      // Menggunakan try-catch untuk mencari kategori. Jika tidak ketemu, _selectedCategory akan tetap null.
      if (categoryId != null && _categories.isNotEmpty) {
        try {
           _selectedCategory = _categories.firstWhere((c) => c.idCategory == categoryId);
        } catch(e) {
          _selectedCategory = null; // Kategori tidak ditemukan dalam daftar
        }
      }

    } else {
      throw Exception('Failed to load customer details: ${response.body}');
    }
  }

  Future<List<CustomerCategoryDropdownModel>> _fetchCategories() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer-category/'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> parsed = decoded is Map && decoded.containsKey("data")
          ? decoded["data"]
          : (decoded is List ? decoded : []);
      return parsed.map((e) => CustomerCategoryDropdownModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories');
  }

  Future<List<CountryModel>> _fetchCountries() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/master/countries/'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> parsed = decoded is Map && decoded.containsKey("data")
          ? decoded["data"]
          : (decoded is List ? decoded : []);
      return parsed.map((e) => CountryModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load countries');
  }

  Future<void> _updateCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final body = {
      "customer_name": _nameController.text,
      "customer_code": _codeController.text,
      "customer_type": _selectedType?.value,
      "customer_category": _selectedCategory?.idCategory,
      "phone_no": _phoneController.text,
      "email": _emailController.text,
      "address": _addressController.text,
      "province": _provinceController.text,
      "city": _cityController.text,
      "postal_code": _postalCodeController.text,
      "website": _websiteController.text,
      "pic_name": _picNameController.text,
      "pic_phone": _picPhoneController.text,
      "pic_email": _picEmailController.text,
      "id_country": _selectedCountryId,
    };

    final response = await http.put(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/${widget.id}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update: ${response.body}")),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }

    final softGreen = const Color(0xFF679436);
    // ▼▼▼ PERBAIKAN 2: Memperbaiki warning 'withOpacity' ▼▼▼
    // Menggunakan kode hex untuk opacity secara langsung
    final lightGreenWithOpacity = const Color(0x4DC8E6C9); // Opacity ~30%
    final softGreenWithOpacity = const Color(0x80679436); // Opacity 50%
    final borderRadius = BorderRadius.circular(16.0);

    final inputDecorationTheme = InputDecoration(
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      filled: true,
      fillColor: lightGreenWithOpacity,
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: softGreenWithOpacity, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: softGreen, width: 2.0),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Update Customer", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            TextFormField(controller: _nameController, decoration: inputDecorationTheme.copyWith(labelText: "Name"), validator: (v) => v!.isEmpty ? "Required" : null),
            const SizedBox(height: 16),

            TextFormField(controller: _codeController, decoration: inputDecorationTheme.copyWith(labelText: "Code"), validator: (v) => v!.isEmpty ? "Required" : null),
            const SizedBox(height: 16),

            DropdownButtonFormField<CustomerTypeDropdownModel>(
              value: _selectedType,
              items: CustomerTypeDropdownModel.types.map((t) => DropdownMenuItem(value: t, child: Text(t.displayName))).toList(),
              onChanged: (val) => setState(() => _selectedType = val),
              decoration: inputDecorationTheme.copyWith(labelText: "Customer Type"),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<CustomerCategoryDropdownModel>(
              value: _selectedCategory,
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c.categoryName))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              decoration: inputDecorationTheme.copyWith(labelText: "Customer Category"),
            ),
            const SizedBox(height: 16),
            
            TextFormField(controller: _phoneController, decoration: inputDecorationTheme.copyWith(labelText: "Phone")),
            const SizedBox(height: 16),

            TextFormField(controller: _emailController, decoration: inputDecorationTheme.copyWith(labelText: "Email")),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<int>(
              value: _selectedCountryId,
              items: _countries.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (val) => setState(() => _selectedCountryId = val),
              decoration: inputDecorationTheme.copyWith(labelText: "Country"),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _updateCustomer,
              style: ElevatedButton.styleFrom(
                backgroundColor: softGreen,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("Update Customer", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}